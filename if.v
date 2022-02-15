
module PC(

	input	wire 		clk,
	input	wire		rst,
	input 	wire		PCSel,  // if branch or not
	input 	wire[31:0] 	Addr,	 // target address
	output	reg [31:0] 	PC

);

/*
 * This always part controls the signal ce.
 */
// always @ (posedge clk) begin
// 	if (rst)
// 		ce <= 1'b0;
// 	else
// 		ce <= 1'b1;
// end

/*
 * This always part controls the signal PC.
 */
always @ (posedge clk) begin
	if (rst)
		PC <= 32'b0;
	else if (PCSel)
		PC <= Addr;
	else
		//PC <= PC + 4'h4;  // New PC equals ((old PC) + 4) per cycle.
	PC <= PC + 4;
end

endmodule