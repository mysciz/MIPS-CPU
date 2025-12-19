`timescale 1ns / 1ps

module SR(
    input wire clk,           // 时钟信号
    input wire rst,           // 复位信号
    input wire [3:0] NS,   // 下一状态输入 (NS3, NS2, NS1, NS0)
    output reg [3:0] S   // 当前状态输出
);

// 状态寄存器
always @(posedge clk or posedge rst) begin
    if (rst) begin
        S <= 4'b0000;  // 复位时回到初始状态（通常是取指状态）
    end else begin
        S <= NS;    // 每个时钟更新状态
    end
end

endmodule