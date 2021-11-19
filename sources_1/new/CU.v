`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2021/09/04 10:37:21
// Design Name:
// Module Name: CU
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

module CU(
    ins, rst, clk, Zero, Neg, uNeg, op,
    Pcif, Id, Rf, C_mux0, C_mux1, C_mux2, C_mux3, C_mux4, op_Alu, e_Alu, Mct, Npc
);

input [6 : 0] ins, op;
input rst, clk, Zero, Neg, uNeg;
output Pcif, Id, C_mux0, C_mux1, C_mux3, C_mux4, e_Alu, Npc;
reg Pcif, Id, C_mux0, C_mux1, C_mux3, C_mux4, e_Alu, Npc;
output [1 : 0] Rf, C_mux2;reg [1 : 0] Rf, C_mux2;
output [3 : 0] op_Alu, Mct;reg [3 : 0] op_Alu, Mct;

reg [2 : 0] curstate, nxtstate;

always @(posedge clk  or posedge rst) begin
    if (!rst) curstate <= `FETCH;
    else curstate <= nxtstate;
end

always @(*) begin
    case (curstate)
        `FETCH : nxtstate <= `DECODE;
        `DECODE : begin
            if ($signed(ins) != `NULL_)
                nxtstate <= `EXECUTE;
            else 
                nxtstate <= `FETCH;
        end
        `EXECUTE : begin
            case (op)
                `SType : nxtstate <= `STORE;
                `LType : nxtstate <= `LOAD;
                default : nxtstate <= `WRITEB;
            endcase
        end
        `STORE : nxtstate <= `FETCH;
        `LOAD : nxtstate <= `WRITEB;
        `WRITEB : begin
            case (op)
                `BType, `jalType, `jalrType : begin
                    nxtstate <= `CURD;
                end
                default : nxtstate <= `FETCH;
            endcase
        end
        default : nxtstate <= `FETCH;
    endcase
end

always @(*) begin
    case (curstate)
        `FETCH : begin
            {C_mux0, C_mux1, C_mux2, C_mux3, C_mux4} <= 6'b01_01_00;
            {Pcif, Id, e_Alu, Npc} <= 4'b1000;
            Rf <= 0; //[1 : 0]
            op_Alu <= 0; //output [3 : 0]
            Mct <= 4'b1111; //output [3 : 0]
        end
        `DECODE : begin
            {C_mux0, C_mux1, C_mux2, C_mux3, C_mux4} <= 6'b00_01_00;
            {Pcif, Id, e_Alu, Npc} <= 4'b0100;
            Rf <= {1'b1, `RRD}; //[1 : 0]
            op_Alu <= 0; //output [3 : 0]
            Mct <= 4'b0000; //output [3 : 0]
        end
        `EXECUTE : begin
            {C_mux0, C_mux1, C_mux2, C_mux3, C_mux4} <= 6'b00_00_00;
            //if (`add_ <= ins && ins <= `sra_) C_mux0 <= 0;
            //else C_mux0 <= 1;
            if (op == `RType || op == `BType) C_mux0 <= 0;
            else C_mux0 <= 1;
            {Pcif, Id, e_Alu, Npc} <= 4'b0010;
            Rf <= 0; //[1 : 0]
            case (ins)/* Not Finished */
                `add_, `addi_ : op_Alu = `ADD;
                `sub_, `beq_, `bne_, `blt_, `bge_, `bltu_, `bgeu_ : op_Alu = `SUB;
                `xor_, `xori_ : op_Alu = `XOR;
                `or_, `ori_ : op_Alu = `OR;
                `and_, `andi_ : op_Alu = `AND;
                `sll_, `slli_ : op_Alu = `SLL;
                `srl_, `srli_ : op_Alu = `SRL;
                `sra_, `srai_ : op_Alu = `SRA;
                `slt_, `slti_ : op_Alu = `SLT;
                `sltu_, `sltiu_ : op_Alu = `SLTU;
                default : op_Alu = `ADD;
            endcase
        end
        `LOAD : begin
            {C_mux0, C_mux1, C_mux2, C_mux3, C_mux4} <= 6'b10_01_00;
            {Pcif, Id, e_Alu, Npc} <= 4'b0000;
            Rf <= 0; //[1 : 0]
            op_Alu <= 0; //output [3 : 0]
            case (ins)
                `lw_ : Mct <= 4'b1000;
                `lb_ : Mct <= 4'b1010;
                `lh_ : Mct <= 4'b1001;
                default : Mct <= 4'b0000;
            endcase
        end
        `STORE : begin
            {C_mux0, C_mux1, C_mux2, C_mux3, C_mux4} <= 6'b10_00_00;
            {Pcif, Id, e_Alu, Npc} <= 4'b0001;
            Rf <= 0; //[1 : 0]
            op_Alu <= 0; //output [3 : 0]
            case (ins)
                `sw_ : Mct <= 4'b1100;
                `sh_ : Mct <= 4'b1101;
                `sb_ : Mct <= 4'b1110;
                default : Mct <= 4'b0000;
            endcase
        end
        `WRITEB : begin
            {C_mux0, C_mux1, C_mux3, C_mux4} <= 4'b00_00;
            {Pcif, Id, e_Alu, Npc} = 4'b0001;
            Rf = {1'b1, `RWT}; //[1 : 0]
            op_Alu = 0; //output [3 : 0]
            Mct = 4'b0000; //output [3 : 0]
        end
        `CURD : begin/* not finished */
            case (ins)
                `jal_ : begin
                    {C_mux0, C_mux1, C_mux2, C_mux3, C_mux4} = 6'b00_10_10;
                    {Pcif, Id, e_Alu, Npc} = 4'b0001;
                    Rf = {1'b1, `RWT}; //[1 : 0]
                    op_Alu = 0;
                    Mct = 0;
                end
                `jalr_ : begin
                    {C_mux0, C_mux1, C_mux2, C_mux3, C_mux4} = 6'b00_10_01;
                    {Pcif, Id, e_Alu, Npc} = 4'b0001;
                    Rf = {1'b1, `RWT}; //[1 : 0]
                    op_Alu = 0;
                    Mct = 0;
                end
                `beq_ : begin
                    if (Zero == 0) begin
                        {C_mux0, C_mux1, C_mux2, C_mux3, C_mux4} = 6'b00_00_10;
                        {Pcif, Id, e_Alu, Npc} = 4'b0001;
                        Rf = 0; //[1 : 0]
                        op_Alu = 0;
                        Mct = 0;
                    end
                    else begin
                        {C_mux0, C_mux1, C_mux2, C_mux3, C_mux4} = 6'b00_00_00;
                        {Pcif, Id, e_Alu, Npc} = 4'b0001;
                        Rf = 0; //[1 : 0]
                        op_Alu = 0;
                        Mct = 0;
                    end
                end
                `bne_ : begin
                    if (!Zero) begin
                        {C_mux0, C_mux1, C_mux2, C_mux3, C_mux4} = 6'b00_00_10;
                        {Pcif, Id, e_Alu, Npc} = 4'b0001;
                        Rf = 0; //[1 : 0]
                        op_Alu = 0;
                        Mct = 0;
                    end
                    else begin
                        {C_mux0, C_mux1, C_mux2, C_mux3, C_mux4} = 6'b00_00_00;
                        {Pcif, Id, e_Alu, Npc} = 4'b0001;
                        Rf = 0; //[1 : 0]
                        op_Alu = 0;
                        Mct = 0;
                    end
                end
                `blt_ : begin
                    if (!Zero && Neg) begin
                        {C_mux0, C_mux1, C_mux2, C_mux3, C_mux4} = 6'b00_00_10;
                        {Pcif, Id, e_Alu, Npc} = 4'b0001;
                        Rf = 0; //[1 : 0]
                        op_Alu = 0;
                        Mct = 0;
                    end
                    else begin
                        {C_mux0, C_mux1, C_mux2, C_mux3, C_mux4} = 6'b00_00_00;
                        {Pcif, Id, e_Alu, Npc} = 4'b0001;
                        Rf = 0; //[1 : 0]
                        op_Alu = 0;
                        Mct = 0;
                    end
                end
                `bge_ : begin
                    if (!Neg) begin
                        {C_mux0, C_mux1, C_mux2, C_mux3, C_mux4} = 6'b00_10_10;
                        {Pcif, Id, e_Alu, Npc} = 4'b0001;
                        Rf = 0; //[1 : 0]
                        op_Alu = 0;
                        Mct = 0;
                    end
                    else begin
                        {C_mux0, C_mux1, C_mux2, C_mux3, C_mux4} = 6'b00_00_00;
                        {Pcif, Id, e_Alu, Npc} = 4'b0001;
                        Rf = 0; //[1 : 0]
                        op_Alu = 0;
                        Mct = 0;
                    end
                end
                `bltu_ : begin
                    if (uNeg != Neg) begin
                        {C_mux0, C_mux1, C_mux2, C_mux3, C_mux4} = 6'b00_10_10;
                        {Pcif, Id, e_Alu, Npc} = 4'b0001;
                        Rf = 0; //[1 : 0]
                        op_Alu = 0;
                        Mct = 0;
                    end
                    else begin
                        {C_mux0, C_mux1, C_mux2, C_mux3, C_mux4} = 6'b00_00_00;
                        {Pcif, Id, e_Alu, Npc} = 4'b0001;
                        Rf = 0; //[1 : 0]
                        op_Alu = 0;
                        Mct = 0;
                    end
                end
                `bgeu_ : begin
                    if (uNeg == Neg) begin
                        {C_mux0, C_mux1, C_mux2, C_mux3, C_mux4} = 6'b00_10_10;
                        {Pcif, Id, e_Alu, Npc} = 4'b0001;
                        Rf = 0; //[1 : 0]
                        op_Alu = 0;
                        Mct = 0;
                    end
                    else begin
                        {C_mux0, C_mux1, C_mux2, C_mux3, C_mux4} = 6'b00_00_00;
                        {Pcif, Id, e_Alu, Npc} = 4'b0001;
                        Rf = 0; //[1 : 0]
                        op_Alu = 0;
                        Mct = 0;
                    end
                end
                default : begin
                    {C_mux0, C_mux1, C_mux2, C_mux3, C_mux4} = 6'b00_00_00;
                    {Pcif, Id, e_Alu, Npc} = 4'b0001;
                    Rf = 0; //[1 : 0]
                    op_Alu = 0;
                    Mct = 0;
                end
            endcase
        end
    endcase
end
endmodule