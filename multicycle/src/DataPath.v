`timescale 1ns / 1ps
`include "PC.v"
`include "ALU.v"
`include "RF.v"
`include "SigExt16_32.v"
`include "ALUCU.v"
`include "MUX_2.v"
`include "SHL2.v"
`include "MUX_4.v"
`include "Reg32.v"
`include "IR.v"
module DataPath (   
    input wire clk,rst,
    //CU
    input wire lorD,IRWr,PCWr,PCWrcond,RegDst,RegWr,ALUSrcA,MemWr,MemRd,MemtoReg,
    input wire[1:0] ALUOp,PCsrc,ALUSrcB,
    //MEM
    input wire[31:0] inst,
    output wire[31:0] addr,W_data,
    output wire[5:0] opcode,
    output wire[31:0] alu_out
);
    wire[31:0] pc,next_pc,alu_res,R_data1,R_data2,mux_mdr,mdr,a,b,alu_a,alu_b,sigext,shl2_out;
    wire [27:0] pc_j;
    wire [4:0] rs,rt,W_Reg;
    wire[15:0] Imm;
    wire zf;
    wire[3:0] ALUCtrl;

    PC Pc(
        .clk     (clk),
        .rst     (rst),
        .PCWrite (PCWr|(PCWrcond&zf)),
        .next_pc (next_pc),
        .pc      (pc)
    );

    MUX_2#(32) Mux_pc(
        .d0     (pc),
        .d1     (alu_out),
        .signal (lorD),
        .out    (addr)
    );

    MUX_4#(32) Mux_npc(
        .d0     (alu_res),
        .d1     (alu_out),
        .d2     ({pc[31:28],pc_j}),
        .d3     (32'h0),
        .signal (PCsrc),
        .out    (next_pc)
    );
    
    MUX_2#(5) Mux_ir(
        .d0     (rt),
        .d1     (Imm[15:11]),
        .signal (RegDst),
        .out    (W_Reg)
    );

    MUX_2#(32) Mux_mdr(
        .d0     (alu_out),
        .d1     (mdr),
        .signal (MemtoReg),
        .out    (mux_mdr)
    );
    
    MUX_2#(32) Mux_a(
        .d0     (pc),
        .d1     (a),
        .signal (ALUSrcA),
        .out    (alu_a)
    );

    MUX_4#(32) Mux_b(
        .d0     (b),
        .d1     (32'd4),
        .d2     (sigext),
        .d3     (shl2_out),
        .signal (ALUSrcB),
        .out    (alu_b)
    );
    
    Reg32 Mdr(
        .clk (clk),
        .in  (inst),
        .out (mdr)
    );
    

    IR Ir(
        .clk  (clk),
        .IRWr (IRWr),
        .inst (inst),
        .rs   (rs),
        .rt   (rt),
        .Imm  (Imm),
        .opcode (opcode)
    );

    RF Rf(
        .clk     (clk),
        .w       (RegWr),
        .R_Reg1  (rs),
        .R_Reg2  (rt),
        .W_Reg   (W_Reg),
        .w_data  (mux_mdr),
        .R_data1 (R_data1),
        .R_data2 (R_data2)
    );

    Reg32 A(
        .clk (clk),
        .in  (R_data1),
        .out (a)
    );
    
    Reg32 B(
        .clk (clk),
        .in  (R_data2),
        .out (b)
    );
    SigExt16_32 Sigext16_32(
        .in  (Imm),
        .out (sigext)
    );

    SHL#(32,32) Shl_2(
        .data_in  (sigext),
        .data_out (shl2_out)
    );

    SHL Shl_pc(
        .data_in  ({rs,rt,Imm}),
        .data_out (pc_j)
    );
    
    ALU Alu(
        .ALUCtrl (ALUCtrl),
        .a       (alu_a),
        .b       (alu_b),
        .alu_out (alu_res),
        .zf      (zf)
    );
    
    ALUCU Alucu(
        .opcode  (opcode),
        .funct   (Imm[5:0]),
        .ALUOp   (ALUOp),
        .ALUCtrl (ALUCtrl)
    );

    Reg32 Aluout(
        .clk (clk),
        .in  (alu_res),
        .out (alu_out)
    );
endmodule


