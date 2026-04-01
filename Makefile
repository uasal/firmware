# Install headers from `include` directory into PREFIX directory.
# By default, PREFIX is /usr/local/include/summerDevice, but it can be
# overridden by setting the PREFIX variable when invoking make. For example:
#   make install PREFIX=/opt/MAgAOX/source/summerDevice
# Note: installing / uninstalling to /usr/local requires root privileges:
#   sudo make install / uninstall

PREFIX ?= /usr/local/include/summerDevice
DESTDIR ?=

SRCDIR := include
BUILD_DIR := build
MANIFEST := $(BUILD_DIR)/install_manifest.txt

INSTALL_DIR := install -d

ALL_HEADERS := $(shell find $(SRCDIR) -type f -name '*.h' -o -type f -name '*.hpp')

.PHONY: all build install uninstall clean help

# Default: build list of headers to be installed
all: build

build:
	@echo "Building header list in $(BUILD_DIR)"
	@mkdir -p $(BUILD_DIR)
	@find $(SRCDIR) -type f -name '*.h' -o -type f -name '*.hpp' > $(BUILD_DIR)/headers.list
	@echo "Found $$(wc -l < $(BUILD_DIR)/headers.list) header files to install"

install: uninstall build
	@echo "Installing headers to $(DESTDIR)$(PREFIX)"
	@> $(MANIFEST)
	@while IFS= read -r f; do \
		rel=$${f#$(SRCDIR)/}; \
		dest=$(DESTDIR)$(PREFIX)/$$rel; \
		$(INSTALL_DIR) "$$(dirname "$$dest")"; \
		cp "$$f" "$$dest"; \
		echo "$$dest" >> $(MANIFEST); \
	done < $(BUILD_DIR)/headers.list
	@echo "Installed $$(wc -l < $(MANIFEST)) headers; manifest written to $(MANIFEST)"

uninstall:
	@if [ -f $(MANIFEST) ]; then \
		echo "Removing files listed in $(MANIFEST)"; \
		xargs rm -f < $(MANIFEST); \
		rm -f $(MANIFEST); \
		echo "Removing empty directories under $(DESTDIR)$(PREFIX)"; \
		find $(DESTDIR)$(PREFIX) -type d -empty -delete 2>/dev/null || true; \
	else \
		echo "No manifest found at $(MANIFEST); nothing to uninstall"; \
	fi

clean:
	@echo "Cleaning $(BUILD_DIR)"
	@rm -rf $(BUILD_DIR)

help:
	@echo "Usage: make [target] [PREFIX=/path] [DESTDIR=/staging]"
	@echo "Targets: all, build, install, uninstall, clean, help"
