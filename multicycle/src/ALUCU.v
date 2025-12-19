`timescale 1ns / 1ps

module ALUCU(
    // 输入
    input wire[5:0] opcode,     // 新增：指令opcode
    input wire[5:0] funct,      // 指令的funct字段
    input wire[1:0] ALUOp,      // 主控制器的ALU操作类型
    
    // 输出
    output reg[3:0] ALUCtrl     // 4位ALU操作码
);
    
    // ==================== opcode定义 ====================
    localparam OP_ADDI  = 6'b001000;
    localparam OP_ADDIU = 6'b001001;
    localparam OP_ANDI  = 6'b001100;
    localparam OP_ORI   = 6'b001101;
    localparam OP_XORI  = 6'b001110;
    localparam OP_SLTI  = 6'b001010;
    localparam OP_SLTIU = 6'b001011;
    localparam OP_LUI   = 6'b001111;
    
    // ==================== funct字段定义 ====================
    localparam FUNCT_ADD  = 6'b100000;
    localparam FUNCT_ADDU = 6'b100001;
    localparam FUNCT_SUB  = 6'b100010;
    localparam FUNCT_SUBU = 6'b100011;
    localparam FUNCT_AND  = 6'b100100;
    localparam FUNCT_OR   = 6'b100101;
    localparam FUNCT_XOR  = 6'b100110;
    localparam FUNCT_NOR  = 6'b100111;
    localparam FUNCT_SLT  = 6'b101010;
    localparam FUNCT_SLTU = 6'b101011;
    localparam FUNCT_SLL  = 6'b000000;
    localparam FUNCT_SRL  = 6'b000010;
    localparam FUNCT_SRA  = 6'b000011;
    localparam FUNCT_JR   = 6'b001000;
    
    always @(*) begin
        case(ALUOp)
            2'b00: begin  // lw, sw等需要地址计算的指令
                ALUCtrl = 4'b0010;  // ADD
            end
            
            2'b01: begin  // beq, bne
                ALUCtrl = 4'b0110;  // SUB
            end
            
            2'b10: begin  // R-type指令
                case(funct)
                    FUNCT_ADD, FUNCT_ADDU:  ALUCtrl = 4'b0010;  // ADD
                    FUNCT_SUB, FUNCT_SUBU:  ALUCtrl = 4'b0110;  // SUB
                    FUNCT_AND:              ALUCtrl = 4'b0000;  // AND
                    FUNCT_OR:               ALUCtrl = 4'b0001;  // OR
                    FUNCT_XOR:              ALUCtrl = 4'b0100;  // XOR
                    FUNCT_NOR:              ALUCtrl = 4'b0101;  // NOR
                    FUNCT_SLT:              ALUCtrl = 4'b0111;  // SLT
                    FUNCT_SLTU:             ALUCtrl = 4'b1000;  // SLTU
                    FUNCT_SLL:              ALUCtrl = 4'b1001;  // SLL
                    FUNCT_SRL:              ALUCtrl = 4'b1010;  // SRL
                    FUNCT_SRA:              ALUCtrl = 4'b1011;  // SRA
                    default:                ALUCtrl = 4'b0010;  // 默认ADD
                endcase
            end
            
            2'b11: begin  // 新增：I-type立即数指令
                case(opcode)
                    OP_ADDI, OP_ADDIU:      ALUCtrl = 4'b0010;  // ADD
                    OP_ANDI:                ALUCtrl = 4'b0000;  // AND
                    OP_ORI:                 ALUCtrl = 4'b0001;  // OR
                    OP_XORI:                ALUCtrl = 4'b0100;  // XOR
                    OP_SLTI:                ALUCtrl = 4'b0111;  // SLT
                    OP_SLTIU:               ALUCtrl = 4'b1000;  // SLTU
                    OP_LUI:                 ALUCtrl = 4'b1100;  // LUI（特殊）
                    default:                ALUCtrl = 4'b0010;  // 默认ADD
                endcase
            end
            
            default: begin
                ALUCtrl = 4'b0010;  // 默认ADD
            end
        endcase
    end
    
endmodule