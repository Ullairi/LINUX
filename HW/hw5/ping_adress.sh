#!/bin/bash

ping_address="google.com"
max_ping_ms=10
max_failures=3
failures=0

	while true;
		do #recieving string with ping that contain time
			ping_result=$(ping -c 1 -W 1 "$ping_address" | grep 'time=')
	
			#recieving ping time
			ping_time=$(echo "$ping_result" | awk -F'time=' '{print $2}' | awk '{print $1}')
			ping_time_numb=${ping_time%.*}

			if [ -n "$ping_time" ] && [ "$ping_time_numb" -gt "$max_ping_ms" ]; then
				echo "Ping $ping_address exceed $max_ping_ms ms: ${ping_time} ms"
			fi

			if [ -z "$ping_time" ]; then
				echo "Ping $ping_address failed"
				((failures++))

			else
				echo "Ping $ping_address succesfull: ${ping_time} ms"
				failures=0
			fi

			if [ "$failures" -ge "$max_failures" ]; then
				echo "The maximum number of failed attempts has been exceeded"
				break
			fi

			sleep 1
		done
