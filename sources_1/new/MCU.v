`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/04 10:06:10
// Design Name: 
// Module Name: MCT
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

module MCU(out, address, num, ctl);
    output [31 : 0] out;reg [31 : 0] out;
    input [31 : 0] address, num;
    input [3 : 0] ctl;
    reg [31 : 0] M[0 : 8'hff];

    /* The initial code is only for testbranch, */ 
    /* as if the assemble code and data are loaded from the disks */
    initial begin
        /* Segment 01 : Test add and addi options */
        M[0] = 32'b0000000_00001_00000_000_00010_0110011;
        M[1] = 32'b111111111101_00000_000_00011_0010011;
        M[2] = 0;
        /* Segment 01 end */

        /* Segment 02 : Test Load and store options */
        /* Fetch the numbers in *(M+60 / 4), *(M+68 / 4), then add both of them */
        M[15] = 32'b00000000_00000000_00000000_00001011; /* 11 , address : 60 */
        M[17] = 32'b11111111_11111111_11111111_11111001; /* -7 , address : 68 */
        /* assemble code : from M[3] to M[8] */
        M[3] = 32'b0000000_00001_00001_100_00001_0110011; /* set rs1 0 */
        M[4] = 32'b000000111100_00001_010_00010_0000011; /* load data(words) at *(M+60 / 4) to rs2 */
        M[5] = 32'b000001000100_00001_010_00011_0000011; /* load data(words) at *(M+68 / 4) to rs3 */
        M[6] = 32'b0000000_00010_00011_000_00100_0110011; /* add rs4 <= rs2 + rs3 */
        M[7] = 32'b0000001_00100_00001_010_11100_0100011; /* store the value of rs4 to *(M+60 / 4) */
        M[8] = 0; /* end */
        /* assemble code end; */


        /* Segment 03 : Test "jump" and and "Load Imm" options */
        /* This test is a tiny program that calculate from 1 to 100, rs0 is 
         * the base address register, and rs1 is the counter, rs3 save the 
         * sum, rs2 save the number of 100, which is the limit of the loop.
         */
        M[25] = 32'b00000000_00000000_00000000_01100101; /* 101 , address : 100(/4) */
        /* assemble code : from M[9] to M[17] */
        M[9] = 32'b0000000_00011_00011_100_00011_0110011; /* set rs3 0 */
        M[10] = 32'b0000000_00000_00000_100_00000_0110011; /* set rs0 0 */
        M[11] = 32'b0000000_00001_00001_100_00001_0110011; /* set rs1 0 */
        M[12] = 32'b000001100100_00000_010_00010_0000011; /* load data(words) from address 100 to rs2*/
        M[13] = 32'b0000000_00011_00001_000_00011_0110011; /* add rs3, rs3, rs1 */
        M[14] = 32'b000000000001_00001_000_00001_0010011; /* add rs1, rs1, $1 */
        M[15] = 32'b1111111_00010_00001_100_11001_1100011; /* blt rs1, rs2, PC+= (-10)<<1 */
        M[16] = 32'b0000011_00011_00000_010_01000_0100011; /* sw rs3, *(M + 104) */
        M[17] = 0;
        /* assemble code end; */

        /* Segment 04: Test "jal, jalr" and "lui, auipc" */
        M[18] = 32'b0_0000011000_0_0_00000000_00001_1101111; /* jal rs1, (12 << 1) */
        M[19] = 32'b00001111_000000000000_00010_0010111; /* auipc rs2, rs2, $15 */
        M[20] = 0;
        M[24] = 32'b000000011000_00010_000_00010_0010011; /* addi rs2, rs2, $24 */
        M[25] = 32'b000000000000_00001_000_00011_1100111; /* jalr rs1, rs3, $0 */
        M[26] = 0;
        /* assemble code end; */

    end
    /* Initial code end; */

    always@(*) begin
        if (ctl[3 : 3]) begin
            case (ctl[2 : 0])
                `LDW : begin
                    out = {
                        M[(address + 3) / 4][(address + 3) % 4 * 8 + 7 -: 8],
                        M[(address + 2) / 4][(address + 2) % 4 * 8 + 7 -: 8],
                        M[(address + 1) / 4][(address + 1) % 4 * 8 + 7 -: 8],
                        M[address / 4][address % 4 * 8 + 7 -: 8]
                    };
                end
                `LDH : begin
                    out = {16'h0000, M[(address + 1) / 4][(address + 1) % 4 * 8 + 7 -: 8],
                        M[address / 4][address % 4 * 8 + 7 -: 8]};
                end
                `LDB : out = {24'h000000, M[address / 4][address % 4 * 8 + 7 -: 8]};
                `STB : M[address / 4][address % 4 * 8 + 7 -: 8] = num[7 : 0];
                `STH : begin
                    M[(address + 1) / 4][(address + 1) % 4 * 8 + 7 -: 8] = num[15 : 8];
                    M[address / 4][address % 4 * 8 + 7 -: 8] = num[7 : 0];
                end
                `STW :begin
                    M[(address + 3) / 4][(address + 3) % 4 * 8 + 7 -: 8] = num[31 : 24];
                    M[(address + 2) / 4][(address + 2) % 4 * 8 + 7 -: 8] = num[23 : 16];
                    M[(address + 1) / 4][(address + 1) % 4 * 8 + 7 -: 8] = num[15 : 8];
                    M[address / 4][address % 4 * 8 + 7 -: 8] = num[7 : 0];
                end 
                default : out = {
                    M[(address + 3) / 4][(address + 3) % 4 * 8 + 7 -: 8],
                    M[(address + 2) / 4][(address + 2) % 4 * 8 + 7 -: 8],
                    M[(address + 1) / 4][(address + 1) % 4 * 8 + 7 -: 8],
                    M[address / 4][address % 4 * 8 + 7 -: 8]
                };
            endcase
        end
    end
endmodule
