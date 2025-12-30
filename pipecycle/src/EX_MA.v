`timescale 1ns / 1ps
module EX_MA (
    input clk,rst,
    input [31:0] pc_jE,pc_iE,
    input zfE,
    input [31:0] ALUOutE,
    input [31:0] RtE,
    input [31:0] inst_e,
    input wire[2:0] WB_E,
    input wire[3:0] MA_E,
    output reg[31:0] pc_jM,pc_iM,
    output reg zfM,
    output reg[31:0] ALUOutM,
    output reg[31:0] RtM,
    output reg[31:0] inst_m,
    output reg[2:0] WB_M,
    output reg[3:0] MA_M
);
    // 流水线寄存器更新逻辑
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // 复位所有流水线寄存器
            pc_jM <= 32'b0;
            pc_iM <= 32'b0;
            zfM <= 1'b0;
            ALUOutM <= 32'b0;
            RtM <= 32'b0;
            inst_m <= 32'b0;
            WB_M <= 3'b0;
            MA_M <= 4'b0;
        end
        else begin
            // 在每个时钟上升沿，将 EX 阶段的数据传递到 MA 阶段
            pc_jM <= pc_jE;
            pc_iM <= pc_iE;
            zfM <= zfE;
            ALUOutM <= ALUOutE;
            RtM <= RtE;
            inst_m <= inst_e;
            WB_M <= WB_E;
            MA_M <= MA_E;
        end
    end

endmodule