# TNBC scRNA-seq ML GenAI

## Reproducible Single-Cell RNA-seq, Machine Learning, Biological Validation, and GenAI Interpretation Platform for Triple-Negative Breast Cancer

## Overview

This project develops a reproducible, production-oriented computational platform for analyzing single-cell RNA sequencing (scRNA-seq) data from triple-negative breast cancer (TNBC), with downstream machine-learning-based biomarker discovery, independent biological validation, and GenAI-assisted biological interpretation.

The project is designed from the beginning around **Nextflow, Docker, GitHub, and AWS**, with the goal of producing a reproducible workflow suitable for research, publication, portfolio demonstration, and future cloud deployment.

The computational workflow will progress from raw sequencing data through:

**FASTQ → preprocessing → transcript quantification → count-matrix generation → cell-level QC → normalization → clustering → cell-type annotation → differential expression/pathway analysis → sample-level pseudobulk → ML biomarker discovery → independent validation → GenAI biological interpretation → AWS deployment**

---

## Scientific Motivation

Triple-negative breast cancer (TNBC) lacks expression of estrogen receptor, progesterone receptor, and HER2, and is therefore characterized by substantial biological and molecular heterogeneity.

Single-cell RNA sequencing provides an opportunity to investigate this heterogeneity at cellular resolution by identifying:

- distinct cellular populations
- tumor-associated cell states
- immune-cell populations
- stromal and epithelial populations
- differentially expressed genes
- biological pathways associated with disease states
- candidate molecular biomarkers

The objective of this project is to combine these biological insights with statistically appropriate machine-learning approaches to identify candidate biomarker signatures while maintaining strict separation between discovery and validation.

---

## Project Objectives

### Primary objective

Develop a reproducible TNBC scRNA-seq analysis and biomarker-discovery platform combining:

1. Single-cell RNA-seq processing
2. Cell-level quality control
3. Cell-type annotation
4. Differential expression analysis
5. Pathway and biological interpretation
6. Sample-level pseudobulk feature generation
7. Machine-learning-based biomarker discovery
8. Independent validation
9. GenAI-assisted biological interpretation
10. Cloud-based reproducible execution on AWS

### Reproducibility objective

Every computational stage should be executable through version-controlled workflow code and containerized software rather than relying on undocumented manual processing.

---

## Dataset

The initial TNBC dataset is:

- **GEO accession:** GSE188600
- **SRA project:** SRP345543
- **Initial sequencing run:** SRR16915023
- **Platform:** 10x Genomics Chromium v2
- **Species:** Homo sapiens
- **Disease context:** Triple-negative breast cancer

The sequencing run will be processed as the complete dataset.

For computational scalability and controlled processing, the sequencing reads may be divided into multiple read partitions. These partitions represent portions of the **same sequencing library** and must therefore be aggregated at the count level before downstream cell-level analysis.

They must **not** be treated as independent biological samples.

Additional publicly available TNBC datasets will be incorporated where required to establish an appropriate sample-level machine-learning and independent-validation design.

---

# Project Architecture

```text
                         GitHub Repository
                               │
                               ▼
                    Nextflow + Docker
                               │
                               ▼
                       Reproducible Pipeline
                               │
             ┌─────────────────┴─────────────────┐
             ▼                                   ▼
       Local / WSL2                         AWS Cloud
                                               │
                                  ┌────────────┴────────────┐
                                  ▼                         ▼
                                 S3                 AWS Batch / EC2
                                                           │
                                                           ▼
                                                   Containerized Jobs
                                                           │
                                                           ▼
                         ┌─────────────────────────────────────────┐
                         │         scRNA-seq Analysis              │
                         │                                         │
                         │ FASTQ → Quantification → Matrix        │
                         │ → QC → Normalization → Clustering      │
                         │ → Cell-type Annotation → DEG/Pathways  │
                         └──────────────────┬──────────────────────┘
                                            │
                                            ▼
                                   Sample-level Pseudobulk
                                            │
                                            ▼
                                  ML Feature Engineering
                                            │
                                            ▼
                                     SageMaker ML
                                            │
                              ┌─────────────┴─────────────┐
                              ▼                           ▼
                         Biomarker                  Model Evaluation
                         Discovery                  & Interpretation
                              │
                              ▼
                    Independent Validation
                              │
                              ▼
                    GenAI Biological Interpretation
```

