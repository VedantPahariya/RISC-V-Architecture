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
                decimal_value = int(hex_value, 16)
                
                # Format with professional style - hex | dec:value
                new_line = f"{hex_value} │ dec: {decimal_value:,}"
                new_lines.append(new_line)
            else:
                new_lines.append(line)
        except ValueError:
            # If conversion fails, keep the original line
            new_lines.append(line)
    
    # Key change: Add UTF-8 encoding when writing the file
    with open(filename, 'w', encoding='utf-8') as file:
        for line in new_lines:
            file.write(line + '\n')

def main():
    # Process both register and memory log files
    try:
        format_memory_file('Registerlog.mem')
    except Exception as e:
        print(f"Error processing Registerlog.mem: {e}")
        
    try:
        format_memory_file('Memorylog.mem')
    except Exception as e:
        print(f"Error processing Memorylog.mem: {e}")

if __name__ == "__main__":
    main()