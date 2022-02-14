module test_REG ();
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


// Dut instantiation
 PC pc (
     .clk (clk),
     .rst (reset),
     .Addr (in_addr),
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
    .WriteData (in_WriteData),
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

 // Generate the clock
 initial begin
     clk = 1'b0;
     forever #10 clk = ~clk;
 end

 // Generate the reset
 initial begin
     reset = 1'b0;
     #15
     reset = 1'b1;
 end
 // Test stimulus
 initial begin
     // Use the monitor task to display FPGA IO
    $monitor( "time=%3d, in_addr=%32b, in_PCSel=%1b, PC=%32b, Inst=%32b\n", $time, in_addr, in_PCSel, out_PC, out_inst);
    //$monitor( "***time=%3d, pc_out=%32d,immediate=%32d, rd=%5d, rs1=%5d, rs2=%5d, WriteData=%32d, ReadData1=%32d, ReadData2=%32d\n", $time, out_PC,Imm, rd, rs1, rs2, in_WriteData, in_ReadData1, in_ReadData2);
// Generate each input with a 20ns delay between them
    
    in_addr = 32'h00000000;
    #20 
    in_WriteData = in_ReadData1 + Imm;
    #20
    in_WriteData = in_ReadData1 + Imm;
    #20
    in_WriteData = in_ReadData1 + in_ReadData2;
    #20
    in_WriteData = in_ReadData1 - in_ReadData2;
    #20
    in_WriteData = in_ReadData1 + in_ReadData2;
    
    
    
  
 end
endmodule