---

# Reproducibility Framework

The project is built around four core reproducibility components:

### GitHub

Source-code version control, documentation, workflow definitions, configuration, tests, and project history.

### Nextflow

Workflow orchestration, dependency management, process execution, parallelization, resumability, and local/cloud portability.

### Docker

Containerized computational environments with explicitly defined software dependencies and versions.

### AWS

Cloud-based storage, scalable compute, workflow execution, machine learning, logging, and model infrastructure.

---

# Workflow

## Phase 1 — Data Acquisition

Raw sequencing data will be obtained from public repositories such as SRA/GEO.

Planned workflow:

```text
GEO/SRA
   ↓
SRA accession
   ↓
FASTQ
   ↓
S3 raw-data storage
```

Data acquisition will be implemented as a reproducible Nextflow process rather than a manual download step.

---

## Phase 2 — Raw FASTQ Processing

The sequencing reads will undergo:

- FASTQ validation
- sequencing quality assessment
- FastQC
- MultiQC
- 10x barcode/UMI-aware processing
- transcript quantification

The project will preserve the barcode and UMI structure required by the 10x Genomics chemistry.

No arbitrary trimming will be introduced if it compromises barcode/UMI structure.

---

## Phase 3 — Transcript Quantification and Count-Matrix Generation

The workflow will use a reproducibly versioned reference genome and annotation.

The reference configuration will explicitly document:

- genome assembly
- annotation release
- transcript-to-gene mapping
- kallisto index
- software versions

The transcript quantification stage will produce gene-by-cell count information.

When sequencing reads are processed in partitions, counts corresponding to the same cell barcode will be **summed across partitions** to reconstruct the complete count matrix.

This is essential because the partitions originate from the same biological library.

---

## Phase 4 — Single-Cell Quality Control

Cell-level QC will evaluate metrics including:

- number of detected genes
- total UMI counts
- mitochondrial transcript percentage
- potential doublets
- low-quality cells
- highly expressed genes
- sequencing/library quality

Filtering thresholds will be parameterized rather than hard-coded where possible.

QC thresholds and resulting cell numbers will be recorded as workflow outputs.

---

## Phase 5 — Normalization and Integration

The workflow will perform:

- normalization
- highly variable gene identification
- scaling
- dimensionality reduction
- PCA
- neighborhood graph construction
- UMAP
- clustering

If multiple biological datasets are incorporated, batch correction/integration will be performed using an explicitly documented strategy.

---

## Phase 6 — Cell-Type Annotation

Cell-type annotation will be performed **before supervised biomarker ML**.

Annotation will combine:

- canonical marker genes
- cluster-level differential expression
- biological knowledge
- appropriate automated/reference-based methods where justified

Expected populations may include immune, epithelial/tumor, stromal, and other relevant cellular compartments.

Cell-type assignments will be treated as biological annotations rather than simply cluster numbers.

---

## Phase 7 — Differential Expression and Biological Analysis

The project will generate:

- cluster markers
- cell-type markers
- differential-expression results
- enriched biological pathways
- GO analysis
- KEGG/pathway analysis where appropriate
- relevant gene-set analyses
- biological interpretation

Results will be stored as machine-readable files and publication-quality figures.

---

# Phase 8 — Pseudobulk and Machine Learning

## Critical statistical design

Individual cells will **not** be treated as independent biological samples for supervised machine learning.

Instead, the workflow will construct sample-level features using pseudobulk aggregation.

Conceptually:

```text
Individual cells
       ↓
Cell-type annotation
       ↓
Cell type × biological sample
       ↓
Pseudobulk expression
       ↓
Feature engineering
       ↓
Sample-level ML matrix
```

The current sequencing run represents a biological library and therefore does not by itself provide sufficient independent biological samples for a defensible supervised ML model.

