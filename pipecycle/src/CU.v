`timescale 1ns / 1ps

module CU (
    input wire[5:0] opcode,      // 指令高6位（opcode字段）
    input wire[5:0] func,        // 指令低6位（funct字段，用于R型指令）
    output wire[10:0] cu_out,    // 控制信号输出 [10:0]
    output wire[3:0] ALUCtrl     // ALU控制信号（四位）
);

// ==================== 指令opcode定义 ====================
parameter R_TYPE  = 6'b000000;  // R-type指令
parameter LW      = 6'b100011;  // lw指令
parameter SW      = 6'b101011;  // sw指令
parameter BEQ     = 6'b000100;  // beq指令
parameter BNE     = 6'b000101;  // bne指令
parameter J       = 6'b000010;  // j指令
parameter JAL     = 6'b000011;  // jal指令
parameter ADDI    = 6'b001000;  // addi指令
parameter ADDIU   = 6'b001001;  // addiu指令
parameter ANDI    = 6'b001100;  // andi指令
parameter ORI     = 6'b001101;  // ori指令
parameter XORI    = 6'b001110;  // xori指令
parameter SLTI    = 6'b001010;  // slti指令
parameter SLTIU   = 6'b001011;  // sltiu指令

// ==================== R型指令func定义 ====================
parameter FUNC_ADD  = 6'b100000;  // add
parameter FUNC_ADDU = 6'b100001;  // addu
parameter FUNC_SUB  = 6'b100010;  // sub
parameter FUNC_SUBU = 6'b100011;  // subu
parameter FUNC_AND  = 6'b100100;  // and
parameter FUNC_OR   = 6'b100101;  // or
parameter FUNC_XOR  = 6'b100110;  // xor
parameter FUNC_NOR  = 6'b100111;  // nor
parameter FUNC_SLT  = 6'b101010;  // slt
parameter FUNC_SLTU = 6'b101011;  // sltu
parameter FUNC_SLL  = 6'b000000;  // sll
parameter FUNC_SRL  = 6'b000010;  // srl
parameter FUNC_SRA  = 6'b000011;  // sra
parameter FUNC_JR   = 6'b001000;  // jr指令

// ==================== ALU控制码定义 =====================
parameter ALU_AND   = 4'b0000;  // AND
parameter ALU_OR    = 4'b0001;  // OR
parameter ALU_ADD   = 4'b0010;  // ADD/ADDU/ADDI/ADDIU
parameter ALU_XOR   = 4'b0100;  // XOR
parameter ALU_NOR   = 4'b0101;  // NOR
parameter ALU_SUB   = 4'b0110;  // SUB/SUBU/BEQ/BNE
parameter ALU_SLT   = 4'b0111;  // SLT/SLTI
parameter ALU_SLTU  = 4'b1000;  // SLTU/SLTIU
parameter ALU_SLL   = 4'b1001;  // SLL
parameter ALU_SRL   = 4'b1010;  // SRL
parameter ALU_SRA   = 4'b1011;  // SRA

/*
控制信号定义（修正版）：
WB控制 [2:0] = {RegDst, RegWrite, MemToReg}
  RegDst: 1=R型指令(rd), 0=I型指令(rt)
  RegWrite: 1=写寄存器, 0=不写
  MemToReg: 1=数据来自内存(lw), 0=数据来自ALU

MA控制 [3:0] = {MemRead, MemWrite, Branch, Jump}
  MemRead: 1=lw指令
  MemWrite: 1=sw指令
  Branch: 1=分支指令(beq/bne)
  Jump: 1=跳转指令(j/jal)

EX控制 [3:0] = ALUCtrl（单独输出）

实际分配：
cu_out[10:0] = {WB[2:0], MA[3:0], ALUCtrl_reg[3:0]}
*/

// 内部信号定义
reg [2:0] WB_ctrl;    // 写回控制：{RegDst, RegWrite, MemToReg}
reg [3:0] MA_ctrl;    // 访存控制：{MemRead, MemWrite, Branch, Jump}
reg [3:0] ALUCtrl_reg; // ALU控制信号

// 将内部寄存器信号连接到输出
assign cu_out = {WB_ctrl, MA_ctrl, ALUCtrl_reg};
assign ALUCtrl = ALUCtrl_reg;

// 指令译码和控制信号生成
always @(*) begin
    // 默认值（防止锁存器）
    WB_ctrl = 3'b000;      // 默认不写回寄存器
    MA_ctrl = 4'b0000;     // 默认不访存，不跳转
    ALUCtrl_reg = ALU_ADD; // 默认ALU操作：加法

    case (opcode)
        // R型指令 - 根据func字段确定具体操作
        R_TYPE: begin
            case (func)
                FUNC_JR: begin
                    // jr指令
                    WB_ctrl = 3'b000;      // 不写回寄存器
                    MA_ctrl = 4'b0001;     // Jump=1（寄存器跳转）
                    ALUCtrl_reg = ALU_ADD; // ALU操作无关紧要
                end
                default: begin
                    // 其他R型指令
                    WB_ctrl = 3'b110;      // RegDst=1, RegWrite=1, MemToReg=0
                    MA_ctrl = 4'b0000;     // 不访存，不跳转
                    
                    // 根据func字段确定ALU操作
                    case (func)
                        FUNC_ADD, FUNC_ADDU:  ALUCtrl_reg = ALU_ADD;   // add/addu
                        FUNC_SUB, FUNC_SUBU:  ALUCtrl_reg = ALU_SUB;   // sub/subu
                        FUNC_AND:             ALUCtrl_reg = ALU_AND;   // and
                        FUNC_OR:              ALUCtrl_reg = ALU_OR;    // or
                        FUNC_XOR:             ALUCtrl_reg = ALU_XOR;   // xor
                        FUNC_NOR:             ALUCtrl_reg = ALU_NOR;   // nor
                        FUNC_SLT:             ALUCtrl_reg = ALU_SLT;   // slt
                        FUNC_SLTU:            ALUCtrl_reg = ALU_SLTU;  // sltu
                        FUNC_SLL:             ALUCtrl_reg = ALU_SLL;   // sll
                        FUNC_SRL:             ALUCtrl_reg = ALU_SRL;   // srl
                        FUNC_SRA:             ALUCtrl_reg = ALU_SRA;   // sra
                        default:              ALUCtrl_reg = ALU_ADD;   // 默认加法
                    endcase
                end
            endcase
        end
        
        // lw指令
        LW: begin
            WB_ctrl = 3'b011;      // RegDst=0, RegWrite=1, MemToReg=1
            MA_ctrl = 4'b1000;     // MemRead=1, MemWrite=0, Branch=0, Jump=0
            ALUCtrl_reg = ALU_ADD; // ALU执行加法计算地址
        end
        
        // sw指令
        SW: begin
            WB_ctrl = 3'b000;      // RegDst=X, RegWrite=0, MemToReg=X
            MA_ctrl = 4'b0100;     // MemRead=0, MemWrite=1, Branch=0, Jump=0
            ALUCtrl_reg = ALU_ADD; // ALU执行加法计算地址
        end
        
        // beq指令
        BEQ: begin
            WB_ctrl = 3'b000;      // RegDst=X, RegWrite=0, MemToReg=X
            MA_ctrl = 4'b0010;     // MemRead=0, MemWrite=0, Branch=1, Jump=0
            ALUCtrl_reg = ALU_SUB; // ALU执行减法用于比较
        end
        
        // bne指令
        BNE: begin
            WB_ctrl = 3'b000;      // RegDst=X, RegWrite=0, MemToReg=X
            MA_ctrl = 4'b0010;     // MemRead=0, MemWrite=0, Branch=1, Jump=0
            ALUCtrl_reg = ALU_SUB; // ALU执行减法用于比较
        end
        
        // j指令
        J: begin
            WB_ctrl = 3'b000;      // RegDst=X, RegWrite=0, MemToReg=X
            MA_ctrl = 4'b0001;     // MemRead=0, MemWrite=0, Branch=0, Jump=1
            ALUCtrl_reg = ALU_ADD; // ALU操作无关紧要
        end
        
        // jal指令
        JAL: begin
            WB_ctrl = 3'b010;      // RegDst=X, RegWrite=1, MemToReg=0（写入$31）
            MA_ctrl = 4'b0001;     // MemRead=0, MemWrite=0, Branch=0, Jump=1
            ALUCtrl_reg = ALU_ADD; // ALU操作无关紧要
        end
        
        // addi指令
        ADDI: begin
            WB_ctrl = 3'b010;      // RegDst=0, RegWrite=1, MemToReg=0
            MA_ctrl = 4'b0000;     // 不访存，不跳转
            ALUCtrl_reg = ALU_ADD; // ALU执行加法
        end
        
        // addiu指令
        ADDIU: begin
            WB_ctrl = 3'b010;      // RegDst=0, RegWrite=1, MemToReg=0
            MA_ctrl = 4'b0000;     // 不访存，不跳转
            ALUCtrl_reg = ALU_ADD; // ALU执行加法
        end
        
        // andi指令
        ANDI: begin
            WB_ctrl = 3'b010;      // RegDst=0, RegWrite=1, MemToReg=0
            MA_ctrl = 4'b0000;     // 不访存，不跳转
            ALUCtrl_reg = ALU_AND; // ALU执行与操作
        end
        
        // ori指令
        ORI: begin
            WB_ctrl = 3'b010;      // RegDst=0, RegWrite=1, MemToReg=0
            MA_ctrl = 4'b0000;     // 不访存，不跳转
            ALUCtrl_reg = ALU_OR;  // ALU执行或操作
        end
        
        // xori指令
        XORI: begin
            WB_ctrl = 3'b010;      // RegDst=0, RegWrite=1, MemToReg=0
            MA_ctrl = 4'b0000;     // 不访存，不跳转
            ALUCtrl_reg = ALU_XOR; // ALU执行异或操作
        end
        
        // slti指令
        SLTI: begin
            WB_ctrl = 3'b010;      // RegDst=0, RegWrite=1, MemToReg=0
            MA_ctrl = 4'b0000;     // 不访存，不跳转
            ALUCtrl_reg = ALU_SLT; // ALU执行有符号比较
        end
        
        // sltiu指令
        SLTIU: begin
            WB_ctrl = 3'b010;      // RegDst=0, RegWrite=1, MemToReg=0
            MA_ctrl = 4'b0000;     // 不访存，不跳转
            ALUCtrl_reg = ALU_SLTU; // ALU执行无符号比较
        end
        
        default: begin
            // 未定义指令，保持默认值（相当于nop）
            WB_ctrl = 3'b000;
            MA_ctrl = 4'b0000;
            ALUCtrl_reg = ALU_ADD;
        end
    endcase
end

endmodule