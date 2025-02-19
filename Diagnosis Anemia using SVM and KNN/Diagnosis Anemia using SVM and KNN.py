## Upload Data
# import libraries
import pandas as pd
import numpy as np

# load data
data = pd.read_excel('...\SKILICARSLAN_Anemia_DataSet_2.xlsx')
data = data[['Gender', 'Hemoglobin', 'HCT', 'MCH', 'MCHC', 'MCV', 'RBC', 'Result']]

# display data
print(data)

# displays the data type of each variable
print(data.dtypes)

## Preprocessing Data
# Distribution of Each Variable (Box-plot)
import matplotlib.pyplot as plt

plt.figure(figsize=(5, 3))
data.boxplot()
plt.title('Boxplot of 8 Variables')
plt.xlabel('Variables')
plt.ylabel('Values')
plt.show()

# Extreme Outlier Detection
extreme_outlier_mch_dg = data[data['MCH'] > 60]
extreme_outlier_mchc_dg = data[data['MCHC'] > 60]
print(f'Extreme outlier berdasarkan variabel MCH: \n{extreme_outlier_mch_dg}\n')
print(f'Extreme outlier berdasarkan variabel MCHC: \n{extreme_outlier_mchc_dg}')

# Cleaning Data from Extreme Outliers
data = data.drop(extreme_outlier_mch_dg.index)

# Missing Values Detection
print(data.isnull().sum())

# Null Values Detection
nul_value = data.apply(lambda x: (x == 0).sum())
print(nul_value)

## Exploratory Data Analysis
# Statistics Descriptif
description = data.describe()

# Adding The Mode Value of Each Variable
mode = data.mode().iloc[0]

# Adding The Mode to Statistics Descriptif
description.loc['mode'] = mode
print(description)

# Target Variable Analysis
import matplotlib.pyplot as plt

result_no_anemia = 0
result_anemia = 0

for i in data['Result']:
  if i == 1:
    result_anemia += 1
  else:
    result_no_anemia += 1

labels = ['Tidak Anemia', 'Anemia']
values = [result_no_anemia, result_anemia]

# Distribution of Target Variable (Pie Chart)
import matplotlib.pyplot as plt

plt.figure(figsize=(8, 8))
plt.pie(values, labels=labels, autopct='%1.1f%%')
plt.title('Distribution of Target Variable')
plt.show()

# Coefficient of Correlation
import seaborn as sns

# Correlation Matrix for Each Variable
correlation_matrix = data.corr()

# Heatmap of Correlation
plt.figure(figsize=(10, 8))
sns.heatmap(correlation_matrix, annot=True, cmap='coolwarm', vmin=-1, vmax=1)
plt.title("Heatmap of Correlation")
plt.show()

## Feature Scaling
data1 = data.copy()

# Split Dataset (train test split)
X = data1.drop(columns='Result')
y = data1['Result']

# Divide The Data into Train Data and Test Data
from sklearn.model_selection import train_test_split
X_train1, X_test1, y_train1, y_test1 = train_test_split(X, y, test_size=0.2, random_state=0)

# Implement MinMaxScaler
from sklearn.preprocessing import MinMaxScaler

# Inisialization Min-Max Scaler
mm_scaler = MinMaxScaler()

# Scaling only for data training
X_train_num = mm_scaler.fit_transform(X_train1[['Hemoglobin', 'HCT','MCH', 'MCHC', 'MCV', 'RBC']])

# Using The Same Scaling Parameters for Data Testing
X_test_num = mm_scaler.transform(X_test1[['Hemoglobin', 'HCT', 'MCH', 'MCHC', 'MCV', 'RBC']])

# Combining Gender Data with Scaled Numerical Data
X_train_processed = np.hstack((X_train1[['Gender']].values, X_train_num))
X_test_processed = np.hstack((X_test1[['Gender']].values, X_test_num))

