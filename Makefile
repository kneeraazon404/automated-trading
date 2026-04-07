.PHONY: setup install sync run run-parallel services data web help

# Default target
help:
	@echo "automated-trading — available commands:"
	@echo ""
	@echo "  make setup       Create .venv and install all dependencies"
	@echo "  make sync        Sync dependencies (after pyproject.toml changes)"
	@echo "  make data        Fetch and merge NASDAQ 100 price data"
	@echo "  make services    Start all MCP tool servers"
	@echo "  make run         Run the sequential trading agent"
	@echo "  make run-parallel Run the parallel trading agent"
	@echo "  make web         Start the local web dashboard"
	@echo ""

setup:
	uv venv --python 3.11
	uv sync
	@echo ""
	@echo "✅ Virtual environment ready. Activate with: source .venv/bin/activate"

sync:
	uv sync

data:
	uv run python data/get_daily_price.py
	uv run python data/merge_jsonl.py

services:
	uv run python agent_tools/start_mcp_services.py

run:
	uv run python main.py $(CONFIG)

run-parallel:
	uv run python main_parrallel.py $(CONFIG)

web:
	@echo "🌐 Starting web dashboard at http://localhost:8888"
	uv run python -m http.server 8888 --directory docs
