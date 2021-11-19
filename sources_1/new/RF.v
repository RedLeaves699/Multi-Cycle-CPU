`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/03 21:41:44
// Design Name: 
// Module Name: RF
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

module RF(rs1, rs2, zero, a, b, neg, uneg,
    ctl, rd, Ans
);
output [31 : 0] a, b;reg [31 : 0] a, b;
output zero, neg, uneg;
input [4 : 0] rd, rs1, rs2;
input [31 : 0] Ans;
input [1 : 0] ctl;
//32 regs
reg [31 : 0] x[0 : 31];

assign zero = ((Ans == 0) ? 1'b1 : 1'b0);
assign neg = Ans[31 : 31];
assign uneg = a[31 : 31];
/* The initial code is only for test */
initial begin
    x[0] = 0;
    x[1] = 0;
    x[2] = 0;
    x[3] = 0;
end
/* Code end*/

always @(*) begin
    if (ctl[1 : 1]) begin
        case(ctl[0 : 0])
            `RRD : begin
                a = x[rs1];
                b = x[rs2];
            end
            `RWT : begin
                x[rd] = Ans;
            end
        endcase
    end
end
endmodule
