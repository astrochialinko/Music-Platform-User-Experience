# Music Platform User Experience

- MATH/STAT 571B Final Project (Spring 2025)
- Authors: Chia-Lin Ko, Winston Zeng, Mushaer Ahmed, Aiqing Li

## Goals

This project evaluates the user experience of four major music streaming platforms in their free (ad-supported) versions. The focus is on understanding how frequently ads appear and how satisfied users feel with the music selection, considering both new and returning users.

The comparison will be based on two response variables:

- **Ad Count**: the total number of advertisements per hour of listening.
- **Music Inventory Satisfaction**: User rating on a subjective 1-10 scale evaluating how satisfied the listener is with the platform’s music recommendation.

## Experimental Design

For each platform, the observer experienced the platform as both a **first-time user** and a **returning customer**. This resulted in a factorial structure:

- **Platform**: 4 levels (Spotify, Amazon, Apple, YouTube)
- **Customer Status**: 2 levels (First-time, Returning)
- **Observer (Student)**: 4 individuals (Chia-Lin, Winston, Mushaer, Aiqing) (random effect)
- **Total observations**: $4 \times 2 \times 4 = 32$

## Getting Started

1. Open the `code/analysis.R` file in R or RStudio.
2. Make sure that `data/music.csv` is available in the relative path.
3. Run the script to reproduce statistical models and regenerate figures in the `output/`` directory.

## Included files

```
.
├── README.md        # Project description and overview
├── code
│   └── analysis.R   # R script for data analysis and visualization
├── data
│   └── music.csv    # Experimental data
└── output           # Model diagnostics and interaction plots
    ├── model_ads_interaction.png
    ├── model_ads_resid.png
    ├── model_sat_ad_interaction.png
    ├── model_sat_ad_resid.png
    ├── model_sat_interaction.png
    └── model_sat_resid.png

```
