`timescale 1ns / 1ps
`include "DataPath.v"
`include "CU.v"
`include "DM.v"
`include "IM.v"
module MIPS(
    input wire clk,
    input wire rst,
    //pc
    output wire [31:0] pc,
    //ALU
    output wire zf,
    output wire [31:0] alu_out,
    //cu
    output wire RegDst,
    output wire Jump,
    output wire Branch,
    output wire MemRead,
    output wire MemtoReg,
    output wire [1:0] ALUOp,
    output wire MemWrite,
    output wire ALUSrc,
    output wire RegWrite,
    //IM
    output wire [31:0] inst,
    //RF
    output wire [31:0] W_data,
    //DM
    output wire [31:0] R_data
    );

    CU cu(
        .opcode(inst[31:26]),
        .func(inst[5:0]),
        .RegDst(RegDst),
        .Jump(Jump),
        .Branch(Branch),
        .MemRead(MemRead),
        .MemtoReg(MemtoReg),
        .ALUOp(ALUOp),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite)
    );
   
   DataPath data_path(
        .clk(clk),
        .rst(rst),
        .RegDst(RegDst),
        .Jump(Jump),
        .Branch(Branch),
        .MemtoReg(MemtoReg),
        .ALUOp(ALUOp),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .inst(inst),
        .R_data(R_data),
        .pc(pc),
        .alu_out(alu_out),
        .R_data2(W_data)
   );

   IM im(
    .addr(pc),
    .inst(inst)
   );

   DM dm(
    .clk(clk),
    .addr(alu_out),
    .W(MemWrite),
    .R(MemRead),
    .W_data(W_data),
    .R_data(R_data)
   );
endmodule