Additional publicly available TNBC samples/datasets will therefore be incorporated for model development and validation.

---

# ML Biomarker Discovery

Candidate models may include:

- Logistic Regression
- Random Forest
- XGBoost
- Support Vector Machine

The workflow will incorporate:

- discovery/validation separation
- training/validation/test strategy where dataset size permits
- cross-validation
- feature selection
- class-balance considerations
- hyperparameter optimization where appropriate
- feature importance
- SHAP-based model interpretation

Feature selection must occur within the appropriate training folds to prevent data leakage.

The final output will be a candidate biomarker signature rather than simply a list of genes correlated with the dataset.

---

# Independent Validation

Discovery and validation will be treated as separate analytical stages.

The validation dataset will not be used during:

- feature selection
- model training
- hyperparameter selection
- biomarker ranking

The final candidate signature will be evaluated on an independent dataset where appropriate.

Validation will consider both:

- predictive performance
- biological reproducibility

---

# GenAI Interpretation

GenAI will be used as a **downstream interpretation layer**, not as a replacement for statistical analysis.

Potential applications include:

- literature-supported interpretation of candidate biomarkers
- gene–gene relationships
- gene–pathway relationships
- biological mechanism summaries
- interpretation of enriched pathways
- generation of structured biological hypotheses
- comparison with published TNBC biology

GenAI-generated interpretations will be separated from experimentally or statistically validated findings.

---

# AWS Architecture

The production cloud architecture is planned around:

### Amazon S3

Storage for:

- raw data
- reference files
- intermediate outputs
- count matrices
- analysis results
- ML features
- trained models
- validation results

### Amazon ECR

Versioned Docker images used by the workflow.

### AWS Batch

Scalable execution of containerized Nextflow processes using managed compute.

### Amazon EC2

Compute infrastructure for AWS Batch where appropriate.

### AWS Fargate

Optional execution environment for lightweight containerized services where appropriate.

### Amazon SageMaker

Planned use for:

- ML training
- model evaluation
- hyperparameter optimization
- model management
- model deployment where appropriate

SageMaker will operate downstream of the scRNA-seq/pseudobulk feature-generation workflow rather than replacing the primary scRNA-seq processing pipeline.

### Amazon CloudWatch

Monitoring and centralized logging for cloud jobs and services.

---

# Software Stack

Planned core technologies include:

| Component | Technology |
|---|---|
| Workflow | Nextflow |
| Containers | Docker |
| Version control | Git / GitHub |
| scRNA-seq | Scanpy / Seurat |
| Quantification | kb-python / kallisto / bustools |
| QC | FastQC / MultiQC |
| Statistical analysis | R / Python |
| Machine learning | scikit-learn / XGBoost |
| Model interpretation | SHAP |
| Cloud storage | Amazon S3 |
| Container registry | Amazon ECR |
| Workflow compute | AWS Batch / EC2 |
| ML platform | Amazon SageMaker |
| Monitoring | Amazon CloudWatch |
| GenAI | To be defined according to the final cloud architecture |

Exact software versions will be pinned and recorded as the pipeline is implemented.

---

# Repository Structure

The repository is being developed with the following structure:

