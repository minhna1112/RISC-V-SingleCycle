module riscv_soc_tb();
// Clock and reset signals
reg clk;
reg reset;
// Design Inputs and Outputs

wire[31:0] out_inst;
wire[31:0] MemDataOut;


wire[31:0] MemAddr;
wire[31:0] out_PC;
wire[31:0] MemDataIn;

wire PCSel, MemWE;

riscv rv32(
    .clk(clk),
    .reset(reset),
    .Inst(out_inst),
    .data_in_from_mem(MemDataOut),
    .PC(out_PC),
    .mem_addr(MemAddr),
    .data_out_to_mem(MemDataIn),
    .PCSel(PCSel),
    .MemWE(MemWE)
);

inst_mem im ( 
    .rst (reset),
    .addr (out_PC),
    .inst (out_inst)
);

DataMem mem(
    .clk(clk),
    .rst(reset),
    .we(MemWE),
    .addr(MemAddr),
    .data_i(MemDataIn),
    .data_o(MemDataOut)
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
    $monitor( "***time=%3d, pc_out=%d, PCSel = %b,  MemWE=%b\n", $time, out_PC, PCSel, MemWE);    

 end
endmodule
