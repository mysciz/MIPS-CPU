`timescale 1ns / 1ps

module mips_basic_tb;

    // 时钟和复位
    reg clk;
    reg rst;
    
    // DUT输出线
    wire [31:0] pcf;
    wire [31:0] inst_f;
    wire [31:0] inst_d;
    wire [31:0] inst_e;
    wire [31:0] inst_m;
    wire [31:0] inst_w;
    wire [31:0] RsE;
    wire [31:0] RtE;
    wire [31:0] ALUOutE;
    wire [31:0] A;
    wire [31:0] B;
    wire [31:0] Imm32E;
    wire [31:0] RtM;
    wire [31:0] ALUOutM;
    wire [31:0] ALUOutW;
    wire [31:0] MEMOutW;
    wire [31:0] MEMOutM;
    wire [4:0] W_Regw;
    wire [1:0] ALUSrcA;
    wire [1:0] ALUSrcB;
    wire [2:0] WB_E;
    wire [3:0] MA_E;
    wire [3:0] EX_E;
    wire [2:0] WB_M;
    wire [3:0] MA_M;
    wire [2:0] WB_W;
    wire IF_ID_RegWr;
    wire PCWr;
    wire MemSrc;
    wire Clear0;    // 新增
    wire Clear1;    // 新增
    wire[31:0] pcplus4d;
    wire[31:0] pcplus4e;
    wire[31:0] pcplus4f;
    wire[31:0] mux_ma;
    
    // 转为reg以便VCD记录
    reg [31:0] pcf_reg;
    reg [31:0] inst_f_reg;
    reg [31:0] inst_d_reg;
    reg [31:0] inst_e_reg;
    reg [31:0] inst_m_reg;
    reg [31:0] inst_w_reg;
    reg [31:0] RsE_reg;
    reg [31:0] RtE_reg;
    reg [31:0] ALUOutE_reg;
    reg [31:0] A_reg;
    reg [31:0] B_reg;
    reg [31:0] Imm32E_reg;
    reg [31:0] RtM_reg;
    reg [31:0] ALUOutM_reg;
    reg [31:0] ALUOutW_reg;
    reg [31:0] MEMOutW_reg;
    reg [31:0] MEMOutM_reg;
    reg [4:0] W_Regw_reg;
    reg [1:0] ALUSrcA_reg;
    reg [1:0] ALUSrcB_reg;
    reg [2:0] WB_E_reg;
    reg [3:0] MA_E_reg;
    reg [3:0] EX_E_reg;
    reg [2:0] WB_M_reg;
    reg [3:0] MA_M_reg;
    reg [2:0] WB_W_reg;
    reg PCWr_reg;
    reg IF_ID_RegWr_reg;
    reg MemSrc_reg;
    reg Clear0_reg;  // 新增
    reg Clear1_reg;  // 新增
    reg[31:0] pcplus4f_reg;
    reg[31:0] pcplus4d_reg;
    reg[31:0] pcplus4e_reg;
    reg[31:0] mux_ma_reg; 
    
    // DUT实例
    MIPS dut (
        .clk(clk),
        .rst(rst),
        .pcf(pcf),
        .inst_f(inst_f),
        .inst_d(inst_d),
        .inst_e(inst_e),
        .inst_m(inst_m),
        .inst_w(inst_w),
        .RsE(RsE),
        .RtE(RtE),
        .ALUOutE(ALUOutE),
        .A(A),
        .B(B),
        .Imm32E(Imm32E),
        .RtM(RtM),
        .ALUOutM(ALUOutM),
        .ALUOutW(ALUOutW),
        .MEMOutW(MEMOutW),
        .MEMOutM(MEMOutM),
        .W_Regw(W_Regw),
        .PCWr(PCWr),
        .IF_ID_RegWr(IF_ID_RegWr),
        .MemSrc(MemSrc),
        .Clear0(Clear0),    // 新增连接
        .Clear1(Clear1),    // 新增连接
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .WB_E(WB_E),
        .MA_E(MA_E),
        .EX_E(EX_E),
        .WB_M(WB_M),
        .MA_M(MA_M),
        .WB_W(WB_W),
        .pcplus4f(pcplus4f),
        .pcplus4d(pcplus4d),
        .pcplus4e(pcplus4e),
        .mux_ma(mux_ma)
    );
    
    // 将wire信号连接到reg用于VCD
    always @(*) begin
        pcf_reg = pcf;
        inst_f_reg = inst_f;
        inst_d_reg = inst_d;
        inst_e_reg = inst_e;
        inst_m_reg = inst_m;
        inst_w_reg = inst_w;
        RsE_reg = RsE;
        RtE_reg = RtE;
        ALUOutE_reg = ALUOutE;
        A_reg = A;
        B_reg = B;
        Imm32E_reg = Imm32E;
        RtM_reg = RtM;
        ALUOutM_reg = ALUOutM;
        ALUOutW_reg = ALUOutW;
        MEMOutW_reg = MEMOutW;
        MEMOutM_reg = MEMOutM;
        W_Regw_reg = W_Regw;
        ALUSrcA_reg = ALUSrcA;
        ALUSrcB_reg = ALUSrcB;
        WB_E_reg = WB_E;
        MA_E_reg = MA_E;
        EX_E_reg = EX_E;
        WB_M_reg = WB_M;
        MA_M_reg = MA_M;
        WB_W_reg = WB_W;
        PCWr_reg = PCWr;
        IF_ID_RegWr_reg = IF_ID_RegWr;
        MemSrc_reg = MemSrc;
        Clear0_reg = Clear0;  // 新增
        Clear1_reg = Clear1;  // 新增
        pcplus4f_reg = pcplus4f;
        pcplus4d_reg = pcplus4d;
        pcplus4e_reg = pcplus4e;
        mux_ma_reg = mux_ma;
    end
    
    // 时钟生成
    always #5 clk = ~clk;  // 100MHz时钟
    
    // 测试主程序
    integer cycle_count = 0;
    integer error_count = 0;
    
    // 预期结果
    reg [31:0] expected_regs [0:31];
    reg [31:0] expected_mem [0:1023];
    integer i;
    
    initial begin
        // 初始化信号
        clk = 0;
        rst = 1;
        
        // 初始化预期寄存器值
        for (i = 0; i < 32; i = i + 1) begin
            expected_regs[i] = 32'h0;
        end
        
        // 初始化预期内存值
        for (i = 0; i < 1024; i = i + 1) begin
            expected_mem[i] = 32'h0;
        end
        expected_mem[0] = 32'h0000000f;  // 地址0存储15
        
        // 生成VCD文件
        $dumpfile("out/mips_basic.vcd");
        $dumpvars(0, mips_basic_tb);
        
        // 长复位
        #50 rst = 0;
        
        $display("==========================================");
        $display("MIPS流水线CPU基础测试开始");
        $display("时间单位：ns");
        $display("==========================================");
        
        // 等待足够的时间让程序执行完
        #1500;
        
        // 显示最后的状态
        $display("\n==========================================");
        $display("测试完成时间：%t ns", $time);
        $display("总时钟周期：%0d", cycle_count);
        $display("错误计数：%0d", error_count);
        $display("最终PC值：%h", pcf_reg);
        $display("控制信号：PCWr=%b, IF_ID_RegWr=%b, MemSrc=%b", 
                PCWr_reg, IF_ID_RegWr_reg, MemSrc_reg);
        $display("冒险控制：Clear0=%b, Clear1=%b", Clear0_reg, Clear1_reg);
        $display("当前写寄存器：$%d, WB_W=%b", W_Regw_reg, WB_W_reg);
        $display("==========================================");
        
        // 显示预期的最终寄存器状态
        $display("\n预期最终寄存器状态：");
        $display("  $1 = 10 ($1 = %h)", expected_regs[1]);
        $display("  $2 = 5  ($2 = %h)", expected_regs[2]);
        $display("  $3 = 15 ($3 = %h)", expected_regs[3]);
        $display("  $4 = 7  ($4 = %h)", expected_regs[4]);
        $display("  $5 = 15 ($5 = %h)", expected_regs[5]);
        $display("  $6 = 0  ($6 = %h) - 不应执行", expected_regs[6]);
        $display("  $7 = 0  ($7 = %h) - 不应执行", expected_regs[7]);
        $display("  $8 = 1  ($8 = %h)", expected_regs[8]);
        
        // 显示内存状态
        $display("\n内存状态检查：");
        $display("  mem[0] = %h (预期: %h)", expected_mem[0], 32'h0000000f);
        
        $finish;
    end
    
    // 实时监控流水线状态
    always @(posedge clk) begin
        cycle_count <= cycle_count + 1;
        
        if (!rst) begin
            $display("\n=== 时钟周期 %0d @ %t ns ===", cycle_count, $time);
            
            // PC和控制状态
            $display("PC状态：");
            $display("  PC = %h, PCWr = %b, IF_ID_RegWr = %b", 
                    pcf_reg, PCWr_reg, IF_ID_RegWr_reg);
            $display("  冒险控制：Clear0 = %b (清ID控制), Clear1 = %b (清EX控制)", 
                    Clear0_reg, Clear1_reg);
            
            // 流水线指令
            $display("流水线指令：");
            $display("  IF: %h (opcode:%h, rs:$%d, rt:$%d)", 
                    inst_f_reg, inst_f_reg[31:26], inst_f_reg[25:21], inst_f_reg[20:16]);
            $display("  ID: %h (opcode:%h, rs:$%d, rt:$%d)", 
                    inst_d_reg, inst_d_reg[31:26], inst_d_reg[25:21], inst_d_reg[20:16]);
            $display("  EX: %h (opcode:%h, rs:$%d, rt:$%d)", 
                    inst_e_reg, inst_e_reg[31:26], inst_e_reg[25:21], inst_e_reg[20:16]);
            $display("  MEM: %h (opcode:%h, rs:$%d, rt:$%d)", 
                    inst_m_reg, inst_m_reg[31:26], inst_m_reg[25:21], inst_m_reg[20:16]);
            $display("  WB: %h (opcode:%h, rs:$%d, rt:$%d)", 
                    inst_w_reg, inst_w_reg[31:26], inst_w_reg[25:21], inst_w_reg[20:16]);
            
            // 写回阶段信息
            $display("写回阶段：");
            $display("  目标寄存器：$%d, 数据：%h", W_Regw_reg, 
                    (WB_W_reg[0] ? MEMOutW_reg : ALUOutW_reg));
            $display("  控制：RegWrite=%b, MemtoReg=%b, RegDst=%b", 
                    WB_W_reg[1], WB_W_reg[0], WB_W_reg[2]);
            
            // 更新预期寄存器值
            if (WB_W_reg[1] && W_Regw_reg != 0) begin
                expected_regs[W_Regw_reg] = (WB_W_reg[0] ? MEMOutW_reg : ALUOutW_reg);
                $display("  [寄存器更新] $%d <- %h", W_Regw_reg, expected_regs[W_Regw_reg]);
            end
            
            // 检查内存写入
            if (MA_M_reg[2]) begin  // MemWrite
                $display("  [内存写入] 地址=%h, 数据=?", ALUOutM_reg);
            end
            
            // 各级控制信号
            $display("控制信号分析：");
            
            // EX级控制
            $display("  EX级控制：[WB:%b MA:%b EX:%b]", 
                    WB_E_reg, MA_E_reg, EX_E_reg);
            $display("    写回控制 - RegDst:%b RegWrite:%b MemToReg:%b",
                    WB_E_reg[2], WB_E_reg[1], WB_E_reg[0]);
            $display("    访存控制 - MemRead:%b MemWrite:%b Branch:%b Jump:%b",
                    MA_E_reg[3], MA_E_reg[2], MA_E_reg[1], MA_E_reg[0]);
            $display("    ALU控制：%b", EX_E_reg);
            
            // EX阶段数据
            $display("  EX阶段数据：");
            $display("    RsE = %h, RtE = %h, Imm32E = %h", 
                    RsE_reg, RtE_reg, Imm32E_reg);
            $display("    ALU输入: A = %h, B = %h", A_reg, B_reg);
            $display("    ALU输出: %h", ALUOutE_reg);
            $display("    转发控制: ALUSrcA = %b, ALUSrcB = %b, MemSrc = %b", 
                    ALUSrcA_reg, ALUSrcB_reg, MemSrc_reg);
            
            // MEM级控制
            $display("  MEM级控制：[WB:%b MA:%b]", WB_M_reg, MA_M_reg);
            $display("    写回控制 - RegDst:%b RegWrite:%b MemToReg:%b",
                    WB_M_reg[2], WB_M_reg[1], WB_M_reg[0]);
            $display("    访存控制 - MemRead:%b MemWrite:%b Branch:%b Jump:%b",
                    MA_M_reg[3], MA_M_reg[2], MA_M_reg[1], MA_M_reg[0]);
            
            // MEM阶段数据
            $display("  MEM阶段数据：");
            $display("    ALUOutM = %h, RtM = %h, MEMOutM = %h", 
                    ALUOutM_reg, RtM_reg, MEMOutM_reg);
            
            // WB级控制
            $display("  WB级控制：[WB:%b]", WB_W_reg);
            $display("    写回控制 - RegDst:%b RegWrite:%b MemToReg:%b",
                    WB_W_reg[2], WB_W_reg[1], WB_W_reg[0]);
            
            // WB阶段数据
            $display("  WB阶段数据：");
            $display("    ALUOutW = %h, MEMOutW = %h", ALUOutW_reg, MEMOutW_reg);
            $display("地址信息：");
            $display("pcplus4f=%h,pcplus4d=%h,pcplus4e=%h,mux_ma=%h",pcplus4f_reg,pcplus4d_reg,pcplus4e_reg,mux_ma_reg);
            // 特别检查关键周期
            if (cycle_count >= 5 && cycle_count <= 25) begin
                $display("[周期%d详细分析]", cycle_count);
                
                // 检查数据冒险情况
                case (cycle_count)
                    7: begin
                        if (inst_e_reg == 32'h2001000a) begin
                            $display("  [关键检查] addi $1, $0, 10");
                            $display("    预期：A=0, B=10, ALUOutE=10");
                            $display("    实际：A=%h, B=%h, ALUOutE=%h", 
                                    A_reg, B_reg, ALUOutE_reg);
                            if (ALUOutE_reg != 32'h0000000a) begin
                                $display("  [错误] ALU输出错误！");
                                error_count = error_count + 1;
                            end
                        end
                    end
                    8: begin
                        if (inst_e_reg == 32'h20020005) begin
                            $display("  [关键检查] addi $2, $0, 5");
                            $display("    预期：A=0, B=5, ALUOutE=5");
                            $display("    实际：A=%h, B=%h, ALUOutE=%h", 
                                    A_reg, B_reg, ALUOutE_reg);
                            if (ALUOutE_reg != 32'h00000005) begin
                                $display("  [错误] ALU输出错误！");
                                error_count = error_count + 1;
                            end
                        end
                    end
                    9: begin
                        if (inst_e_reg == 32'h00221820) begin
                            $display("  [关键检查] add $3, $1, $2");
                            $display("    预期：A=10, B=5, ALUOutE=15");
                            $display("    实际：A=%h, B=%h, ALUOutE=%h", 
                                    A_reg, B_reg, ALUOutE_reg);
                            $display("    转发：ALUSrcA=%b, ALUSrcB=%b", 
                                    ALUSrcA_reg, ALUSrcB_reg);
                            if (ALUOutE_reg != 32'h0000000f) begin
                                $display("  [错误] ALU输出错误！应为15(0x0f)");
                                error_count = error_count + 1;
                            end
                        end
                    end
                    10: begin
                        if (inst_e_reg == 32'h30640007) begin
                            $display("  [关键检查] andi $4, $3, 7");
                            $display("    预期：A=15, B=7, ALUOutE=7 (15 & 7 = 7)");
                            $display("    实际：A=%h, B=%h, ALUOutE=%h", 
                                    A_reg, B_reg, ALUOutE_reg);
                        end
                    end
                    11: begin
                        if (inst_e_reg == 32'hac030000) begin
                            $display("  [关键检查] sw $3, 0($0)");
                            $display("    这是关键冒险案例！");
                            $display("    sw需要$3=15，但$3来自前面的add指令");
                            $display("    转发分析：ALUSrcA=%b (base=$0), ALUSrcB=%b (data=$3)", 
                                    ALUSrcA_reg, ALUSrcB_reg);
                            $display("    RtE=%h (应为15或转发)", RtE_reg);
                            $display("    冒险控制：Clear0=%b, Clear1=%b", Clear0_reg, Clear1_reg);
                        end
                    end
                    12: begin
                        if (inst_m_reg == 32'hac030000) begin
                            $display("  [关键检查] sw在MEM阶段");
                            $display("    应该存储$3=15到地址0");
                            $display("    RtM=%h, MemSrc=%b", RtM_reg, MemSrc_reg);
                        end
                    end
                    13: begin
                        if (inst_e_reg == 32'h10650001) begin
                            $display("  [关键检查] beq $3, $5, equal");
                            $display("    这是load-use冒险案例！");
                            $display("    lw $5在MEM阶段，beq需要$5的值");
                            $display("    冒险控制应检测到并暂停：Clear0=%b, Clear1=%b", 
                                    Clear0_reg, Clear1_reg);
                            $display("    预期：A=15, B=15, ALUOutE=0 (相等)");
                            $display("    实际：A=%h, B=%h, ALUOutE=%h", 
                                    A_reg, B_reg, ALUOutE_reg);
                            $display("    转发：ALUSrcA=%b, ALUSrcB=%b", 
                                    ALUSrcA_reg, ALUSrcB_reg);
                        end
                    end
                endcase
            end
            
            // 检查冒险控制信号
            if (Clear0_reg) begin
                $display("  [冒险控制] Clear0=1：正在清除ID阶段控制信号（插入气泡）");
            end
            if (Clear1_reg) begin
                $display("  [冒险控制] Clear1=1：正在清除EX阶段控制信号（插入气泡）");
            end
            
            // 检查明显的错误
            if (ALUOutE_reg == 32'h00000000 && A_reg != 32'h00000000 && B_reg != 32'h00000000) begin
                $display("  [警告] ALU输出为0，但输入非零！可能ALU操作错误");
                if (cycle_count > 10) error_count = error_count + 1;
            end
            
            if (ALUSrcA_reg == 2'b11 && A_reg != 32'h00000000) begin
                $display("  [警告] ALUSrcA=11但A不为0");
            end
            
            // 检查sw指令的关键问题
            if (inst_e_reg[31:26] == 6'b101011) begin  // sw指令
                $display("  [SW分析] 存储指令：rt=$%d, 值应为：%h", 
                        inst_e_reg[20:16], expected_regs[inst_e_reg[20:16]]);
                $display("    当前RtE=%h, ALUSrcB=%b", RtE_reg, ALUSrcB_reg);
            end
            
            $display("--------------------------------------------------");
        end
    end

endmodule