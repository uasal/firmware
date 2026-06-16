# Use make install to install ghdl and gtkwave

RTL_DIR   := ..
TB_DIR    := .
WORK_DIR  := work
WAVES_DIR := waves
RUN_JOBS  ?= 8

GHDL_FLAGS := --std=08 -fsynopsys -frelaxed --workdir=$(WORK_DIR)

TB_FILES := $(notdir $(wildcard $(TB_DIR)/*_tb.vhd))
TB_NAMES := $(patsubst %_tb.vhd,%,$(TB_FILES))
RTL_FILES := $(patsubst %_tb.vhd,$(RTL_DIR)/%.vhd,$(TB_FILES))

PASS := \033[0;32m
FAIL := \033[0;31m
NC   := \033[0m

.PHONY: all build rebuild clean install help FORCE

$(WORK_DIR):
	@mkdir -p $@

build: | $(WORK_DIR)
	@ghdl -a $(GHDL_FLAGS) $(TB_DIR)/tb_utils_pkg.vhd
	@for f in $(RTL_FILES) $(TB_FILES:%=$(TB_DIR)/%); do \
		[ -f $$f ] && ghdl -a $(GHDL_FLAGS) $$f; \
	done
	@for tb in $(TB_NAMES); do \
		ghdl -e $(GHDL_FLAGS) $${tb}_tb; \
	done

rebuild: clean build

define run_tb
	@LOG=$(WORK_DIR)/$1_tb_output.log; \
	rm -f "$$LOG"; \
	if ghdl -r $(GHDL_FLAGS) $1_tb $2 >"$$LOG" 2>&1 && \
	   ! grep -qE 'error:|FAIL:' "$$LOG"; then \
		printf "$(PASS)$1_tb$(NC)\n"; \
	else \
		printf "$(FAIL)$1_tb$(NC)\n"; \
	fi
endef

all: build
	@$(MAKE) --no-print-directory --output-sync=target -j$(RUN_JOBS) $(TB_NAMES:%=%.run)
	@sh ./update_doxygen_baud.sh $(WORK_DIR) $(TB_DIR)
	@! grep -rlE 'error:|FAIL:' $(TB_NAMES:%=$(WORK_DIR)/%_tb_output.log) 2>/dev/null | grep -q .

%.run: FORCE
	$(call run_tb,$*)

%.sim: build
	@ghdl -r $(GHDL_FLAGS) $*_tb 2>&1 | tee $(WORK_DIR)/$*_tb_output.log; \
	! grep -qE 'error:|FAIL:' $(WORK_DIR)/$*_tb_output.log

%.wav: build
	@ghdl -r $(GHDL_FLAGS) $*_tb --wave=$(WORK_DIR)/$*_tb.ghw
	@if [ -f $(WAVES_DIR)/$*.gtkw ]; then \
		gtkwave -a $(WAVES_DIR)/$*.gtkw $(WORK_DIR)/$*_tb.ghw & \
	else \
		gtkwave $(WORK_DIR)/$*_tb.ghw & \
	fi

clean:
	rm -rf $(WORK_DIR) *.cf *.vcd *.ghw *.log

install:
	sudo apt-get update && sudo apt-get install -y ghdl gtkwave

help:
	@printf "Targets:\n"
	@printf "  make build      Build all testbenches\n"
	@printf "  make all        Build + run all in parallel ($(RUN_JOBS) jobs)\n"
	@printf "  make <n>.sim    Build and run one testbench\n"
	@printf "  make <n>.wav    Build and open waveform\n"
	@printf "  make install    Install required dependencies\n"
	@printf "  make clean      Remove build artifacts\n"
