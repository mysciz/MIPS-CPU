`timescale 1ns / 1ps

module ALUCU(
    // 输入
    input wire[5:0] funct,      // 指令的funct字段
    input wire[1:0] ALUOp,      // 主控制器的ALU操作类型
    
    // 输出
    output reg[3:0] ALUCtrl  // 4位ALU操作码
);
    
    // ==================== funct字段定义 ====================
    localparam FUNCT_ADD  = 6'b100000;  // add
    localparam FUNCT_ADDU = 6'b100001;  // addu
    localparam FUNCT_SUB  = 6'b100010;  // sub
    localparam FUNCT_SUBU = 6'b100011;  // subu
    localparam FUNCT_AND  = 6'b100100;  // and
    localparam FUNCT_OR   = 6'b100101;  // or
    localparam FUNCT_XOR  = 6'b100110;  // xor
    localparam FUNCT_NOR  = 6'b100111;  // nor
    localparam FUNCT_SLT  = 6'b101010;  // slt
    localparam FUNCT_SLTU = 6'b101011;  // sltu
    localparam FUNCT_SLL  = 6'b000000;  // sll
    localparam FUNCT_SRL  = 6'b000010;  // srl
    localparam FUNCT_SRA  = 6'b000011;  // sra
    
    always @(*) begin
        case(ALUOp)
            2'b00: begin  // lw, sw, addi等
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
                    FUNCT_SLT:               ALUCtrl = 4'b0111;  // SLT
                    FUNCT_SLTU:             ALUCtrl = 4'b1000;  // SLTU
                    FUNCT_SLL:              ALUCtrl = 4'b1001;  // SLL
                    FUNCT_SRL:              ALUCtrl = 4'b1010;  // SRL
                    FUNCT_SRA:              ALUCtrl = 4'b1011;  // SRA
                    default:                ALUCtrl = 4'b0010;  // 默认ADD
                endcase
            end
            
            default: begin
                ALUCtrl = 4'b0010;  // 默认ADD
            end
        endcase
    end
    
endmodule