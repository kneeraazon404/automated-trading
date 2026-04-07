#!/usr/bin/env bash
# automated-trading main launch script — runs the full trading pipeline.
# Usage: ./main.sh [config_path]

set -euo pipefail

CONFIG="${1:-configs/default_config.json}"
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🚀 Launching automated-trading..."
echo "📄 Config: $CONFIG"

# Step 1: Fetch and merge price data
echo ""
echo "📊 Fetching and merging price data..."
uv run python "$PROJECT_ROOT/data/get_daily_price.py"
uv run python "$PROJECT_ROOT/data/merge_jsonl.py"

# Step 2: Start MCP services in background
echo ""
echo "🔧 Starting MCP services..."
uv run python "$PROJECT_ROOT/agent_tools/start_mcp_services.py" &
MCP_PID=$!
echo "   MCP manager PID: $MCP_PID"

# Give services time to bind their ports
sleep 3

# Step 3: Run trading agent
echo ""
echo "🤖 Starting AI trading agent..."
uv run python "$PROJECT_ROOT/main.py" "$CONFIG"

# Step 4: Stop MCP services
echo ""
echo "🛑 Stopping MCP services..."
kill "$MCP_PID" 2>/dev/null || true

echo ""
echo "✅ automated-trading finished."
