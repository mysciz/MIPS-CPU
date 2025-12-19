`timescale 1ns / 1ps

`timescale 1ns / 1ps

module ID_EX (
    input clk,
    input rst,
    
    // 数据输入（来自ID阶段）
    input [31:0] ID_Rs,          // 寄存器Rs的值
    input [31:0] ID_Rt,          // 寄存器Rt的值
    input [31:0] ID_Imm32,       // 符号扩展后的立即数
    input [31:0] inst_id,        // 指令
    input [31:0] ID_npc,         // PC+4值（新增输入）
    
    // 控制信号输入（已通过clear0 MUX）
    input [2:0]  ID_WB,          // WB控制信号（MemtoReg, RegWrite, RegDst）
    input [3:0]  ID_MA,          // MA控制信号（MemRead, MemWrite, Branch, jump）
    input [3:0]  ID_EX,          // EX控制信号（ALUOp, ALUSrc）
    
    // 输出到EX阶段
    output reg [31:0] EX_Rs,
    output reg [31:0] EX_Rt,
    output reg [31:0] EX_Imm32,
    output reg [31:0] inst_ex,
    output reg [31:0] EX_npc,    // 新增输出：传递的PC+4
    
    output reg [2:0]  EX_WB,     // WB控制信号（保持3位）
    output reg [3:0]  EX_MA,     // MA控制信号（保持4位）
    output reg [2:0]  EX_EX      // EX控制信号（保持3位）
);

// 信号定义（用于调试）
wire [5:0] opcode = inst_ex[31:26];
wire [4:0] rs = inst_ex[25:21];
wire [4:0] rt = inst_ex[20:16];
wire [4:0] rd = inst_ex[15:11];
wire [5:0] funct = inst_ex[5:0];

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // 复位所有输出
        EX_Rs      <= 32'h00000000;
        EX_Rt      <= 32'h00000000;
        EX_Imm32   <= 32'h00000000;
        inst_ex    <= 32'h00000000;
        EX_npc     <= 32'h00000000;  // 新增复位
        
        EX_WB      <= 3'b000;   // WB控制清零（3位）
        EX_MA      <= 4'b0000;  // MA控制清零（4位）
        EX_EX      <= 3'b000;   // EX控制清零（3位）
    end
    else begin
        // 正常流水线传递
        EX_Rs      <= ID_Rs;
        EX_Rt      <= ID_Rt;
        EX_Imm32   <= ID_Imm32;
        inst_ex    <= inst_id;
        EX_npc     <= ID_npc;   // 传递PC+4
        
        // 控制信号直接传递（注意位宽匹配）
        EX_WB      <= ID_WB;    // 3位
        EX_MA      <= ID_MA;    // 4位
        EX_EX      <= ID_EX;    // 3位
    end
end

endmodule