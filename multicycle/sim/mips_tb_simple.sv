`timescale 1ns / 1ps

module mips_tb;
    // 时钟和复位
    reg clk;
    reg rst;
    
    // MIPS输出信号
    wire [31:0] inst;
    wire [31:0] addr;
    wire [31:0] alu_out;
    wire [3:0] NS;
    wire [3:0] S;
    
    // 周期计数器
    integer total_cycles;
    integer instruction_count;
    integer max_cycles;
    
    // 实例化MIPS
    MIPS u_mips(
        .clk(clk),
        .rst(rst),
        .inst(inst),
        .addr(addr),
        .alu_out(alu_out),
        .NS(NS),
        .S(S)
    );
    
    // 时钟生成：100MHz (10ns周期)
    always #5 clk = ~clk;
    
    // 初始化
    initial begin
        // 初始化信号
        clk = 0;
        rst = 1;
        total_cycles = 0;
        instruction_count = 0;
        max_cycles = 500;
        
        // 创建波形文件
        $dumpfile("out/mips_test.vcd");
        $dumpvars(0, mips_tb);
        
        // 生成复位
        #20;
        rst = 0;
        
        $display("\n========================================");
        $display("MIPS CPU alu_out验证测试");
        $display("时间: %t", $time);
        $display("测试程序: 综合测试程序");
        $display("将监控alu_out输出");
        $display("========================================");
        
        // 主仿真循环
        while (total_cycles < max_cycles) begin
            @(posedge clk);
            total_cycles = total_cycles + 1;
            
            // 在每个时钟边沿显示alu_out
            $display("[CYCLE %0d] alu_out=0x%h, addr=0x%h, inst=0x%h, S=%b", 
                     total_cycles, alu_out, addr, inst, S);
            
            // 指令计数（IF阶段）
            if (S == 4'b0000) begin
                instruction_count = instruction_count + 1;
            end
            
            // 监控特定的alu_out值
            case (alu_out)
                32'h00000004: $display("  -> PC+4计算");
                32'h00000001: $display("  -> 生成常数1");
                32'h00000002: $display("  -> 生成常数2"); 
                32'h00000003: $display("  -> 生成常数3");
                32'hffffffff: $display("  -> 0xFFFFFFFF (nor结果)");
                32'hfffffffc: $display("  -> 0xFFFFFFFC (nor结果)");
                32'h3fffffff: $display("  -> 0x3FFFFFFF (srl结果)");
                default: begin
                    // 检查是否是内存地址
                    if (alu_out >= 32'h400 && alu_out <= 32'h4ff) begin
                        $display("  -> 内存地址计算: 0x%h", alu_out);
                    end
                end
            endcase
            
            // 检测程序结束
            if (inst == 32'h08000024 || inst == 32'h08000025) begin
                $display("\n程序正常结束，进入无限循环");
                #100;
                break;
            end
            
            // 显示关键指令的执行
            if (S == 4'b0010) begin // EX阶段
                case (inst[31:26])
                    6'h00: begin // R-type
                        case (inst[5:0])
                            6'h20: $display("  [EX] add指令");
                            6'h22: $display("  [EX] sub指令");
                            6'h24: $display("  [EX] and指令");
                            6'h25: $display("  [EX] or指令");
                            6'h26: $display("  [EX] xor指令");
                            6'h27: $display("  [EX] nor指令");
                            6'h00: $display("  [EX] sll指令");
                            6'h02: $display("  [EX] srl指令");
                            6'h2a: $display("  [EX] slt指令");
                            6'h2b: $display("  [EX] sltu指令");
                        endcase
                    end
                    6'h2b: $display("  [EX] sw指令");
                    6'h23: $display("  [EX] lw指令");
                    6'h04: $display("  [EX] beq指令");
                    6'h02: $display("  [EX] j指令");
                endcase
            end
            
            // 安全停止
            if (total_cycles >= max_cycles - 10) begin
                $display("[WARNING] 接近最大仿真周期");
            end
        end
        
        // 结果汇总
        $display("\n========================================");
        $display("alu_out验证测试完成");
        $display("总仿真周期: %d", total_cycles);
        $display("总执行指令: %d", instruction_count);
        if (instruction_count > 0) begin
            $display("平均CPI: %.2f", $itor(total_cycles) / $itor(instruction_count));
        end
        $display("========================================");
        
        #100;
        $finish;
    end
    
endmodule