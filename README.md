# Edge Computing with MicroBlaze C

Implementing handwritten digit recognition using the MicroBlaze soft processor to accurately predict handwritten digits between 0-9 on FPGA hardware

![MicroBlaze Block Diagram](https://github.com/ved-tiwari/fpga_digit_recognition/blob/main/Docs/download.png)

## Project Overview

This project implements a lightweight, two-layer **neural network** for handwritten digit recognition on a **Spartan-7** FPGA using the **MicroBlaze** soft processor. Due to tight on-chip memory constraints (<64KB), model training was performed off-board, using Google's TensorFlow machine learning framework, and inference was run using parameters stored in the board’s **DDR3** memory.

Images were captured at 640×480 using the **OV7670** camera, then downsampled using **nearest neighbor interpolation** to a 28×28 format compatible with the **MNIST** dataset. This enabled accurate digit classification within the FPGA's resource limits.

Inference is handled in C:
- `dense_layer()` performs matrix multiplication, bias addition, and optional **ReLU** activation.  
- `predict()` runs the input through two dense layers (784→128→10), returning the class with the highest activation.  
- `p()` normalizes the image, calls `predict()`, and outputs the result via **UART** and a memory-mapped **HEX display** at `0x40010000`.

This design demonstrates real-time edge inference with efficient use of hardware and memory on constrained FPGA systems.

#### Core Inference Snippet (C)

```c
int predict(const float image[784]) {
    float layer_1_output[128];
    float layer_2_output[10];

    dense_layer(image,
                model_weights_dense_sequential_dense_weights,
                model_weights_dense_sequential_dense_biases,
                layer_1_output,
                784, 128, 1);

    dense_layer(layer_1_output,
                model_weights_dense_1_sequential_dense_1_weights,
                model_weights_dense_1_sequential_dense_1_biases,
                layer_2_output,
                128, 10, 0);

    return return_max(layer_2_output, 10);
}

void p() {
    float normalized_input[784];
    for (int i = 0; i < 784; ++i)
        normalized_input[i] = digit[i] / 255.0f;

    int prediction = predict(normalized_input);
    xil_printf("The number is %d\n", prediction);

    display_on_hex(prediction);
}
```
### Camera Module
The **OV7670** camera module is used to capture real-time grayscale images at a resultion of 640x480 pixels. Interfacing with the camera involved configuring the SCCB (Serial Camera Control Bus) to set internal registers and capture frames using the FPGA’s **VDMA** and **AXI GPIO** interfaces.

To reduce memory bandwidth and processing requirements, the raw image was:

1. **Downsampled** to 28×28 using **nearest neighbor interpolation** in hardware, converting it to a format compatible with the MNIST dataset.
2. processed pixel by pixel, implementing an Finite State Machine to ensure synchronization with camera's **VSYNC** and **PCLK** signals.
3. **Stored in on-chip memory BRAM**, and then passed to the MicroBlaze processor for inference.
4. A custom **I²C driver** was implemented in SystemVerilog to communicate with the camera over SCCB. This driver handled start/stop conditions, byte-level transmission, color-mode initialization, and acknowledgment checking to ensure reliable register writes during initialization.


### Tools
- **Vivado** 2022.4
- **Vitis SDK**
- **TensorFlow**
- **C/C++**
- **Inter-Integrated Circuit Driver: SCCB**

### Hardware
- **RealDigital Urbana** FPGA Board  
- **OV7670** Camera Module

