`timescale 1ns / 1ps
module IF_ID (
    input clk,
    input rst,
    input FI_ID_RegWr,     // 来自冒险检测单元（写使能）
    input [31:0] inst_in,
    input [31:0] pc4_in,
    output reg [31:0] inst_out,
    output reg [31:0] pc4_out
);

// stall信号：当FI_ID_RegWr=0时暂停
wire stall = !FI_ID_RegWr;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        inst_out <= 32'h00000020;  // NOP指令
        pc4_out <= 32'h00000000;
    end
    else if (!stall) begin
        // 只有FI_ID_RegWr=1时才更新
        inst_out <= inst_in;
        pc4_out <= pc4_in;
    end
    // stall=1时：保持原值（不写）
end

endmodule