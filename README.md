# GTPV1-P4

This P4 programm provides [GTP.v1][GTP.v1] encapsulation/decapsulation/steering for ICMP and UDP traffic. Furthermore you can get hop latency via postcard telemetry from each node of the network.

The folder/files contain:
* `Graph`: contains the workflows of each part of the P4 piplenies, e.i, parser, ingress pipeline, egress pipeline, etc.
* `Include`: contains the P4 program files. The P4 file `main.p4` defines the "total pipeline" and the files contained in `Include` folder specifies:  headers, parser, tables, etc.
* `Command files`: These files contain a set of flow rules for configuring a P4 switch loaded with GTPV1-P4 pipeline. More in detail these three files are referred to a specified network topology.
* `Parsing_INT_pkt`: is a python script for parsing a report packet and send the telemetry infortaions, contained in the packet, to Grafana.
* `Simpe_network_topology`: is a python script for creating a mininet network.
* `Write_entries_scan`: is a python script for creating flow rules.

## Steps to run GTPV1-P4 on Mininet


To run the program:

    docker run --privileged --rm -it opennetworking/p4mn [MININET ARGS]

After running this command, you should see the mininet CLI (`mininet>`).

It is important to run this container in privileged mode (`--privileged`) so
mininet can modify the network interfaces and properties to emulate the desired
topology.

The image defines as entry point the mininet executable configured to use BMv2
`simple_switch_grpc` as the default switch. Options to the docker run command
(`[MININET ARGS]`) are passed as parameters to the mininet process. For more
information on the supported mininet options, please check the official mininet
documentation.

For example, to run a linear topology with 3 switches:

    docker run --privileged --rm -it opennetworking/p4mn --topo linear,3
    
## Steps to run GTPV1-P4 on a single switch
   
[GTP.v1]: https://en.wikipedia.org/wiki/GPRS_Tunnelling_Protocol
