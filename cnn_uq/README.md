# Automated Segmentation and Analysis of High-Speed Video Phase-Detection Data for Boiling Heat Transfer Characterization Using U-Net Convolutional Neural Networks and Uncertainty Quantification

![MIT](https://img.shields.io/badge/Made%20at-MIT-blue.svg)
![Computer Vision](https://img.shields.io/badge/Computer%20Vision-Boiling%20Dynamics-brightgreen.svg)
![Machine Learning](https://img.shields.io/badge/Machine%20Learning-U--Net-brightgreen.svg)
![Deep Learning](https://img.shields.io/badge/Deep%20Learning-Convolutional%20Neural%20Networks-critical.svg)
![Data Analysis](https://img.shields.io/badge/Data%20Analysis-High%20Speed%20Video-orange.svg)

This repository is the official GitHub page accompanying the thesis titled above, authored at MIT. It details a comprehensive approach to characterizing and understanding boiling dynamics using high-speed video (HSV) imaging and advanced computer vision techniques. The focus is on developing and applying U-Net Convolutional Neural Networks (CNNs) for the automated segmentation of boiling phenomena in various fluids and experimental conditions, coupled with uncertainty quantification to enhance the reliability of the analyses.

## Table of Contents
- [Overview](#overview)
- [Abstract](#abstract)
- [Installation](#installation)
- [Tutorials](#tutorials)
  - [Installation Guide](#installation-guide)
  - [Segmentation](#segmentation)
  - [Fine-Tuning](#fine-tuning)
  - [Detection](#detection)
- [Data](#data)
- [License](#license)
- [Citations](#citations)

## Overview
This project applies U-Net CNNs to the automated segmentation and analysis of high-speed video data, aiming to improve the accuracy and efficiency of boiling heat transfer characterization. It spans a variety of fluids, including liquid nitrogen and high-pressure water, under different experimental setups.

## Abstract
Boiling heat transfer is a complex phenomenon essential for cooling and heat management in various industrial applications. This thesis presents a novel approach using U-Net CNNs for the automated segmentation of HSV phase-detection images to enhance the characterization of boiling dynamics. It involves developing tailored U-Net models, evaluating their performance against traditional methods, and integrating comprehensive uncertainty quantification analyses to validate the reliability of the derived metrics. The findings underscore the potential of advanced computer vision techniques in revolutionizing boiling heat transfer research and industrial applications.

## Installation
To set up this project for replication of results or further development, follow these steps:
```bash
git clone https://github.com/chikap421/cvboil
cd cvboil
```

## Tutorials
This section provides detailed tutorials to help users effectively use the tools developed in this project for their own data or contribute to further research.

### Installation Guide
A comprehensive guide to installing the necessary dependencies and setting up the environment to run the project. Follow the steps below and refer to the external resources for more detailed instructions.
- Complete installation instructions are available here: [Installation Guide](https://lmb.informatik.uni-freiburg.de/resources/opensource/unet/#installation)

### Annotation of Boiling Data
Learn how to annotate boiling phenomena using the tools provided. This tutorial will guide you through the annotation process, essential for preparing your data for segmentation.
- Watch the annotation tutorial here: [Annotation Tutorial](https://www.youtube.com/watch?v=NvnxIK_CoTE&list=PLQ0mDSFR46UAAvgCA32vduLkCst_bzr9O)

### Managing Annotations
Once annotations are created, managing them effectively is crucial for maintaining data integrity and preparing for model training. This tutorial covers best practices for annotation management.
- Learn how to manage your annotations here: [Managing Annotations Tutorial](https://www.youtube.com/watch?v=pikQh7HQ8WM&list=PLQ0mDSFR46UAAvgCA32vduLkCst_bzr9O&index=3)

### Segmentation
Learn how to apply the U-Net models for segmenting bubbles in boiling phenomena from high-speed video data. This tutorial covers the process from data preparation to running the segmentation models.
- Detailed tutorial on segmentation can be found here: [Segmentation Tutorial](https://lmb.informatik.uni-freiburg.de/resources/opensource/unet/#segmentation)

### Fine-Tuning
This tutorial provides guidelines on how to fine-tune the pre-trained U-Net models to adapt to specific characteristics of new datasets or experimental conditions different from the training set. It includes parameter adjustments, training tips, and evaluation criteria.
- Learn more about fine-tuning the models here: [Fine-Tuning Tutorial](https://lmb.informatik.uni-freiburg.de/resources/opensource/unet/#finetuning)

### Detection
After successful segmentation, this tutorial helps users understand how to detect and classify different phases within the segmented images. It includes instructions on modifying detection algorithms to improve accuracy and adapt to specific features of the boiling process.
- Check the detailed detection methods here: [Detection Tutorial](https://lmb.informatik.uni-freiburg.de/resources/opensource/unet/#detection)

### Presentation of Results
Finally, this tutorial showcases how to interpret and present the results obtained from the U-Net models. It provides insights into how the results can be utilized for further analysis and reporting.
- Watch the results presentation here: [Presentation of Results Tutorial](https://www.youtube.com/watch?v=IkNgL3g9rlo&list=PLQ0mDSFR46UAAvgCA32vduLkCst_bzr9O&index=2)

## Data
The data used in this project consists of high-speed video recordings of boiling phenomena, obtained through experimental setups at the MIT Red Lab. For more information about the lab and other research conducted there, visit their official website: [MIT Red Lab](https://bucci.mit.edu/). Access to the data used in this project is restricted to authorized users due to the experimental nature of the recordings. For access requests or more information, please contact the lab PI.

## License
This project is licensed under the MIT License.

## Citations
Please cite the following works if you use this project's software, data, or methodologies in your own research:

### Thesis
```bibtex
@thesis{Maduabuchi2024,
  author       = {Chika Maduabuchi},
  title        = {Automated Segmentation and Analysis of High-Speed Video Phase-Detection Data for Boiling Heat Transfer Characterization Using U-Net Convolutional Neural Networks and Uncertainty Quantification},
  school       = {Massachusetts Institute of Technology},
  year         = 2024,
  address      = {Cambridge, MA},
  month        = 9,
  note         = {Publication forthcoming}
  }
```  
### U-Net Paper
```bibtex
@article{ronneberger2015u,
  title={U-net: Convolutional networks for biomedical image segmentation},
  author={Ronneberger, Olaf and Fischer, Philipp and Brox, Thomas},
  journal={International Conference on Medical image computing and computer-assisted intervention},
  pages={234--241},
  year={2015},
  organization={Springer}
}
```



