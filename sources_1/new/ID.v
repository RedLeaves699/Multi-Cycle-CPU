`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2021/09/03 21:27:00
// Design Name:
// Module Name: ID
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

module ID(Imm, rs2, rs1, rd, iout, op,
    ins, enable
);
    output [6 : 0] iout;reg [6 : 0] iout;
    output [4 : 0] rd, rs1, rs2;reg [4 : 0] rd, rs1, rs2;
    output [19 : 0] Imm;reg [19 : 0] Imm;
    output [6 : 0] op; reg [6 : 0] op;
    input [31 : 0] ins;
    input enable;
    always@(*) begin
        if (enable) begin
            op = ins[6 : 0];
            case (ins[6 : 0])
                `RType : begin
                    rd = ins[11 : 7];
                    rs1 = ins[19 : 15];
                    rs2 = ins[24 : 20];
                    case ({ins[14 : 12], ins[31 : 25]})
                        {3'b000, 7'b0000000} : iout = `add_;
                        {3'b000, 7'b0100000} : iout = `sub_;
                        {3'b100, 7'b0000000} : iout = `xor_;
                        {3'b110, 7'b0000000} : iout = `or_;
                        {3'b111, 7'b0000000} : iout = `and_;
                        {3'b001, 7'b0000000} : iout = `sll_;
                        {3'b101, 7'b0000000} : iout = `srl_; /*逻辑右移*/
                        {3'b101, 7'b0100000} : iout = `sra_; /*算数右移*/
                        {3'b010, 7'b0000000} : iout = `slt_;
                        {3'b011, 7'b0000000} : iout = `sltu_;
                        default : iout = `NULL_;
                    endcase
                end
                `IType : begin
                    rd = ins[11 : 7];
                    rs1 = ins[19 : 15];
                    rs2 = 0;
                    Imm = {8'h00, ins[31 : 20]};
                    case (ins[14 : 12])
                        4'h0 : iout = `addi_;
                        4'h4 : iout = `xori_;
                        4'h6 : iout = `ori_;
                        4'h7 : iout = `andi_;
                        4'h1 : begin
                            iout = `slli_;
                            Imm = {15'h0, ins[24 : 20]};
                        end
                        4'h5 : begin
                            iout = `srli_; /*逻辑右移*/
                            Imm = {15'h0, ins[24 : 20]};
                        end
                        4'h2 : begin
                            iout = `slti_;
                        end
                        4'h3 : begin
                            iout = `sltiu_;
                        end
                        default : iout = `NULL_;
                    endcase
                end
                `LType : begin
                    rd = ins[11 : 7];
                    rs1 = ins[19 : 15];
                    rs2 = 0;
                    Imm = {8'h00, ins[31 : 20]};
                    case (ins[14 : 12])
                        4'h0 : iout = `lb_;
                        4'h1 : iout = `lh_;
                        4'h2 : iout = `lw_;
                        4'h4 : iout = `lbu_;
                        4'h5 : iout = `lhu_;
                        default: iout = `NULL_;
                    endcase
                end
                `SType : begin
                    rd = ins[11 : 7];
                    rs1 = ins[19 : 15];
                    rs2 = ins[24 : 20];
                    Imm = {8'h00, ins[31 : 25], ins[11 : 7]};
                    case (ins[14 : 12])
                        4'h0 : iout = `sb_;
                        4'h1 : iout = `sh_;
                        4'h2 : iout = `sw_;
                        default: iout = `NULL_;
                    endcase
                end
                `BType : begin
                    rd = ins[11 : 7];
                    rs1 = ins[19 : 15];
                    rs2 = ins[24 : 20];
                    Imm = {8'h00, ins[31 : 31], ins[7 : 7], ins[30 : 25], ins[11 : 8]};
                    case (ins[14 : 12])
                        4'h0 : iout = `beq_;
                        4'h1 : iout = `bne_;
                        4'h4 : iout = `blt_;
                        4'h5 : iout = `bge_;
                        4'h6 : iout = `bltu_;
                        4'h7 : iout = `bgeu_;
                        default: iout = `NULL_;
                    endcase
                end
                `jalType : begin
                    iout = `jal_;
                    rd = ins[11 : 7];
                    Imm = {ins[31 : 31], ins[21 : 12], ins[22 : 22], ins[30 : 23]};
                end
                `jalrType : begin
                    iout = `jalr_;
                    rd = ins[11 : 7];
                    rs1 = ins[19 : 15];
                    Imm = {{8{ins[31 : 31]}}, ins[31 : 20]};
                end
                `luiType : begin
                    iout = `lui_;
                    rd = ins[11 : 7];
                    Imm = ins[31 : 24];
                end
                `auipcType: begin
                    iout = `auipc_;
                    rd = ins[11 : 7];
                    Imm = ins[31 : 24];
                end
                `ecall_ : ;
                `ebreak_ : ;
                default : iout = -1;
            endcase
        end
    end
endmodule
