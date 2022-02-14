
module EX(

	input	wire	    rst,
	input	wire[4:0]   ALUop_i,
    input   wire[31:0]  Oprend1,
    input   wire[31:0]  Oprend2,
    input   wire[4:0]   WriteDataNum_i,
	input 	wire		WriteReg_i,
	input	wire[31:0]  LinkAddr,
	input   wire[31:0]  inst_i,
	output	reg 		WriteReg_o,
	output	wire[4:0]	ALUop_o,
	output	reg [4:0]	WriteDataNum_o,
	output	reg [31:0]	WriteData_o,
    output  wire[31:0]  MemAddr_o,
    output  wire[31:0]  Result

);
    
  assign ALUop_o   = ALUop_i;
  
/*
 * This always part controls the WriteDatamNum_o.
 */    
always @ (*) begin
	if (rst)
		WriteDataNum_o <= 5'b0;
	else
    	WriteDataNum_o <= WriteDataNum_i;
end

/*
 * This always part controls the WriteReg_i.
 */    
always @ (*) begin
  if (rst)
    WriteReg_o <= 1'b0;
  else
    WriteReg_o <= WriteReg_i;
end

/*
 * This always part controls the WriteData_o.
 */    
always @ (*) begin
  if (rst)
    WriteData_o <= 32'b0;
  else begin
    case (ALUop_i)
      5'b10000: WriteData_o <= LinkAddr; 					      // jal
      5'b10001: WriteData_o <= LinkAddr; 				        // beq
      5'b10010: WriteData_o <= LinkAddr; 					      // blt
      5'b10100: WriteData_o <= 32'b0;                   // lw
      5'b10101: WriteData_o <= 32'b0;                   // sw
      5'b01100: WriteData_o <= Oprend1 +  Oprend2;  		// addi
      5'b01101: WriteData_o <= Oprend1 +  Oprend2;  		// add
      5'b01110: WriteData_o <= Oprend1 -  Oprend2;  		// sub
      5'b01000: WriteData_o <= Oprend1 << Oprend2[4:0];	// sll
      5'b00110: WriteData_o <= Oprend1 ^  Oprend2; 		  // xor
      5'b01001: WriteData_o <= Oprend1 >> Oprend2[4:0]; // srl
      5'b00101: WriteData_o <= Oprend1 |  Oprend2;  		// or
      5'b00100: WriteData_o <= Oprend1 &  Oprend2;  		// and
      default:  WriteData_o <= 32'b0;
    endcase
  end
end
 
endmodule
