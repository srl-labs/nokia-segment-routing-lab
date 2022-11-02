# SROS SR-MPLS: low latency service with Flex-Algo
Flexible-Algorithm (Flex-Algo) provides a mechanism for IGPs to compute constraint-based paths across a network. We use a Flexible-Algorithm Definition (FAD) to describe how a particular algorithm should look like by defining what metric-type needs to be used when calculating the shortest path. This metric type can be IGP-metric, TE-metric or delay-metric. In this lab we will be using delay-metric to provide a low-latency service. The **goal** of this lab is to show case that per VPN service we can provide one prefix to use delay-metric and another prefix to use standard IGP-metric to calculate the shortest path. All done with Segment Routing and MPLS in the underlay.

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

This is the high-level overview to enable Flex-Algo for SR-MPLS:

1. Configure and advertise the Flex-Algo Definition (FAD)
2. Configure Flex-Algo participation
3. Configure a Flex-Algo prefix node-SID on all router that will use Flex-Algo
4. Apply traffic steering use Flex-Algo on VPN service

### 1. Configuring and advertise FAD
Create the FAD with metric-type delay and advertise it into the IGP. In our case we are using ISIS
```
A:admin@R1# admin show configuration /configure routing-options
    flexible-algorithm-definitions {
        flex-algo "Flex-Algo-128" {
            admin-state enable
            description "Flex-Algo for Delay Metric"
            metric-type delay
        }
    }
```
Next enable Flex-Algo under ISIS. Only one router in the domain needs to advertise the FAD but everyone who wants to be part of the Flex-Algo topology needs to participate. In our case only R1 is advertising the FAD and all other routers are particpating.
```
A:admin@R1# admin show configuration /configure router isis flexible-algorithms
    admin-state enable
    flex-algo 128 {
        participate true
        advertise "Flex-Algo-128"
    }

```
We can see R1 is advertising the FAD as an ISIS Sub-Tlv with metric-type delay. All participating routers now know how the Flex-Algo looks like.
<pre>
A:admin@R1# show router isis database R1.00-00 level 2 detail | match "FAD Sub-Tlv" post-lines 5
    FAD Sub-Tlv:
        Flex-Algorithm   : 128
        <b>Metric-Type      : delay</b>
        Calculation-Type : 0
        Priority         : 100
        Flags: M
</pre>
### 2. Configure Flex-Algo participation
Looking into R3 we can see its only participating in the Flex-Algo topology and not advertising the FAD.
```
A:admin@R3# admin show configuration /configure router isis flexible-algorithms
    admin-state enable
    flex-algo 128 {
        participate true
    }
```
If we look into the Router Capabilities Tlv of R3 we can see its supporting two SR Algo's, the default SFP algorithm based on IGP-metric and Flex-Algo 128 based on delay-metric
<pre>
A:admin@R3# show router isis database R3.00-00 level 2 detail | match "Router Cap" post-lines 5
  Router Cap : 192.0.2.3, D:0, S:0
    TE Node Cap : B E M  P
    SR Cap: IPv4 MPLS-IPv6
       SRGB Base:100000, Range:1000
    <b>SR Alg: metric based SPF, 128</b>
    Node MSD Cap: BMI : 12 ERLD : 15
</pre>

### Verify that link delays are advertised into ISIS
In our topology is the upper plane (R1->R3->R5-R2) confgigured with 10ms delay staticly. While to lower plane (R1->R4->R6->R2) is configured with 20ms. We can see R1 is advertising a delay of 10ms for its link towards R3.
<pre>
A:admin@R1# show router isis database R1.00-00 detail
<snipp>
  TE IS Nbrs   :
    Nbr   : R3.00
    Default Metric  : 10
    Sub TLV Len     : 34
    IF Addr   : 192.168.13.0
    Nbr IP    : 192.168.13.1
    TE APP LINK ATTR    :
      SABML-flag:Non-Legacy SABM-flags:   X
        <b>Delay Min : 10000 Max : 10000</b>
    Adj-SID: Flags:v4VL Weight:0 Label:524285
</pre>

## Running traffic

To run traffic between the home user and the internet services, leverage `traffic.sh` control script.

To start the traffic from home users to internet service or gaming service:

* `bash traffic.sh start internet` - start traffic from home user to internet service
* `bash traffic.sh start gamer` - start traffic from gamer to low-latency gaming service

To stop the traffic:

* `bash traffic.sh stop` - stop traffic generation between all nodes





## Grafana

## Access details

* Grafana: <http://localhost:3000>
* Prometheus: <http://localhost:9090/graph>
