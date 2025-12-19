# 简单 ModelSim 脚本 - 保存 VCD 和 WLF 格式
# 用法: vsim -do scripts/run_with_vcd.do

puts "=== ALU Simulation - Saving VCD & WLF ==="

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

# 4. 编译文件
vlog ./src/ALU.v
vlog ./sim/ALU_tb.sv

# 5. 开始仿真，同时保存 WLF
vsim -wlf ./out/alu_wave.wlf work.ALU_tb

# 6. 开启 VCD 记录
# 方法1：使用 ModelSim 的 vcd 命令
vcd file ./out/alu_wave.vcd
vcd add /ALU_tb/*

# 方法2：如果要记录 DUT 内部信号
vcd add /ALU_tb/dut/*

# 7. 添加波形到 ModelSim 窗口
add wave *
add wave -divider "ALU Signals"
add wave -radix hex /ALU_tb/a /ALU_tb/b /ALU_tb/alu_out
add wave -radix bin /ALU_tb/ALUControl /ALU_tb/zf

# 8. 运行仿真
run 1000ns

# 9. 结束 VCD 记录
vcd flush
vcd close

# 10. 保存波形配置（ModelSim 格式）
save wave ./out/alu_wave.do

# 11. 显示结果
puts "\n========================================"
puts "Simulation completed successfully!"
puts "========================================"
puts "Waveform files saved in ./out/:"
puts ""
puts "For VS Code viewing:"
puts "  alu_wave.vcd       - VCD format (can view in VS Code)"
puts ""
puts "For ModelSim viewing:"
puts "  alu_wave.wlf       - WLF format (ModelSim native)"
puts "  alu_wave.do        - Waveform configuration"
puts ""
puts "To view in VS Code:"
puts "  1. Install 'WaveTrace' or 'VCD Viewer' extension"
puts "  2. Open ./out/alu_wave.vcd in VS Code"
puts ""
puts "To view in ModelSim:"
puts "  vsim -view ./out/alu_wave.wlf"
puts "  do ./out/alu_wave.do"
puts "========================================"

# 12. 自动缩放波形
wave zoom full