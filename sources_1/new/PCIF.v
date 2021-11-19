`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/03 20:42:09
// Design Name: 
// Module Name: PC
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


module PCIF(pc_out, 
    enable, npc, init, rst
);
output [31 : 0] pc_out;
input [31 : 0] npc, init;
input enable, rst;
reg [31 : 0] pc_out;
always @(posedge rst) begin
    pc_out <= init;
end
always@(*) begin
    if (enable) begin
        pc_out = npc;
    end
end
endmodule
