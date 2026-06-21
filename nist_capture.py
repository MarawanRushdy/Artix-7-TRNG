import serial
import time

# 125,000 bytes = 1,000,000 bits
TOTAL_BYTES = 125000 
filename = "million_bits.txt"

print(f"Connecting to the Quantum Matrix on COM6...")
fpga_port = serial.Serial('COM6', 115200)

print(f"Capturing 1,000,000 bits. This will take about 11 seconds...")
start_time = time.time()

with open(filename, "w") as f:
    for i in range(TOTAL_BYTES):
        raw_byte = fpga_port.read(1)
        binary_string = format(raw_byte[0], '08b')
        f.write(binary_string)
        
        # Print a progress update every 25,000 bytes
        if (i + 1) % 25000 == 0:
            print(f" > Captured {(i + 1) * 8:,} bits...")

end_time = time.time()
print(f"\nCapture complete in {end_time - start_time:.2f} seconds!")
print(f"Saved to {filename}")

fpga_port.close()