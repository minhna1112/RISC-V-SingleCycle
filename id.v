module ID (
    input wire rst,
    input wire[31:0] inst_i,
    output reg PCSel, ALUSrc1, ALUSrc2, RegWE, MemWE,
    output reg[1:0] WBSel,
    output reg[31:0] Imm,
    output reg[4:0]  ALUop,
    output reg[5:0] rs1, rs2, rd
);

wire[31:0] imm_I = {{21{inst_i[31:31]}}, inst_i[30:20]};
wire[31:0] imm_B = {{20{inst_i[31:31]}}, inst_i[ 7: 7], inst_i[30:25], inst_i[11:8], 1'b0};
wire[31:0] imm_S = {{21{inst_i[31:31]}}, inst_i[30:25], inst_i[11:7]};

always @ (*) begin
    if (!rst)
        PCSel <= 1'b0;
    else if (inst_i[6:0] == 7'b1100111 || inst_i[6:0] == 7'b1100011)  // jalr, beq
        PCSel <= 1'b1;
    else
        PCSel <= 1'b0;
end


always @ (*) begin
    if (!rst)
        ALUSrc1 <= 1'b0;
    else if (inst_i[6:0] == 7'b1100011)  //  beq
        ALUSrc1 <= 1'b1;
    else
        ALUSrc1 <= 1'b0;
end

always @ (*) begin
    if (!rst)
        ALUSrc2 <= 1'b0;
    else if (inst_i[6:0] == 7'b0110011)  // R-type
        ALUSrc2 <= 1'b0;
    else
        ALUSrc2 <= 1'b1;
end

always @ (*) begin
    if (!rst)
       RegWE <= 1'b0;
    else if (inst_i[6:0] == 7'b0100011 || inst_i[6:0] == 7'b1100011) // S-type and B-type
       RegWE <= 1'b0;
    else
       RegWE <= 1'b1;
end

always @ (*) begin
    if (!rst)
       MemWE <= 1'b0;
    else if (inst_i[6:0] == 7'b0100011) // Store Instruction
       MemWE <= 1'b1;
    else
       MemWE <= 1'b0;
end

always @ (*) begin
    if (!rst)
       WBSel <= 2'b0;
    else if (inst_i[6:0] == 7'b0000011)
       WBSel <= 2'b01;
    else if (inst_i[6:0] == 7'b1100111)
       WBSel <= 2'b10;
    else
       WBSel <= 2'b0;    
end

always @ (*) begin
    if (!rst)
        ALUop <= 5'b0;
    else begin
        casex (inst_i)

            32'bxxxxxxxxxxxxxxxxx000xxxxx1100011: ALUop <= 5'b10001;  // beq
            32'bxxxxxxxxxxxxxxxxx010xxxxx0000011: ALUop <= 5'b10100;  // lw
            32'bxxxxxxxxxxxxxxxxx010xxxxx0100011: ALUop <= 5'b10101;  // sw
            32'bxxxxxxxxxxxxxxxxx000xxxxx0010011: ALUop <= 5'b01100;  // addi
            32'b0000000xxxxxxxxxx000xxxxx0110011: ALUop <= 5'b01101;  // add
            32'b0100000xxxxxxxxxx000xxxxx0110011: ALUop <= 5'b01110;  // sub
            32'b0000000xxxxxxxxxx100xxxxx0110011: ALUop <= 5'b00110;  // xor
            32'b0000000xxxxxxxxxx101xxxxx0110011: ALUop <= 5'b01001;  // srl
            32'b0000000xxxxxxxxxx110xxxxx0110011: ALUop <= 5'b00101;  // or
            32'b0000000xxxxxxxxxx111xxxxx0110011: ALUop <= 5'b00100;  // and
            32'bxxxxxxxxxxxxxxxxx000xxxxx1100111: ALUop <= 5'b10100;  // jalr
            default: ALUop <= 5'b0;
        endcase
    end
end

always @ (*) begin
    if (!rst)
        Imm <= 32'b0;
    else begin
        casex (inst_i)
            32'bxxxxxxxxxxxxxxxxx000xxxxx1100011: Imm <= imm_B;  // beq
            32'bxxxxxxxxxxxxxxxxx010xxxxx0000011: Imm <= imm_I;  // lw
            32'bxxxxxxxxxxxxxxxxx010xxxxx0100011: Imm <= imm_S;  // sw
            32'bxxxxxxxxxxxxxxxxx000xxxxx0010011: Imm <= imm_I;  // addi
            32'bxxxxxxxxxxxxxxxxx000xxxxx1100111: Imm <= imm_I;  // jalr
            default: Imm <= 32'b0;
        endcase
    end
end

always @ (*) begin
    if (!rst)
        rd <= 1'b0;
    else
        rd <= inst_i[11:7];
end

always @ (*) begin
    if (!rst)
        rs1 <= 1'b0;
    else
        rs1 <= inst_i[19:15];
end

always @ (*) begin
    if (!rst)
        rs2 <= 1'b0;
    else
        rs2 <= inst_i[24:20];
end

endmodule