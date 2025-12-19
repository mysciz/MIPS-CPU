# ALU Test Makefile for Windows
# 使用方法:
#   make all     - 编译、仿真并生成所有波形文件
#   make compile - 只编译
#   make sim     - 运行仿真（无GUI）
#   make wave    - 打开波形窗口
#   make vcd     - 生成 VCD 和 WLF 文件
#   make clean   - 清理文件
#   make help    - 显示帮助

# ============ 配置 ============
VLOG       = vlog
VSIM       = vsim
WORK_DIR   = out/work
OUT_DIR    = out
TOP_TB     = ALU_tb
SIM_TIME   = 1000ns

# 源文件
SRC_FILES  = src/ALU.v
TB_FILES   = sim/ALU_tb.sv
ALL_FILES  = $(SRC_FILES) $(TB_FILES)

# 输出文件
WLF_FILE   = $(OUT_DIR)/alu_wave.wlf
VCD_FILE   = $(OUT_DIR)/alu_wave.vcd
WAVE_DO    = $(OUT_DIR)/alu_wave.do
LOG_FILE   = $(OUT_DIR)/simulation.log

# Windows 命令
RM         = rmdir /s /q
MKDIR      = mkdir
ECHO       = echo

# ============ 目标定义 ============
.PHONY: all compile sim wave vcd clean help

# 默认目标：生成所有波形文件
all: vcd

# 编译所有文件
compile: create_dirs
	@$(ECHO) ========================================
	@$(ECHO) Compiling ALU testbench...
	@$(ECHO) ========================================
	$(VLOG) -work $(WORK_DIR) $(ALL_FILES)
	@$(ECHO) ✅ Compilation complete!

# 运行仿真（无GUI）
sim: compile
	@$(ECHO) ========================================
	@$(ECHO) Running simulation: $(TOP_TB)
	@$(ECHO) ========================================
	$(VSIM) -c -work $(WORK_DIR) $(TOP_TB) \
		-do "run $(SIM_TIME); quit" \
		-l $(LOG_FILE)
	@$(ECHO) ✅ Simulation complete!
	@$(ECHO) Log file: $(LOG_FILE)

# 生成 VCD 和 WLF 文件（对应 run_with_vcd.do 的功能）
vcd: create_dirs compile
	@$(ECHO) ========================================
	@$(ECHO) Generating VCD ^& WLF files...
	@$(ECHO) ========================================
	$(VSIM) -c -work $(WORK_DIR) $(TOP_TB) \
		-wlf $(WLF_FILE) \
		-do " \
			puts \"Starting VCD recording...\"; \
			vcd file $(VCD_FILE); \
			vcd add /$(TOP_TB)/*; \
			vcd add /$(TOP_TB)/dut/*; \
			run $(SIM_TIME); \
			vcd flush; \
			vcd close; \
			save wave $(WAVE_DO); \
			quit" \
		-l $(LOG_FILE)
	@$(ECHO) ✅ Waveform files generated:
	@$(ECHO)   $(VCD_FILE)  - VCD format (for VS Code)
	@$(ECHO)   $(WLF_FILE)  - WLF format (for ModelSim)
	@$(ECHO)   $(WAVE_DO)   - Waveform configuration
	@$(ECHO).
	@$(ECHO) To view in VS Code:
	@$(ECHO)   1. Install 'WaveTrace' extension
	@$(ECHO)   2. Open $(VCD_FILE) in VS Code
	@$(ECHO).
	@$(ECHO) To view in ModelSim:
	@$(ECHO)   vsim -view $(WLF_FILE)
	@$(ECHO)   do $(WAVE_DO)

# 打开波形窗口（GUI模式）
wave: create_dirs compile
	@$(ECHO) ========================================
	@$(ECHO) Opening waveform GUI...
	@$(ECHO) ========================================
	$(VSIM) -gui -work $(WORK_DIR) $(TOP_TB) \
		-wlf $(WLF_FILE) \
		-do " \
			add wave *; \
			add wave -divider \"ALU Signals\"; \
			add wave -radix hex /$(TOP_TB)/a /$(TOP_TB)/b /$(TOP_TB)/alu_out; \
			add wave -radix bin /$(TOP_TB)/ALUControl /$(TOP_TB)/zf; \
			vcd file $(VCD_FILE); \
			vcd add /$(TOP_TB)/*; \
			vcd add /$(TOP_TB)/dut/*; \
			run $(SIM_TIME); \
			vcd flush; \
			vcd close; \
			save wave $(WAVE_DO); \
			wave zoom full;"

# 快速测试（只生成必要文件）
quick: create_dirs
	@$(ECHO) Quick test...
	$(VLOG) -work $(WORK_DIR) $(ALL_FILES)
	$(VSIM) -c -work $(WORK_DIR) $(TOP_TB) \
		-do "run $(SIM_TIME); quit"
	@$(ECHO) Quick test complete!

# 清理所有生成的文件
clean:
	@$(ECHO) Cleaning output files...
	@if exist $(OUT_DIR) $(RM) $(OUT_DIR)
	@if exist transcript del /f transcript 2>nul
	@if exist vsim.wlf del /f vsim.wlf 2>nul
	@if exist modelsim.ini del /f modelsim.ini 2>nul
	@$(ECHO) ✅ Clean complete!

# 创建目录
create_dirs:
	@if not exist $(OUT_DIR) $(MKDIR) $(OUT_DIR)
	@if not exist $(WORK_DIR) $(MKDIR) $(WORK_DIR)

# 帮助信息
help:
	@$(ECHO) ========================================
	@$(ECHO)        ALU Test Makefile Help
	@$(ECHO) ========================================
	@$(ECHO) Usage: mingw32-make [target]
	@$(ECHO).
	@$(ECHO) Targets:
	@$(ECHO)   make           - Generate VCD ^& WLF files (default)
	@$(ECHO)   make all       - Same as 'make vcd'
	@$(ECHO)   make compile   - Compile only
	@$(ECHO)   make sim       - Run simulation (no GUI)
	@$(ECHO)   make wave      - Open waveform GUI
	@$(ECHO)   make vcd       - Generate VCD and WLF files
	@$(ECHO)   make quick     - Quick test (no waveforms)
	@$(ECHO)   make clean     - Clean all generated files
	@$(ECHO)   make help      - Show this help
	@$(ECHO).
	@$(ECHO) Output files (in ./out/):
	@$(ECHO)   alu_wave.vcd   - VCD format for VS Code
	@$(ECHO)   alu_wave.wlf   - WLF format for ModelSim
	@$(ECHO)   alu_wave.do    - Waveform configuration
	@$(ECHO)   simulation.log - Simulation log
	@$(ECHO).
	@$(ECHO) Examples:
	@$(ECHO)   make vcd                 # 生成波形文件
	@$(ECHO)   make SIM_TIME=2000ns    # 指定仿真时间
	@$(ECHO)   make clean ^&^& make vcd  # 清理后重新生成
	@$(ECHO) ========================================

# 显示文件列表
list:
	@$(ECHO) Source files:
	@for %%f in ($(ALL_FILES)) do @if exist %%f (@echo   ✅ %%f) else (@echo   ❌ %%f (not found))