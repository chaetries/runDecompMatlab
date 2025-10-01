# Mueller Matrix Decomposition (MATLAB)

This repository demonstrates how to perform decomposition of Mueller matrices using pre-trained machine learning models in MATLAB.  
The approach avoids computationally heavy **Lu–Chipman decomposition** by running fast inference through ONNX models.

---

## Requirements

- MATLAB  
  - **Deep Learning Toolbox**  
  - **Deep Learning Toolbox Converter for ONNX Model Format**  

---

## Dataset Information

The dataset contains measured and simulated Mueller matrices from tissue imaging.  

### IMP1 Imaging Characteristics

| Parameter            | Value                   |
|----------------------|--------------------------|
| Field of view        | Up to 10 cm             |
| Resolution           | 600 × 800 pixels        |
| Imaging geometry     | Reflection              |
| Wavelength           | 550 nm (visible)        |
| Tissue type          | Uterine cervix (bulk)   |
| Tissue thickness     | 1–3 cm                  |

- **Training set**: 23 samples (~1,152,000 Mueller matrices used for train/test/validation).  
- ⚠️ *Note*: If you are working with a different tissue type, wavelength, or imaging setup, retraining will be required.  

---

## Repository Structure

```
├── model/
│   ├── full/
│   │   ├── cvae_cervix_decoder_best.onnx
│   │   └── cvae_cervix_encoder_best.onnx
│   └── partial/
│       ├── cvae_cervix_decoder_best.onnx
│       └── cvae_cervix_encoder_best.onnx
│
├── sample/
│   ├── full/
│   │   ├── SAMMM.npz
│   │   └── PPRIMM.npz
│   └── partial/
│       └── example_partial.npz
│
├── run_full.m
├── run_partial.m
└── README.md
```

---

## Sample Data

### Full Mueller Matrix Example  
`{protect}/sample/full/SAMMM.npz`  

| Key                  | Description                                    | Shape          |
|-----------------------|-----------------------------------------------|----------------|
| `nM`                 | Normalized full Mueller matrix                | (H, W, 16)     |
| `M11s`               | Intensity                                     | (H, W)         |
| `GT_linrs`           | Ground truth linear retardance                 | (H, W)         |
| `GT_Mdepols`         | Ground truth depolarization                    | (H, W)         |
| `GT_Mdiattenuations` | Ground truth diattenuation                     | (H, W)         |
| `GT_Morientations`   | Ground truth optical axis orientation (azimuth)| (H, W)         |

---

### Partial Mueller Matrix Example  
`{protect}/sample/full/PPRIMM.npz`  

| Key        | Description                              | Shape      |
|------------|------------------------------------------|------------|
| `nM`       | Normalized partial Mueller matrix (3×4)  | (H, W, 12) |
| `M11s`     | Intensity                                | (H, W)     |

---

## Running the Code

Two example MATLAB scripts are included:

### 1. Full Mueller Matrix (4×4)  
Run the decomposition using the full 16-element Mueller matrix:  
```matlab
run_full
```

### 2. Partial Mueller Matrix (3×4)  
Run the decomposition using the partial 12-element Mueller matrix:  
```matlab
run_partial
```

---

## Output Polarimetric Maps

After running either script, **polarimetric decomposition results** will be saved into the same MATLAB output file as additional keys.  
All output keys are prefixed with **`ML_`**.  

| Key                  | Description                                    | Shape    |
|-----------------------|-----------------------------------------------|----------|
| `ML_linrs`           | Predicted linear retardance                    | (H, W)   |
| `ML_Mdepols`         | Predicted depolarization                       | (H, W)   |
| `ML_Mdiattenuations` | Predicted diattenuation                        | (H, W)   |
| `ML_Morientations`   | Predicted optical axis orientation (azimuth)   | (H, W)   |

---

## Citation

If you use this code, models, or dataset in your research, please cite:  

```
[To be updated with paper/preprint reference]
```

---

## Notes

- Models are stored in the repository under:  
  - `{protect}/model/full/` (for full 4×4)  
  - `{protect}/model/partial/` (for partial 3×4)  

- Example datasets are available in `{protect}/sample/full/` and `{protect}/sample/partial/`.  

- ⚠️ If using different tissue type, wavelength, or imaging setup, retraining the model will be required.  
