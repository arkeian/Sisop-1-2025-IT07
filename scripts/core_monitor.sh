#!/bin/bash

LOG_FILE="/home/maulana/log/core.log"

WAKTU=$(date '+%Y-%m-%d %H:%M:%S')

CPU_USAGE=$(top -bn1 | awk '/Cpu\(s\):/ {print 100 - $8}')
CPU_MODEL=$(grep -m 1 "model name" /proc/cpuinfo | cut -d: -f2 | sed 's/^ //')

echo "[$WAKTU] - Core Usage [$CPU_USAGE%] - Terminal Model [$CPU_MODEL]" >> "$LOG_FILE"


