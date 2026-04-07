#!/bin/bash


echo "🤖 Now starting the main trading agent..."
# python main.py configs/day_config.json #run daily config
python main.py configs/test_real_hour_config.json #run hour config

echo "✅ automated-trading stopped"
