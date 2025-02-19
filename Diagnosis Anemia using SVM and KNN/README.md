# Diagnosis Anemia using SVM and KNN
## Project Description
This project aims to classify anemia using supervised machine learning techniques, specifically Support Vector Machine (SVM) and K-Nearest Neighbors (KNN). The dataset used consists of 15,299 samples with 7 predictor variables: Gender, Hemoglobin, Hematocrit, MCH, MCHC, MCV, and RBC. The response variable is binary, indicating whether a patient has anemia or not. The goal is to compare the performance of SVM and KNN models in predicting anemia based on these hematological parameters.

## Methodology
1. **Preprocessing Data**
  - Detect missing values
  - Identifying and removing outliers using the IQR method
  - Encoding categorical variable (Gender)
  - Normalizing numerical features using Min-Max Scaler

2. **Exploratory Data Analysis**
- Statistical summary of variables
- Distribution of anemia cases
- Visualizing the correlation coefficient of each variable using a heatmap

3. **Model Implementation**
- Hyperparameter tuning SVM Linear, polynomial, and RBF Kernel using GridSearchCV
- Implement SVM Linear, polynomial, and RBF Kernel with best parameters result of hyperparameter tuning
- Hyperparameter tuning KNN using GridSearchCV
- Implement KNN with best parameters result of hyperparameter tuning

4. **Model Evaluation**
- Performance metrics: Accuracy, Precision, Recall, and F1-Score.
- Confusion Matrix for each model

## Final Results
The results indicate that the Polynomial SVM model achieves the highest accuracy at 99.93%, along with the best overall classification metrics. However, this comes at the cost of the longest computation time (10.04 seconds). On the other hand, KNN demonstrates the highest computational efficiency, requiring only 0.08 seconds, though its accuracy (98.69%) is lower than that of the other models. This makes KNN a suitable choice for scenarios where speed is a critical factor.
