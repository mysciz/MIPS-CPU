`timescale 1ns / 1ps
module Reg32(
    input  wire        clk,     
    input  wire [31:0] in,      
    output reg  [31:0] out      
);

always @(posedge clk) begin
    out <= in;  // 每个时钟上升沿更新输出
end

endmodule