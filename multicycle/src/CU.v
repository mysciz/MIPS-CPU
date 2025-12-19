`timescale 1ns / 1ps

module CU(
    input wire clk,
    input wire[5:0] opcode,
    input wire[3:0] S,            // 当前状态（来自SR模块）
    input wire[5:0] func,         // R-type指令的func字段
    output wire lorD,             // 选择内存地址：0=PC, 1=ALU输出
    output wire IRWr,             // 指令寄存器写使能
    output wire PCWr,             // PC写使能（无条件）
    output wire PCWrcond,         // PC写使能（条件）
    output wire RegDst,           // 寄存器目标选择：0=rt, 1=rd
    output wire RegWr,            // 寄存器文件写使能
    output wire ALUSrcA,          // ALU输入A选择：0=PC, 1=寄存器A
    output wire MemWr,            // 内存写使能
    output wire MemRd,            // 内存读使能
    output wire MemtoReg,         // 寄存器写入数据选择：0=ALU输出, 1=内存数据
    output wire[1:0] ALUOp,       // ALU操作类型
    output wire[1:0] PCsrc,       // PC来源选择
    output wire[1:0] ALUSrcB,     // ALU输入B选择
    output wire[3:0] NS           // 下一个状态（输出到SR模块）
);

    // ==================== 状态定义 ====================
    // 多周期CPU的典型状态
    localparam S_IF   = 4'b0000;  // 取指令 (Instruction Fetch)
    localparam S_ID   = 4'b0001;  // 指令译码 (Instruction Decode)
    localparam S_EX   = 4'b0010;  // 执行/计算地址 (Execute)
    localparam S_MEM  = 4'b0011;  // 内存访问 (Memory Access)
    localparam S_WB   = 4'b0100;  // 写回 (Write Back)
    localparam S_J    = 4'b0101;  // 跳转 (Jump)
    localparam S_BR   = 4'b0110;  // 分支 (Branch)
    localparam S_ALU  = 4'b0111;  // ALU操作完成
    localparam S_LW2  = 4'b1000;  // lw的第二阶段
    localparam S_SW2  = 4'b1001;  // sw的第二阶段
    localparam S_RT   = 4'b1010;  // R-type完成
    localparam S_ADDI = 4'b1011;  // addi完成
    localparam S_SHIFT = 4'b1100; // 移位指令处理
    
    // ==================== 指令opcode定义 ====================
    localparam OP_RTYPE = 6'b000000;  // R-type指令
    localparam OP_LW    = 6'b100011;  // lw
    localparam OP_SW    = 6'b101011;  // sw
    localparam OP_BEQ   = 6'b000100;  // beq
    localparam OP_J     = 6'b000010;  // j
    localparam OP_ADDI  = 6'b001000;  // addi
    localparam OP_ANDI  = 6'b001100;  // andi
    localparam OP_ORI   = 6'b001101;  // ori
    localparam OP_XORI  = 6'b001110;  // xori
    
    // ==================== R-type指令func定义 ====================
    localparam FUNC_ADD  = 6'b100000;
    localparam FUNC_ADDU = 6'b100001;
    localparam FUNC_SUB  = 6'b100010;
    localparam FUNC_SUBU = 6'b100011;
    localparam FUNC_AND  = 6'b100100;
    localparam FUNC_OR   = 6'b100101;
    localparam FUNC_XOR  = 6'b100110;
    localparam FUNC_NOR  = 6'b100111;
    localparam FUNC_SLT  = 6'b101010;
    localparam FUNC_SLTU = 6'b101011;
    localparam FUNC_SLL  = 6'b000000;  // 移位指令
    localparam FUNC_SRL  = 6'b000010;
    localparam FUNC_SRA  = 6'b000011;
    localparam FUNC_JR   = 6'b001000;  // jr指令
    
    // ==================== 输出寄存器 ====================
    reg r_lorD, r_IRWr, r_PCWr, r_PCWrcond, r_RegDst, r_RegWr;
    reg r_ALUSrcA, r_MemWr, r_MemRd, r_MemtoReg;
    reg [1:0] r_ALUOp, r_PCsrc, r_ALUSrcB;
    reg [3:0] r_NS;  // 下一个状态
    
    // ==================== 内部信号 ====================
    reg is_shift;    // 是否为移位指令
    reg is_jr;       // 是否为jr指令
    
    // 判断指令类型
    always @(*) begin
        is_shift = 1'b0;
        is_jr = 1'b0;
        
        if (opcode == OP_RTYPE) begin
            case (func)
                FUNC_SLL, FUNC_SRL, FUNC_SRA: is_shift = 1'b1;
                FUNC_JR: is_jr = 1'b1;
                default: begin
                    is_shift = 1'b0;
                    is_jr = 1'b0;
                end
            endcase
        end
    end
    
    // ==================== 状态转移和输出逻辑 ====================
    always @(*) begin
        // 默认值
        r_lorD = 1'b0;
        r_IRWr = 1'b0;
        r_PCWr = 1'b0;
        r_PCWrcond = 1'b0;
        r_RegDst = 1'b0;
        r_RegWr = 1'b0;
        r_ALUSrcA = 1'b0;
        r_MemWr = 1'b0;
        r_MemRd = 1'b0;
        r_MemtoReg = 1'b0;
        r_ALUOp = 2'b00;
        r_PCsrc = 2'b00;
        r_ALUSrcB = 2'b01;
        r_NS = S;  // 默认保持当前状态
        
        case (S)
            S_IF: begin
                // 状态0: 取指令
                r_MemRd = 1'b1;     // 读内存
                r_IRWr = 1'b1;      // 写入指令寄存器
                r_ALUSrcB = 2'b01;  // ALU输入B=4
                r_ALUOp = 2'b00;    // 加法
                r_PCsrc = 2'b00;    // PC+4
                r_PCWr = 1'b1;      // 更新PC
                r_NS = S_ID;        // 下一状态: 指令译码
            end
            
            S_ID: begin
                // 状态1: 指令译码/读寄存器
                r_ALUSrcB = 2'b11;  // 符号扩展的立即数<<2（为分支准备）
                
                // 根据指令类型决定下一状态
                case (opcode)
                    OP_RTYPE: begin
                        if (is_shift) 
                            r_NS = S_SHIFT;  // 移位指令特殊处理
                        else if (is_jr)
                            r_NS = S_J;      // jr指令（当作跳转处理）
                        else
                            r_NS = S_EX;     // 普通R-type
                    end
                    OP_LW:    r_NS = S_EX;    // lw: 进入地址计算
                    OP_SW:    r_NS = S_EX;    // sw: 进入地址计算
                    OP_BEQ:   r_NS = S_BR;    // beq: 进入分支
                    OP_J:     r_NS = S_J;     // j: 进入跳转
                    OP_ADDI:  r_NS = S_EX;    // addi: 进入执行
                    OP_ANDI:  r_NS = S_EX;    // andi: 进入执行
                    OP_ORI:   r_NS = S_EX;    // ori: 进入执行
                    OP_XORI:  r_NS = S_EX;    // xori: 进入执行
                    default:  r_NS = S_IF;    // 未知指令: 回到取指
                endcase
            end
            
            S_EX: begin
                // 状态2: 执行/计算地址
                r_ALUSrcA = 1'b1;   // 寄存器A作为ALU输入A
                
                case (opcode)
                    OP_RTYPE: begin
                        r_ALUSrcB = 2'b00;  // 寄存器B作为ALU输入B
                        r_ALUOp = 2'b10;    // R-type ALU操作
                        r_NS = S_ALU;       // 下一状态: ALU完成
                    end
                    OP_LW: begin
                        r_ALUSrcB = 2'b10;  // 符号扩展的立即数
                        r_ALUOp = 2'b00;    // 加法（计算地址）
                        r_NS = S_MEM;       // 下一状态: 内存访问
                    end
                    OP_SW: begin
                        r_ALUSrcB = 2'b10;  // 符号扩展的立即数
                        r_ALUOp = 2'b00;    // 加法（计算地址）
                        r_NS = S_MEM;       // 下一状态: 内存访问
                    end
                    OP_ADDI: begin
                        r_ALUSrcB = 2'b10;  // 立即数
                        r_ALUOp = 2'b11;    // 修改这里！I-type立即数指令
                        r_NS = S_ADDI;      // 下一状态: addi完成
                    end
                    OP_ANDI: begin
                        r_ALUSrcB = 2'b10;  // 立即数（零扩展）
                        r_ALUOp = 2'b11;    // 修改这里！I-type立即数指令
                        r_NS = S_ADDI;      // 与addi类似
                    end
                    OP_ORI: begin
                        r_ALUSrcB = 2'b10;  // 立即数（零扩展）
                        r_ALUOp = 2'b11;    // 修改这里！I-type立即数指令
                        r_NS = S_ADDI;      // 与addi类似
                    end
                    OP_XORI: begin
                        r_ALUSrcB = 2'b10;  // 立即数（零扩展）
                        r_ALUOp = 2'b11;    // 修改这里！I-type立即数指令
                        r_NS = S_ADDI;      // 与addi类似
                    end
                    default: r_NS = S_IF;
                endcase
            end
            
            S_SHIFT: begin
                // 状态12: 移位指令处理
                // 关键修改：这里需要特殊处理ALUOp
                r_ALUSrcA = 1'b0;   // 特殊：可能需要传递shamt，这里设为0
                r_ALUSrcB = 2'b00;  // 寄存器B（rt值）
                r_ALUOp = 2'b10;    // R-type ALU操作（ALUCU会根据func生成移位控制）
                r_NS = S_ALU;       // 下一状态: ALU完成
            end
            
            S_MEM: begin
                // 状态3: 内存访问
                r_lorD = 1'b1;      // ALU输出作为内存地址
                
                case (opcode)
                    OP_LW: begin
                        r_MemRd = 1'b1;     // 读内存
                        r_NS = S_LW2;       // 下一状态: lw第二阶段
                    end
                    OP_SW: begin
                        r_MemWr = 1'b1;     // 写内存
                        r_NS = S_SW2;       // 下一状态: sw完成
                    end
                    default: r_NS = S_IF;
                endcase
            end
            
            S_WB: begin
                // 状态4: 写回（主要是lw）
                r_RegWr = 1'b1;     // 写寄存器
                r_MemtoReg = 1'b1;  // 内存数据作为写入数据
                r_RegDst = 1'b0;    // rt作为目标寄存器
                r_NS = S_IF;        // 下一状态: 取指令
            end
            
            S_J: begin
                // 状态5: 跳转指令
                if (opcode == OP_J) begin
                    r_PCsrc = 2'b10;    // 跳转地址（j指令）
                end else if (opcode == OP_RTYPE && func == FUNC_JR) begin
                    r_PCsrc = 2'b11;    // 寄存器地址（jr指令）
                end
                r_PCWr = 1'b1;      // 更新PC
                r_NS = S_IF;        // 下一状态: 取指令
            end
            
            S_BR: begin
                // 状态6: 分支指令
                r_ALUSrcA = 1'b1;   // 寄存器A作为ALU输入A
                r_ALUSrcB = 2'b00;  // 寄存器B作为ALU输入B
                r_ALUOp = 2'b01;    // 减法（比较）
                r_PCsrc = 2'b01;    // 分支目标地址
                r_PCWrcond = 1'b1;  // 条件更新PC
                r_NS = S_IF;        // 下一状态: 取指令
            end
            
            S_ALU: begin
                // 状态7: ALU操作完成（R-type）
                r_RegDst = 1'b1;    // rd为目标寄存器
                r_RegWr = 1'b1;     // 写寄存器
                r_MemtoReg = 1'b0;  // ALU输出作为写入数据
                r_NS = S_IF;        // 下一状态: 取指令
            end
            
            S_ADDI: begin
                // 状态11: addi/andi/ori/xori完成
                r_RegDst = 1'b0;    // rt为目标寄存器
                r_RegWr = 1'b1;     // 写寄存器
                r_MemtoReg = 1'b0;  // ALU输出作为写入数据
                r_NS = S_IF;        // 下一状态: 取指令
            end
            
            S_LW2: begin
                // 状态8: lw内存读取完成
                // 数据已从内存读出，进入写回
                r_NS = S_WB;        // 下一状态: 写回
            end
            
            S_SW2: begin
                // 状态9: sw完成
                r_NS = S_IF;        // 下一状态: 取指令
            end
            
            default: begin
                // 其他状态，默认回到取指令
                r_NS = S_IF;
            end
        endcase
    end
    
    // ==================== 输出赋值 ====================
    assign lorD = r_lorD;
    assign IRWr = r_IRWr;
    assign PCWr = r_PCWr;
    assign PCWrcond = r_PCWrcond;
    assign RegDst = r_RegDst;
    assign RegWr = r_RegWr;
    assign ALUSrcA = r_ALUSrcA;
    assign MemWr = r_MemWr;
    assign MemRd = r_MemRd;
    assign MemtoReg = r_MemtoReg;
    assign ALUOp = r_ALUOp;
    assign PCsrc = r_PCsrc;
    assign ALUSrcB = r_ALUSrcB;
    assign NS = r_NS;
    
endmodule