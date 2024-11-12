# U-Net Models for Bubble Segmentation

This repository contains split files of U-Net models used for segmenting bubbles in various datasets. Follow the instructions below to combine these split files and obtain the complete model files.

## Prerequisites

- Install [7-Zip](https://www.7-zip.org/) on your system.

## Instructions

1. **Download all the split files** from this repository.

2. **Place all the split files** in the same directory on your local machine.

3. **Combine the split files** using 7-Zip.

### Using 7-Zip on Windows

1. Right-click on the first split file (`compressed_models_split.7z.001`).
2. Select `7-Zip` > `Extract Here`.
3. 7-Zip will automatically combine the split files and extract the U-Net model files into the current directory.

### Using 7-Zip on macOS/Linux

1. Open a Terminal window.
2. Navigate to the directory containing the split files:
   ```sh
   cd /path/to/directory
   ```
3. Run the following command to combine and extract the files:
   ```sh
   7z x compressed_models_split.7z.001
   ```
4. 7-Zip will automatically combine the split files and extract the U-Net model files into the current directory.
