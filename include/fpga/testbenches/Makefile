# Use: sudo apt-get install ghdl gtkwave

RTL_DIR = ..
TB_DIR = .
WAVES_DIR = waves
WORK_DIR = work

GHDL_FLAGS = --std=08 -fsynopsys -fexplicit --workdir=$(WORK_DIR)

TESTBENCHES = $(patsubst %_tb.vhd,%.sim,$(wildcard $(TB_DIR)/*_tb.vhd))

define build_tb
	TB=$*_tb; \
	RTL=$*; \
	mkdir -p $(WORK_DIR); \
	ghdl -a $(GHDL_FLAGS) $(TB_DIR)/tb_utils_pkg.vhd; \
	if [ -f $(RTL_DIR)/$$RTL.vhd ]; then \
		ghdl -a $(GHDL_FLAGS) $(RTL_DIR)/$$RTL.vhd; \
	fi; \
	ghdl -a $(GHDL_FLAGS) $(TB_DIR)/$${TB}.vhd; \
	ghdl -e $(GHDL_FLAGS) $${TB};
endef

.PHONY: all
all: $(TESTBENCHES)
	@echo "Done!"

# command line
%.sim:
	@rm -rf *.cf; \
	rm -rf $(WORK_DIR)/*.cf
	@$(build_tb)
	@TB=$*_tb; \
	ghdl -r $(GHDL_FLAGS) $${TB} 2>&1 | tee $(WORK_DIR)/$${TB}_output.log; \
	if grep -q "FAIL:" $(WORK_DIR)/$${TB}_output.log; then \
		echo "Testbench $${TB} failed! Check $(WORK_DIR)/$${TB}_output.log for details."; \
		exit 1; \
	fi

# waveforms (gtkwave)
%.wav:
	@rm -rf *.cf; \
	rm -rf $(WORK_DIR)/*.cf
	@$(build_tb)
	@TB=$*_tb; \
	ghdl -r $(GHDL_FLAGS) $${TB} --wave=$(WORK_DIR)/$${TB}.ghw; \
	if [ -f $(WAVES_DIR)/$*.gtkw ]; then \
		gtkwave -a $(WAVES_DIR)/$*.gtkw $(WORK_DIR)/$${TB}.ghw & \
	else \
		gtkwave $(WORK_DIR)/$${TB}.ghw & \
	fi

.PHONY: clean
clean:
	rm -rf $(WORK_DIR) *.cf *.vcd *.ghw *.log

.PHONY: help
help:
	@echo "Make targets:"
	@echo "  make <vhdl file>.sim   - Run simulation (text output)"
	@echo "  make <vhdl file>.wav   - Run with waveform viewer (gtkwave)"
	@echo "  make all                - Run all testbenches"
	@echo "  make clean              - Clean build files"

