`timescale 1ns / 1ps
module PC(
    input wire clk,           // 时钟信号
    input wire rst,           // 复位信号
    input wire [31:0] next_pc, // 下一条指令地址
    output reg [31:0] pc      // 当前指令地址
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // 复位时PC指向初始地址（如0x00000000）
        pc <= 32'h0000_0000;
    end else begin
        // 正常情况下来自next_pc的地址
        pc <= next_pc;
    end
end

endmodule