module test_ID ();
// Clock and reset signals
reg clk;
reg reset;
// Design Inputs and Outputs

reg[31:0] in_addr;
wire[31:0] out_PC;
wire[31:0] out_inst;

wire   in_PCSel, ALUSrc1, AlUSrc2, RegWE, MemWE;
wire[1:0] WBSel;
wire[31:0] Imm;
wire[4:0]  ALUOp;



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
    .RegWE (RegWe),
    .MemWE (MemWe),
    .WBSel (WBSel),
    .Imm (Imm),
    .ALUop (ALUOp)
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
// Generate each input with a 20ns delay between them
    
    in_addr = 32'h00000000;
    #110
    in_addr = 32'h00000000;
  
 end
endmodule

