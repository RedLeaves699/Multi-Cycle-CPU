`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/04 09:03:33
// Design Name: 
// Module Name: IMM_EXT
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "cpu_constant.v"

module IMM_EXT(Imm, option, rImm);
output [31 : 0] Imm;reg [31 : 0] Imm;
input [6 : 0] option;
input [19 : 0] rImm;
always @(*) begin
    case (option)
        `IType ,`SType, `LType : Imm = {{20{rImm[11 : 11]}}, rImm[11 : 0]};
        `BType : Imm = {{19{rImm[11 : 11]}}, rImm[11 : 0], 1'b0};
        `jalType, `jalrType : Imm = {{11{rImm[19 : 19]}}, rImm, 1'b0};
        `luiType, `auipcType : Imm = {{12{rImm[19 : 19]}}, rImm};
        default  : Imm = -1;
    endcase
end
endmodule
