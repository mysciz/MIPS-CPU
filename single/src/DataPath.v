`timescale 1ns / 1ps
`include "PC.v"
`include "ALU.v"
`include "RF.v"
`include "SigExt16_32.v"
`include "ALUCU.v"
`include "ADD.v"
`include "MUX.v"
`include "SHL2.v"

module DataPath(
    input wire clk,rst,
    // CU
    input wire RegDst, Jump, Branch, MemtoReg,
    input wire[1:0] ALUOp,
    input wire ALUSrc, RegWrite,
	// IM
	input wire[31:0] inst,
	// DM
    input wire[31:0] R_data,
    output wire[31:0] pc,
    output wire[31:0] alu_out,
    output wire[31:0] R_data2// DM W_data
    );
    wire[4:0] W_Reg;
    wire[31:0] mux_pc,mux_add,add1,add2,add2_B;
    wire [27:0] pc_j;
    wire zf;
    wire[3:0] ALUCtrl;
    wire[31:0] sigext;
    wire[31:0] R_data1,mux_rf,mux_alu;

    PC Pc(
        .clk(clk),
        .rst(rst),
        .next_pc(mux_pc),
        .pc(pc)
    );

    MUX#(32) Mux_pc(
        .d0(mux_add),
        .d1({mux_add[31:28],pc_j}),
        .signal(Jump),
        .out(mux_pc)
    );

    MUX#(32) Mux_add(
        .d0(add1),
        .d1(add2),
        .signal(Branch&zf),
        .out(mux_add)
    );

    MUX#(32) Mux_rf(
        .d0(R_data2),
        .d1(sigext),
        .signal(ALUSrc),
        .out(mux_rf)
    );

    MUX#(5) Mux_w(
        .d0(inst[20:16]),
        .d1(inst[15:11]),
        .signal(RegDst),
        .out(W_Reg)
    );
    MUX#(32) Mux_alu(
        .d0(alu_out),
        .d1(R_data),
        .signal(MemtoReg),
        .out(mux_alu)
    );
    ADD Add1(
        .a(4),
        .b(pc),
        .result(add1)
    );
  
    ADD Add2(
        .a(add1),
        .b(add2_B),
        .result(add2)
    );

    SigExt16_32 Sigext16_32(
        .in(inst[15:0]),
        .out(sigext)
    );

    SHL2#(26,28) Shl_pc(
        .data_in(inst[25:0]),
        .data_out(pc_j)
    );

    SHL2#(32,32) Shl_add1(
        .data_in(sigext),
        .data_out(add2_B)
    );

    ALUCU Alucu(
        .opcode(inst[31:26]),
        .funct(inst[5:0]),
        .ALUOp(ALUOp),
        .ALUCtrl(ALUCtrl)
    );

    ALU Alu(
        .ALUCtrl(ALUCtrl),
        .a(R_data1),
        .b(mux_rf),
        .alu_out(alu_out),
        .zf(zf)
    );
    RF Rf(
        .clk(clk),
        .w(RegWrite),
        .R_Reg1(inst[25:21]),
        .R_Reg2(inst[20:16]),
        .W_Reg(W_Reg),
        .w_data(mux_alu),
        .R_data1(R_data1),
        .R_data2(R_data2)
    );
endmodule