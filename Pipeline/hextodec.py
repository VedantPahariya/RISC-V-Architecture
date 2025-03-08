#!/usr/bin/env python3

def format_memory_file(filename):
    """Annotate memory file with decimal values in a professional format."""
    
    with open(filename, 'r', encoding='utf-8') as file:
        lines = file.readlines()
    
    new_lines = []
    reg_index = 0  # Register counter for Registerlog.mem
    is_register_file = "Register" in filename
    
    for line in lines:
        line = line.rstrip('\n')
        
        # Skip section header lines (like "// 0x00000010")
        if line.strip().startswith('// 0x'):
            # Still update the register index, but don't add the line to output
            if is_register_file:
                reg_index = int(line.strip().split('0x')[1], 16)
            continue
            
        # Handle other comment lines
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
                
                # Format with professional style
                if is_register_file and reg_index < 32:  # Only for registers x0-x31
                    # Format: x0: 0000000000000000 │ dec: 0
                    reg_name = f"x{reg_index}"
                    new_line = f"{reg_name:<3}: {hex_value} / {decimal_value:,}"
                    reg_index += 1
                else:
                    # Standard format for memory: hex │ dec: value
                    new_line = f"{hex_value} / {decimal_value:,}"
                
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
        print("Register file updated with signed decimal values and register numbers")
    except Exception as e:
        print(f"Error processing Registerlog.mem: {e}")
        
    try:
        format_memory_file('Memorylog.mem')
        print("Memory file updated with signed decimal values")
    except Exception as e:
        print(f"Error processing Memorylog.mem: {e}")

if __name__ == "__main__":
    main()