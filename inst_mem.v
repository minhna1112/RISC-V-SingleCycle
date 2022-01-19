module inst_mem(

	input	wire		rst,    // chip select signal
	input	wire[31:0]	addr,  // instruction address
	output 	reg [31:0]	inst   // instruction
	
);

	reg[31:0]  inst_memory[0:1000];

	//initial $readmemb ("./TestCode/test_copy.txt", inst_memory);	// read test assembly code file
	initial $readmemb ("machinecode.txt", inst_memory);	// read test assembly code file

always @ (*) begin
	if (!rst)
		inst <= 32'b0;
	else
		inst <= inst_memory[addr];
end

endmodule