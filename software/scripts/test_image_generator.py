from tensorflow.keras.datasets import mnist
import matplotlib.pyplot as plt
import numpy as np
import os

test_num = 2

# Load dataset
(_, _), (x_test, y_test) = mnist.load_data()

# Find the first image of the desired digit
for i in range(len(y_test)):
    if y_test[i] == test_num:
        sample = x_test[i]
        break

# Flatten and normalize to 0–1 if needed
flattened = sample.flatten().astype(float)

# Clean up previous files
if os.path.exists("digit.h"):
    os.remove("digit.h")
if os.path.exists("digit.png"):
    os.remove("digit.png")

# Save as C array
with open("../classification/include/digit.h", "w") as f:
    f.write("extern const float digit[784] = {\n    ")
    f.write(", ".join(map(str, flattened)))
    f.write("\n};\n")

# Save the image for visual reference
plt.imsave("digit.png", sample, cmap='gray')