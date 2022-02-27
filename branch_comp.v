module BranchComp(
    input	wire	    rst,
    input   wire[31:0]  DataOutReg1,
    input   wire[31:0]  DataOutReg2,

    output reg BrEq, BrLt
);

always @(*) begin
    
    if (rst) begin
        BrLt = 1'b0;
        BrEq = 1'b0;
    end


    else  begin
        if (DataOutReg1 == DataOutReg2) begin
            BrEq = 1'b1;
            BrLt = 1'b0;
        end
        else if  (DataOutReg1 < DataOutReg2) begin
            BrEq = 1'b0;
            BrLt = 1'b1;
        end
        else begin
            BrEq = 1'b0;
            BrLt = 1'b0;
        end
    end

end
endmodule

