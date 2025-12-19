`timescale 1ns / 1ps
`include "ADD.v"
`include "IM.v"
`include "PC.v"
`include "MUX_2.v"
`include "IF_ID.v"
module MIPS (
    input wire clk,rst
);
    wire[31:0] pc,next_pc,inst,mux_4,add1,inst_id,inst_ex,add1_out,pc4_id,EX_Rs,EX_Rt,ID_Rs,ID_Rt,RF_W_dat,ID_Imm32,EX_Imm32,ID_npc,EX_npc;
    wire PCSrc,PCWrite,FI_ID_RegWr,RF_RegWr;
    wire[4:0] RF_W_Reg;
    wire[9:0] cu_out,mux_cu;
    wire[2:0] EX_WB;
    wire[3:0] EX_MA,EX_EX;
    PC Pc(
        .clk     (clk     ),
        .rst     (rst     ),
        .next_pc (next_pc ),
        .PCWrite (PCWrite ),
        .pc      (pc      )
    );
    IM Im(
        .addr (pc ),
        .inst (inst )
    );
    
    ADD Add(
        .a      (32'd4),
        .b      (pc),
        .result (add1)
    );
    MUX_2#(32) Mux_pc(
        .d0     (add1),
        .d1     (mux_4),
        .signal (PCSrc),
        .out    (next_pc )
    );
    Hazard_Detection Hazard_Unit(
        .EX_MA_Flag_ZF     (EX_MA_Flag_ZF     ),
        .EX_MA_Flag_Branch (EX_MA_Flag_Branch ),
        .EX_Jump           (EX_MA[0]          ),
        .EX_MemRD          (EX_MA[3]         ),
        .ID_Rs             (inst_id[25:21]    ),
        .ID_Rt             (inst_id[20:16]    ),
        .EX_Rt             (EX_Rt             ),
        .clear1            (clear1            ),
        .clear0            (clear0            ),
        .FI_ID_RegWr       (FI_ID_RegWr       ),
        .PCWr              (PCWr              )
    );
    
    IF_ID If_id(
        .clk         (clk         ),
        .rst         (rst         ),
        .FI_ID_RegWr (FI_ID_RegWr ),
        .inst_in     (inst     ),
        .pc4_in      (add1      ),
        .inst_out    (inst_id    ),
        .pc4_out     (ID_npc     )
    );
    
    RF Rf(
        .clk     (clk     ),
        .w       (RF_RegWr),
        .R_Reg1  (inst_id[25:21]),
        .R_Reg2  (inst_id[20:16]),
        .W_Reg   (RF_W_Reg),
        .w_data  (RF_W_data),
        .R_data1 (ID_Rs),
        .R_data2 (ID_Rt)
    );
    SigExt16_32 Sigext16_32(
        .in  (inst_id[15:0]),
        .out (ID_IMmm32)
    );
    CU Cu(
        .opcode (inst_id[31:26] ),
        .cu_out (cu_out )
    );
    
    MUX_2#(10) Mux_cu(
        .d0     (cu_out     ),
        .d1     (10'd0     ),
        .signal (clear0 ),
        .out    (mux_cu    )
    );
    ID_EX ID_ex(
        .clk      (clk      ),
        .rst      (rst      ),
        .ID_Rs    (ID_Rs    ),
        .ID_Rt    (ID_Rt    ),
        .ID_Imm32 (ID_Imm32 ),
        .inst_id  (inst_id  ),
        .ID_npc   (ID_npc),
        .ID_WB    (mux_cu[9:7]    ),
        .ID_MA    (mux_cu[6:3]    ),
        .ID_EX    (mux_cu[2:0]    ),
        .EX_Rs    (EX_Rs    ),
        .EX_Rt    (EX_Rt    ),
        .EX_Imm32 (EX_Imm32 ),
        .inst_ex  (inst_ex  ),
        .EX_npc   (EX_npc),
        .EX_WB    (EX_WB    ),
        .EX_MA    (EX_MA    ),
        .EX_EX    (EX_EX    )
    );

    ALUCU Alucu(
        .funct   (funct   ),
        .ALUOp   (   ),
        .ALUCtrl (ALUCtrl )
    );
    
    ALU Alu(
        .ALUCtrl (ALUCtrl ),
        .a       (a       ),
        .b       (b       ),
        .alu_out (alu_out ),
        .zf      (zf      )
    );
    
    
endmodule