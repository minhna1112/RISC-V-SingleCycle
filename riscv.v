module riscv(
    input wire clk,
    input wire reset,
    input wire[31:0] Inst,
    input wire[31:0] data_in_from_mem,
    
    output wire [31:0] PC,
    output reg[31:0] mem_addr,
    output reg[31:0] data_out_to_mem,
    output wire PCSel,
    output wire MemWE
);

wire   ALUSrc1, ALUSrc2, RegWE;
wire[1:0] WBSel;
wire[31:0] Imm;
wire[4:0]  ALUOp;
wire[4:0] rs1, rs2, rd;
wire BrEq, BrLt;

//reg[31:0] in_WriteData;
wire [31:0] in_ReadData1;
wire [31:0] in_ReadData2;

wire[4:0] ALUop_o;
wire[31:0] ALUOut;


wire[31:0] DataWriteBack;

// Dut instantiation
 PC pc (
     .clk (clk),
     .rst (reset),
     .Addr (ALUOut),
     .PCSel (PCSel),
     .PC (PC)
 );


ID id(
    .rst (reset),
    .inst_i (Inst),
    .PCSel (PCSel),
    .ALUSrc1 (ALUSrc1),
    .ALUSrc2 (ALUSrc2),
    .RegWE (RegWE),
    .MemWE (MemWE),
    .WBSel (WBSel),
    .Imm (Imm),
    .ALUop (ALUOp),
    .rs1 (rs1),
    .rs2 (rs2),
    .rd (rd),
    .BrEq (BrEq),
    .BrLt (BrLt)
);

Registers reg_mem (
    .clk (clk),
    .rst (reset),
    .we (RegWE),
    .WriteAddr (rd),
    .WriteData (DataWriteBack), 
    .ReadAddr1 (rs1),
    .ReadAddr2 (rs2),
    .ReadData1 (in_ReadData1),
    .ReadData2 (in_ReadData2)
);

BranchComp brc(
    .rst (reset),
    .DataOutReg1(in_ReadData1),
    .DataOutReg2(in_ReadData2),
    .BrEq (BrEq),
    .BrLt (BrLt)
);

EX ex(
    .rst(reset),
    .ALUop_i(ALUOp),
    .DataOutReg1 (in_ReadData1),
    .DataOutReg2(in_ReadData2),
    .ALUSrc1 (ALUSrc1),
    .ALUSrc2 (ALUSrc2),
    .Imm(Imm),
    .PC(PC),
    .ALUop_o(ALUop_o),
    .ALUOut(ALUOut)
);

WB wb(
    .rst(reset),
    .WBSel(WBSel),
    .PC(PC),
    .ALUOut(ALUOut),
    .Data_from_mem(data_in_from_mem),
    .DataWriteToReg(DataWriteBack)
);

always @(*) begin
    data_out_to_mem = in_ReadData2;
end

always @(*) begin
    mem_addr = ALUOut;
end

endmodule
