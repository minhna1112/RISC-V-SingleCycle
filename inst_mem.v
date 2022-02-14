module inst_mem(

	input	wire		rst,    // chip select signal
	input	wire[31:0]	addr,  // instruction address
	output 	reg [31:0]	inst   // instruction
	
);

	reg[31:0]  inst_memory[0:100];

	initial $readmemb ("./RISC-V-SingleCycle/machinecode2.txt", inst_memory);	// read test assembly code file

always @ (*) begin
	if (!rst)
		inst <= 32'b0;
	else
		inst <= inst_memory[addr[31:2]];
end

endmodule