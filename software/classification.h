#ifndef CLASSIFICATION_H
#define CLASSIFICATION_H

void debug(float* data, int size);
void relu(float *data, int size, int do_relu);
void dense_layer(
    const float* input_vector,
    const float* weights_vector,
    const float* bias_vector,
    float* output_vector,
    int num_features,
    int num_neurons,
    int do_relu
);
int return_max(const float* data, int size);
int predict(const float image[784]);
void p(void);

#endif // CLASSIFICATION_H
