# MIPS CPU alu_out验证测试脚本
# 用法: vsim -do scripts/run_mips.do

puts "=== MIPS CPU alu_out验证测试 ==="

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
vsim -wlf ./out/mips_alu_test.wlf -voptargs="+acc" work.mips_tb

# 8. 添加波形信号
add wave -divider "===== 时钟 & 复位 ====="
add wave -color yellow /mips_tb/clk
add wave -color red /mips_tb/rst
add wave -decimal -color cyan /mips_tb/total_cycles
add wave -decimal -color magenta /mips_tb/instruction_count

add wave -divider "===== alu_out验证 ====="
add wave -radix hex -color blue -label "alu_out" /mips_tb/alu_out
add wave -radix hex -color orange -label "addr" /mips_tb/addr
add wave -radix hex -color green -label "inst" /mips_tb/inst
add wave -radix binary -color white -label "状态S" /mips_tb/S

add wave -divider "===== 控制状态 ====="
add wave -radix binary -label "下一状态NS" /mips_tb/NS

# 9. 运行仿真
puts "开始alu_out验证仿真..."
run 2000ns

# 10. 保存波形配置
write wave ./out/mips_alu_test.do

# 11. 显示测试说明
puts "\n========================================"
puts "alu_out验证测试说明"
puts "========================================"
puts "观察要点："
puts "1. alu_out信号的值变化"
puts "2. 状态机(S)的工作状态"
puts "3. 指令执行的顺序"
puts ""
puts "预期alu_out序列："
puts "1. PC+4计算: 0x4, 0x8, 0xC, 0x10..."
puts "2. nor指令: 0xFFFFFFFF"
puts "3. srl指令: 0x00000001"
puts "4. 算术运算: 1+1=0x2, 2+1=0x3, 3-1=0x2"
puts "5. 逻辑运算: 2&3=0x2, 2|3=0x3, 2^3=0x1"
puts "6. 移位运算: 1<<2=0x4, 0xFFFFFFFC>>2=0x3FFFFFFF"
puts "7. 比较运算: 1<2=0x1"
puts "8. 内存地址: 0x400, 0x404, 0x408, 0x40C"
puts ""
puts "状态机说明："
puts "S=0000: IF阶段 (取指令)"
puts "S=0001: ID阶段 (指令译码)"
puts "S=0010: EX阶段 (执行)"
puts "S=0011: MEM阶段 (内存访问)"
puts "S=0100: WB阶段 (写回)"
puts "S=0101: 跳转指令处理"
puts "S=0110: 分支指令处理"
puts "S=0111: R-type指令完成"
puts ""
puts "测试输出观察："
puts "1. 控制台会显示每个周期的alu_out值"
puts "2. 自动标注常见的alu_out值意义"
puts "3. 显示正在执行的指令类型"
puts ""
puts "波形文件已保存："
puts "  ./out/mips_alu_test.wlf"
puts "  ./out/mips_alu_test.do"
puts "  ./out/mips_test.vcd"
puts "========================================"

# 12. 自动缩放波形
wave zoom full

# 13. 保持窗口打开
puts "\n按任意键退出仿真..."
gets stdin
quit -sim