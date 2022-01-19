module test_IM ();
// Clock and reset signals
reg clk;
reg reset;
// Design Inputs and outputs
reg[31:0] in_addr;
wire[31:0] out_inst;
// Dut instantiation
inst_mem dut (
  
    .rst (reset),
    .addr (in_addr),
    .inst (out_inst)
);
// Generate the clock
initial begin
    clk = 1'b0;
    forever #1 clk = ~clk;
end

// Generate the reset
initial begin
    reset = 1'b0;
    #10
    reset = 1'b1;
end

// Test stimulus
initial begin
    // Use the monitor task to display the FPGA IO
    $monitor( "time=%3d, in_add=%32b, inst=%32b\n", $time, in_addr, out_inst);
    // Generate each input with a 20 ns delay between them
    in_addr = 32'h00000000;
    #20
    in_addr = 32'h00000001;
    #20
    in_addr = 32'h00000002;
    #20
    in_addr = 32'h00000003;
end

endmodule


module test_PC ();
// Clock and reset signals
reg clk;
reg reset;
// Design Inputs and Outputs
reg in_PCSel;
reg[31:0] in_addr;
wire[31:0] out_PC;
// Dut instantiation
 PC dut (
     .clk (clk),
     .rst (reset),
     .Addr (in_addr),
     .PCSel (in_PCSel),
     .PC (out_PC)
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
    $monitor( "time=%3d, in_addr=%32b, in_PCSel=%1b, PC=%32b\n", $time, in_addr, in_PCSel, out_PC);
// Generate each input with a 20ns delay between them
    
    in_addr = 32'h00000000;
    in_PCSel = 1'b0;
    #30
    in_addr = 32'h00001000;
    #20
    in_addr = 32'h00001000;
    in_PCSel = 1'b0;
    #20
    in_addr = 32'h00001000;
    in_PCSel = 1'b1;
    #20
    in_addr = 32'h00001000;
    in_PCSel = 1'b0;
    
 end
endmodule



module test_IF ();
// Clock and reset signals
reg clk;
reg reset;
// Design Inputs and Outputs
reg in_PCSel;
reg[31:0] in_addr;
wire[31:0] out_PC;
wire[31:0] out_inst;
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
    in_PCSel = 1'b0;
    #110
    in_addr = 32'h00000000;
    in_PCSel = 1'b1;
    #20
    in_addr = 32'h00000000;
    in_PCSel = 1'b0;
 end
endmodule
