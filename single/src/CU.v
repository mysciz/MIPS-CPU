`timescale 1ns / 1ps

module CU(
    input wire[5:0] opcode,  // op5, op4, op3, op2, op1, op0
    input wire[5:0] func,
    output reg RegDst, Jump, Branch, MemRead, MemtoReg,
    output reg[1:0] ALUOp,
    output reg MemWrite, ALUSrc, RegWrite
);
    // ==================== 指令opcode定义 ====================
    parameter R_TYPE  = 6'b000000;  // R-type指令
    parameter LW      = 6'b100011;  // lw指令
    parameter SW      = 6'b101011;  // sw指令
    parameter BEQ     = 6'b000100;  // beq指令
    parameter J       = 6'b000010;  // j指令
    parameter ADDI    = 6'b001000;  // addi指令
    parameter ANDI    = 6'b001100;  // andi指令
    parameter ORI     = 6'b001101;  // ori指令
    parameter XORI    = 6'b001110;  // xori指令
    parameter SLTI    = 6'b001010;  // slti指令
    
    // ==================== R-type指令func定义 ====================
    parameter FUNC_ADD  = 6'b100000;
    parameter FUNC_SUB  = 6'b100010;
    parameter FUNC_AND  = 6'b100100;
    parameter FUNC_OR   = 6'b100101;
    parameter FUNC_XOR  = 6'b100110;
    parameter FUNC_NOR  = 6'b100111;
    parameter FUNC_SLT  = 6'b101010;
    
    // ==================== 控制信号生成 ====================
    always @(*) begin
        case (opcode)
            R_TYPE: begin  // R型指令
                RegDst    = 1'b1;
                Jump      = 1'b0;
                Branch    = 1'b0;
                MemRead   = 1'b0;
                MemtoReg  = 1'b0;
                MemWrite  = 1'b0;
                ALUSrc    = 1'b0;    // 使用寄存器值
                RegWrite  = 1'b1;
                ALUOp     = 2'b10;   // 由func决定
            end
            
            LW: begin      // lw指令
                RegDst    = 1'b0;    // rt为目标
                Jump      = 1'b0;
                Branch    = 1'b0;
                MemRead   = 1'b1;    // 读内存
                MemtoReg  = 1'b1;    // 内存数据写入寄存器
                MemWrite  = 1'b0;
                ALUSrc    = 1'b1;    // 使用立即数
                RegWrite  = 1'b1;    // 写寄存器
                ALUOp     = 2'b00;   // 加法计算地址
            end
            
            SW: begin      // sw指令
                RegDst    = 1'bx;    // 无关
                Jump      = 1'b0;
                Branch    = 1'b0;
                MemRead   = 1'b0;
                MemtoReg  = 1'bx;    // 无关
                MemWrite  = 1'b1;    // 写内存
                ALUSrc    = 1'b1;    // 使用立即数
                RegWrite  = 1'b0;    // 不写寄存器
                ALUOp     = 2'b00;   // 加法计算地址
            end
            
            BEQ: begin     // beq指令
                RegDst    = 1'bx;    // 无关
                Jump      = 1'b0;
                Branch    = 1'b1;    // 分支使能
                MemRead   = 1'b0;
                MemtoReg  = 1'bx;    // 无关
                MemWrite  = 1'b0;
                ALUSrc    = 1'b0;    // 使用寄存器值比较
                RegWrite  = 1'b0;    // 不写寄存器
                ALUOp     = 2'b01;   // 减法比较
            end
            
            J: begin       // j指令
                RegDst    = 1'bx;    // 无关
                Jump      = 1'b1;    // 跳转使能
                Branch    = 1'b0;
                MemRead   = 1'b0;
                MemtoReg  = 1'bx;    // 无关
                MemWrite  = 1'b0;
                ALUSrc    = 1'bx;    // 无关
                RegWrite  = 1'b0;    // 不写寄存器
                ALUOp     = 2'bxx;   // 无关
            end
            
            ADDI: begin    // addi指令
                RegDst    = 1'b0;    // rt为目标
                Jump      = 1'b0;
                Branch    = 1'b0;
                MemRead   = 1'b0;
                MemtoReg  = 1'b0;    // ALU结果写入寄存器
                MemWrite  = 1'b0;
                ALUSrc    = 1'b1;    // 使用立即数
                RegWrite  = 1'b1;    // 写寄存器
                ALUOp     = 2'b11;   // 特殊：立即数加法
            end
            
            ANDI: begin    // andi指令
                RegDst    = 1'b0;    // rt为目标
                Jump      = 1'b0;
                Branch    = 1'b0;
                MemRead   = 1'b0;
                MemtoReg  = 1'b0;    // ALU结果写入寄存器
                MemWrite  = 1'b0;
                ALUSrc    = 1'b1;    // 使用立即数
                RegWrite  = 1'b1;    // 写寄存器
                ALUOp     = 2'b11;   // 特殊：立即数逻辑与
            end
            
            ORI: begin     // ori指令
                RegDst    = 1'b0;    // rt为目标
                Jump      = 1'b0;
                Branch    = 1'b0;
                MemRead   = 1'b0;
                MemtoReg  = 1'b0;    // ALU结果写入寄存器
                MemWrite  = 1'b0;
                ALUSrc    = 1'b1;    // 使用立即数
                RegWrite  = 1'b1;    // 写寄存器
                ALUOp     = 2'b11;   // 特殊：立即数逻辑或
            end
            
            XORI: begin    // xori指令
                RegDst    = 1'b0;    // rt为目标
                Jump      = 1'b0;
                Branch    = 1'b0;
                MemRead   = 1'b0;
                MemtoReg  = 1'b0;    // ALU结果写入寄存器
                MemWrite  = 1'b0;
                ALUSrc    = 1'b1;    // 使用立即数
                RegWrite  = 1'b1;    // 写寄存器
                ALUOp     = 2'b11;   // 特殊：立即数逻辑异或
            end
            
            SLTI: begin    // slti指令
                RegDst    = 1'b0;    // rt为目标
                Jump      = 1'b0;
                Branch    = 1'b0;
                MemRead   = 1'b0;
                MemtoReg  = 1'b0;    // ALU结果写入寄存器
                MemWrite  = 1'b0;
                ALUSrc    = 1'b1;    // 使用立即数
                RegWrite  = 1'b1;    // 写寄存器
                ALUOp     = 2'b11;   // 特殊：立即数比较
            end
            
            default: begin // 默认情况
                RegDst    = 1'bx;
                Jump      = 1'bx;
                Branch    = 1'bx;
                MemRead   = 1'bx;
                MemtoReg  = 1'bx;
                MemWrite  = 1'bx;
                ALUSrc    = 1'bx;
                RegWrite  = 1'bx;
                ALUOp     = 2'bxx;
            end
        endcase
    end
    
endmodule