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
                ALUSrc    = 1'b0;
                RegWrite  = 1'b1;
                ALUOp     = 2'b10;
            end
            
            LW: begin      // lw指令
                RegDst    = 1'b0;
                Jump      = 1'b0;
                Branch    = 1'b0;
                MemRead   = 1'b1;
                MemtoReg  = 1'b1;
                MemWrite  = 1'b0;
                ALUSrc    = 1'b1;
                RegWrite  = 1'b1;
                ALUOp     = 2'b00;
            end
            
            SW: begin      // sw指令
                RegDst    = 1'bx;  // 无关
                Jump      = 1'b0;
                Branch    = 1'b0;
                MemRead   = 1'b0;
                MemtoReg  = 1'bx;  // 无关
                MemWrite  = 1'b1;
                ALUSrc    = 1'b1;
                RegWrite  = 1'b0;
                ALUOp     = 2'b00;
            end
            
            BEQ: begin     // beq指令
                RegDst    = 1'bx;  // 无关
                Jump      = 1'b0;
                Branch    = 1'b1;
                MemRead   = 1'b0;
                MemtoReg  = 1'bx;  // 无关
                MemWrite  = 1'b0;
                ALUSrc    = 1'b0;
                RegWrite  = 1'b0;
                ALUOp     = 2'b01;  // beq的特殊ALUOp
            end
            
            J: begin       // j指令
                RegDst    = 1'bx;  // 无关
                Jump      = 1'b1;
                Branch    = 1'b0;
                MemRead   = 1'b0;
                MemtoReg  = 1'bx;  // 无关
                MemWrite  = 1'b0;
                ALUSrc    = 1'bx;  // 无关
                RegWrite  = 1'b0;
                ALUOp     = 2'bxx; // 无关
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