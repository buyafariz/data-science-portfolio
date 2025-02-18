# Vegetable Image Classification Using CNN
## Project Description
This project aims to develop a Convolutional Neural Network (CNN) model to perform vegetable image classification based on a dataset obtained from Vegetable Image Dataset - Kaggle. The model is designed to recognize 15 types of vegetables based on the images given as input.

## Methodologi
1. Preprocessing Data
  - The dataset is divided into three parts: Train, Validation, and Test.
  - Images were converted to numerical arrays and normalized to improve model performance.
  - Data Augmentation is applied using ImageDataGenerator to improve model generalization.

2. CNN Architecture  
The CNN model used consists of several main layers:
- Convolutional Layer: Extracting features from an image with a 3x3 filter.
- MaxPooling Layer: Reduce feature dimensions to improve computational efficiency.
- Flatten Layer: Convert features into one-dimensional vectors.
- Fully Connected (Dense) Layer: Connecting all neurons for final classification.
- Dropout Layer: Reducing overfitting by ignoring some neurons during training.

3. Model Training
- Model compiled using Adam Optimizer and Categorical Crossentropy Loss.
- Training was conducted for 100 epochs with an Early Stopping strategy to stop training if the model performance stagnated..
- Evaluation is done using a test dataset to measure the accuracy of the model.

4. Image Prediction
- The model can predict the type of vegetable from the input image.
- The prediction result is visualized by displaying the input image along with the predicted label..

## Final Results
- The CNN model successfully performs classification with a high level of accuracy on validation and test datasets..
- Visualization of prediction results shows that the model is able to recognize various types of vegetables well.
- This project can be expanded to be applied in vegetable recognition automation system in farming or retail industry..
