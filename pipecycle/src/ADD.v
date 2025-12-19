`timescale 1ns / 1ps

module ADD(
    input wire[31:0] a,      // 操作数1
    input wire[31:0] b,      // 操作数2
    output wire[31:0] result // 加法结果
);

assign result = a + b;

endmodule