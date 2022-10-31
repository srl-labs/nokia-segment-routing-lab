# SROS SR-MPLS: low latency service with Flex-Algo
Flexible-Algorithm (Flex-Algo) provides a mechanism for IGPs to compute constraint-based paths across a network. We use a Flexible-Algorithm Definition (FAD) to describe how a particular algorithm should like by defining what metric-type needs to be used when calculating the shortest path. This metric type can be IGP-metric, TE-metric or delay-metric. In this lab we will be using delay-metric to provide a low-latency service. The **goal** of this lab is to show case that per VPN service we can provide one prefix to use delay-metric and another prefix to use standard IGP-metric to calculate the shortest path. All done with Segment Routing and MPLS in the underlay.

This is translated into a home user that has access to two services. One serivice is a low-latency service when gaming while connected to the gaming servers. The other is using standard IGP metric when the user is making use of the internet service.

## Deploying the lab
The lab is deployed with [containerlab](https://containerlab.dev/) project where [`nokia-sr.clab.yml`](https://github.com/srl-labs/nokia-segment-routing-lab/blob/master/nokia-sr.clab.yml) file declaratively describes the lab topology.
```
clab deploy
```
Same goes for destroying the lab
```
clab destroy
```

## Accessing the network elements
After deploying the lab, you will see a summary of the deployed nodes in table format like below. To access a network element with SSH simply use the hostname as described in the table.
```
ssh admin@clab-sr-r1
```
The Linux CE clients can be accessed as regular containers, you can connect to them just like to any other container
```
docker exec -it clab-sr-client1 bash
```

## Configuration
All nodes come preconfigured thanks to startup-config setting in the topology file [`nokia-sr.clab.yml`](nokia-sr.clab.yml), so there is no need to configure the nodes after deployment. Each node has its own config file which you can find [`configs`](/configs).


## Running traffic

To run traffic between the users and the services, leverage `traffic.sh` control script.

To start the traffic from home users to internet service or gaming service:

* `bash traffic.sh start internet` - start traffic from home user to internet service
* `bash traffic.sh start gamer` - start traffic from gamer to low-latency gaming service

To stop the traffic:

* `bash traffic.sh stop` - stop traffic generation between all nodes





## Grafana

## Access details

* Grafana: <http://localhost:3000>
* Prometheus: <http://localhost:9090/graph>
