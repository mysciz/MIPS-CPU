`timescale 1ns / 1ps
module IF_ID (
    input clk,
    input rst,
    input FI_ID_RegWr,     // 来自冒险检测单元（写使能）
    input [31:0] inst_f,
    input [31:0] pcplus4f,
    input flush,
    output reg [31:0] inst_d,
    output reg [31:0] pcplus4d
);
 // 寄存器更新逻辑
    always @(posedge clk or posedge rst) begin
        if (rst|flush) begin
            // 复位时清空流水线寄存器
            inst_d <= 32'b0;
            pcplus4d <= 32'b0;
        end
        else if (FI_ID_RegWr) begin
            // 当写使能有效时，更新流水线寄存器
            inst_d <= inst_f;
            pcplus4d <= pcplus4f;
        end
        // 注意：如果 FI_ID_RegWr 为 0，寄存器保持原值（流水线停顿）
    end


endmodule