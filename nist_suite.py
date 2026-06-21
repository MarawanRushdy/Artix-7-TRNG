import math

def nist_frequency_test(bits):
    print("Running NIST Frequency (Monobit) Test...")
    n = len(bits)
    # Convert '0' to -1, and '1' to +1
    sum_n = sum(1 if b == '1' else -1 for b in bits)
    
    # Calculate test statistic and P-value
    s_obs = abs(sum_n) / math.sqrt(n)
    p_value = math.erfc(s_obs / math.sqrt(2))
    
    status = "PASS" if p_value >= 0.01 else "FAIL"
    print(f" > P-Value: {p_value:.6f} [{status}]\n")
    return p_value

def nist_runs_test(bits):
    print("Running NIST Runs Test...")
    n = len(bits)
    pi = bits.count('1') / n
    
    # Prerequisite: Frequency must pass a loose boundary first
    tau = 2 / math.sqrt(n)
    if abs(pi - 0.5) >= tau:
        print(" > FAIL: Frequency prerequisite not met for Runs test.\n")
        return 0.0
        
    # Count the number of runs (flips)
    v_obs = 1
    for i in range(n - 1):
        if bits[i] != bits[i+1]:
            v_obs += 1
            
    # Calculate P-value using the standard NIST formula
    numerator = abs(v_obs - 2 * n * pi * (1 - pi))
    denominator = 2 * math.sqrt(2 * n) * pi * (1 - pi)
    p_value = math.erfc(numerator / denominator)
    
    status = "PASS" if p_value >= 0.01 else "FAIL"
    print(f" > P-Value: {p_value:.6f} [{status}]\n")
    return p_value

# --- Main Execution ---
print("=== SP 800-22 CRYPTOGRAPHIC TEST SUITE ===")
print("Loading 1,000,000 bits into memory...")

with open("whitened_bits.txt", "r") as f:
    data = f.read()

nist_frequency_test(data)
nist_runs_test(data)
print("==========================================")