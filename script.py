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

registers = {
    "x0": "00000", "x1": "00001", "x2": "00010", "x3": "00011", "x4": "00100", 
    "x5": "00101", "x6": "00110", "x7": "00111", "x8": "01000", "x9": "01001",
    "x10": "01010", "x11": "01011", "x12": "01100", "x13": "01101", "x14": "01110",
    "x15": "01111", "x16": "10000", "x17": "10001", "x18": "10010", "x19": "10011",
    "x20": "10100", "x21": "10101", "x22": "10110", "x23": "10111", "x24": "11000",
    "x25": "11001", "x26": "11010", "x27": "11011", "x28": "11100", "x29": "11101",
    "x30": "11110", "x31": "11111"
}

def assemble(instruction):
    parts = instruction.replace(',', '').split()
    mnemonic = parts[0]
    
    if mnemonic in ["add", "and", "or", "xor"]:  # R-type
        rd, rs1, rs2 = registers[parts[1]], registers[parts[2]], registers[parts[3]]
        binary = instruction_map[mnemonic].replace("rs1", rs1).replace("rs2", rs2).replace("rd", rd)
    
    elif mnemonic == "addi":  # I-type immediate
        rd, rs1, imm = registers[parts[1]], registers[parts[2]], format(int(parts[3]), '012b')
        binary = instruction_map[mnemonic].replace("rs1", rs1).replace("rd", rd).replace("imm[11:0]", imm)
    
    elif mnemonic == "ld":  # I-type load
        rd, imm_rs1 = parts[1], parts[2].split('(')
        imm, rs1 = format(int(imm_rs1[0]), '012b'), registers[imm_rs1[1][:-1]]
        binary = instruction_map[mnemonic].replace("rs1", rs1).replace("rd", registers[rd]).replace("imm[11:0]", imm)
    
    elif mnemonic == "sd":  # S-type store
        rs2, imm_rs1 = parts[1], parts[2].split('(')
        imm, rs1 = format(int(imm_rs1[0]), '012b'), registers[imm_rs1[1][:-1]]
        imm_high, imm_low = imm[:7], imm[7:]
        binary = instruction_map[mnemonic].replace("rs1", rs1).replace("rs2", registers[rs2]).replace("imm[11:5]", imm_high).replace("imm[4:0]", imm_low)
    
    elif mnemonic == "beq":  # SB-type branch
        rs1, rs2, imm = registers[parts[1]], registers[parts[2]], format(int(parts[3]), '013b')
        imm_high, imm_low = imm[0] + imm[2:8], imm[8:] + imm[1]
        binary = instruction_map[mnemonic].replace("rs1", rs1).replace("rs2", rs2).replace("imm[12|10:5]", imm_high).replace("imm[4:1|11]", imm_low)
    
    else:
        return None
    
    hex_code = format(int(binary.replace(' ', ''), 2), '08X')
    little_endian = '\n'.join([hex_code[i:i+2] for i in range(6, -1, -2)])
    return little_endian

def main():
    with open("Instruction_Fetch/Instructions.mem", "w") as f:
        while True:
            user_input = input("Enter RISC-V instruction (or 'exit' to quit): ")
            if user_input.lower() == 'exit':
                break
            hex_code = assemble(user_input)
            if hex_code:
                f.write(hex_code + "\n\n")
                print(f"Hex (Little Endian):\n{hex_code}")
            else:
                print("Invalid instruction.")

if __name__ == "__main__":
    main()