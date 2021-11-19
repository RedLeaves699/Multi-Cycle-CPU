`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/04 08:22:40
// Design Name: 
// Module Name: cpu_constant
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

`define EXECUTE 3'b010
`define DECODE 3'b001
`define WRITEBACK  3'b010


//Operator ALU
`define ADD  4'b0000
`define SUB  4'b0001
`define XOR  4'b1000
`define OR   4'b1100
`define AND  4'b1110
`define SLL  4'b0010
`define SRL  4'b1010
`define SRA  4'b1111
`define SLT  4'b0101
`define SLTU 4'b0111

//Imm_EXT option
`define R_ins   3'b000
`define I_ins   3'b001
`define S_ins   3'b010
`define B_ins   3'b011
`define U_ins   3'b100
`define J_ins   3'b101
//Control Sign

//REG
`define RRD 1'b0
`define RWT 1'b1

//MEM
`define LDB 3'b010
`define LDH 3'b001
`define LDW 3'b000
`define LDBU `LDB
`define LDHU `LDH
`define LDINS 3'b011

`define STB 3'b110
`define STH 3'b101
`define STW 3'b100

//states
`define FETCH 3'b000
`define DECODE 3'b001
`define EXECUTE 3'b010
`define WRITEB 3'b011
`define CURD 3'b100
`define STORE 3'b101
`define LOAD 3'b111

//instruction type

`define LType 7'b0000011
`define RType 7'b0110011
`define IType 7'b0010011
`define SType 7'b0100011
`define BType 7'b1100011
`define jalType 7'b1101111
`define jalrType 7'b1100111
`define luiType 7'b0110111
`define auipcType 7'b0010111
`define SYSType 7'b1110011

//opcode
`define _add_op 7'b0110011
`define _add3 3'b000
`define _sub3 3'b000
`define _xor3 3'b100
`define _or3 3'b110
`define _and3 3'b111
`define _sll3 3'b001
`define _srl3 3'b101
`define _sra3 3'b101
`define _slt3 3'b010
`define _sltu3 3'b011
`define _add7 7'b0000000
`define _sub7 7'b0100000
`define _xor7 7'b0000000
`define _or7 7'b0000000
`define _and7 7'b0000000
`define _sll7 7'b0000000
`define _srl7 7'b0000000
`define _sra7 7'b0100000
`define _slt7 7'b0000000
`define _sltu7 7'b0000000

`define _addi_op 7'b0010011
`define _addi3 3'b000
`define _xori3 3'b100
`define _ori3 3'b110
`define _andi3 3'b111
`define _slli3 3'b001
`define _srli3 3'b101
`define _srai3 3'b101
`define _slti3 3'b010
`define _sltui3 3'b011

`define _lw_op 7'b0000011
`define _lb3 3'b000
`define _lh3 3'b001
`define _lw3 3'b010
`define _lbu3 3'b100
`define _lhu3 3'b101

`define _sw_op 7'b0100011
`define _sb3 3'b000
`define _sh3 3'b001
`define _sw3 3'b010

`define _beq_op 7'b1100011
`define _beq3 17'b000
`define _bne3 17'b001
`define _blt3 17'b100
`define _bge3 17'b101
`define _bltu3 17'b110
`define _bgeu3 17'b111

`define _jal_op 7'b1101111
`define _jalr_op 7'b1100111
//`define _jal3 3'b111
`define _jalr3 3'b000



`define _lui_op 7'b0110111
`define _auipc_op 7'b0010111
`define _ecall 17'b00000000_0000_1110011
`define _ebreak 17'b00000000_0001_1110011

//iout
`define NULL_ -1
`define add_ 0
`define sub_ 1
`define xor_ 2
`define and_ 3
`define or_ 4
`define sll_ 5
`define srl_ 6
`define slt_ 7
`define sltu_ 8
`define sra_ 9
`define addi_ 10
`define xori_ 11
`define ori_ 12
`define andi_ 13
`define slli_ 14
`define srli_ 15
`define srai_ 16
`define slti_ 17
`define sltiu_ 18
`define lb_ 19
`define lh_ 20
`define lw_ 21
`define lbu_ 22
`define lhu_ 23
`define sb_ 24
`define sh_ 25
`define sw_ 26
`define beq_ 27
`define bne_ 28
`define blt_ 29
`define bge_ 30
`define bltu_ 31
`define bgeu_ 32
`define jal_ 33
`define jalr_ 34
`define lui_ 35
`define auipc_ 36
`define ecall_ 37
`define ebreak_ 38