```text
TNBC-scRNAseq-ML-GenAI/
│
├── README.md
├── LICENSE
├── CITATION.cff
├── CHANGELOG.md
├── CONTRIBUTING.md
│
├── main.nf
├── nextflow.config
├── nextflow_schema.json
│
├── conf/
│   ├── base.config
│   ├── local.config
│   ├── aws.config
│   └── profiles.config
│
├── modules/
│   ├── sra/
│   ├── qc/
│   ├── reference/
│   ├── kb/
│   ├── matrix/
│   ├── sc_qc/
│   ├── normalization/
│   ├── clustering/
│   ├── annotation/
│   ├── deg/
│   ├── pathway/
│   ├── pseudobulk/
│   ├── feature_engineering/
│   ├── ml/
│   ├── validation/
│   └── genai/
│
├── subworkflows/
│   ├── acquisition.nf
│   ├── preprocessing.nf
│   ├── scrna_analysis.nf
│   ├── biological_analysis.nf
│   ├── ml_pipeline.nf
│   └── validation.nf
│
├── containers/
│   ├── sra/
│   ├── qc/
│   ├── kb/
│   ├── r-seurat/
│   ├── python-ml/
│   └── genai/
│
├── scripts/
│   ├── matrix_aggregation/
│   ├── pseudobulk/
│   ├── annotation/
│   ├── ml/
│   └── validation/
│
├── params/
│   ├── project.yml
│   ├── dataset.yml
│   └── reference.yml
│
├── tests/
│   ├── test_data/
│   ├── test_modules/
│   └── test_workflow/
│
├── docs/
│   ├── architecture/
│   ├── workflow/
│   ├── methods/
│   ├── figures/
│   └── manuscript/
│
├── infrastructure/
│   └── aws/
│
└── .github/
    └── workflows/
        ├── nf-test.yml
        ├── docker-build.yml
        └── lint.yml
```

---

# Reproducibility and Quality Control

The project will use:

- version-controlled source code
- pinned software/container versions
- parameterized workflows
- Nextflow execution reports
- workflow provenance
- Docker containers
- automated tests
- GitHub Actions
- documented reference versions
- reproducible random seeds where applicable
- explicit discovery/validation separation

Large sequencing files, AWS credentials, secrets, and generated intermediate data will not be committed to GitHub.

---

# Testing Strategy

The workflow will be tested progressively.

### Unit/module tests

Individual workflow modules will be tested independently.

### Small test dataset

A small test dataset will be used to verify pipeline execution without requiring the full TNBC dataset.

### Integration testing

The complete workflow will be tested from input to output using controlled test data.

### Production execution

The complete TNBC dataset will then be processed using the validated workflow.

---

# Current Project Status

**Status: Project initialization**

Completed:

- project scientific architecture defined
- reproducibility strategy defined
- GitHub repository initialized
- local Git repository initialized
- `main` branch established
- Nextflow environment available
- Docker environment available

In development:

- Nextflow workflow
- Docker containers
- reproducible reference generation
- SRA/FASTQ acquisition
- matrix aggregation
- scRNA-seq QC and analysis
- cell-type annotation
- pseudobulk generation
- ML feature engineering
- biomarker discovery
- independent validation
- GenAI interpretation
- AWS infrastructure
- automated testing

---

# Important Scientific Limitations

The initial sequencing run represents a biological library rather than multiple independent biological samples.

Dividing sequencing reads into multiple computational partitions does **not** create independent biological replicates.

Therefore, the initial dataset alone is suitable for developing and demonstrating the scRNA-seq processing workflow but is not sufficient by itself for a robust supervised ML biomarker-discovery study.

Additional biological samples/datasets will be incorporated for sample-level ML and independent validation.

---

# Planned Outputs

The completed project is expected to produce:

- reproducible scRNA-seq processing pipeline
- quality-control reports
- integrated single-cell expression matrix
- cell-type annotations
- clustering and UMAP visualizations
- marker-gene results
- differential-expression results
- pathway-enrichment results
- sample-level pseudobulk matrices
- ML feature matrices
- candidate biomarker signatures
- model-performance evaluations
- independent validation results
- interpretable ML outputs
- GenAI-assisted biological interpretation
- AWS deployment architecture
- reproducible execution documentation
- publication-quality figures and tables

---

# Project Philosophy

The central principle of this project is:

> **Reproducibility first, biological validity second, machine learning third, and GenAI as an interpretation layer.**

The goal is not simply to produce a machine-learning model.

The goal is to build an end-to-end computational framework in which:

**raw sequencing data → reproducible processing → biologically meaningful cellular states → statistically appropriate sample-level features → validated ML biomarkers → independent validation → interpretable biological hypotheses**

can be reproduced by another researcher.

---

# License

License information will be finalized before public release.

---

# Citation

Citation information will be added when the final project and associated manuscript are established.

---

# Acknowledgements

This project uses publicly available genomic datasets and open-source computational tools.

Dataset and software citations will be documented in the final release.