## Implement SVM and KNN Algorithm
# Defining functions for model evaluation
def evaluate_model(y_test, y_pred, start_time):
    accuracy = accuracy_score(y_test, y_pred)
    precision = precision_score(y_test, y_pred)
    recall = recall_score(y_test, y_pred)
    f1 = f1_score(y_test, y_pred)
    confusion_mat = confusion_matrix(y_test, y_pred)
    computation_time = time.time() - start_time
    print(f"Accuracy = {accuracy}")
    print(f"Precision = {precision}")
    print(f"Recall = {recall}")
    print(f"F1-score = {f1}")
    print("Confusion Matrix:\n", confusion_mat)
    print(f"\nComputation Time: {computation_time} detik\n")

## SVM Algorithm
# SVM Classification Algorithm
from sklearn.metrics import accuracy_score, confusion_matrix, precision_score, recall_score, f1_score
from sklearn.svm import SVC
import time

# Start Time
start_time = time.time()

# Training SVM Model
svm_model = SVC()
print(f"Parameter model :\n{svm_model.get_params()}\n")

svm_model.fit(X_train_processed, y_train1)

# Predict and Test The Model
y_pred = svm_model.predict(X_test_processed)

# Evaluating The Model
evaluate_model(y_test1, y_pred, start_time)

## KNN Algorithm
# KNN Classification Algorithm
from sklearn.metrics import accuracy_score, confusion_matrix, precision_score, recall_score, f1_score
from sklearn.neighbors import KNeighborsClassifier
import time

# Start Time
start_time = time.time()

# Training KNN Model
knn_model = KNeighborsClassifier()
print(f"Parameter model :\n{knn_model.get_params()}\n")

knn_model.fit(X_train_processed, y_train1)

# Predict and Test The Model
y_pred = knn_model.predict(X_test_processed)

# Evaluating The Model
evaluate_model(y_test1, y_pred, start_time)

## SVM Linear Algorithm (Tuned Parameters)
# Hyperparameters Tuning SVM Linear Classification Algorithm
from sklearn.model_selection import GridSearchCV

# List of Hyperparameters to be Tuned
c = [0.1, 1, 10, 100]
kernel = ['linear']

# Convert to Dictionary Form
hyperparameters = dict(C=c, kernel=kernel)

# Use Gridsearch
clf = GridSearchCV(svm_model, hyperparameters, scoring = 'accuracy', cv=5)

# Fit The Model
best_model = clf.fit(X_train_processed, y_train1)

# Display The Score of Each Possible Parameter
results = pd.DataFrame(clf.cv_results_)
scores = results[['param_C', 'param_kernel', 'mean_test_score']]
print(scores)

# Best Hyperparameters
best_score = best_model.best_score_
best_params = best_model.best_params_
print(f"Best Score: {best_score}")
print(f"Best Parameters: {best_params}")

# SVM Linear Algorithm
from sklearn.metrics import accuracy_score, confusion_matrix, precision_score, recall_score, f1_score
from sklearn.svm import SVC
import time

# Start time
start_time = time.time()

# Training SVM Linear Model
svm_linear_model = SVC(C=100, kernel='linear', probability=True)
print(f"Parameter model :\n{svm_linear_model.get_params()}\n")

svm_linear_model.fit(X_train_processed, y_train1)

# Predict and Test The Model
y_pred = svm_linear_model.predict(X_test_processed)

# Evaluating The Model
evaluate_model(y_test1, y_pred, start_time)

## SVM Polynomial Algorithm (Tuned Parameters)
# Hyperparameters Tuning SVM Polynomial Classification Algorithm
from sklearn.model_selection import GridSearchCV

# List of Hyperparameters to be Tuned
c = [0.1, 1, 10, 100]
degree = [2, 3, 4, 5]
kernel = ['poly']

# Convert to Dictionary Form
hyperparameters = dict(C=c, degree=degree, kernel=kernel)

# Use Gridsearch
clf = GridSearchCV(svm_model, hyperparameters, scoring = 'accuracy', cv=5)

# Fit the model
best_model = clf.fit(X_train_processed, y_train1)

# Display The Score of Each Possible Parameter
results = pd.DataFrame(clf.cv_results_)
scores = results[['param_C', 'param_degree', 'param_kernel', 'mean_test_score']]
print(scores)

