`timescale 1ns / 1ps

module mips_tb;
    // 时钟和复位
    reg clk;
    reg rst;
    
    // 测试信号
    integer cycle_count;
    integer pass_count;
    integer fail_count;
    
    // MIPS实例化
    wire [31:0] pc;
    wire zf;
    wire [31:0] alu_out;
    wire RegDst, Jump, Branch, MemRead, MemtoReg;
    wire [1:0] ALUOp;
    wire MemWrite, ALUSrc, RegWrite;
    wire [31:0] inst;
    wire [31:0] W_data;
    wire [31:0] R_data;
    
    // 实例化MIPS CPU
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
    
    // 时钟生成：50MHz
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // 20ns周期
    end
    
    // 测试主程序
    initial begin
        // 初始化
        cycle_count = 0;
        pass_count = 0;
        fail_count = 0;
        rst = 1;
        
        // 重置系统
        #20;
        rst = 0;
        
        $display("=====================================");
        $display("MIPS CPU 测试开始");
        $display("时间: %t", $time);
        $display("=====================================\n");
        
        // 等待一段时间执行
        #2000;
        
        // 检查测试结果
        check_results();
        
        // 输出摘要
        print_summary();
        
        // 结束仿真
        #100;
        $finish;
    end
    
    // 时钟周期计数
    always @(posedge clk) begin
        if (!rst) begin
            cycle_count <= cycle_count + 1;
            
            // 监控关键信号（前20个周期）
            if (cycle_count < 20) begin
                $display("[Cycle %0d] PC=0x%h, Inst=0x%h, ALU_Out=0x%h", 
                        cycle_count, pc, inst, alu_out);
            end
            
            // 每50周期显示一次进度
            if (cycle_count % 50 == 0 && cycle_count > 0) begin
                $display("[Cycle %0d] 执行中... PC=0x%h", cycle_count, pc);
            end
            
            // 安全停止：过多周期
            if (cycle_count > 500) begin
                $display("警告：超过500周期，停止仿真");
                $finish;
            end
        end
    end
    
    // 结果检查任务
    task check_results;
    begin
        $display("\n=====================================");
        $display("测试结果检查 - 时间: %t", $time);
        $display("=====================================");
        
        // 检查关键信号
        $display("当前 PC: 0x%h", pc);
        $display("当前指令: 0x%h", inst);
        $display("ALU 输出: 0x%h", alu_out);
        $display("Zero 标志: %b", zf);
        
        // 检查控制信号
        $display("控制信号: RegDst=%b, Jump=%b, Branch=%b", 
                RegDst, Jump, Branch);
        $display("          MemRead=%b, MemWrite=%b, ALUSrc=%b", 
                MemRead, MemWrite, ALUSrc);
        
        // 检查是否成功执行了程序
        // 这里可以根据你的测试程序逻辑添加检查点
        if (cycle_count > 20 && cycle_count < 200) begin
            $display("✓ 程序正常执行");
            pass_count = pass_count + 1;
        end else begin
            $display("⚠ 执行异常");
            fail_count = fail_count + 1;
        end
        
        $display("执行周期数: %0d", cycle_count);
    end
    endtask
    
    // 输出摘要
    task print_summary;
    begin
        $display("\n=====================================");
        $display("测试摘要 - 时间: %t", $time);
        $display("=====================================");
        $display("总周期数: %0d", cycle_count);
        $display("通过测试: %0d", pass_count);
        $display("失败测试: %0d", fail_count);
        
        if (fail_count == 0 && pass_count > 0) begin
            $display("\n✅ 测试通过！");
        end else begin
            $display("\n❌ 测试失败！");
        end
        
        $display("=====================================");
    end
    endtask
    
endmodule