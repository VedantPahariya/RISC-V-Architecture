#!/usr/bin/env python3

def format_memory_file(filename):
    
    with open(filename, 'r', encoding='utf-8') as file:
        lines = file.readlines()
    
    new_lines = []
    
    for line in lines:
        line = line.rstrip('\n')
        
        # Handle comment lines or section headers
        if line.strip().startswith('//'):
            new_lines.append(line)
            continue
            
        # Handle empty lines
        if not line.strip():
            new_lines.append(line)
            continue
            
        # Process memory values
        try:
            hex_value = line.strip()
            if all(c in '0123456789abcdefABCDEF' for c in hex_value):
                # Convert to unsigned integer first
                unsigned_value = int(hex_value, 16)
                
                # For 64-bit values (16 hex digits), handle two's complement
                if len(hex_value) == 16:
                    # Check if sign bit (leftmost bit) is set
                    if unsigned_value & (1 << 63):
                        # Apply two's complement to get negative value
                        decimal_value = unsigned_value - (1 << 64)
                    else:
                        decimal_value = unsigned_value
                else:
                    decimal_value = unsigned_value
                
                # Format with professional style - hex | dec:value
                new_line = f"{hex_value} │ dec: {decimal_value:,}"
                new_lines.append(new_line)
            else:
                new_lines.append(line)
        except ValueError:
            # If conversion fails, keep the original line
            new_lines.append(line)
    
    with open(filename, 'w', encoding='utf-8') as file:
        for line in new_lines:
            file.write(line + '\n')

def main():
    # Process both register and memory log files
    try:
        format_memory_file('Registerlog.mem')
        print("Register file updated with signed decimal values")
    except Exception as e:
        print(f"Error processing Registerlog.mem: {e}")
        
    try:
        format_memory_file('Memorylog.mem')
        print("Memory file updated with signed decimal values")
    except Exception as e:
        print(f"Error processing Memorylog.mem: {e}")

if __name__ == "__main__":
    main()