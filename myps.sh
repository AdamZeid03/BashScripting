#!/bin/bash

function getProcFdCount 
{
    if (ls -1 "/proc/$1/fdinfo" &> /dev/null); 
    then
        ls -1 "/proc/$1/fdinfo" | wc -l
    else
        echo "0"
    fi
}

pids=$(ls /proc | grep '[0-9]' | sort -g)
(echo "PPID;PID;COMM;STATE;TTY;RSS;PGID;SID;FDs";
for pid in $pids;
do
	if test -f "/proc/$pid/stat"; then
		stat_arr=($(cat /proc/$pid/stat))
		# (3) - ppid, (0) - pid, (1) - comm, (2) - state, (6) - tty_nr, (23) - rss
    	# (4) - pgrp, (5) - session 
		ppid=${stat_arr[3]}
		pid=${stat_arr[0]}
		comm=${stat_arr[1]}
		state=${stat_arr[2]}
		tty=${stat_arr[6]}
		rss=${stat_arr[23]}
		pgid=${stat_arr[4]}
		sid=${stat_arr[5]}
		opened_files=$(getProcFdCount $pid);
		
		echo "$ppid;$pid;$comm;$state;$tty;$rss;$pgid;$sid;$opened_files"
	fi
done) | column -t -s ";" 
