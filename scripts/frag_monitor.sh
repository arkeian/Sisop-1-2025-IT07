#!/bin/bash

LOG_FILE="/home/maulana/log/fragment.log"

WAKTU=$(date '+%Y-%m-%d %H:%M:%S')

RAM_USAGE=$(free -m | awk 'NR==2{printf "%.2f", $3*100/$2}')
TOTAL_RAM=$(free -m | awk 'NR==2 {print $2}')
USED_RAM=$(free -m | awk 'NR==2 {print $3}')
AVAILABLE_RAM=$(free -m | awk 'NR==2 {print $7}')

echo "[$WAKTU] - Fragment Usage [$RAM_USAGE%] - Fragment Count [$USED_RAM MB] - Details [Total: $TOTAL_RAM MB, Available: $AVAILABLE_RAM MB]" >> "$LOG_FILE"

