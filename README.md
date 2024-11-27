# MSEG-VCUQ: Multimodal SEGmentation with Enhanced Vision Foundation Models, Convolutional Neural Networks, and Uncertainty Quantification for High-Speed Video Phase Detection Data

![MIT](https://img.shields.io/badge/Developed%20at-MIT-blue.svg)
![Vision Models](https://img.shields.io/badge/Vision-Foundation%20Models-green.svg)
![Uncertainty Quantification](https://img.shields.io/badge/Uncertainty-Quantification-orange.svg)
![Open Source](https://img.shields.io/badge/Open%20Source-Contributions%20Welcome-brightgreen.svg)

This repository contains the codebase and resources for the **MSEG-VCUQ framework**, as detailed in the paper, "*MSEG-VCUQ: Multimodal SEGmentation with Enhanced Vision Foundation Models, Convolutional Neural Networks, and Uncertainty Quantification for High-Speed Video Phase Detection Data*." The framework integrates **vision foundation models** and **convolutional neural networks (CNNs)** with **uncertainty quantification (UQ)** to advance segmentation accuracy and reliability across diverse HSV modalities.

---

## 📁 Repository Structure

<details>
<summary><strong>cnn_uq/</strong> - Convolutional Neural Networks and Uncertainty Quantification</summary>

This folder focuses on **U-Net Convolutional Neural Networks (CNNs)** and **Uncertainty Quantification (UQ)** for HSV segmentation. Highlights include:
- Automated segmentation pipelines using U-Net for high-speed video data.
- Quantification of pixel-level discretization errors to evaluate boiling metrics such as contact line density and dry area fraction.
- Comprehensive UQ analyses to enhance experimental reproducibility.
- Refer to the folder-specific `README.md` for detailed instructions.
</details>

<details>
<summary><strong>videosam/</strong> - Vision Foundation Models: VideoSAM Framework</summary>

This folder contains the **VideoSAM framework**, which integrates convolutional neural networks (CNNs) with the transformer-based **Segment Anything Model (SAM)**. It represents the vision foundation model component of the MSEG-VCUQ framework, specifically tailored for multimodal segmentation tasks. Key features include:
- Advanced segmentation capabilities across complex HSV modalities, including Argon, Nitrogen, and FC-72.
- Zero-shot generalization on unseen datasets, demonstrating robust adaptability to varying fluid dynamics.
- Comprehensive evaluation of segmentation performance using metrics like IoU and F1 Score.
- Detailed implementation and usage instructions are available in the folder-specific `README.md`.
</details>

<details>
<summary><strong>paper/</strong> - Research Documentation</summary>

This folder contains:
- The research paper outlining the MSEG-VCUQ framework, experimental results, and key findings.
- Supporting figures, tables, and datasets used in the study.
</details>


<details>
<summary><strong>README.md</strong></summary>

This file provides a comprehensive overview of the repository and guides users in navigating its structure.
</details>

---

## 🚀 Getting Started

To begin using MSEG-VCUQ, follow these steps:

1. Clone the repository:
   ```bash
   git clone https://github.com/chikap421/mseg_vcuq.git
   cd mseg_vcuq
   ```

2. Explore the subdirectories (`cnn_uq`, `videosam`, `paper`) for specific tools, datasets, and models.

3. Install required dependencies:
   ```bash
   pip install -r requirements.txt
   ```

4. Follow folder-specific `README.md` files for instructions on replicating results or running experiments.

---

## 🔗 Links and Resources

- [MIT Red Lab](https://bucci.mit.edu/): Experimental data and resources for this project.
- [VideoSAM Repository](https://github.com/chikap421/videosam): Standalone implementation of the VideoSAM framework.
- [CNN-UQ Repository](https://github.com/chikap421/cvboil): Implementation of U-Net CNNs and Uncertainty Quantification for HSV segmentation.

---

## 📜 License

This repository is licensed under the **MIT License**. See the `LICENSE` file for details.

## 🖋️ Citations

If you use this repository in your research, please cite:

```bibtex
@misc{maduabuchi2024msegvcuqmultimodalsegmentationenhanced,
      title={MSEG-VCUQ: Multimodal SEGmentation with Enhanced Vision Foundation Models, Convolutional Neural Networks, and Uncertainty Quantification for High-Speed Video Phase Detection Data}, 
      author={Chika Maduabuchi and Ericmoore Jossou and Matteo Bucci},
      year={2024},
      eprint={2411.07463},
      archivePrefix={arXiv},
      primaryClass={cs.CV},
      url={https://arxiv.org/abs/2411.07463}, 
}
```

---

## 🌟 Acknowledgments

We acknowledge the contributions of the **MIT Red Lab**, collaborators, and funding agencies that supported this research.