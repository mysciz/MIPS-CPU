# MIPS CPU 仿真脚本 - 保存 VCD 和 WLF 格式
# 用法: vsim -do scripts/run_mips.do
# 注意：在 single 目录下运行

puts "=== MIPS CPU Simulation - Saving VCD & WLF ==="

# 1. 清除工作区
quit -sim
.main clear

# 2. 创建输出目录（如果不存在）
if {![file exists "./out"]} {
    file mkdir "./out"
}

# 3. 创建库
vlib ./out/work
vmap work ./out/work

# 4. 编译设计文件
puts "编译设计文件..."
vlog ./src/ADD.v
vlog ./src/ALU.v
vlog ./src/ALUCU.v
vlog ./src/CU_logic.v
vlog ./src/CU.v
vlog ./src/DataPath.v
vlog ./src/DM.v
vlog ./src/IM.v
vlog ./src/MIPS.v
vlog ./src/MUX.v
vlog ./src/PC.v
vlog ./src/RF.v
vlog ./src/SHL2.v
vlog ./src/SigExt16_32.v

# 5. 编译测试平台
puts "编译测试平台..."
vlog ./sim/mips_tb.sv

# 6. 开始仿真，同时保存 WLF
vsim -wlf ./out/mips_wave.wlf work.mips_tb

# 7. 开启 VCD 记录
vcd file ./out/mips_wave.vcd
vcd add /mips_tb/*

# 8. 添加波形信号
add wave -divider "Clock & Reset"
add wave /mips_tb/clk
add wave /mips_tb/rst
add wave /mips_tb/cycle_count

add wave -divider "Program Counter"
add wave -radix hex -label "PC" /mips_tb/u_mips/pc
add wave -radix hex -label "Instruction" /mips_tb/u_mips/inst

add wave -divider "Control Unit Signals"
add wave -label "RegDst" /mips_tb/u_mips/RegDst
add wave -label "Jump" /mips_tb/u_mips/Jump
add wave -label "Branch" /mips_tb/u_mips/Branch
add wave -label "MemRead" /mips_tb/u_mips/MemRead
add wave -label "MemtoReg" /mips_tb/u_mips/MemtoReg
add wave -radix binary -label "ALUOp" /mips_tb/u_mips/ALUOp
add wave -label "MemWrite" /mips_tb/u_mips/MemWrite
add wave -label "ALUSrc" /mips_tb/u_mips/ALUSrc
add wave -label "RegWrite" /mips_tb/u_mips/RegWrite

add wave -divider "ALU"
add wave -radix hex -label "ALU_Out" /mips_tb/u_mips/alu_out
add wave -label "Zero_Flag" /mips_tb/u_mips/zf

add wave -divider "Register File"
add wave -radix hex -label "Write_Data" /mips_tb/u_mips/W_data

add wave -divider "Data Memory"
add wave -radix hex -label "Read_Data" /mips_tb/u_mips/R_data

add wave -divider "Test Results"
add wave -label "Pass_Count" /mips_tb/pass_count
add wave -label "Fail_Count" /mips_tb/fail_count

# 9. 运行仿真
puts "开始仿真..."
run 3000ns

# 10. 结束 VCD 记录
vcd flush
vcd off

# 11. 保存波形配置（ModelSim 格式）
write wave ./out/mips_wave.do

# 12. 显示结果
puts "\n========================================"
puts "MIPS CPU 仿真完成！"
puts "========================================"
puts "波形文件已保存到 ./out/ 目录:"
puts ""
puts "VS Code 查看:"
puts "  mips_wave.vcd       - VCD 格式 (可在 VS Code 中查看)"
puts ""
puts "ModelSim 查看:"
puts "  mips_wave.wlf       - WLF 格式 (ModelSim 原生格式)"
puts "  mips_wave.do        - 波形配置文件"
puts ""
puts "查看方法:"
puts "  VS Code: 安装 'WaveTrace' 或 'VCD Viewer' 扩展"
puts "  ModelSim: vsim -view ./out/mips_wave.wlf"
puts "             do ./out/mips_wave.do"
puts "========================================"

# 13. 自动缩放波形
wave zoom full

# 14. 保持窗口打开，等待用户操作
puts "\n按任意键退出..."
gets stdin
quit -sim