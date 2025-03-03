# instruction_map = {
#     "add":  "0000000 rs2 rs1 000 rd 0110011",
#     "addi": "imm[11:0] rs1 000 rd 0010011",
#     "and":  "0000000 rs2 rs1 111 rd 0110011",
#     "or":   "0000000 rs2 rs1 110 rd 0110011",
#     "xor":  "0000000 rs2 rs1 100 rd 0110011",
#     "ld":   "imm[11:0] rs1 011 rd 0000011",
#     "sd":   "imm[11:5] rs2 rs1 011 imm[4:0] 0100011",
#     "beq":  "imm[12|10:5] rs2 rs1 000 imm[4:1|11] 1100011",
# }

# registers = {f"x{i}": format(i, "05b") for i in range(32)}  # x0 - x31 in binary

def main():
    # Read input file
    with open("input.txt", "r") as f:
        lines = [line.strip() for line in f.readlines() if line.strip()]
    
    # Convert each instruction to hexadecimal
    hex_instructions = []
    for line in lines:
        binary = instruction_to_binary(line)
        hex_val = binary_to_hex_little_endian(binary)
        hex_instructions.append(hex_val)
    
    # Write to output file
    with open("Instructions.mem", "w") as f:
        for hex_instr in hex_instructions:
            for i in range(4):  # 4 bytes per instruction
                f.write(hex_instr[i*2:(i+1)*2] + "\n")

