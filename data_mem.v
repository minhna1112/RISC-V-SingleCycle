module DataMem(

	input	wire		clk,
	//input	wire		ce,		// Chip select signal, when it's high, enable data_mem.
    input   wire        rst,
	input	wire		we,		// When it's high, write data_mem. Otherwise read data_mem.
	input	wire[31:0]	addr,
	input	wire[31:0]	data_i,	// Data waiting for writing into data_mem
	output	reg [31:0]	data_o,	// Data reading from data_mem
	output 	wire[31:0]	verify	// test example.
	
);

	reg[7:0]  data[0:32'h400];
	initial $readmemh ( "SingleCycle/data_mem.txt", data );

	assign verify = {data[15], data[14], data[13], data[12]};

//Store data in Little Edians order.
always @ (posedge clk) begin
	if (!rst && we) begin
		data[addr]     <= data_i[7:0];
		data[addr + 1] <= data_i[15:8];
		data[addr + 2] <= data_i[23:16];
		data[addr + 3] <= data_i[31:24];
        
        $display("Word 0x%h = %d", address, {data[addr+3],data[addr+2],data[addr+1],data[addr]}); 
         // Display the change of a word.
	end
end

//Store data in Little Edians order.
always @ (*) begin
	if (rst)
		data_o <= 32'b0;
	else if(we == 1'b0) begin
		data_o <= {
					data[addr + 3],
					data[addr + 2],
					data[addr + 1],
					data[addr]   };
	end else
		data_o <= 32'b0;
end		

endmodule