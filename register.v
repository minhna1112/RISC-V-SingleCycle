
 module Registers(

    input   wire        clk,
    input   wire        rst,
    input   wire        we,
    input   wire[4:0]   WriteAddr,
    input   wire[31:0]  WriteData,
    input   wire[4:0]   ReadAddr1,
    input   wire[4:0]   ReadAddr2,
    output  reg [31:0]  ReadData1,
    output  reg [31:0]  ReadData2

    );

    integer i;
    reg [31:0] regFile [0:32];

/*
 * This always part controls the regFile, it's a 32*32 reg.
 */    
always @ (posedge clk) begin
    regFile[5'h0] <= 32'b0;  // Register x0 always equals 0. 
    if (!rst)
        regFile[5'b00001] <= 32'b0;
        regFile[5'b00010] <= 32'b0;
        regFile[5'b00011] <= 32'b0;
        regFile[5'b00100] <= 32'b0;
        regFile[5'b00101] <= 32'b0;
        regFile[5'b00110] <= 32'b0;
        regFile[5'b00111] <= 32'b0;
        regFile[5'b01000] <= 32'b0;
        regFile[5'b01001] <= 32'b0;
        regFile[5'b01010] <= 32'b0;
        regFile[5'b01011] <= 32'b0;
        regFile[5'b01100] <= 32'b0;
        regFile[5'b01101] <= 32'b0;
        regFile[5'b01110] <= 32'b0;
        regFile[5'b01111] <= 32'b0;
        regFile[5'b10000] <= 32'b0;
        regFile[5'b10001] <= 32'b0;
        regFile[5'b10010] <= 32'b0;
        regFile[5'b10011] <= 32'b0;
        regFile[5'b10100] <= 32'b0;
        regFile[5'b10101] <= 32'b0;
        regFile[5'b10110] <= 32'b0;
        regFile[5'b10111] <= 32'b0;
        regFile[5'b11000] <= 32'b0;
        regFile[5'b11001] <= 32'b0;
        regFile[5'b11010] <= 32'b0;
        regFile[5'b11011] <= 32'b0;
        regFile[5'b11100] <= 32'b0;
        regFile[5'b11101] <= 32'b0;
        regFile[5'b11110] <= 32'b0;
        regFile[5'b11111] <= 32'b0;
        
    if (rst && we && WriteAddr != 5'h0) begin
        regFile[WriteAddr] <= WriteData;  // Write data to register.
        $display("x%d = %d", WriteAddr, WriteData);  // Display the change of register.
    end
end

/*
 * This always part controls the signal ReadData1 as rs1. 
 */ 
always @ (*) begin
    if (!rst || ReadAddr1 == 5'h0)
        ReadData1 <= 32'b0;
    else 
        ReadData1 <= regFile[ReadAddr1];

end

/*
 * This always part controls the signal ReadData2 as rs2.
 */ 
always @ (*) begin
    if (!rst || ReadAddr2 == 5'h0)
        ReadData2 <= 32'b0;
    else 
        ReadData2 <= regFile[ReadAddr2];
end
    
endmodule