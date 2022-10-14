#!/bin/bash

set -eu

startTraffic() {
	echo Starting traffic from client1 to client2
	docker exec clab-sr-client1 bash /config/iperf.sh
}

stopTraffic() {
	echo Stopping traffic
	docker exec clab-sr-client1 pkill iperf3
}

if [ $1 == "start" ]; then
	startTraffic
fi

if [ $1 == "stop" ]; then
	stopTraffic
fi
