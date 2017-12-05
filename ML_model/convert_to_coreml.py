# See documentation for more details
# https://apple.github.io/coremltools/generated/coremltools.converters.keras.convert.html
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


