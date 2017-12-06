# Digit Recogition with Custom Model using CoreML
![ios11+](https://img.shields.io/badge/ios-11%2B-blue.svg)
![swift4+](https://img.shields.io/badge/swift-4%2B-orange.svg)


After **iOS 11**, Apple introduce **[CoreML](https://developer.apple.com/documentation/coreml)**, which enables developer to build up application with state-of-the-art AI technique.

In this project, you can recognize your **handwritten digit** with a machine learning model, specially trained model based on digit [(MNIST)](http://yann.lecun.com/exdb/mnist/).

![digit_recognition.gif](https://github.com/Weijay/DigitRecognition/blob/master/resources/digitRecognition.gif)

Apple provides [ready-to-use Core ML models](https://developer.apple.com/machine-learning/), or you can find some interesting models available [here](https://coreml.store/). What's more, you can use **your own machine learning model!**

---
## Build up Machine Learning Model with Keras
![tensorflow](https://img.shields.io/badge/tensorflow-1.4.0-blue.svg)
![keras](https://img.shields.io/badge/keras-2.1.2-brightgreen.svg)
![coremltools](https://img.shields.io/badge/coremltools-0.7-orange.svg)

As you may know, [TensorFlow](https://www.tensorflow.org/) is the most popular machine learning library, and  [Keras](https://keras.io/) is a high-level neural networks API, written in Python and capable of running on top of TensorFlow.

#### Environment Requiresments:
- **python 2.7** (for coremltools)
- [coremoltools](https://pypi.python.org/pypi/coremltools)
- [tensorflow](https://www.tensorflow.org/)
- [keras](https://keras.io/)


~~My environment is currently in Python 3. To be pain-free, you have to create a python 2 environment for everything to work.~~
For me I use [Anaconda](https://conda.io/docs/user-guide/install/download.html) to manage packages and environments.

create one for python version 2.

``conda create -n py2 python=2``

and you can list all the environments you have

``conda env list``

```
# conda environments:
#
py2                      /Users/WeiJay/anaconda/envs/py2
tensorflow               /Users/WeiJay/anaconda/envs/tensorflow
root                  *  /Users/WeiJay/anaconda
```
activate **py2** to set up the environment

``source activate py2``

```
pip install -U coremltools
pip install --upgrade tensorflow      # for Python 2.7
pip install keras
pip install h5py                      # required if you plan on saving Keras models to disk
```

### Quick use
open your terminal, and go to the project directory.
``` 
$ cd ~/DigitRecognition/ML_model/
$ python mnist.py
$ python convert_to_coreml.py
```


### Build my own deep MNIST model
I build an easy deep network with the [Deep MNIST for Experts](https://www.tensorflow.org/get_started/mnist/pros) instruction.
In brief, my network structure is as follows: **Conv - Pool - Conv - Pool - FC - Dropout - FC(Softmax)**

With Keras' API, you can see your network structure `model.summary()`

Also, you can evaluate you model `model.evaluate(X_test, y_test)`

![model_image](https://github.com/Weijay/DigitRecognition/blob/master/resources/model.png)


Training a model is pretty time consuming, you can save your model to disk whenever you want!

```python
# save your model! serialize model to JSON
model_json = model.to_json()
with open("keras_model.json", "w") as json_file:
    json_file.write(model_json)

# serialize weights to HDF5
model.save_weights("keras_mnist_model.h5")
```

### Convert to CoreML Model
When you satisfy with your model, **load** your **model** from disk as well as the **pretrained weights**, then convert to coreml model. 

That's all. Finally, drag and drop your model and happy coding 😀

```python
import coremltools
from keras.models import model_from_json

# load model and weights
json_file = open('keras_model.json', 'r')
loaded_model_json = json_file.read()
json_file.close()
model = model_from_json(loaded_model_json)
model.load_weights("keras_mnist_model.h5")

# convert to .mlmodel
keras_model = coremltools.converters.keras.convert(model, 
                                                    input_names='image (28x28)', 
                                                    image_input_names='image (28x28)', 
                                                    output_names = ['prediction'],
                                                    class_labels=['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'])
keras_model.author = 'Wei Chieh'
keras_model.license = 'nope'
keras_model.short_description = 'Predicts a handwritten digit'

keras_model.save('my_mnist.mlmodel')
```

