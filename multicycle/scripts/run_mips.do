# ================================================
# MIPS CPU 指令流监控测试
# ================================================
# 用法: vsim -do scripts/run_mips.do

puts "=== MIPS CPU 指令流监控测试 ==="

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
vlog -work work ./src/ALU.v
vlog -work work ./src/RF.v
vlog -work work ./src/SigExt16_32.v
vlog -work work ./src/ALUCU.v
vlog -work work ./src/MUX_2.v
vlog -work work ./src/SHL2.v
vlog -work work ./src/MUX_4.v
vlog -work work ./src/Reg32.v
vlog -work work ./src/IR.v
vlog -work work ./src/DataPath.v
vlog -work work ./src/CU.v
vlog -work work ./src/MEM.v
vlog -work work ./src/SR.v
vlog -work work ./src/MIPS.v

# 6. 编译测试平台
puts "编译测试平台..."
vlog -work work -sv ./sim/mips_tb.sv

# 7. 开始仿真
puts "开始仿真..."
vsim -wlf ./out/mips_test.wlf -voptargs="+acc" work.mips_tb

# 8. 添加关键波形信号
add wave -divider "===== 时钟 & 复位 ====="
add wave -color yellow /mips_tb/clk
add wave -color red /mips_tb/rst

add wave -divider "===== 指令流 ====="
add wave -radix hex -color green -label "Inst" /mips_tb/inst
add wave -radix hex -color orange -label "PC (addr)" /mips_tb/addr
add wave -radix hex -label "Last_Inst" /mips_tb/last_inst
add wave -radix hex -label "期望指令(08100017)" /mips_tb/expected_jump_inst

add wave -divider "===== ALU ====="
add wave -radix hex -color blue -label "ALU_Out" /mips_tb/alu_out

add wave -divider "===== 控制状态 ====="
add wave -radix binary -color white -label "状态S" /mips_tb/S
add wave -radix binary -label "下一状态NS" /mips_tb/NS

add wave -divider "===== 监控信息 ====="
add wave -decimal -color cyan -label "周期数" /mips_tb/total_cycles
add wave -decimal -label "相同指令计数" /mips_tb/same_inst_count
add wave -decimal -label "指令计数" /mips_tb/inst_count

# 9. 运行仿真
puts "开始指令流监控..."
puts "期望循环指令: 0x08100017 (j指令)"
puts "对应跳转地址: 0x0040005C"
puts "运行2000ns..."
run 2000ns

# 10. 保存波形配置
write wave ./out/mips_test.do

# 11. 显示测试说明
puts "\n========================================"
puts "测试说明"
puts "========================================"
puts "监控目标：验证是否执行 inst = 0x08100017"
puts ""
puts "关键观察点："
puts "1. 控制台输出最后行"
puts "2. Inst是否稳定为0x08100017"
puts "3. 相同指令计数(same_inst_count)是否持续增加"
puts "4. PC是否在固定地址间跳转"
puts ""
puts "期望的执行流程："
puts "1. 执行beq分支跳转到success标签"
puts "2. 执行sw写入成功标记(地址0xC)"
puts "3. 执行j指令跳转到end_loop"
puts "4. 在end_loop中无限循环执行j指令"
puts ""
puts "如果未看到0x08100017："
puts "1. 程序可能未执行到end_loop"
puts "2. beq分支可能未正确跳转"
puts "3. j指令地址计算可能错误"
puts ""
puts "波形查看建议："
puts "1. 展开指令流相关信号"
puts "2. 观察Inst和PC的变化关系"
puts "3. 注意状态机S的工作状态"

puts "\n波形文件已保存："
puts "  ./out/mips_test.wlf"
puts "  ./out/mips_test.do"
puts "========================================"

# 12. 自动缩放波形
wave zoom full

# 13. 保持窗口打开
puts "\n按任意键退出仿真..."
gets stdin
quit -sim