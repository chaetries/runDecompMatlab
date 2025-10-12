# Mueller Matrix Decomposition (MATLAB)
<img width="1306" height="664" alt="Screenshot 2025-10-12 at 16 02 17" src="https://github.com/user-attachments/assets/a2da86fb-f9c9-410b-a7ad-ff915369788f" />



This repository demonstrates how to perform decomposition of Mueller matrices using pre-trained machine learning models in MATLAB.  
The approach avoids computationally heavy **Lu–Chipman decomposition** by running fast inference through ONNX models.



---

## Requirements

- MATLAB  
  - **Deep Learning Toolbox**  
  - **Deep Learning Toolbox Converter for ONNX Model Format**  

---

## Dataset Information

Below is the samples used for training

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
- *Note*: If you are working with a different tissue type, wavelength, or imaging setup, retraining will be required.  

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
│   │   └── SAMMM.mat      # Self Validating Automatic Mueller Meso Microscope (SAMMM)
│   └── partial/
│       └── PPRIM.mat      # Portable Pre-term Imaging (PPRIM)
│
├── run_full.m
├── run_partial.m
└── README.md
```
**Note**: On first run, MATLAB will automatically generate `DecoderFunction.m` files and package folders (e.g., `+cvae_cervix_decoder_best/`) in the respective model directories. These are required for inference and should not be deleted.

---

## Sample Data

### Full Mueller Matrix Example  
`sample/full/SAMMM.mat`

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
`sample/partial/PPRIM.mat`

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
After running either script, **polarimetric decomposition results** will be saved back to the original data file as additional keys.

All output keys are prefixed with **`ML_`**.  

| Key                  | Description                                    | Shape    |
|-----------------------|-----------------------------------------------|----------|
| `ML_linrs`           | Predicted linear retardance                    | (H, W)   |
| `ML_Mdepols`         | Predicted depolarization                       | (H, W)   |
| `ML_Mdiattenuations` | Predicted diattenuation                        | (H, W)   |
| `ML_Morientations`   | Predicted optical axis orientation (azimuth)   | (H, W)   |

---

## Citation



---

## Notes
