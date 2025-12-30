`timescale 1ns / 1ps


module ID_EX (
    input clk,
    input rst,
    input wire[31:0] pcplus4d,RsD,RtD,Imm32D,inst_d,
    input wire[2:0] WB_D,
    input wire[3:0] MA_D,
    input wire[3:0] EX_D,
    input Clear,
    output reg[31:0] pcplus4e,
    output reg[31:0] RsE,
    output reg[31:0] RtE,
    output reg[31:0] Imm32E,
    output reg[31:0] inst_e,
    output reg[2:0] WB_E,
    output reg[3:0] MA_E,
    output reg[3:0] EX_E
);

 // 流水线寄存器更新逻辑
    always @(posedge clk or posedge rst) begin
        if (rst | !Clear) begin
            // 复位所有流水线寄存器
            pcplus4e <= 32'b0;
            RsE <= 32'b0;
            RtE <= 32'b0;
            Imm32E <= 32'b0;
            inst_e <= 32'b0;
            WB_E <= 3'b0;
            MA_E <= 4'b0;
            EX_E <= 4'b0;
        end
        else begin
            // 在每个时钟上升沿，将 ID 阶段的数据传递到 EX 阶段
            pcplus4e <= pcplus4d;
            RsE <= RsD;
            RtE <= RtD;
            Imm32E <= Imm32D;
            inst_e <= inst_d;
            WB_E <= WB_D;
            MA_E <= MA_D;
            EX_E <= EX_D;
        end
    end

endmodule