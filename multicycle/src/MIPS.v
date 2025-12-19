`timescale 1ns / 1ps
`include "DataPath.v"
`include "CU.v"
`include "MEM.v"
`include "SR.v"
module MIPS (
    input wire clk,rst,
    output wire[31:0] inst,addr,alu_out,
    output wire[3:0]NS,S
);
    wire lorD,IRWr,PCWr,PCWrcond,RegDst,RegWr,ALUSrcA,MemWr,MemRd,MemtoReg;
    wire[1:0] ALUOp,PCsrc,ALUSrcB;
    wire[31:0] W_data;
    wire[5:0] opcode;
    DataPath Datapath(
        .clk      (clk      ),
        .rst      (rst      ),
        .lorD     (lorD     ),
        .IRWr     (IRWr     ),
        .PCWr     (PCWr     ),
        .PCWrcond (PCWrcond ),
        .RegDst   (RegDst   ),
        .RegWr    (RegWr    ),
        .ALUSrcA  (ALUSrcA  ),
        .MemWr    (MemWr    ),
        .MemRd    (MemRd    ),
        .MemtoReg (MemtoReg ),
        .ALUOp    (ALUOp    ),
        .PCsrc    (PCsrc    ),
        .ALUSrcB  (ALUSrcB  ),
        .inst     (inst     ),
        .addr     (addr     ),
        .W_data   (W_data   ),
        .opcode   (opcode   ),
        .alu_out  (alu_out  )
    );

    MEM Mem(
        .clk    (clk    ),
        .addr   (addr   ),
        .W      (MemWr      ),
        .R      (MemRd      ),
        .W_data (W_data ),
        .R_data (inst)
    );
    
    CU Cu(
        .clk      (clk      ),
        .opcode   (opcode   ),
        .S        (S        ),
        .func     (inst[5:0]),
        .lorD     (lorD     ),
        .IRWr     (IRWr     ),
        .PCWr     (PCWr     ),
        .PCWrcond (PCWrcond ),
        .RegDst   (RegDst   ),
        .RegWr    (RegWr    ),
        .ALUSrcA  (ALUSrcA  ),
        .MemWr    (MemWr    ),
        .MemRd    (MemRd    ),
        .MemtoReg (MemtoReg ),
        .ALUOp    (ALUOp    ),
        .PCsrc    (PCsrc    ),
        .ALUSrcB  (ALUSrcB  ),
        .NS       (NS       )
    );
    SR Sr(
        .clk (clk ),
        .rst (rst ),
        .NS  (NS  ),
        .S   (S   )
    );
endmodule