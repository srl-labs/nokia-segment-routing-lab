#!/bin/bash

set -eu

startTrafficGamer() {
	echo Starting gamer traffic
	docker exec clab-sr-home bash /config/iperf_gamer.sh
}

startTrafficNonGamer() {
	echo Starting non-gamer traffic to internet
	docker exec clab-sr-home bash /config/iperf_non_gamer.sh
}

stopTraffic() {
	echo Stopping traffic
	docker exec clab-sr-home pkill iperf3
}

if [ $1 == "start" ]; then
	if [ $2 == "gamer" ]; then
		startTrafficGamer
	fi
	if [ $2 == "internet" ]; then
		startTrafficNonGamer
	fi
	
fi

if [ $1 == "stop" ]; then
	stopTraffic
fi
