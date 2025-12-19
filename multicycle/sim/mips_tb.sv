`timescale 1ns/1ps

module mips_tb;
    // 时钟和复位
    reg clk;
    reg rst;
    
    // CPU输出信号
    wire [31:0] inst;
    wire [31:0] addr;
    wire [31:0] alu_out;
    wire [3:0] NS;
    wire [3:0] S;
    
    // 测试控制
    integer total_cycles;
    integer inst_count;
    reg [31:0] last_inst;
    integer same_inst_count;
    reg [31:0] expected_jump_inst;
    
    // 实例化MIPS CPU
    MIPS u_mips (
        .clk(clk),
        .rst(rst),
        .inst(inst),
        .addr(addr),
        .alu_out(alu_out),
        .NS(NS),
        .S(S)
    );
    
    // 时钟生成：10ns周期，50%占空比
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // 复位和测试控制
    initial begin
        // 初始化
        rst = 1;
        total_cycles = 0;
        inst_count = 0;
        last_inst = 32'h0;
        same_inst_count = 0;
        expected_jump_inst = 32'h08100017;  // 修正：期望的跳转指令是08100017
        
        // 应用复位
        #20 rst = 0;
        
        $display("========================================");
        $display("MIPS CPU 指令流监控");
        $display("========================================");
        $display("期望的结束循环指令: 0x%h (j指令)", expected_jump_inst);
        $display("对应跳转地址: 0x0040005C");
        $display("格式: [Cycle] PC=0x, Inst=0x, ALU_Out=0x");
        $display("========================================");
        
        // 运行测试
        #2000;  // 2000ns测试时间
        
        // 显示最终分析
        display_final_analysis();
        
        $stop;
    end
    
    // 主监控逻辑 - 每周期显示PC、Inst、ALU_Out
    always @(posedge clk) begin
        reg [31:0] imm_value;
        reg [31:0] jump_target;
        
        if (!rst) begin
            total_cycles <= total_cycles + 1;
            
            // 只显示有效的inst（不是高阻态）
            if (inst !== 32'hzzzzzzzz) begin
                inst_count <= inst_count + 1;
                
                // 格式化输出：3列对齐
                $display("[Cycle %0d] PC=0x%h, Inst=0x%h, ALU_Out=0x%h", 
                        total_cycles, addr, inst, alu_out);
                
                // 记录上一个指令
                last_inst <= inst;
                
                // 检查是否连续执行相同指令
                if (inst == last_inst) begin
                    same_inst_count <= same_inst_count + 1;
                    // 当检测到循环时标注
                    if (same_inst_count == 3 || same_inst_count == 10 || same_inst_count == 20) begin
                        $display("      ↳ 循环中：指令 0x%h 连续执行%0d次", inst, same_inst_count);
                    end
                end else begin
                    same_inst_count <= 0;
                end
                
                // 如果是跳转指令，特别标注
                if (inst[31:26] == 6'b000010) begin  // j指令opcode
                    // 计算跳转目标地址
                    jump_target = {addr[31:28], inst[25:0], 2'b00};
                    $display("      ↳ J指令：目标地址 = 0x%h", jump_target);
                    
                    // 检查是否为目标跳转指令
                    if (inst == expected_jump_inst) begin
                        $display("      ↳ ✓ 成功循环指令！跳转到0x0040005C");
                    end
                end
                
                // 检查分支指令
                if (inst[31:26] == 6'b000100) begin  // beq指令opcode
                    $display("      ↳ BEQ指令：比较 $%0d 和 $%0d", 
                            inst[25:21], inst[20:16]);
                end
                
                // 检查R-type指令
                if (inst[31:26] == 6'b000000) begin  // R-type opcode
                    case (inst[5:0])
                        6'b100000: $display("      ↳ ADD指令");
                        6'b100010: $display("      ↳ SUB指令");
                        6'b100100: $display("      ↳ AND指令");
                        6'b100101: $display("      ↳ OR指令");
                        6'b100110: $display("      ↳ XOR指令");
                        6'b100111: $display("      ↳ NOR指令");
                        6'b101010: $display("      ↳ SLT指令");
                        default: $display("      ↳ R-type指令，func=0x%h", inst[5:0]);
                    endcase
                end
                
                // 检查I-type指令
                if (inst[31:26] == 6'b001000) begin  // addi
                    // 提取立即数字段
                    imm_value = {{16{inst[15]}}, inst[15:0]};
                    $display("      ↳ ADDI指令：$%0d = $%0d + 0x%h", 
                            inst[20:16], inst[25:21], imm_value);
                end
                if (inst[31:26] == 6'b001100) begin  // andi
                    $display("      ↳ ANDI指令");
                end
                if (inst[31:26] == 6'b001101) begin  // ori
                    $display("      ↳ ORI指令");
                end
                if (inst[31:26] == 6'b001110) begin  // xori
                    $display("      ↳ XORI指令");
                end
                if (inst[31:26] == 6'b100011) begin  // lw
                    imm_value = {{16{inst[15]}}, inst[15:0]};
                    $display("      ↳ LW指令：$%0d = mem[$%0d + 0x%h]", 
                            inst[20:16], inst[25:21], imm_value);
                end
                if (inst[31:26] == 6'b101011) begin  // sw
                    imm_value = {{16{inst[15]}}, inst[15:0]};
                    $display("      ↳ SW指令：mem[$%0d + 0x%h] = $%0d", 
                            inst[25:21], imm_value, inst[20:16]);
                end
            end
        end
    end
    
    // 每50个周期显示一次状态摘要
    always @(posedge clk) begin
        if (!rst && total_cycles > 0 && total_cycles % 50 == 0) begin
            $display("--- 状态报告 [周期 %0d] ---", total_cycles);
            $display("当前状态 S = %b", S);
            $display("指令执行数 = %0d", inst_count);
            $display("最后指令 = 0x%h", last_inst);
            $display("连续相同指令 = %0d 次", same_inst_count);
            if (same_inst_count > 0) begin
                $display("正在执行的指令: 0x%h", last_inst);
                if (last_inst[31:26] == 6'b000010) begin
                    $display("指令类型: J (跳转到 0x%h)", {last_inst[25:0], 2'b00});
                end
            end
            $display("------------------------");
        end
    end
    
    // 安全停止
    initial begin
        #4000;  // 4000ns后强制停止
        $display("\n⚠ 安全停止：仿真时间到");
        display_final_analysis();
        $stop;
    end
    
    // 显示最终分析
    task display_final_analysis;
        begin
            $display("\n========================================");
            $display("最终分析");
            $display("========================================");
            $display("总时钟周期数: %0d", total_cycles);
            $display("有效指令数: %0d", inst_count);
            $display("最后执行的指令: 0x%h", last_inst);
            
            // 解码最后指令
            $display("\n最后指令解码:");
            $display("  Opcode: %b (0x%h)", last_inst[31:26], last_inst[31:26]);
            
            if (last_inst[31:26] == 6'b000010) begin  // j指令
                $display("  指令类型: J (无条件跳转)");
                $display("  目标地址字段: 0x%h", last_inst[25:0]);
                $display("  完整跳转地址: 0x%h", {addr[31:28], last_inst[25:0], 2'b00});
                
                if (last_inst == expected_jump_inst) begin
                    $display("  ✓ 与期望的循环指令一致");
                end else begin
                    $display("  ⚠ 与期望的循环指令不一致");
                    $display("     期望: 0x%h", expected_jump_inst);
                    $display("     实际: 0x%h", last_inst);
                end
            end else if (last_inst[31:26] == 6'b000000) begin  // R-type
                $display("  指令类型: R-type");
                $display("  Func: %b (0x%h)", last_inst[5:0], last_inst[5:0]);
            end else if (last_inst[31:26] == 6'b000100) begin  // beq
                $display("  指令类型: BEQ (分支)");
            end else if (last_inst == 32'h0) begin
                $display("  指令类型: NOP");
            end else begin
                $display("  指令类型: I-type 或其他");
            end
            
            // 检查是否进入循环
            $display("\n循环检测:");
            if (same_inst_count > 20) begin
                $display("✅ 检测到稳定循环");
                $display("   指令 0x%h 连续执行 %0d 次", last_inst, same_inst_count);
            end else if (same_inst_count > 5) begin
                $display("⚠ 检测到初步循环");
                $display("   指令 0x%h 连续执行 %0d 次", last_inst, same_inst_count);
            end else begin
                $display("❌ 未检测到稳定循环");
                $display("   相同指令连续执行: %0d 次", same_inst_count);
            end
            
            // 检查是否执行了期望的循环
            if (last_inst == expected_jump_inst && same_inst_count > 10) begin
                $display("\n🎉 测试成功！");
                $display("CPU正确执行了成功循环 (0x%h)", expected_jump_inst);
            end else if (last_inst[31:26] == 6'b000010 && same_inst_count > 5) begin
                $display("\n⚠ 执行了跳转循环，但不是期望的指令");
                $display("  实际循环指令: 0x%h", last_inst);
                $display("  期望循环指令: 0x%h", expected_jump_inst);
            end else if (same_inst_count == 0) begin
                $display("\n❌ 程序可能还在执行不同指令");
                $display("   未进入循环状态");
            end
            
            $display("\n调试建议:");
            if (same_inst_count == 0) begin
                $display("  1. 检查程序是否执行到end_loop标签");
                $display("  2. 检查beq分支是否正确跳转");
                $display("  3. 检查sw指令是否写入成功标记");
            end
            if (last_inst != expected_jump_inst && last_inst[31:26] == 6'b000010) begin
                $display("  1. 检查j指令的目标地址");
                $display("  2. 确认end_loop标签的实际地址");
            end
            $display("  查看波形确认完整执行流程");
            $display("========================================");
        end
    endtask
    
endmodule