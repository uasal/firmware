# Use: sudo apt-get install ghdl gtkwave

RTL_DIR = ..
TB_DIR = .
WAVES_DIR = waves
WORK_DIR = work


GHDL_FLAGS = --std=08 -fsynopsys -frelaxed --workdir=$(WORK_DIR)

TB_FILES = $(notdir $(wildcard $(TB_DIR)/*_tb.vhd))
TESTBENCHES = $(patsubst %_tb.vhd,%.sim,$(TB_FILES))

QUIET ?= 0

define build_tb
	TB=$*_tb; \
	mkdir -p $(WORK_DIR); \
	set -e; \
	ghdl -a $(GHDL_FLAGS) $(TB_DIR)/tb_utils_pkg.vhd; \
	for f in $(PKG_FILES); do \
		[ -f $$f ] && ghdl -a $(GHDL_FLAGS) $$f; \
	done; \
	for f in $(TESTED_RTL_FILES); do \
		[ -f $$f ] && ghdl -a $(GHDL_FLAGS) $$f; \
	done; \
	ghdl -a $(GHDL_FLAGS) $(TB_DIR)/$${TB}.vhd; \
	ghdl -e $(GHDL_FLAGS) $${TB};
endef

.PHONY: all
.PHONY: clean
.PHONY: help

PKG_FILES = $(RTL_DIR)/CGraphTypes.vhd

# RTL files that have a matching *_tb.vhd
TESTED_RTL_FILES = $(patsubst %_tb.vhd,$(RTL_DIR)/%.vhd,$(TB_FILES))

# Avoid compiling packages twice
TESTED_RTL_FILES := $(filter-out $(PKG_FILES),$(TESTED_RTL_FILES))

all:
	@fail=0; \
	GREEN="\033[0;32m"; \
	RED="\033[0;31m"; \
	NC="\033[0m"; \
	for tb in $(TESTBENCHES); do \
		name=$${tb%.sim}; \
		if $(MAKE) --no-print-directory QUIET=1 $${tb} >/dev/null 2>&1; then \
			printf "$${GREEN}$${name}_tb$${NC}\n"; \
		else \
			printf "$${RED}$${name}_tb$${NC}\n"; \
			fail=1; \
		fi; \
	done; \
	if [ $$fail -ne 0 ]; then exit 1; fi

# command line
%.sim:
	@rm -rf *.cf; \
	rm -rf $(WORK_DIR)/*.cf
	@$(build_tb)
	@TB=$*_tb; \
	LOG="$(WORK_DIR)/$${TB}_output.log"; \
	rm -f "$$LOG"; \
	ghdl -r $(GHDL_FLAGS) $${TB} 2>&1 | tee "$$LOG"; \
	if grep -q "error:" "$$LOG"; then \
		echo "Errors found in $${TB}! Check $$LOG for details."; \
		exit 1; \
	fi; \
	if grep -q "FAIL:" "$$LOG"; then \
		echo "Testbench $${TB} failed! Check $$LOG for details."; \
		exit 1; \
	fi

# waveforms (gtkwave)
%.wav:
	@rm -rf *.cf; \
	rm -rf $(WORK_DIR)/*.cf
	@$(build_tb)
	@TB=$*_tb; \
	if ! ghdl -r $(GHDL_FLAGS) $${TB} --wave=$(WORK_DIR)/$${TB}.ghw; then \
		echo "ghdl run failed for $${TB}"; \
		exit 1; \
	fi; \
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

