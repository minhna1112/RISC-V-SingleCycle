
module EX(

	input	wire	    rst,
	input	wire[4:0]   ALUop_i,
    input   wire[31:0]  DataOutReg1,
    input   wire[31:0]  DataOutReg2,
    input   wire ALUSrc1,
    input   wire ALUSrc2,
    input wire[31:0] Imm,
	
	
	input   wire[31:0]  PC,
	output	wire[4:0]	ALUop_o,
	output  wire[31:0] ALUOut,

  
  

);
    
  assign ALUop_o   = ALUop_i;
  wire[31:0] Oprend1;
  wire[31:0] Oprend2;  

always @ (*) begin
    if (!rst)
        Oprend1 <= 32'b0;
    else if (ALUSrc1)
        Oprend1 <= PC;
    else
        Oprend1 <= DataOutReg1;
end

always @ (*) begin
    if (!rst)
        Oprend2 <= 32'b0;
    else if (ALUSrc1)
        Oprend2 <= Imm;
    else
        Oprend2 <= DataOutReg2;
end

always @ (*) begin
    if (!rst)
        Oprend1 <= 32'b0;
    else if (ALUSrc1)
        Oprend1 <= PC;
    else
        Oprend1 <= DataOutReg1;
end

/*
 * This always part controls the WriteData_o.
 */    
always @ (*) begin
  if (rst)
    WriteData_o <= 32'b0;
  else begin
    case (ALUop_i)
      
      5'b10001: ALUOut <= Oprend1 +  Oprend2; 				// beq
      
      5'b10100: ALUOut <= Oprend1 +  Oprend2;      // lw and jalr
      5'b10101: ALUOut <= Oprend1 +  Oprend2;      // sw
      5'b01100: ALUOut <= Oprend1 +  Oprend2;  		// addi
      5'b01101: ALUOut <= Oprend1 +  Oprend2;  		// add
      5'b01110: ALUOut <= Oprend1 -  Oprend2;  		// sub
      5'b01000: ALUOut <= Oprend1 << Oprend2[4:0];	// sll
      5'b00110: ALUOut <= Oprend1 ^  Oprend2; 		  // xor
      5'b01001: ALUOut <= Oprend1 >> Oprend2[4:0]; // srl
      5'b00101: ALUOut <= Oprend1 |  Oprend2;  		// or
      5'b00100: ALUOut <= Oprend1 &  Oprend2;  		// and
      
      default:  ALUOut <= 32'b0;
    endcase
  end
end
 
endmodule
