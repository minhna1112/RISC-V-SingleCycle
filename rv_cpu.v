module RISCV-Processor (
    input wire clk, 
    input wire reset,
    input wire[31:0] Inst,
    input wire[31:0] data_in,
    
    output reg[31:0] PC,
    output reg[31:0] mem_addr,
    output reg[31:0] data_out,
    output reg MemWE
);


wire[31:0] out_inst;

wire   PCSel, ALUSrc1, ALUSrc2, RegWE, MemWE;
wire[1:0] WBSel;
wire[31:0] Imm;
wire[4:0]  ALUOp;
wire[4:0] rs1, rs2, rd;
wire BrEq, BrLt;

//reg[31:0] in_WriteData;
wire [31:0] DataOutReg1;
wire [31:0] DataOutReg2;

wire[4:0] ALUop_o;
wire[31:0] ALUOut;

wire[31:0] MemDataOut, verify;
wire[31:0] DataWriteBack;

// Dut instantiation
 PC pc (
     .clk (clk),
     .rst (reset),
     .Addr (ALUOut),
     .PCSel (PCSel),
     .PC (PC)
 );
//  inst_mem im (
  
//     .rst (reset),
//     .addr (out_PC),
//     .inst (out_inst)
// );
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
    .WriteData (DataWriteBack), //not consider writeback yet
    .ReadAddr1 (rs1),
    .ReadAddr2 (rs2),
    .ReadData1 (DataOutReg1),
    .ReadData2 (DataOutReg2)
);

BranchComp brc(
    .rst (reset),
    .DataOutReg1(DataOutReg1),
    .DataOutReg2(DataOutReg2),
    .BrEq (BrEq),
    .BrLt (BrLt)
);

EX ex(
    .rst(reset),
    .ALUop_i(ALUOp),
    .DataOutReg1 (DataOutReg1),
    .DataOutReg2(DataOutReg2),
    .ALUSrc1 (ALUSrc1),
    .ALUSrc2 (ALUSrc2),
    .Imm(Imm),
    .PC(out_PC),
    .ALUop_o(ALUop_o),
    .ALUOut(ALUOut)
);

DataMem mem(
    .clk(clk),
    .rst(reset),
    .we(MemWE),
    .addr(ALUOut),
    .data_i(DataOutReg2),
    .data_o(MemDataOut),
    .verify(verify)
);

WB wb(
    .rst(reset),
    .WBSel(WBSel),
    .PC(out_PC),
    .ALUOut(ALUOut),
    .Data_from_mem(MemDataOut),
    .DataWriteToReg(DataWriteBack)
);
//  // Generate the clock
//  initial begin
//      clk = 1'b0;
//      forever #10 clk = ~clk;
//  end

//  // Generate the reset
//  initial begin
//      reset = 1'b1;
//      #15
//      reset = 1'b0;
//  end

//  // Test stimulus
//  initial begin
//      // Use the monitor task to display FPGA IO
//     //$monitor( "time=%3d, in_addr=%32b, breq = %1b, in_PCSel=%1b, PC=%32b, Inst=%32b\n", $time, in_addr, BrEq,in_PCSel, out_PC, out_inst);
//     $monitor( "***time=%3d, pc_out=%d,immediate=%d, rd=%d, rs1=%d, rs2=%d, WriteData=%d, ReadData1=%d, ReadData2=%d, MemOut=%d\n", $time, out_PC,Imm, rd, rs1, rs2, ALUOut, in_ReadData1, in_ReadData2, MemDataOut);    

//  end
endmodule
