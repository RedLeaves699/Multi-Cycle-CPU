`include "cpu_constant.v"
module PCReg (op, pc, imm, out);
    input [6 : 0] op;
    input [31 : 0] pc, imm;
    output [31 : 0] out;
    reg [31 : 0] out;
always @(*) begin
    if ((op == `auipcType) || (op == `luiType)) begin
        out = pc + (imm << 12);
    end
    else begin
        out = pc + 4;
    end
end
    
endmodule