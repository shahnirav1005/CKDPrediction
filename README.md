# Chronic Kidney Disease Prediction

## About

The chronic kidney disease (CKD) describes the heterogeneous disorders that affect the functionality and the structure of kidney.
The progression of CKD may lead to complications such as high blood pressure, anemia, weak bones, poor nutritional health and
damage and if not treated, it may eventually lead to kidney failure which requires dialysis or kidney transplant.
Therefore, it is vital to detect it and prevent its progression in the early stages. The existing markers for CKD diagnosis
can only identify high-risk patients and do not improve the understanding of the pathogenesis and progression of disease.

In this study, the objective is to analyze and determine the possible predictive factors that are reliable and easily measured
in laboratory environment for the early recognition and prevention of the progression of the disease.

In this report, we try to use GLM along with various model selection techniques to build a prediction model for CKD detection. We validate the model and test its predictive power via the generalized linear models.

## Usage

### The R script - ckd_predictions.R require R and R Studio be installed with the following libraries:

- ggplot2
- VIM
- Amelia
- vcd
- glm
- ResourceSelection
- lars
- lasso
- glmnet
- cv.glmnet
- nnet

### The Python script - ckd_classifiers.py required Python2.7 or above installed along with the following modules:

- scikit-learn

## Data

The data was downloaded from the following URL - 
[CKD Dataset](https://archive.ics.uci.edu/ml/datasets/chronic_kidney_disease)
The dataset information such as attributes, their description and values can be found in the downloaded folder.
The dataset is renamed to CKD.csv which is used for both R and Python Scripts
There are 400 observations with 25 attributes including the outcome.

## Repository Folder Hierarchy

	CKDPrediction/								<- Parent Directory <parent_dir>
	├── CKD_UCI_Data    							<- Dataset Directory
	│   ├── CKD.csv 							<- Raw dataset
	│   ├── CKDClean.csv 							<- NA-omitted dataset
	│   ├── chronic_kidney_disease.arff
	│   ├── chronic_kidney_disease.info.txt
	│   └── chronic_kidney_disease_full.arff
	│
	├── ckd_predictions.R 							<- R-script for exploratory and glm analysis
	├── ckd_classifiers.py 							<- Python2.7 for ML classifiers and predictions
	│
	├── CKD_FinalAnalysisReport.pdf 					<- Final Report (Submitted - Analyzed and Explained)
	└── README.md 								<- This file

