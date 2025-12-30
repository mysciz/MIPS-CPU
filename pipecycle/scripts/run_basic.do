# ====================================================
# MIPS流水线CPU测试脚本
# ====================================================

puts "=== MIPS Pipeline CPU Simulation ==="

# 1. 清除工作区
quit -sim
.main clear

# 2. 创建输出目录
if {![file exists "./out"]} {
    file mkdir "./out"
}

# 3. 创建库
vlib ./out/work
vmap work ./out/work

# 4. 编译文件
puts "\n--- Compiling Verilog files ---"
vlog ./src/ADD.v
vlog ./src/IM.v
vlog ./src/PC.v
vlog ./src/MUX_2.v
vlog ./src/IF_ID.v
vlog ./src/RF.v
vlog ./src/ID_EX.v
vlog ./src/SigExt16_32.v
vlog ./src/SHL2.v
vlog ./src/MUX_4.v
vlog ./src/ALU.v
vlog ./src/EX_MA.v
vlog ./src/DM.v
vlog ./src/MA_WB.v
vlog ./src/CU.v
vlog ./src/Forward_Unit.v
vlog ./src/Hazard_Unit.v
vlog ./src/MIPS.v
vlog ./sim/mips_basic_tb.sv

# 5. 检查测试程序
set test_file "./asm/basic.txt"
if {[file exists $test_file]} {
    puts "Test program: $test_file"
} else {
    puts "ERROR: Test program $test_file not found!"
    quit -code 1
}

# 6. 开始仿真
puts "\n--- Starting simulation ---"
vsim -wlf ./out/mips_wave.wlf work.mips_basic_tb

# 7. 开启VCD记录
vcd file ./out/mips_wave.vcd
vcd add /mips_basic_tb/*

# 8. 添加波形到ModelSim窗口
add wave -divider "时钟和复位"
add wave /mips_basic_tb/clk
add wave /mips_basic_tb/rst

add wave -divider "PC和控制"
add wave -radix hex /mips_basic_tb/pcf_reg
add wave -radix binary /mips_basic_tb/PCWr_reg
add wave -radix binary /mips_basic_tb/IF_ID_RegWr_reg

add wave -divider "五级流水线指令"
add wave -radix hex -label "IF指令" /mips_basic_tb/inst_f_reg
add wave -radix hex -label "ID指令" /mips_basic_tb/inst_d_reg
add wave -radix hex -label "EX指令" /mips_basic_tb/inst_e_reg
add wave -radix hex -label "MEM指令" /mips_basic_tb/inst_m_reg
add wave -radix hex -label "WB指令" /mips_basic_tb/inst_w_reg

add wave -divider "EX级控制信号"
add wave -radix binary -label "WB_E" /mips_basic_tb/WB_E_reg
add wave -radix binary -label "MA_E" /mips_basic_tb/MA_E_reg
add wave -radix binary -label "EX_E" /mips_basic_tb/EX_E_reg

add wave -divider "EX阶段数据"
add wave -radix hex -label "RsE" /mips_basic_tb/RsE_reg
add wave -radix hex -label "RtE" /mips_basic_tb/RtE_reg
add wave -radix hex -label "Imm32E" /mips_basic_tb/Imm32E_reg
add wave -radix hex -label "ALU输入A" /mips_basic_tb/A_reg
add wave -radix hex -label "ALU输入B" /mips_basic_tb/B_reg
add wave -radix hex -label "ALU输出" /mips_basic_tb/ALUOutE_reg
add wave -radix binary -label "ALUSrcA" /mips_basic_tb/ALUSrcA_reg
add wave -radix binary -label "ALUSrcB" /mips_basic_tb/ALUSrcB_reg

add wave -divider "MEM级控制信号"
add wave -radix binary -label "WB_M" /mips_basic_tb/WB_M_reg
add wave -radix binary -label "MA_M" /mips_basic_tb/MA_M_reg

add wave -divider "MEM阶段数据"
add wave -radix hex -label "ALUOutM" /mips_basic_tb/ALUOutM_reg
add wave -radix hex -label "RtM" /mips_basic_tb/RtM_reg

add wave -divider "WB级控制信号"
add wave -radix binary -label "WB_W" /mips_basic_tb/WB_W_reg

add wave -divider "WB阶段数据"
add wave -radix hex -label "ALUOutW" /mips_basic_tb/ALUOutW_reg
add wave -radix hex -label "MEMOutW" /mips_basic_tb/MEMOutW_reg

# 9. 运行仿真
puts "\n--- Running simulation for 600ns ---"
run 600ns

# 10. 结束VCD记录
vcd flush
vcd close

# 11. 保存波形配置
save wave ./out/mips_wave.do

# 12. 自动缩放波形
wave zoom full

# 13. 显示结果
puts "\n=================================================="
puts "Simulation completed successfully!"
puts "=================================================="
puts "Waveform files saved in ./out/:"
puts "  mips_wave.vcd  - VCD format"
puts "  mips_wave.wlf  - WLF format"
puts "  mips_wave.do   - Waveform configuration"
puts ""
puts "To view waveforms:"
puts "  vsim -view ./out/mips_wave.wlf"
puts "  do ./out/mips_wave.do"
puts "=================================================="