# Best Hyperparameters
best_score = best_model.best_score_
best_params = best_model.best_params_
print(f"Best Score: {best_score}")
print(f"Best Parameters: {best_params}")

# SVM Polynomial Algorithm
from sklearn.metrics import accuracy_score, confusion_matrix, precision_score, recall_score, f1_score
from sklearn.svm import SVC
import time

# Start time
start_time =time.time()

# Training SVM Polynomial Model
svm_poly_model = SVC(C=100, degree=5, kernel='poly', probability=True)
print(f"Parameter model :\n{svm_poly_model.get_params()}\n")

svm_poly_model.fit(X_train_processed, y_train1)

# Predict and Test The Model
y_pred = svm_poly_model.predict(X_test_processed)

# Evaluating The Model
evaluate_model(y_test1, y_pred, start_time)

## SVM RBF Algorithm (Tuned Parameters)
# Hyperparameters Tuning SVM Classification Algorithm
from sklearn.model_selection import GridSearchCV

# List of Hyperparameters to be Tuned
c = [0.1, 1, 10, 100]
gamma = [0.001, 0.01, 0.1, 1]
kernel = ['rbf']

# Convert to Dictionary Form
hyperparameters = dict(C=c, gamma=gamma, kernel=kernel)

# Use Gridsearch
clf = GridSearchCV(svm_model, hyperparameters, scoring = 'accuracy', cv=5)

# Fit the model
best_model = clf.fit(X_train_processed, y_train1)

# Display The Score of Each Possible Parameter
results = pd.DataFrame(clf.cv_results_)
scores = results[['param_C', 'param_gamma', 'param_kernel', 'mean_test_score']]
print(scores)

# Best Hyperparameters
best_score = best_model.best_score_
best_params = best_model.best_params_
print(f"Best Score: {best_score}")
print(f"Best Parameters: {best_params}")

# SVM Radial Basis Function Algorithm
from sklearn.metrics import accuracy_score, confusion_matrix, precision_score, recall_score, f1_score
from sklearn.svm import SVC
import time

# Start time
start_time = time.time()

# Training SVM Radial Basis Function Model
svm_rbf_model = SVC(C=100, gamma=1, kernel='rbf', probability=True)
print(f"Parameter model :\n{svm_rbf_model.get_params()}\n")

svm_rbf_model.fit(X_train_processed, y_train1)

# Predict and Test The Model
y_pred = svm_rbf_model.predict(X_test_processed)

# Evaluating The Model
evaluate_model(y_test1, y_pred, start_time)

## KNN Algorithm (Tuned Parameters)
# Hyperparameters Tuning KNN Algorithm
from sklearn.model_selection import GridSearchCV

# List of Hyperparameters to be Tuned
n_neighbors = [3, 5, 7, 9, 11]
weights = ['uniform', 'distance']
metric = ['euclidean']

# Convert to Dictionary Form
hyperparameters = dict(n_neighbors=n_neighbors, weights=weights, metric=metric)

# Use Gridsearch
clf = GridSearchCV(knn_model, hyperparameters, scoring = 'accuracy', cv=5)

# Fit the model
best_model = clf.fit(X_train_processed, y_train1)

# Display The Score of Each Possible Parameter
results = pd.DataFrame(clf.cv_results_)
scores = results[['param_n_neighbors', 'param_weights', 'param_metric', 'mean_test_score']]
print(scores)

# Best Hyperparameters
best_score = best_model.best_score_
best_params = best_model.best_params_
print(f"Best Score: {best_score}")
print(f"Best Parameters: {best_params}")

# KNN Algorithm
from sklearn.metrics import accuracy_score, confusion_matrix, precision_score, recall_score, f1_score
from sklearn.neighbors import KNeighborsClassifier
import time

# Start time
start_time = time.time()

# Training KNN Model
knn1_model = KNeighborsClassifier(n_neighbors=11, metric='euclidean', weights='distance')
print(f"Parameter model :\n{knn1_model.get_params()}\n")

knn1_model.fit(X_train_processed, y_train1)

# Predict and Test The Model
y_pred = knn1_model.predict(X_test_processed)

# Evaluating The Model
evaluate_model(y_test1, y_pred, start_time)
