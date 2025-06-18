import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Flatten
import numpy as np

# Load data
mnist = tf.keras.datasets.mnist
(x_train, y_train), _ = mnist.load_data()
x_train = x_train / 255.0  # Normalize pixel values between 0 and 1

# Build a simple model
model = Sequential([
    Flatten(input_shape=(28, 28)),       # 28x28 = 784 pixel input
    Dense(128, activation='relu'),       # Hidden layer with 128 neurons
    Dense(10, activation='softmax')      # Output layer (10 digits)
])

# Compile and train the model
model.compile(optimizer='adam', loss='sparse_categorical_crossentropy', metrics=['accuracy'])
model.fit(x_train, y_train, epochs=10)

#accuracy check
(_, _), (x_test, y_test) = mnist.load_data()
x_test = x_test / 255.0
loss, acc = model.evaluate(x_test, y_test)
print("Test accuracy:", acc)

#seeing shape
weights = model.get_weights()
print([w.shape for w in weights])

# Save model to .h5
# model.save("digit_model.h5")

# Save the model as a .bin file
flat_weights = np.concatenate([w.flatten() for w in model.get_weights()])
flat_weights.astype(np.float32).tofile("../clsfc/include/digit.bin")

print(f"Saved {len(flat_weights)} weights ({len(flat_weights) * 4} bytes) to weights.bin")
