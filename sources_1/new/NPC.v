`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/05 15:44:47
// Design Name: 
// Module Name: NPC
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


module NPC(
    npc, enable, 
    pc, imm, c_mux3, c_mux4, ans
);
output [31 : 0] npc; reg [31 : 0] npc;
input [31 : 0] pc, imm, ans;

input c_mux3, c_mux4, enable;
always @(*) begin
    if (enable) begin
        if (c_mux3 == 0) begin
            npc = pc + 4;
            if (c_mux4 == 0) begin
                npc = npc;
            end
            else begin
                npc = ans;
            end
        end
        else begin
            npc = pc + imm; //imm & 3 = 0
            if (c_mux4 == 0) begin
                npc = npc;
            end
            else begin
                npc = ans;
            end
        end
    end
    
end
endmodule
