# Human Body Communication (HBC) FEMM Simulation Models

This repository contains **Finite Element Method (FEM)** simulation models, documentation, and literature survey materials for characterizing Human Body Communication (HBC) channels. The project utilizes **FEMM 4.2** to analyze potential distributions, channel gain, and capacitance coupling in the Electro-Quasistatic (EQS) regime.

The work supports the research presented in the paper *"Finite Element Analysis of a Galvanic Human Body Communication Channel with a Wrist-Worn Transmitter and Grounded Receiver"*.

## Project Overview

### 1. Simulation Models (`/src`)
* **`galvanic_planar_auto.py`**: Automated Python script for planar skin-muscle interface simulations. Performs parametric sweeps on channel length and electrode geometry.
* **`galvanic_cylindrical.lua`**: Axisymmetric Lua script modeling the human arm as a cylinder with distinct skin and muscle layers.
* **`capacitive_cross_section.lua`**: 2D planar cross-section model of the arm (Bone, Muscle, Fat, Skin) for analyzing capacitive coupling and return paths.

### 2. Documentation (`/docs`)
* **Manuscript**: The main research paper is available in `docs/manuscript/`.
* **Progress Reports**: Detailed milestone reports and presentations (August-November 2025) are stored in `docs/reports/`.
* **Configuration Logs**: Simulation parameter logs are available in `docs/reports/configurations/`.

### 3. Literature Survey (`/literature`)
This repository includes key foundational papers used to validate the simulation models:
* **Maity et al. (2018)[cite_start]**: *Bio-Physical Modeling, Characterization and Optimization of Electro-Quasistatic HBC*[cite: 7].
* **Nath et al. (2019)[cite_start]**: *Toward Understanding the Return Path Capacitance in Capacitive HBC*[cite: 9].
* **Song et al. (2012)[cite_start]**: *A Finite-Element Simulation of Galvanic Coupling Intra-Body Communication*[cite: 8].
* **Pereira et al. (2015)[cite_start]**: *TIM 2015 Paper on HBC*[cite: 4].
* [cite_start]**Rocke et al.**: *Research on HBC implementations*[cite: 5].

## Prerequisites

To run these simulations, you need:
1.  **FEMM 4.2**: [Download here](http://www.femm.info/wiki/Download)
2.  **Python 3.x** & **pyFEMM**.

### Installation
```bash
pip install -r requirements.txt
