`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/04 09:55:48
// Design Name: 
// Module Name: MUX
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

module MUX3(out, a, b, c, ctl);
parameter NBitS = 32, CBit = 2;
output [NBitS - 1 : 0] out;reg [NBitS - 1 : 0] out;
input [NBitS - 1 : 0] a, b, c;
input [CBit - 1 : 0] ctl;
always @(*) begin
    case (ctl)
        1 : out = a;
        2 : out = c;
        default : out = b;
    endcase
end
endmodule
