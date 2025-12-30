`timescale 1ns / 1ps
`include "ADD.v"
`include "IM.v"
`include "PC.v"
`include "MUX_2.v"
`include "IF_ID.v"
`include "RF.v"
`include "ID_EX.v"
`include "SigExt16_32.v"
`include "SHL2.v"
`include "MUX_4.v"
`include "ALU.v"
`include "EX_MA.v"
`include "DM.v"
`include "MA_WB.v"
`include "CU.v"
`include "Forward_Unit.V"
`include "Hazard_Unit.v"
module MIPS (
    input wire clk,rst,
    output wire[31:0] pcf,inst_f,inst_d,inst_e,inst_m,inst_w,RsE,RtE,ALUOutE,A,B,Imm32E,RtM,ALUOutM,ALUOutW,MEMOutW,MEMOutM,
    output PCWr,IF_ID_RegWr,MemSrc,
    output [1:0] ALUSrcA,ALUSrcB,
    output [2:0] WB_E,WB_M,WB_W,
    output [3:0] MA_E,MA_M,
    output [3:0] EX_E,
    output [4:0] W_Regw,
    output Clear0,Clear1,
    output wire[31:0] pcplus4f,pcplus4d,pcplus4e,mux_ma
    );
    wire[31:0] next_pc,W_dataw,Imm32D,RsD,RtD,shl_i,pc_i,pc_jM,pc_iM,DM_W_data;
    wire PCSrc,zE,zfM,Jump,flush;
    //wire[1:0] ALUSrcA,ALUSrcB;M
    wire[3:0] ALUCtrl;
    //wire[4:0] W_Regw;
    wire[27:0] shl_j;
    //wire[2:0] WB_D;
    //wire[3:0] MA_D;
    //wire[3:0] EX_D;
    //wire[2:0] WB_E;
    //wire[3:0] MA_E;
    //wire[2:0] WB_M;
    //wire[3:0] MA_M;
    //wire[2:0] WB_W;
    //wire[3:0] EX_E;
    wire[10:0] cu_out,cu_d;
    wire[6:0] cu_e;
    PC Pc(
        .clk     (clk     ),
        .rst     (rst     ),
        .PCWrite (PCWr ),
        .next_pc (next_pc ),
        .pc      (pcf      )
    );
    ADD Add_f(
        .a      (pcf      ),
        .b      (32'd4    ),
        .result (pcplus4f  )
    );

    MUX_2#(32) Mux_pc(
        .d0     (pcplus4f),
        .d1     (mux_ma ),
        .signal ((zfM&MA_M[1])| MA_M[0]  ),
        .out    (next_pc)
    );
    
    IM Im(
        .addr (pcf ),
        .inst (inst_f )
    );
    
    IF_ID If_id(
        .clk         (clk         ),
        .rst         (rst         ),
        .FI_ID_RegWr (IF_ID_RegWr ),
        .inst_f      (inst_f      ),
        .pcplus4f    (pcplus4f    ),
        .flush       (flush       ),
        .inst_d      (inst_d      ),
        .pcplus4d    (pcplus4d    )
    );
    
    RF Rf(
        .clk     (clk     ),
        .w       (WB_W[1]      ),
        .R_Reg1  (inst_d[25:21]  ),
        .R_Reg2  (inst_d[20:16]  ),
        .W_Reg   (W_Regw   ),
        .w_data  (W_dataw  ),
        .R_data1 (RsD ),
        .R_data2 (RtD )
    );
    
    SigExt16_32 Sigext16_32(
        .in  (inst_d[15:0]  ),
        .out (Imm32D )
    );
    
    ID_EX Id_ex(
        .clk      (clk      ),
        .rst      (rst      ),
        .pcplus4d (pcplus4d ),
        .RsD      (RsD      ),
        .RtD      (RtD      ),
        .Imm32D   (Imm32D   ),
        .inst_d   (inst_d   ),
        .WB_D     (cu_d[10:8]     ),
        .MA_D     (cu_d[7:4]     ),
        .EX_D     (cu_d[3:0]     ),
        .Clear    (IF_ID_RegWr   ),
        .pcplus4e (pcplus4e ),
        .RsE      (RsE      ),
        .RtE      (RtE      ),
        .Imm32E   (Imm32E   ),
        .inst_e   (inst_e   ),
        .WB_E     (WB_E     ),
        .MA_E     (MA_E     ),
        .EX_E     (EX_E)
    );
    
   SHL Shl_j(
       .data_in  (inst_e[25:0]  ),
       .data_out (shl_j )
   );
   
    ADD Add_i(
        .a      (pcplus4e),
        .b      (shl_i   ),
        .result (pc_i )
    );
    
    SHL#(32,32) Shl2_i(
        .data_in  (Imm32E  ),
        .data_out (shl_i )
    );
    
    MUX_4#(32)  Mux_A(
        .d0     (RsE     ),
        .d1     (ALUOutM     ),
        .d2     (W_dataw     ),
        .d3     (32'd0),
        .signal (ALUSrcA ),
        .out    (A    )
    );
    MUX_4#(32)  Mux_B(
        .d0     (RtE     ),
        .d1     (ALUOutM     ),
        .d2     (W_dataw     ),
        .d3     (Imm32E     ),
        .signal (ALUSrcB ),
        .out    (B    )
    );
    ALU Alu(
        .ALUCtrl (EX_E ),
        .a       (A       ),
        .b       (B       ),
        .alu_out (ALUOutE ),
        .zf      (zE      )
    );
    EX_MA Ex_ma(
        .clk     (clk     ),
        .rst     (rst     ),
        .pc_jE   ({pcplus4e[31:28],shl_j}   ),
        .pc_iE   (pc_i   ),
        .zfE     (zE     ),
        .ALUOutE (ALUOutE ),
        .RtE     (RtE     ),
        .inst_e  (inst_e  ),
        .WB_E    (cu_e[6:4]     ),
        .MA_E    (cu_e[3:0]    ),
        .pc_jM   (pc_jM   ),
        .pc_iM   (pc_iM   ),
        .zfM     (zfM     ),
        .ALUOutM (ALUOutM ),
        .RtM     (RtM     ),
        .inst_m  (inst_m  ),
        .WB_M    (WB_M    ),
        .MA_M    (MA_M    )
    );

    MUX_2#(32)  Mux_DM(
        .d0     (RtM     ),
        .d1     (W_dataw     ),
        .signal (MemSrc ),
        .out    (DM_W_data    )
    );
    
    DM Dm(
        .clk    (clk    ),
        .addr   (ALUOutM   ),
        .W      (MA_M[2]      ),
        .R      (MA_M[3]      ),
        .W_data (DM_W_data ),
        .R_data (MEMOutM )
    );
    
    MUX_4#(32) Mux_jump(
        .d0     (32'd0     ),
        .d1     (pc_jM     ),
        .d2     (pc_iM     ),
        .d3     (32'd0     ),
        .signal ({zfM&MA_M[1],MA_M[0]} ),
        .out    (mux_ma    )
    );
    MA_WB Ma_wb(
        .clk     (clk     ),
        .rst     (rst     ),
        .WB_M    (WB_M    ),
        .ALUOutM (ALUOutM ),
        .MEMOutM (MEMOutM ),
        .inst_m  (inst_m  ),
        .WB_W    (WB_W    ),
        .ALUOutW (ALUOutW ),
        .MEMOutW (MEMOutW ),
        .inst_w  (inst_w  )
    );

    MUX_2#(32)  Mux_data(
        .d0     (ALUOutW     ),
        .d1     (MEMOutW     ),
        .signal (WB_W[0]     ),
        .out    (W_dataw    )
    );
    MUX_2#(5)  Mux_reg(
        .d0     (inst_w[20:16]     ),
        .d1     (inst_w[15:11]     ),
        .signal (WB_W[2] ),
        .out    (W_Regw    )
    );
    
    CU Cu(
        .opcode  (inst_d[31:26]  ),
        .func    (inst_d[5:0]    ),
        .cu_out  (cu_out  ),
        .ALUCtrl (ALUCtrl )
    );
    
    MUX_2#(11) Mux_cu(
        .d0     (cu_out     ),
        .d1     (11'd0     ),
        .signal (Clear0 ),
        .out    (cu_d    )
    );
    
    MUX_2#(7) Mux_ex(
        .d0     ({WB_E,MA_E} ),
        .d1     (7'd0     ),
        .signal (Clear1 ),
        .out    (cu_e    )
    );
    
    Forward_Unit Forward_unit(
        .ID_EX_IR       (inst_e       ),
        .EX_MA_IR       (inst_m       ),
        .MA_WB_IR       (inst_w       ),
        .EX_MA_RegWr    (WB_M[1]   ),
        .EX_MA_MemtoReg (WB_M[0]   ),
        .EX_MA_MemWr    (MA_M[2]    ),
        .ID_EX_MemWr    (MA_E[2]    ),
        .MA_WB_RegWr    (WB_W[1]    ),
        .ALUSrcA        (ALUSrcA        ),
        .ALUSrcB        (ALUSrcB        ),
        .MemSrc         (MemSrc         )
    );
    
    Hazard_Unit Hazard_unit(
        .clk           (clk           ),
        .rst           (rst           ),
        .ID_EX_MemRd   (MA_E[3]  ),
        .ID_EX_Jump    (MA_E[0]    ),
        .EX_MA_Branch  (MA_M[1]  ),
        .FI_ID_Rs      (inst_d[25:21]      ),
        .FI_ID_Rt      (inst_d[20:16]      ),
        .ID_EX_IR_Rt   (inst_e[20:16]      ),
        .EX_MA_Flag_ZF (zfM ),
        .PCWr          (PCWr          ),
        .IF_ID_RegWr   (IF_ID_RegWr   ),
        .clear0        (Clear0        ),
        .clear1        (Clear1        ),
        .flush         (flush          )
    );
    
    
endmodule