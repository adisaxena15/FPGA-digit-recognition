//
// Created by Ved Tiwari on 4/20/25.
//
#include <stdio.h>
#include "model_weights.h"
#include "digit.h"
#include "classification.h"

#include "xil_io.h"                 // Xil_Out32()
#define HEX_GPIO_ADDR 0x40010000

void relu(float *data, int size, int do_relu) {
    if (!do_relu) return;
    for (int i = 0; i < size; ++i)
        if (data[i] < 0) data[i] = 0;
}

void dense_layer(
        const float* input_vector,
        const float* weights_vector,
        const float* bias_vector,
        float* output_vector,
        int num_features,
        int num_neurons,
        int do_relu
) {
    for (int i = 0; i < num_neurons; ++i) {
        float sum = 0.0f;
        for (int j = 0; j < num_features; ++j)
            sum += input_vector[j] * weights_vector[j * num_neurons + i];
        output_vector[i] = sum + bias_vector[i];
    }
    relu(output_vector, num_neurons, do_relu);
}

int return_max(const float* data, int size) {
    int max_index = 0;
    float curr_max = data[0];
    for (int i = 1; i < size; ++i)
        if (data[i] > curr_max) { curr_max = data[i]; max_index = i; }
    return max_index;
}

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

static inline void display_on_hex(int d)
{
    if (d < 0 || d > 9) return;
    Xil_Out32(HEX_GPIO_ADDR, d + 0xFFF0);
}

void p() {
    float normalized_input[784];
    for (int i = 0; i < 784; ++i)
        normalized_input[i] = digit[i] / 255.0f;

    int prediction = predict(normalized_input);
    xil_printf("The number is %d\n", prediction);

    display_on_hex(prediction);
}
