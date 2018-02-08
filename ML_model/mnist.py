import tensorflow as tf
from tensorflow.examples.tutorials.mnist import input_data

from keras.models import Sequential
from keras.utils import to_categorical
from keras.layers import Dense, Dropout, Activation, Flatten, BatchNormalization
from keras.layers import Conv2D, MaxPooling2D
from keras.optimizers import Adam

def get_MNIST_data(): 
    """
    https://www.tensorflow.org/get_started/mnist/beginners

    The MNIST data is split into three parts: 
      - 55,000 data points of training data (mnist.train), 
      - 10,000 points of test data (mnist.test), and
      - 5,000 points of validation data (mnist.validation) 
    """
    # using tensorflow api
    return input_data.read_data_sets("MNIST_data/", one_hot=True)


# Initial setups
num_classes = 10

mnist = get_MNIST_data()
X = mnist.train.images.reshape(-1, 28, 28, 1)
y = mnist.train.labels

# model -- Deep MNIST from TensorFlow Tutorial (https://www.tensorflow.org/get_started/mnist/pros)
#####################################################
model = Sequential()

model.add(Conv2D(32, (5,5), padding='same', activation='relu', input_shape=X.shape[1:]))
model.add(MaxPooling2D())

model.add(Conv2D(64, (5,5), padding='same', activation='relu'))
model.add(MaxPooling2D())

model.add(Flatten())

model.add(Dense(1024, activation='relu'))
model.add(Dropout(0.5))

model.add(Dense(num_classes, activation='softmax'))
#####################################################

# summary of your network
model.summary()

# compile the model
model.compile(optimizer=Adam(1e-4), loss='categorical_crossentropy', metrics=['accuracy'])

X_val = mnist.validation.images.reshape(-1, 28, 28, 1)
y_val = mnist.validation.labels

# training
model.fit(X, y, batch_size=64, epochs=1, validation_data=(X_val, y_val))

# check the score
X_test = mnist.test.images.reshape(-1, 28, 28, 1)
y_test = mnist.test.labels

score = model.evaluate(X_test, y_test)

print('Loss: %.3f' % score[0])
print('Accuracy: %.3f' % score[1])

# save your model! serialize model to JSON
#model_json = model.to_json()
#with open("keras_model.json", "w") as json_file:
#    json_file.write(model_json)

# serialize weights to HDF5
#model.save_weights("keras_mnist_model.h5")

# Saving/loading whole models (architecture + weights + optimizer state)
model.save('keras_mnist_model.h5')

