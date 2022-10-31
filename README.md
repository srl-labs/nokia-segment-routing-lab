# SROS Segment Routing: low latency service with Flex-algo

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
