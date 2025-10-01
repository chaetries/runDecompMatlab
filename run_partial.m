%% Partial CVAE - Cervix Tissue Analysis
clear; clc;

%% Configuration
decoder_file = 'model/partial/cvae_cervix_decoder_best.onnx';
decoder_function = 'model/partial/DecoderFunction';
data_file = 'sample/partial/PPRIM.mat';

%% Load Data
fprintf('Loading partial Mueller matrix data...\n');
data = load(data_file);
nM = data.nM; % Shape: [H, W, 12]
M11s = data.M11s; % Shape: [H, W]
[H, W, ~] = size(nM);
N = H * W;
mueller_data = reshape(nM, N, 12);
fprintf('Image: %d x %d (%d pixels)\n\n', H, W, N);

%% Import ONNX Model
fprintf('Loading ONNX decoder...\n');

% Add model folder to path
addpath('model/partial');

% Check if decoder function already exists
if ~isfile([decoder_function '.m'])
    fprintf('Generating decoder function (first time)...\n');
    importONNXFunction(decoder_file, decoder_function);
end

% Load parameters
try
    params = importONNXFunction(decoder_file, decoder_function);
    fprintf('Parameters loaded successfully!\n');
catch ME
    error('Failed to load ONNX model: %s', ME.message);
end

%% Run Inference
fprintf('Running inference...\n');
tic;
batch_size = 1000000;
predictions = zeros(N, 6);

for i = 1:batch_size:N
    idx_end = min(i + batch_size - 1, N);
    batch_idx = i:idx_end;
    batch_len = length(batch_idx);
    
    % Prepare inputs - [batch_size, features]
    latent_z = dlarray(zeros(batch_len, 5));
    mueller_input = dlarray(mueller_data(batch_idx, :));
    
    % Run decoder
    [batch_pred, ~] = DecoderFunction(latent_z, mueller_input, params);
    
    % Extract and transpose: [features, batch] -> [batch, features]
    predictions(batch_idx, :) = extractdata(batch_pred)';
end

runtime = toc;

%% Convert to Physical Parameters
D_pred = predictions(:, 1);
Delta_pred = predictions(:, 2);
LR_pred = atan2(predictions(:, 4), predictions(:, 3));
Psi_pred = atan2(predictions(:, 6), predictions(:, 5));

ML_Mdepols = reshape(D_pred, H, W);
ML_Mdiattenuations = reshape(Delta_pred, H, W);
ML_linrs = reshape(LR_pred, H, W);
ML_Morientations = reshape(Psi_pred, H, W);

%% Results
fprintf('\n========== PARTIAL CVAE RESULTS ==========\n');
fprintf('Runtime: %.3f seconds\n', runtime);
fprintf('Speed: %.0f pixels/second\n', N/runtime);
fprintf('==========================================\n\n');

%% Save results back to the data file
data.ML_linrs = ML_linrs;
data.ML_Mdepols = ML_Mdepols;
data.ML_Mdiattenuations = ML_Mdiattenuations;
data.ML_Morientations = ML_Morientations;
data.runtime = runtime;

save(data_file, '-struct', 'data');
fprintf('Results saved to: %s\n', data_file);