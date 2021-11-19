`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2021 10:18:41 AM
// Design Name: 
// Module Name: cpu_test_tb
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
module cpu_test_tb;

reg clk_in, rst_in;
reg [31 : 0] init_pc;
wire [31 : 0] npc__pcif, pcif__npc, mux2_out, 
rf__alu, rf__mux0, imm_out, alu_ans_out, mux0__alu, mct__mux2, mux1__mct, pcreg__mux2;
wire [4 : 0] id__rf1, id__rf2, id__rf3;
wire [0 : 0] cu__pcif, cu__id, rf__cuZ, rf__cuN, rf__cuuN, 
cu__mux0, cu__ealu, cu__mux1, cu__mux3, cu__mux4, cu__npc;
wire [1 : 0] cu__rf;
wire [6 : 0] op_out, iout;
wire [19 : 0] id__ext;
wire [3 : 0] cu__aluop, cu__mct;
wire [1 : 0] cu__mux2;

always #10 begin
    clk_in = ~clk_in;
end
integer i;
always @(posedge clk_in) begin
    $display("curstate = %d, nxtstate = %d", cu.curstate, cu.nxtstate);
    $display("PC = %d", pcif__npc);
    /* if (cu.curstate == `DECODE) $display("rs1 = %d, rd = %d, rd.imm = %d", id.rs1, id.rd, id.Imm);*/
    if (cu.curstate == `FETCH) begin
        for (i = 0; i < 5; i = i + 1) begin
            $display("reg[%d] = %d", i, rf.x[i]);
        end
    end
    /* if (cu.curstate == `EXECUTE) begin
        $display("rf.a = %d rf.b = %d, op_alu = %d, mux0.ctl = %d,Ans = %d", rf.a, rf.b ,cu.op_Alu, mux0.ctl,mux2_out);
    end */
    /* if (cu.curstate == `WRITEB) begin
        $display("Zero = %d, neg = %d", cu.Zero, cu.Neg);
    end */
    
    //$display("M[15] = %d\n", MCT.M[15]);
    $display("M[26] = %d", mct.M[26]);
end

initial begin
    clk_in = 0;
    rst_in = 0;
    init_pc = 72;
    #15
    rst_in = 1;
end

PCIF pcif(.pc_out(pcif__npc), .enable(cu__pcif), .npc(npc__pcif), .init(init_pc), .rst(rst_in));
ID id(.Imm(id__ext), .rs2(id__rf3), .rs1(id__rf2), .rd(id__rf1), .iout(iout), 
    .ins(mux2_out), .enable(cu__id), .op(op_out));
RF rf(.rs1(id__rf2), .rs2(id__rf3), .zero(rf__cuZ), .a(rf__alu), .b(rf__mux0), .neg(rf__cuN), .uneg(rf__cuuN),
    .ctl(cu__rf), .rd(id__rf1), .Ans(mux2_out));
IMM_EXT immext(.Imm(imm_out), .option(op_out), .rImm(id__ext));
ALU alu(.Ans(alu_ans_out), .op(cu__aluop), .enable(cu__ealu), .a(rf__alu), .b(mux0__alu));
MCU mct(.out(mct__mux2), .address(mux1__mct), .num(rf__mux0), .ctl(cu__mct));
MUX mux0(.out(mux0__alu), .a(rf__mux0), .b(imm_out), .ctl(cu__mux0));
MUX mux1(.out(mux1__mct), .a(alu_ans_out), .b(pcif__npc), .ctl(cu__mux1));
MUX3 mux2(.out(mux2_out), .a(mct__mux2), .b(alu_ans_out), .c(pcreg__mux2), .ctl(cu__mux2));
CU cu(
    .ins(iout), .op(op_out), .rst(rst_in), .clk(clk_in), .Zero(rf__cuZ), .Neg(rf__cuN), .uNeg(rf__cuuN),
    .Pcif(cu__pcif), .Id(cu__id), .Rf(cu__rf), .C_mux0(cu__mux0), .C_mux1(cu__mux1), 
    .C_mux2(cu__mux2), .C_mux3(cu__mux3),
    .C_mux4(cu__mux4), .op_Alu(cu__aluop), .e_Alu(cu__ealu), .Mct(cu__mct), .Npc(cu__npc)
);
NPC npc(
    .npc(npc__pcif), .enable(cu__npc), 
    .pc(pcif__npc), .imm(imm_out), .c_mux3(cu__mux3), .c_mux4(cu__mux4), .ans(alu_ans_out)
);

PCReg pcReg(.op(op_out), .pc(pcif__npc), .imm(imm_out), .out(pcreg__mux2));

endmodule
