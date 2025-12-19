`timescale 1ns / 1ps

module IR(
    input wire clk,           // 时钟信号
    input wire IRWr,          // IR写使能信号（多周期控制）
    input wire [31:0] inst, // 指令输入
    output wire [25:21] rs, // rs字段
    output wire [20:16] rt, // rt字段
    output wire [15:0] Imm,   // 立即数/地址字段
    output wire [31:26] opcode  // opcode字段
);

reg [31:0] inst_reg;  // 内部指令寄存器

// 指令寄存器更新
always @(posedge clk) begin
    if (IRWr) begin
        inst_reg <= inst;  // 只有当IRWr为1时才更新指令
    end
    // IRWr为0时保持原值
end

// 拆分输出各个字段
assign rs = inst_reg[25:21];  // rs (5位)
assign rt = inst_reg[20:16];  // rt (5位)
assign Imm  = inst_reg[15:0];   // immediate/address (16位)
assign opcode = inst_reg[31:26];  // opcode (6位)

endmodule