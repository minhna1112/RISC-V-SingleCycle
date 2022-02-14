module BranchComp(
    input	wire	    rst,
    input   wire[31:0]  DataOutReg1,
    input   wire[31:0]  DataOutReg2,

    output reg BrEq
);

always @(*) begin
    if (!rst) 
        BrEq <= 1'b0;
    else if (DataOutReg1 == DataOutReg2)
        BrEq <= 1'b1;
    else 
        BrEq <= 1'b0; 
end

endmodule

