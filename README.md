# Automated Trading

[![Python 3.11+](https://img.shields.io/badge/Python-3.11+-blue.svg)](https://python.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

Autonomous AI trading agents that compete on NASDAQ 100 using real market data. Multiple LLMs (GPT, Claude, DeepSeek, Qwen, Gemini) each start with $10,000 and trade independently — zero human intervention.

Built with [LangChain](https://github.com/langchain-ai/langchain), [LangGraph](https://github.com/langchain-ai/langgraph), and [MCP](https://github.com/modelcontextprotocol) (Model Context Protocol).

---

## Features

- **Fully autonomous** — AI agents handle all analysis and trade execution
- **Multi-model arena** — run multiple LLMs head-to-head on the same market
- **MCP toolchain** — trade execution, price queries, web search, and math via HTTP tool servers
- **Daily or hourly** — configurable trading intervals
- **Historical replay** — backtest any date range with automatic future-data filtering
- **Live dashboard** — real-time performance visualization at `localhost:8888`

---

## Quick Start

### Prerequisites

- Python 3.11+
- [uv](https://docs.astral.sh/uv/) package manager
- API keys: OpenAI-compatible endpoint, [Alpha Vantage](https://www.alphavantage.co/), [Jina AI](https://jina.ai/)

### Setup

```bash
git clone https://github.com/kneeraazon404/automated-trading.git
cd automated-trading

make setup          # creates .venv + installs deps
cp .env.example .env
# fill in your API keys in .env
```

### Run

```bash
# 1. Fetch price data
make data

# 2. Start MCP tool servers (in a separate terminal)
make services

# 3. Run trading agents
make run CONFIG=configs/default_config.json            # sequential
make run-parallel CONFIG=configs/default_config.json    # parallel

# 4. View dashboard (optional)
make web    # http://localhost:8888
```

Or use the one-shot script:

```bash
./main.sh                          # default config
./main.sh configs/my_config.json   # custom config
```

---

## Environment Variables

```bash
OPENAI_API_BASE=https://your-openai-proxy.com/v1
OPENAI_API_KEY=your_key
ALPHAADVANTAGE_API_KEY=your_key
JINA_API_KEY=your_key

# MCP ports (defaults)
MATH_HTTP_PORT=8000
SEARCH_HTTP_PORT=8001
TRADE_HTTP_PORT=8002
GETPRICE_HTTP_PORT=8003

AGENT_MAX_STEP=30
```

---

## Configuration

JSON config files live in `configs/`. Key parameters:

| Parameter      | Description                                      | Default     |
| -------------- | ------------------------------------------------ | ----------- |
| `agent_type`   | `BaseAgent` (daily) or `BaseAgent_Hour` (hourly) | `BaseAgent` |
| `init_date`    | Backtest start date (`YYYY-MM-DD`)               | —           |
| `end_date`     | Backtest end date (`YYYY-MM-DD`)                 | —           |
| `max_steps`    | Max reasoning steps per session                  | `30`        |
| `initial_cash` | Starting capital per model                       | `10000.0`   |

See [configs/default_config.json](configs/default_config.json) for a full example.

---

## MCP Toolchain

| Tool            | Functions             | Description             |
| --------------- | --------------------- | ----------------------- |
| **TradeTools**  | `buy()`, `sell()`     | Execute stock trades    |
| **LocalPrices** | `get_price_local()`   | Historical OHLCV lookup |
| **Search**      | `get_information()`   | Jina AI web search      |
| **Math**        | `add()`, `multiply()` | Basic calculations      |

---

## Extending

Subclass `BaseAgent` and register it:

```python
from agent.base_agent.base_agent import BaseAgent

class MyAgent(BaseAgent):
    async def run_trading_session(self, today_date: str) -> None:
        await super().run_trading_session(today_date)
```

Then set `"agent_type": "MyAgent"` in your config.

---

## Project Structure

```text
automated-trading/
├── main.py / main_parrallel.py   # Entry points (sequential / parallel)
├── agent/base_agent/             # BaseAgent + hourly variant
├── agent_tools/                  # MCP tool servers (trade, price, search, math)
├── tools/                        # Shared utilities (constants, price helpers, metrics)
├── prompts/                      # System prompt builder
├── configs/                      # JSON config files
├── data/                         # Price data + per-model trading logs
└── docs/                         # Dashboard frontend
```

---

## License

[MIT](LICENSE)

## Disclaimer

This project is for **research purposes only** and does not constitute investment advice. Past performance does not indicate future results.
