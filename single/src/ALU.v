`timescale 1ns / 1ps

module ALU(
    // 输入
    input wire[3:0] ALUCtrl,  // 来自ALUCU的4位控制信号
    input wire[31:0] a, b,       // 操作数
    
    // 输出
    output reg[31:0] alu_out,    // 计算结果
    output reg zf                // 零标志
);
    
    always @(*) begin
        case(ALUCtrl)
            
            4'b0010: begin  // ADD: 可能是add或addu
                alu_out = $signed(a) + $signed(b);
            end
            
            4'b0110: begin  // SUB: 可能是sub或subu
                alu_out = $signed(a) - $signed(b);
            end
            
            4'b0111: begin  // SLT
                alu_out = ($signed(a) < $signed(b)) ? 32'b1 : 32'b0;
            end
            4'b1000: begin  // SLTU
                alu_out = (a < b) ? 32'b1 : 32'b0;
            end
            4'b0000: alu_out = a & b;      // AND
            4'b0001: alu_out = a | b;      // OR
            4'b0100: alu_out = a ^ b;      // XOR
            4'b0101: alu_out = ~(a | b);   // NOR
            4'b1001: alu_out = b << a[4:0];  // SLL
            4'b1010: alu_out = b >> a[4:0];  // SRL
            4'b1011: alu_out = $signed(b) >>> a[4:0];  // SRA
            
            default: alu_out = 32'b0;
        endcase
        
        zf = (alu_out == 32'b0);
    end
    
endmodule