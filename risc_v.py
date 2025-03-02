instruction_map = {
    "add":  "0000000 rs2 rs1 000 rd 0110011",
    "addi": "imm[11:0] rs1 000 rd 0010011",
    "and":  "0000000 rs2 rs1 111 rd 0110011",
    "or":   "0000000 rs2 rs1 110 rd 0110011",
    "xor":  "0000000 rs2 rs1 100 rd 0110011",
    "ld":   "imm[11:0] rs1 011 rd 0000011",
    "sd":   "imm[11:5] rs2 rs1 011 imm[4:0] 0100011",
    "beq":  "imm[12|10:5] rs2 rs1 000 imm[4:1|11] 1100011",
}

registers = {f"x{i}": format(i, "05b") for i in range(32)}  # x0 - x31 in binary

def assemble(instruction):
    parts = instruction.replace(',', '').split()
    if not parts:
        return None

    mnemonic = parts[0]
    
    if mnemonic in ["add", "and", "or", "xor"]:  # R-type
        rd, rs1, rs2 = registers[parts[1]], registers[parts[2]], registers[parts[3]]
        binary = instruction_map[mnemonic].replace("rs1", rs1).replace("rs2", rs2).replace("rd", rd)
    
    elif mnemonic == "addi":  # I-type
        rd, rs1, imm = registers[parts[1]], registers[parts[2]], format(int(parts[3]), '012b')
        binary = instruction_map[mnemonic].replace("rs1", rs1).replace("rd", rd).replace("imm[11:0]", imm)
    
    elif mnemonic == "ld":  # Load
        rd, imm_rs1 = parts[1], parts[2].split('(')
        imm, rs1 = format(int(imm_rs1[0]), '012b'), registers[imm_rs1[1][:-1]]
        binary = instruction_map[mnemonic].replace("rs1", rs1).replace("rd", registers[rd]).replace("imm[11:0]", imm)
    
    elif mnemonic == "sd":  # Store
        rs2, imm_rs1 = parts[1], parts[2].split('(')
        imm, rs1 = format(int(imm_rs1[0]), '012b'), registers[imm_rs1[1][:-1]]
        imm_high, imm_low = imm[:7], imm[7:]
        binary = instruction_map[mnemonic].replace("rs1", rs1).replace("rs2", registers[rs2]).replace("imm[11:5]", imm_high).replace("imm[4:0]", imm_low)
    
    elif mnemonic == "beq":  # Conditional branch with target
        rs1, rs2, target = registers[parts[1]], registers[parts[2]], int(parts[3])
        imm = format(target * 2, '013b')  # Convert target to 13-bit immediate (PC-relative)
        imm_high, imm_low = imm[0] + imm[2:8], imm[8:] + imm[1]
        binary = instruction_map[mnemonic].replace("rs1", rs1).replace("rs2", rs2).replace("imm[12|10:5]", imm_high).replace("imm[4:1|11]", imm_low)
    
    else:
        return None
    
    hex_code = format(int(binary.replace(' ', ''), 2), '08X')
    little_endian = '\n'.join([hex_code[i:i+2] for i in range(6, -1, -2)])
    return little_endian

def main():
    input_file = "input.txt"
    output_file = "Instruction_Fetch/Instructions.mem"

    try:
        with open(input_file, "r") as f:
            instructions = f.readlines()

        with open(output_file, "w") as f:
            for line in instructions:
                line = line.strip()
                if line and not line.startswith("#"):  # Ignore empty lines and comments
                    hex_code = assemble(line)
                    if hex_code:
                        f.write(hex_code + "\n\n")
                        print(f"Converted: {line} ->\n{hex_code}\n")
                    else:
                        print(f"Invalid instruction: {line}")

        print(f"\nHex instructions saved to {output_file}")

    except FileNotFoundError:
        print(f"Error: {input_file} not found. Please create the file and add instructions.")

if __name__ == "__main__":
    main()
