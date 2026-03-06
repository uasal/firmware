RTL_DIR = ..
TB_DIR = .
WAVES_DIR = waves
WORK_DIR = work

GHDL_FLAGS = --std=08 -fsynopsys -fexplicit --workdir=$(WORK_DIR)

# all testbenches ending in _tb.vhd
TESTBENCHES = $(patsubst %_tb.vhd,%.sim,$(wildcard $(TB_DIR)/*_tb.vhd))

.PHONY: all
all: $(TESTBENCHES)
	@echo "Done!"

# command line
%.sim:
	@TB=$*_tb; \
	RTL=$*; \
	mkdir -p $(WORK_DIR); \
	rm -rf *.cf; \
	rm -rf $(WORK_DIR)/*.cf; \
	ghdl -a $(GHDL_FLAGS) $(TB_DIR)/tb_utils_pkg.vhd; \
	if [ -f $(RTL_DIR)/$$RTL.vhd ]; then \
		ghdl -a $(GHDL_FLAGS) $(RTL_DIR)/$$RTL.vhd; \
	fi; \
	ghdl -a $(GHDL_FLAGS) $(TB_DIR)/$${TB}.vhd; \
	ghdl -e $(GHDL_FLAGS) $${TB}; \
	ghdl -r $(GHDL_FLAGS) $${TB}

# waveforms
%.wav:
	@TB=$*_tb; \
	RTL=$*; \
	mkdir -p $(WORK_DIR); \
	rm -rf *.cf; \
	rm -rf $(WORK_DIR)/*.cf; \
	ghdl -a $(GHDL_FLAGS) $(TB_DIR)/tb_utils_pkg.vhd; \
	if [ -f $(RTL_DIR)/$$RTL.vhd ]; then \
		ghdl -a $(GHDL_FLAGS) $(RTL_DIR)/$$RTL.vhd; \
	fi; \
	ghdl -a $(GHDL_FLAGS) $(TB_DIR)/$${TB}.vhd; \
	ghdl -e $(GHDL_FLAGS) $${TB}; \
	ghdl -r $(GHDL_FLAGS) $${TB} --vcd=$${TB}.vcd; \
	if [ -f $(WAVES_DIR)/$*.gtkw ]; then \
		gtkwave -a $(WAVES_DIR)/$*.gtkw $${TB}.vcd & \
	else \
		gtkwave $${TB}.vcd & \
	fi

.PHONY: clean
clean:
	rm -rf $(WORK_DIR) *.cf *.vcd *.ghw

.PHONY: help
help:
	@echo "Make targets:"
	@echo "  make <vhdl file>.sim   - Run simulation (text output)"
	@echo "  make <vhdl file>.wav   - Run with waveform viewer (gtkwave)"
	@echo "  make all                - Run all testbenches"
	@echo "  make clean              - Clean build files"

