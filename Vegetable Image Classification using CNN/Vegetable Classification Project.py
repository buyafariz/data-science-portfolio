## Import Libraries
import numpy as np
import matplotlib.pyplot as plt
import os
import tensorflow as tf
from tensorflow import keras
from keras.preprocessing import image
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from keras.models import Sequential
from keras.layers import Conv2D
from keras.layers import MaxPooling2D
from keras.layers import Flatten
from keras.layers import Dense
from keras.layers import Dropout


## Import Files
train_path = "...Vegetable/Vegetable Images/train"
validation_path = "...Vegetable/Vegetable Images/validation"
test_path = "...Vegetable/Vegetable Images/test"

## Define the Plot Images Function
# list img_arr
img_arr_list = []

# define plot_image function
def plot_images(image_categories):
    global img_arr_list

    # create a canvas with size 12x12
    plt.figure(figsize=(12,12))
    for i, cat in enumerate(image_categories, start=0):

        # load images for the i-th category
        image_path = train_path + '/' + cat
        images_in_folder = os.listdir(image_path)
        first_image_of_folder = images_in_folder[0]
        first_image_path = image_path + '/' + first_image_of_folder
        img = image.load_img(first_image_path)
        img_arr = image.img_to_array(img)/255

        # add img_arr to the img_arr_list list
        img_arr_list.append(img_arr)

        # creating subplots and plotting images
        plt.subplot(4, 4, i+1)
        plt.imshow(img_arr)
        plt.title(cat)
        plt.axis('off')
    
    # display plot
    plt.show()

## Setting-up The Dataset
# 1. Train Set
train_gen = ImageDataGenerator(rescale=1/255)
train_image_generator = train_gen.flow_from_directory(train_path, target_size=(150,150), batch_size=32, class_mode='categorical')

# 2. Validation Set
val_gen = ImageDataGenerator(rescale=1/225)
val_image_generator = val_gen.flow_from_directory(validation_path, target_size=(150,150), batch_size=32, class_mode='categorical')

# 3. Test Set
test_gen = ImageDataGenerator(rescale=1/225)
test_image_generator = test_gen.flow_from_directory(test_path, target_size=(150,150), batch_size=32, class_mode='categorical')

# Display class label
class_map = dict([(v,k) for k, v in train_image_generator.class_indices.items()])

## Building CNN Model
# Sequential CNN Model
model = Sequential()

# Add layers (layer 1)
model.add(Conv2D(filters=32, kernel_size=3, strides=1, padding='same', activation='relu', input_shape=[150, 150, 3]))

# Add layers (layer 2)
model.add(MaxPooling2D(2))

# Add layers (layer 3)
model.add(Conv2D(filters=64, kernel_size=3, strides=1, padding='same', activation='relu'))

# Add layers (layer 4)
model.add(MaxPooling2D(2))

# Flatten feature map (layer 5)
model.add(Flatten())

# Add fully connected layers (layer 6)
model.add(Dense(128, activation='relu'))

# Add fully connected layers (layer 7)
model.add(Dropout(0.25))

# Add fully connected layers (layer 8)
model.add(Dense(128, activation='relu'))

# Add fully connected layers (layer 9)
model.add(Dense(15, activation='softmax'))

## Schematic Summary of The Model
model.summary()

## Model Prediction
# Menyusun dan menyesuaikan model
early_stopping = keras.callbacks.EarlyStopping(patience=5)
model.compile(optimizer='Adam', loss='categorical_crossentropy', metrics=['accuracy'])
hist = model.fit(train_image_generator, epochs=100, verbose=1, validation_data=val_image_generator, steps_per_epoch=15000//3, validation_steps=3000//32, callbacks=early_stopping)
model.evaluate(test_image_generator)

# Target prediction
test_image_path = "D:/Project/Vegetable Images/test/Pumpkin/1023.jpg"

# Define prediction function
def generate_predictions(test_image_path, actual_label):

    #1 image preprocessing
    test_img = image.load_img(test_image_path, target_size=(150,150))
    test_img_arr = image.img_to_array(test_img)/225
    test_img_input = test_img_arr.reshape((1, test_img_arr.shape[0], test_img_arr.shape[1], test_img_arr.shape[2]))

    #2 prediction
    predicted_label = np.argmax(model.predict(test_img_input))
    predicted_vegetable = class_map[predicted_label]
    plt.figure(figsize=(4,4))
    plt.imshow(test_img_arr)
    plt.title(f"Predicted label: {predicted_vegetable}, Actual label: {actual_label}")
    plt.grid()
    plt.axis('off')
    plt.show()

# Calling The Function
generate_predictions(test_image_path, actual_label='pumpkin')
