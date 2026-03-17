.PHONY: setup render preview clean check help

# Default target
help:
	@echo "Numerical Geophysics - Build Commands"
	@echo ""
	@echo "Available targets:"
	@echo "  setup   - Install Quarto and Python dependencies"
	@echo "  render  - Build all documentation"
	@echo "  preview - Start preview server (port 4200)"
	@echo "  clean   - Remove generated HTML files"
	@echo "  check   - Verify environment setup"
	@echo ""

setup:
	@echo "Setting up build environment..."
	@./install-quarto.sh
	@echo "Installing Python dependencies with uv..."
	@uv sync
	@echo "✓ Setup complete"

render:
	@echo "Building documentation..."
	@quarto render
	@echo "Flattening output directory..."
	@if [ -d docs/src ]; then \
		mv docs/src/* docs/; \
		rmdir docs/src; \
	fi

preview:
	@echo "Starting preview server..."
	@quarto preview --port 4200

clean:
	@echo "Cleaning generated files..."
	@rm -rf docs/*.html docs/site_libs docs/search.json docs/*_files
	@echo "✓ Clean complete"

check:
	@echo "Checking environment..."
	@echo -n "Quarto: "
	@if command -v quarto >/dev/null 2>&1; then \
		quarto --version; \
	else \
		echo "NOT INSTALLED"; \
		exit 1; \
	fi
	@echo -n "Python: "
	@if command -v python3 >/dev/null 2>&1; then \
		python3 --version; \
	else \
		echo "NOT INSTALLED"; \
		exit 1; \
	fi
	@echo -n "uv: "
	@if command -v uv >/dev/null 2>&1; then \
		uv --version; \
	else \
		echo "NOT INSTALLED"; \
		exit 1; \
	fi
	@echo "Checking Python environment..."
	@uv sync --check
	@echo "✓ Environment check passed"
