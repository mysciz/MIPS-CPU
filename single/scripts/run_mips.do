# ================================================
# 单周期MIPS CPU 仿真脚本
# 用法: vsim -do scripts/run_mips.do
# 注意：在项目根目录下运行
# ================================================

puts "=== 单周期MIPS CPU 功能验证测试 ==="

# 1. 清除工作区
quit -sim
.main clear

# 2. 创建输出目录
if {![file exists "./out"]} {
    file mkdir "./out"
}

# 3. 清理旧的库
if {[file exists "./out/work"]} {
    file delete -force "./out/work"
}

# 4. 创建库
vlib ./out/work
vmap work ./out/work

# 5. 编译设计文件
puts "编译MIPS设计文件..."

# 编译顺序按照依赖关系
vlog -work work ./src/PC.v
vlog -work work ./src/IM.v
vlog -work work ./src/RF.v
vlog -work work ./src/ALU.v
vlog -work work ./src/ALUCU.v
vlog -work work ./src/SigExt16_32.v
vlog -work work ./src/MUX.v
vlog -work work ./src/SHL2.v
vlog -work work ./src/DM.v
vlog -work work ./src/CU.v
vlog -work work ./src/DataPath.v
vlog -work work ./src/MIPS.v

# 6. 编译测试平台
puts "编译测试平台..."
vlog -work work -sv ./sim/mips_tb.sv

# 7. 开始仿真
puts "开始仿真..."
vsim -wlf ./out/mips_test.wlf -voptargs="+acc" work.mips_tb

# 8. 添加波形信号
add wave -divider "===== 时钟 & 复位 ====="
add wave -color yellow /mips_tb/clk
add wave -color red /mips_tb/rst
add wave -decimal -color cyan /mips_tb/cycle_count

add wave -divider "===== 程序计数器 & 指令 ====="
add wave -radix hex -color blue -label "PC" /mips_tb/pc
add wave -radix hex -color green -label "Inst" /mips_tb/inst
add wave -radix hex -color orange -label "ALU_Out" /mips_tb/alu_out
add wave -label "Zero_Flag" /mips_tb/zf

add wave -divider "===== 控制信号 ====="
add wave -label "RegDst" /mips_tb/RegDst
add wave -label "Jump" /mips_tb/Jump
add wave -label "Branch" /mips_tb/Branch
add wave -label "MemRead" /mips_tb/MemRead
add wave -label "MemtoReg" /mips_tb/MemtoReg
add wave -radix binary -label "ALUOp" /mips_tb/ALUOp
add wave -label "MemWrite" /mips_tb/MemWrite
add wave -label "ALUSrc" /mips_tb/ALUSrc
add wave -label "RegWrite" /mips_tb/RegWrite

add wave -divider "===== 内存访问 ====="
add wave -radix hex -label "Write_Data" /mips_tb/W_data
add wave -radix hex -label "Read_Data" /mips_tb/R_data

add wave -divider "===== 测试控制 ====="
add wave -decimal /mips_tb/cycle_count
add wave -decimal /mips_tb/test_result
add wave -decimal /mips_tb/success_flag
add wave -decimal /mips_tb/fail_flag

# 9. 开启VCD记录（可选）
vcd file ./out/mips_test.vcd
vcd add /mips_tb/*

# 10. 运行仿真
puts "开始功能验证仿真..."
puts "运行1500ns观察执行结果..."
run 1500ns

# 11. 结束VCD记录
vcd off

# 12. 保存波形配置
write wave ./out/mips_test.do

# 13. 获取测试结果并显示
set test_result [examine /mips_tb/test_result]
set success_flag_val [examine /mips_tb/success_flag]
set fail_flag_val [examine /mips_tb/fail_flag]
set cycle_count_val [examine /mips_tb/cycle_count]

puts "\n========================================"
puts "          测试结果分析"
puts "========================================"
puts "总执行周期数: $cycle_count_val"

# 修复：使用简单的if语句而不是复杂的expr
if {$success_flag_val == 1} {
    puts "成功跳转检测: ✓"
} else {
    puts "成功跳转检测: ✗"
}

if {$fail_flag_val == 1} {
    puts "失败跳转检测: ✗ (检测到失败)"
} else {
    puts "失败跳转检测: ✓ (未检测到失败)"
}

if {$test_result == 1} {
    puts "\n✅ 测试完全成功！"
    puts "CPU所有计算验证通过，进入成功循环"
    puts ""
    puts "验证的功能："
    puts "  ✓ 算术运算 (add, sub, and, or, xor)"
    puts "  ✓ I-type指令 (addi, andi, ori, xori)"
    puts "  ✓ 内存访问 (lw, sw)"
    puts "  ✓ 分支指令 (beq)"
    puts "  ✓ 跳转指令 (j)"
} elseif {$test_result == 2} {
    puts "\n❌ 测试失败！"
    puts "CPU计算验证失败，进入失败循环"
    puts ""
    puts "可能的问题："
    puts "  1. ALU计算结果错误"
    puts "  2. 立即数扩展错误"
    puts "  3. 寄存器文件读写错误"
    puts "  4. 控制信号生成错误"
} else {
    puts "\n⚠ 测试未完成或结果不确定"
    puts "程序未进入预期循环"
}

puts "\n========================================"
puts "关键指令监控："
puts "========================================"
puts "成功跳转指令: 0x0810002d (j success_loop)"
puts "失败跳转指令: 0x08100032 (j fail_loop)"
puts ""
puts "观察要点："
puts "1. 查看控制台输出的信息"
puts "2. 观察是否执行了0x0810002d指令"
puts "3. 查看PC是否在成功循环地址"
puts "4. 检查关键计算结果的alu_out值"
puts ""
puts "波形文件已保存："
puts "  ./out/mips_test.wlf  - ModelSim波形文件"
puts "  ./out/mips_test.do   - 波形配置文件"
puts "  ./out/mips_test.vcd  - VCD格式波形文件"
puts "========================================"

# 14. 自动缩放波形
wave zoom full

# 15. 保持窗口打开
puts "\n按任意键退出仿真..."
gets stdin
quit -sim