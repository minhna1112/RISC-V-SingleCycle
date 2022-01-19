module ID (
    input wire rst,
    input wire[31:0] inst,
    output wire PCSel, ALUSrc1, AlUSrc2, RegWE, MemWE,
    output wire[1:0] ALUOp, WBSel,
    output wire[31:0] Imm
)

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
       RegWE <== 1'b0;
    else
       RegWE <== 1'b1;
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
       ALUOp <=  
end