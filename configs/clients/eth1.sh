ip link add link eth1 name eth1.10 type vlan id 10
ip link add link eth1 name eth1.20 type vlan id 20
ip link set dev eth1.10 up
ip link set dev eth1.20 up
