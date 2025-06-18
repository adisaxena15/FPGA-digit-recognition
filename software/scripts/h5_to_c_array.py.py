import h5py
import numpy as np

# Change this to control fixed-point scaling
SCALE_FACTOR = 1000

def format_fixed_point_array(name, array, scale=SCALE_FACTOR):
    scaled_array = np.round(array * scale).astype(np.int16)
    flat_array = scaled_array.flatten()
    c_array = ", ".join(str(x) for x in flat_array)
    shape_comment = f"// shape: {array.shape}, scaled by {scale}"
    return f"{shape_comment}\nconst int16_t {name}[] = {{ {c_array} }};\n"

def save_weights_to_fixed_point_c(h5_path, output_path="model_weights_fixed.h"):
    with h5py.File(h5_path, "r") as f:
        with open(output_path, "w") as out_file:
            out_file.write("// Fixed-point C arrays from H5 model using python script\n\n")
            out_file.write(f"#define FIXED_POINT_SCALE {SCALE_FACTOR}\n\n")
            def visit_fn(name, obj):
                if isinstance(obj, h5py.Dataset):
                    c_name = name.replace("/", "_").replace("kernel", "weights").replace("bias", "biases")
                    data = np.array(obj)
                    array_def = format_fixed_point_array(c_name, data)
                    out_file.write(array_def + "\n")
            f.visititems(visit_fn)

h5_model_path = "../models/digit_model.h5"
save_weights_to_fixed_point_c(h5_model_path)

print("Fixed-point C arrays written to model_weights_fixed.h")