def instruction_to_binary(instruction):
    """Convert a RISC-V assembly instruction to its 32-bit binary representation."""
    parts = instruction.replace(",", " ").split()
    opcode = parts[0].lower()
    
    # R-type instructions (add, sub, xor, or, and, sll, srl, sra, slt, sltu)
    if opcode in ["add", "sub", "xor", "or", "and", "sll", "srl", "sra", "slt", "sltu"]:
        rd = parse_register(parts[1])
        rs1 = parse_register(parts[2])
        rs2 = parse_register(parts[3])
        
        funct3 = {
            "add": "000", "sub": "000",
            "xor": "100", "or": "110", "and": "111",
            "sll": "001", "srl": "101", "sra": "101",
            "slt": "010", "sltu": "011"
        }[opcode]
        
        funct7 = "0000000"
        if opcode in ["sub", "sra"]:
            funct7 = "0100000"
        
        opcode_bin = "0110011"  # R-type opcode
        
        binary = funct7 + rs2 + rs1 + funct3 + rd + opcode_bin
    
    # I-type instructions (addi, xori, ori, andi, slli, srli, srai, slti, sltiu, lb, lh, lw, lbu, lhu, ld)
    elif opcode in ["addi", "xori", "ori", "andi", "slli", "srli", "srai", "slti", "sltiu", 
                   "lb", "lh", "lw", "lbu", "lhu", "ld", "jalr"]:
        rd = parse_register(parts[1])
        
        # Handle load instructions with offset
        if opcode in ["lb", "lh", "lw", "lbu", "lhu", "ld"]:
            # Parse something like "ld x10, 2(x1)"
            offset_reg = parts[2].split("(")
            imm = int(offset_reg[0])
            rs1 = parse_register(offset_reg[1].rstrip(")"))
        else:
            rs1 = parse_register(parts[2])
            imm = int(parts[3])
        
        # Handle negative immediates (12-bit 2's complement)
        if imm < 0:
            imm = (1 << 12) + imm
        

        
        imm_bin = format(imm & 0xFFF, '012b')  # 12-bit immediate
        #print(imm_bin)
        
        funct3 = {
            "addi": "000", "xori": "100", "ori": "110", "andi": "111",
            "slli": "001", "srli": "101", "srai": "101",
            "slti": "010", "sltiu": "011",
            "lb": "000", "lh": "001", "lw": "010", "lbu": "100", "lhu": "101", "ld": "011",
            "jalr": "000"
        }[opcode]
        
        opcode_bin = {
            "addi": "0010011", "xori": "0010011", "ori": "0010011", "andi": "0010011",
            "slli": "0010011", "srli": "0010011", "srai": "0010011",
            "slti": "0010011", "sltiu": "0010011",
            "lb": "0000011", "lh": "0000011", "lw": "0000011", "lbu": "0000011", "lhu": "0000011",
            "ld": "0000011", "jalr": "1100111"
        }[opcode]
        
        binary = imm_bin + rs1 + funct3 + rd + opcode_bin
    
    # S-type instructions (sb, sh, sw, sd)
    elif opcode in ["sb", "sh", "sw", "sd"]:
        rs2 = parse_register(parts[1])
        
        # Parse something like "sd x10, 3(x0)"
        offset_reg = parts[2].split("(")
        imm = int(offset_reg[0])
        rs1 = parse_register(offset_reg[1].rstrip(")"))
        
        # Handle negative immediates (12-bit 2's complement)
        if imm < 0:
            imm = (1 << 12) + imm
        
        imm_bin = format(imm & 0xFFF, '012b')
        imm_high = imm_bin[0:7]  # imm[11:5]
        imm_low = imm_bin[7:12]  # imm[4:0]
        
        funct3 = {
            "sb": "000", "sh": "001", "sw": "010", "sd": "011"
        }[opcode]
        
        opcode_bin = "0100011"  # S-type opcode
        
        binary = imm_high + rs2 + rs1 + funct3 + imm_low + opcode_bin
    
    # B-type instructions (beq, bne, blt, bge, bltu, bgeu)
    elif opcode in ["beq", "bne", "blt", "bge", "bltu", "bgeu"]:
        rs1 = parse_register(parts[1])
        rs2 = parse_register(parts[2])
        imm = int(parts[3])

        #print(imm)
        
        # Branch immediate is 12 bits with LSB always 0 (mult of 2)
        # Handle negative immediates (12-bit 2's complement)
        if imm < 0:
            imm = (1 << 12) + imm
        
        # Convert to 11-bit binary (shifted)
        imm_bin = format(imm & 0x7FF, '012b')
        #print(imm_bin)
        
        # Decompose B-type immediate: imm[11|9:4|3:0|10]
        imm_11 = imm_bin[0]
        #print("imm_11:", imm_11)
        imm_10 = imm_bin[1]
        #print("imm_10:", imm_10)
        imm_9_4 = imm_bin[2:8]
        #print("imm_9_4:", imm_9_4)
        imm_3_0 = imm_bin[8:12]  # Corrected this line to use proper indexing
        #print("imm_3_0:", imm_3_0)

        imm_left = imm_11 + imm_9_4
        #print(imm_left)
        imm_right = imm_3_0 + imm_10
        #print(imm_right)
        
        funct3 = {
            "beq": "000", "bne": "001",
            "blt": "100", "bge": "101",
            "bltu": "110", "bgeu": "111"
        }[opcode]
        
        opcode_bin = "1100011"  # B-type opcode
        
        binary = imm_left + rs2 + rs1 + funct3 + imm_right + opcode_bin
        #print(binary)
    
    else:
        raise ValueError(f"Unsupported instruction: {instruction}")
    
    return binary

def parse_register(reg_str):
    """Parse a register string (e.g., 'x10') and return its binary representation."""
    reg_num = int(reg_str.replace('x', ''))
    return format(reg_num, '05b')

def binary_to_hex_little_endian(binary):
    """Convert a 32-bit binary string to a little-endian hexadecimal string."""
    # Convert binary to integer
    value = int(binary, 2)
    
    # Format as 8-digit hexadecimal
    hex_str = format(value, '08x')
    
    # Convert to little-endian (reverse byte order)
    little_endian = ""
    for i in range(3, -1, -1):
        little_endian += hex_str[i*2:(i+1)*2]
    
    return little_endian

if __name__ == "__main__":
    main()