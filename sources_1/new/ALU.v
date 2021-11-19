`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/03 21:37:24
// Design Name: 
// Module Name: ALU
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

module ALU(Ans, op, enable, a, b);
output [31 : 0] Ans;
reg [31 : 0] Ans;
input [31 : 0] a, b;
input [3 : 0] op;
input enable;
always @(*) begin
    if (enable) begin
        case (op)
            `ADD : Ans = a + b;
            `SUB : Ans = a - b;
            `XOR : Ans = a ^ b;
            `OR  : Ans = a | b;
            `AND : Ans = a & b;
            `SLL : Ans = a << b[4 : 0];
            `SRL : Ans = a >> b[4 : 0];
            `SRA : Ans = ($signed(a)) >>> {b[0], b[1], b[2], b[3], b[4]};
            `SLT : Ans = ($signed(a) < $signed(b)) ? 1 : 0;
            `SLTU : Ans = (a < b) ? 1 : 0;
            default : Ans = -1;
        endcase
    end
end
endmodule