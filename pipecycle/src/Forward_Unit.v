`timescale 1ns/1ps
module Forward_Unit (
    input wire[31:0] ID_EX_IR, EX_MA_IR, MA_WB_IR,
    input wire EX_MA_RegWr, EX_MA_MemtoReg, EX_MA_MemWr, ID_EX_MemWr, MA_WB_RegWr,
    output wire[1:0] ALUSrcA, ALUSrcB,
    output wire MemSrc
);
    
    // ============ 提取寄存器编号 ============
    wire [4:0] id_ex_rs = ID_EX_IR[25:21];
    wire [4:0] id_ex_rt = ID_EX_IR[20:16];
    wire [5:0] id_ex_opcode = ID_EX_IR[31:26];
    
    // EX/MA目标寄存器
    wire [4:0] ex_ma_rd;
    wire [5:0] ex_ma_opcode = EX_MA_IR[31:26];
    wire ex_ma_is_rtype = (ex_ma_opcode == 6'b000000);
    assign ex_ma_rd = ex_ma_is_rtype ? EX_MA_IR[15:11] : 
                     (ex_ma_opcode == 6'b000011) ? 5'b11111 : EX_MA_IR[20:16];
    
    // MA/WB目标寄存器
    wire [4:0] ma_wb_rd;
    wire [5:0] ma_wb_opcode = MA_WB_IR[31:26];
    wire ma_wb_is_rtype = (ma_wb_opcode == 6'b000000);
    assign ma_wb_rd = ma_wb_is_rtype ? MA_WB_IR[15:11] : 
                     (ma_wb_opcode == 6'b000011) ? 5'b11111 : MA_WB_IR[20:16];
    
    // ============ 有效性判断 ============
    wire ex_ma_valid = EX_MA_RegWr && (ex_ma_rd != 5'b0) && !EX_MA_MemtoReg;
    wire ma_wb_valid = MA_WB_RegWr && (ma_wb_rd != 5'b0);
    
    // ============ 转发逻辑 ============
    // ALUSrcA：总是可能转发（除了使用立即数的情况）
    reg [1:0] alu_src_a;
    assign ALUSrcA = alu_src_a;
    
    always @(*) begin
        alu_src_a = 2'b00;
        if (ex_ma_valid && (ex_ma_rd == id_ex_rs))
            alu_src_a = 2'b01;
        else if (ma_wb_valid && (ma_wb_rd == id_ex_rs))
            alu_src_a = 2'b10;
    end
    
    // ALUSrcB：需要考虑指令类型
    reg [1:0] alu_src_b;
    assign ALUSrcB = alu_src_b;
    
    // 判断哪些指令的ALU输入B使用立即数
    wire alu_b_uses_imm;
    assign alu_b_uses_imm = 
        // I-type ALU指令
        (id_ex_opcode == 6'b001000) ||  // addi
        (id_ex_opcode == 6'b001100) ||  // andi  
        (id_ex_opcode == 6'b001101) ||  // ori
        (id_ex_opcode == 6'b001010) ||  // slti
        (id_ex_opcode == 6'b001110) ||  // xori
        (id_ex_opcode == 6'b001111) ||  // lui
        // 访存指令（地址计算）
        (id_ex_opcode == 6'b100011) ||  // lw
        (id_ex_opcode == 6'b101011);    // sw
        // 注意：分支指令（beq/bne等）使用寄存器比较，不使用立即数！
    
    always @(*) begin
        if (alu_b_uses_imm) begin
            alu_src_b = 2'b11;  // 使用立即数
        end
        else begin
            alu_src_b = 2'b00;  // 默认使用寄存器
            if (ex_ma_valid && (ex_ma_rd == id_ex_rt))
                alu_src_b = 2'b01;  // 从EX/MA转发
            else if (ma_wb_valid && (ma_wb_rd == id_ex_rt))
                alu_src_b = 2'b10;  // 从MA/WB转发
        end
    end
    
    // MemSrc逻辑保持不变
    reg mem_src;
    assign MemSrc = mem_src;
    
    always @(*) begin
        mem_src = 1'b0;
        if (ID_EX_MemWr) begin
            if (ex_ma_valid && (ex_ma_rd == id_ex_rt))
                mem_src = 1'b1;
            else if (ma_wb_valid && (ma_wb_rd == id_ex_rt))
                mem_src = 1'b1;
        end
    end
    
endmodule