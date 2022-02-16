module test_MEM ();
// Clock and reset signals
reg clk;
reg reset;
// Design Inputs and Outputs

reg[31:0] in_addr;
wire[31:0] out_PC;
wire[31:0] out_inst;

wire   in_PCSel, ALUSrc1, ALUSrc2, RegWE, MemWE;
wire[1:0] WBSel;
wire[31:0] Imm;
wire[4:0]  ALUOp;
wire[4:0] rs1, rs2, rd;
wire BrEq;

reg[31:0] in_WriteData;
wire [31:0] in_ReadData1;
wire [31:0] in_ReadData2;

wire[4:0] ALUop_o;
wire[31:0] ALUOut;

wire[31:0] MemDataOut, verify;
wire[31:0] DataWriteBack;

// Dut instantiation
 PC pc (
     .clk (clk),
     .rst (reset),
     .Addr (ALUOut),
     .PCSel (in_PCSel),
     .PC (out_PC)
 );
 inst_mem im (
  
    .rst (reset),
    .addr (out_PC),
    .inst (out_inst)
);
ID id(
    .rst (reset),
    .inst_i (out_inst),
    .PCSel (in_PCSel),
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
    .BrEq (BrEq)
);

Registers reg_mem (
    .clk (clk),
    .rst (reset),
    .we (RegWE),
    .WriteAddr (rd),
    .WriteData (DataWriteBack), //not consider writeback yet
    .ReadAddr1 (rs1),
    .ReadAddr2 (rs2),
    .ReadData1 (in_ReadData1),
    .ReadData2 (in_ReadData2)
);

BranchComp brc(
    .rst (reset),
    .DataOutReg1(in_ReadData1),
    .DataOutReg2(in_ReadData2),
    .BrEq (BrEq)
);

EX ex(
    .rst(reset),
    .ALUop_i(ALUOp),
    .DataOutReg1 (in_ReadData1),
    .DataOutReg2(in_ReadData2),
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
    .data_i(in_ReadData2),
    .data_o(MemDataOut),
    .verify(verify)
);

WB wb(
    .rst(reset),
    .WBSel(WBSel),
    .PC(out_PC),
    .ALUOut(ALUOut),
    .Data_from_mem(MemDataOut),
    .DataWriteToReg(DataWriteToReg)
);
 // Generate the clock
 initial begin
     clk = 1'b0;
     forever #10 clk = ~clk;
 end

 // Generate the reset
 initial begin
     reset = 1'b1;
     #15
     reset = 1'b0;
 end
 // Test stimulus
 initial begin
     // Use the monitor task to display FPGA IO
    //$monitor( "time=%3d, in_addr=%32b, breq = %1b, in_PCSel=%1b, PC=%32b, Inst=%32b\n", $time, in_addr, BrEq,in_PCSel, out_PC, out_inst);
    $monitor( "***time=%3d, pc_out=%d,immediate=%d, rd=%d, rs1=%d, rs2=%d, WriteData=%d, ReadData1=%d, ReadData2=%d, MemOut=%d\n", $time, out_PC,Imm, rd, rs1, rs2, ALUOut, in_ReadData1, in_ReadData2, MemDataOut);    

 end
endmodule
