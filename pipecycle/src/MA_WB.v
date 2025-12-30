`timescale 1ns / 1ps
module MA_WB (
    input clk,rst,
    input wire[2:0] WB_M,
    input wire [31:0] ALUOutM,
    input wire [31:0] MEMOutM,
    input wire [31:0] inst_m,
    output reg[2:0] WB_W,
    output reg [31:0] ALUOutW,
    output reg [31:0] MEMOutW,
    output reg [31:0] inst_w
);
     // 流水线寄存器更新逻辑
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // 复位所有流水线寄存器
            WB_W <= 3'b0;
            ALUOutW <= 32'b0;
            MEMOutW <= 32'b0;
            inst_w <= 32'b0;
        end
        else begin
            // 在每个时钟上升沿，将 MA 阶段的数据传递到 WB 阶段
            WB_W <= WB_M;
            ALUOutW <= ALUOutM;
            MEMOutW <= MEMOutM;
            inst_w <= inst_m;
        end
    end
endmodule