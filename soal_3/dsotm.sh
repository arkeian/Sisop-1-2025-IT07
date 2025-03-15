#!/bin/bash

clear

while [ "$#" -gt 0 ]
do
    case "$1" in
        --play=*)
            play="${1#*=}"
            ;;
        *)
            printf "Unknown Argument\n" >&2
    esac
	shift
done

if [ "$play" == "Speak To Me" ]
then
    until read -n 1 -t 1 -s
    do
        curl -sH "Accept: application/json" "https://www.affirmations.dev" | awk -F '"' '{print $4}'
    done
elif [ "$play" == "On The Run" ]
then
    printf "Loading...\n"
    length=$COLUMNS
    let max=$length-7
    progress=1
    while true
    do
        let randnum=($RANDOM%10)+1
        randinterval=$( printf "scale=1; %s / 10\n" $randnum | bc )
        let percent=$progress*100/$max
        if [ $percent -gt 100 ]
        then
            printf "\nFinished!\n"
            break
        else
            ((progress++))
            printf "\r[\e[%dG■" $progress
            printf "\e[%dG] %d%%" $max $percent
            sleep $randinterval
        fi
    done
elif [ "$play" == "Time" ]
then
    until read -n 1 -t 1 -s
    do
        awk '/rtc_date/ {date=$3} /rtc_time/ {time=$3} END {printf "\r%s %s", date, time}' /proc/driver/rtc
    done
    printf "\n"
elif [ "$play" == "Money" ]
then
    symbols=("$" "€" "¥" "₤" "£" "¢" "฿" "₱" "₹" "₩" "₿" "₣")
    until read -n 1 -t 0.001 -s
    do
        printf "\e[%d\n" $LINES
        let randrow=$RANDOM%$LINES+1
        let randcol=$RANDOM%$COLUMNS+1
        let randsym=$RANDOM%${#symbols[@]}
        let randclr=($RANDOM%5)+53
        printf "\e[%d;%dH\e[1;38;5;%dm%s" $randrow $randcol $randclr ${symbols[randsym]}
    done
    printf "\e[0m\n"
elif [ "$play" == "Brain Damage" ]
then
    until read -n 1 -t 1 -s
    do
        printf "\e[0;0H"
        awk '{printf "\033[1;38;5;30mSystem Uptime: %02d:%02d:%02d:%02d\n", $1/3600/24, $1/3600%24, $1/60%60, $1%60}' /proc/uptime
        awk '
            {if ($3 == "R" || $3 == "S" || $3 == "Z" || $3 == "T" || $3 == "I") {count[$3]++;total++}}
            END {
                printf "\033[38;5;66mTasks: %d total, %d running, %d sleeping, %d zombie, %d stopped, %d idle", total, count["R"], count["S"], count["Z"], count["T"], count["I"]
            }
        ' /proc/*/stat 2>/dev/null
        awk '
        /MemTotal/ {memtotal=$2} /MemFree/ {memfree=$2} /MemAvailable/ {avail=$2} /Buffers/ {buffers=$2} /Cached/ {cached=$2} /Slab/ {slab=$2} /SwapTotal/ {swatotal=$2} /SwapFree/ {swafree=$2}
        END {
            buffcache=buffers+cached+slab
            memused=memtotal-memfree-buffcache
            printf "\033[38;5;102m\n\n\ttotal\t\tfree\t\tused\t\tavailable\tbuff/cache"
            printf "\033[38;5;138m\nMemory:\t%.1f MiB\t%.1f MiB\t%.1f MiB\t%.1f MiB\t%.1f MiB", memtotal/1024, memfree/1024, memused/1024, avail/1024, buffcache/1024
            swaused=swatotal-swafree
            printf "\nSwap:\t%.1f MiB\t%.1f MiB\t%.1f MiB", swatotal/1024, swafree/1024, swaused/1024

        }' /proc/meminfo
        printf "\e[38;5;174m\n\nPID\tUSER\tSTATUS\t%%CPU\tCOMMAND\n\n"
        limit=0
        for proc in /proc/*/stat
        do
            status=$( awk '{print $3}' $proc 2>/dev/null)
            if [ "$status" == "R" ] || [ "$status" == "S" ] || [ "$status" == "Z" ] || [ "$status" == "T" ] || [ "$status" == "I" ]
            then
                pid=$( awk '{print $1}' $proc 2>/dev/null)
                user=$(ls -l $proc | awk '{print $3}' 2>/dev/null)
                cmdname=$(awk '{print $2}' $proc 2>/dev/null)
                uptime=$(awk '{print $1}' /proc/uptime)
                utime=$(awk '{print $14}' $proc 2>/dev/null)
                stime=$(awk '{print $15}' $proc 2>/dev/null)
                starttime=$(awk '{print $22}' $proc 2>/dev/null)
                ticks=$(getconf CLK_TCK)
                let timespent=$utime+$stime
                elapsedtime=$( printf "scale=1; %s - (%s / %s)\n" $uptime $starttime $ticks | bc)
                cpuusage=$( printf "scale=1; 100 * ((%s / %s) / %s)\n" $timespent $ticks $elapsedtime | bc )
                printf "\e[38;5;210m%d\t%s\t%s\t%.1f\t%s\e[K\n" $pid $user $status $cpuusage $cmdname
                ((limit++))
            fi
            if [ $limit -gt 15 ]
            then
                break
            fi
        done
    done
    printf "\e[0m\n"
else
    printf "Unknown Argument\n" >&2
fi