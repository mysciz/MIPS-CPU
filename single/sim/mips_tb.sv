`timescale 1ns/1ps

module mips_tb;
    // 时钟和复位
    reg clk;
    reg rst;
    
    // 单周期CPU信号
    wire [31:0] pc;
    wire zf;
    wire [31:0] alu_out;
    wire RegDst, Jump, Branch, MemRead, MemtoReg;
    wire [1:0] ALUOp;
    wire MemWrite, ALUSrc, RegWrite;
    wire [31:0] inst;
    wire [31:0] W_data;
    wire [31:0] R_data;
    
    // 测试控制
    integer cycle_count;
    integer test_result;  // 0=未完成, 1=成功, 2=失败
    integer success_flag;
    integer fail_flag;
    
    // 循环检测相关
    integer same_inst_count;
    reg [31:0] last_inst;
    
    // 跳转指令地址定义
    localparam SUCCESS_JUMP = 32'h0810002d;  // 成功循环跳转指令
    localparam FAIL_JUMP    = 32'h08100032;  // 失败循环跳转指令
    
    // 实例化单周期MIPS CPU
    MIPS u_mips(
        .clk(clk),
        .rst(rst),
        .pc(pc),
        .zf(zf),
        .alu_out(alu_out),
        .RegDst(RegDst),
        .Jump(Jump),
        .Branch(Branch),
        .MemRead(MemRead),
        .MemtoReg(MemtoReg),
        .ALUOp(ALUOp),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .inst(inst),
        .W_data(W_data),
        .R_data(R_data)
    );
    
    // 时钟生成：20ns周期，50%占空比
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end
    
    // 复位和测试控制
    initial begin
        // 初始化
        cycle_count = 0;
        test_result = 0;
        success_flag = 0;
        fail_flag = 0;
        same_inst_count = 0;
        last_inst = 32'h0;
        rst = 1;
        
        // 应用复位
        #20;
        rst = 0;
        
        $display("========================================");
        $display("单周期MIPS CPU 计算结果验证测试");
        $display("========================================");
        $display("测试逻辑：");
        $display("1. 执行算术运算并验证结果");
        $display("2. 所有验证通过 → j success_loop (0x%h)", SUCCESS_JUMP);
        $display("3. 任一验证失败 → j fail_loop    (0x%h)", FAIL_JUMP);
        $display("========================================");
        $display("监控关键指令：");
        $display("- 成功跳转指令: 0x%h", SUCCESS_JUMP);
        $display("- 失败跳转指令: 0x%h", FAIL_JUMP);
        $display("========================================");
        
        // 运行测试
        #1500;  // 1500ns，约75个时钟周期
        
        // 显示最终结果
        display_final_result();
        
        $finish;
    end
    
    // 时钟周期监控
    always @(posedge clk) begin
        if (!rst) begin
            cycle_count <= cycle_count + 1;
            
            // 每周期显示关键信息
            $display("[Cycle %0d] PC=0x%h, Inst=0x%h, ALU_Out=0x%h", 
                    cycle_count, pc, inst, alu_out);
            
            // 检测关键跳转指令
            if (inst == SUCCESS_JUMP) begin
                success_flag = 1;
                $display("     ✅ 执行成功跳转指令！跳转到success_loop");
                $display("     ↳ 目标地址: 0x%h", {pc[31:28], inst[25:0], 2'b00});
            end
            
            if (inst == FAIL_JUMP) begin
                fail_flag = 1;
                $display("     ❌ 执行失败跳转指令！跳转到fail_loop");
                $display("     ↳ 目标地址: 0x%h", {pc[31:28], inst[25:0], 2'b00});
            end
            
            // 解码指令类型（简化的输出）
            case (inst[31:26])
                6'b000000: begin // R-type
                    case (inst[5:0])
                        6'b100000: $display("     ↳ ADD");
                        6'b100010: $display("     ↳ SUB");
                        6'b100100: $display("     ↳ AND");
                        6'b100101: $display("     ↳ OR");
                        6'b100110: $display("     ↳ XOR");
                        default: $display("     ↳ R-type");
                    endcase
                end
                6'b001000: $display("     ↳ ADDI");
                6'b001100: $display("     ↳ ANDI");
                6'b001101: $display("     ↳ ORI");
                6'b001110: $display("     ↳ XORI");
                6'b100011: $display("     ↳ LW");
                6'b101011: $display("     ↳ SW");
                6'b000100: begin // BEQ
                    if (zf == 1'b1) 
                        $display("     ↳ BEQ: 条件成立，跳转");
                    else
                        $display("     ↳ BEQ: 条件不成立，顺序执行");
                end
                6'b000010: $display("     ↳ J");
            endcase
            
            // 检查内存写入（成功标记地址0xC）
            if (pc == 32'h0000003C && inst[31:26] == 6'b101011) begin // sw指令地址
                if (alu_out == 32'h0000000C) begin
                    $display("     ✓ 写入成功标记到地址0xC");
                end
            end
            
            // 安全停止：检测到循环
            if (inst == last_inst) begin
                same_inst_count <= same_inst_count + 1;
                if (same_inst_count == 5) begin
                    $display("     🔄 检测到循环，指令0x%h连续执行%0d次", inst, same_inst_count);
                end
                if (same_inst_count >= 10) begin
                    $display("     🔄 稳定循环中...");
                    test_result = (inst == SUCCESS_JUMP) ? 1 : 2;
                end
            end else begin
                same_inst_count <= 0;
            end
            last_inst <= inst;
            
            // 安全停止机制
            if (cycle_count > 100) begin
                $display("⚠ 超过100周期，停止仿真");
                $finish;
            end
        end
    end
    
    // 显示最终结果
    task display_final_result;
        begin
            $display("\n========================================");
            $display("最终测试结果");
            $display("========================================");
            $display("总执行周期数: %0d", cycle_count);
            $display("最后执行的指令: 0x%h", inst);
            $display("最后PC地址: 0x%h", pc);
            $display("最大连续相同指令: %0d 次", same_inst_count);
            
            if (test_result == 1) begin
                $display("\n🎉 测试完全成功！");
                $display("所有计算验证通过，CPU进入成功循环");
                $display("CPU功能验证：");
                $display("  ✅ 算术运算正确 (add, sub, and, or, xor)");
                $display("  ✅ I-type指令正确 (andi, ori, xori)");
                $display("  ✅ 内存访问正确 (lw, sw)");
                $display("  ✅ 分支指令正确 (beq)");
                $display("  ✅ 跳转指令正确 (j)");
            end else if (test_result == 2) begin
                $display("\n❌ 测试失败！");
                $display("某个计算验证失败，CPU进入失败循环");
                $display("请检查：");
                $display("  1. ALU计算是否正确");
                $display("  2. 立即数扩展是否正确");
                $display("  3. 寄存器文件读写是否正确");
                $display("  4. 控制信号生成是否正确");
            end else begin
                $display("\n⚠ 测试未完成");
                $display("程序未进入预期循环");
                $display("可能原因：");
                $display("  1. 分支跳转地址错误");
                $display("  2. 程序流程异常");
                $display("  3. 需要更多执行周期");
                $display("  4. 检查指令存储器内容");
            end
            $display("========================================");
        end
    endtask
    
endmodule