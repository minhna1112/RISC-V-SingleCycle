module WB (
    input rst,
    input   wire[1:0]       WBSel,
    input   wire[31:0] PC,
    input   wire[31:0] ALUOut,
    input   wire[31:0]  Data_from_mem,
    output  reg[31:0]  DataWriteToReg
);

always @ (*) begin
    if (rst)
        DataWriteToReg <= 32'b0;
    else if (WBSel == 2'b0)
        DataWriteToReg <= Data_from_mem;
    else if (WBSel == 2'b01)
        DataWriteToReg <= ALUOut;
    else if (WBSel == 2'b10)
        DataWriteToReg <= PC + 4;
end

endmodule