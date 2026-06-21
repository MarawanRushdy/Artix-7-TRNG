print("Loading flawed physical data...")
with open("million_bits.txt", "r") as f:
    raw_bits = f.read()

print(f"Raw bits loaded: {len(raw_bits):,}")

# The Von Neumann Extractor
clean_bits = []
for i in range(0, len(raw_bits) - 1, 2):
    pair = raw_bits[i:i+2]
    
    if pair == '01':
        clean_bits.append('1')
    elif pair == '10':
        clean_bits.append('0')
    # If '00' or '11', do nothing (discard)

clean_data_string = "".join(clean_bits)

print(f"Clean bits extracted: {len(clean_data_string):,}")
print("Saving cleaned data to 'whitened_bits.txt'...")

with open("whitened_bits.txt", "w") as f:
    f.write(clean_data_string)

print("Done! You can now run the NIST suite on 'whitened_bits.txt'")