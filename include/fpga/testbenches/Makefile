# Use: sudo apt-get install ghdl gtkwave

RTL_DIR   = ..
TB_DIR    = .
WAVES_DIR = waves
WORK_DIR  = work

GHDL_FLAGS = --std=08 -fsynopsys -frelaxed --workdir=$(WORK_DIR)

TB_FILES = $(notdir $(wildcard $(TB_DIR)/*_tb.vhd))
TB_NAMES = $(patsubst %_tb.vhd,%,$(TB_FILES))

RTL_FILES = $(patsubst %_tb.vhd,$(RTL_DIR)/%.vhd,$(TB_FILES))

.PHONY: all build clean help rebuild

$(WORK_DIR):
	@mkdir -p $(WORK_DIR)

build: | $(WORK_DIR)
	@rm -f *.cf 2>/dev/null || true
	@set -e; \
	ghdl -a $(GHDL_FLAGS) $(TB_DIR)/tb_utils_pkg.vhd; \
	for f in $(RTL_FILES) $(TB_FILES:%=$(TB_DIR)/%); do \
		[ -f $$f ] && ghdl -a $(GHDL_FLAGS) $$f; \
	done; \
	for tb in $(TB_NAMES); do \
		ghdl -e $(GHDL_FLAGS) $${tb}_tb; \
	done

all: build
	@fail=0; \
	GREEN="\033[0;32m"; \
	RED="\033[0;31m"; \
	NC="\033[0m"; \
	for tb in $(TB_NAMES); do \
		LOG="$(WORK_DIR)/$${tb}_tb_output.log"; \
		rm -f "$$LOG"; \
		if ghdl -r $(GHDL_FLAGS) $${tb}_tb >"$$LOG" 2>&1; then \
			if grep -q "error:" "$$LOG" || grep -q "FAIL:" "$$LOG"; then \
				printf "$${RED}%s_tb$${NC}\n" "$$tb"; \
				fail=1; \
			else \
				printf "$${GREEN}%s_tb$${NC}\n" "$$tb"; \
			fi; \
		else \
			printf "$${RED}%s_tb$${NC}\n" "$$tb"; \
			fail=1; \
		fi; \
	done; \
	exit $$fail

%.sim: build
	@TB=$*_tb; \
	LOG="$(WORK_DIR)/$${TB}_output.log"; \
	rm -f "$$LOG"; \
	ghdl -r $(GHDL_FLAGS) $${TB} 2>&1 | tee "$$LOG"; \
	if grep -q "error:" "$$LOG" || grep -q "FAIL:" "$$LOG"; then \
		exit 1; \
	fi

%.wav: build
	@TB=$*_tb; \
	ghdl -r $(GHDL_FLAGS) $${TB} --wave=$(WORK_DIR)/$${TB}.ghw; \
	if [ -f $(WAVES_DIR)/$*.gtkw ]; then \
		gtkwave -a $(WAVES_DIR)/$*.gtkw $(WORK_DIR)/$${TB}.ghw & \
	else \
		gtkwave $(WORK_DIR)/$${TB}.ghw & \
	fi

rebuild: clean build

clean:
	rm -rf $(WORK_DIR) *.cf *.vcd *.ghw *.log

install:
	sudo apt-get update
	sudo apt-get install -y ghdl gtkwave

help:
	@echo "Make targets:"
	@echo "  make build      - Build all testbenches once"
	@echo "  make all        - Build once, run all, print pass/fail colors"
	@echo "  make <name>.sim - Build and run one testbench"
	@echo "  make <name>.wav - Build and open waveform for one testbench"
	@echo "  make clean      - Clean build files"