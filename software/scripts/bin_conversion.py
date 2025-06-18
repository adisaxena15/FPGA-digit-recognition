def encode_text_to_bin_file(text, filename):
    with open(filename, 'wb') as file:
        file.write(text.encode('utf-8'))

if __name__ == "__main__":
    input_text = input("Enter the text to encode: ")
    output_filename = "output.bin"
    encode_text_to_bin_file(input_text, output_filename)
    print(f"Encoded text saved to {output_filename}")