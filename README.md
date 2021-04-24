# GTPV1-P4

This P4 programm provides [GTP.v1][GTP.v1] encapsulation/decapsulation/steering for ICMP and UDP traffic. Furthermore you can get hop latency via postcard telemetry from each node of the network.

The folder/files contain:
* `Graph`: contains the workflows of each part of the P4 piplenies, e.i., parser, ingress pipeline, egress pipeline, etc.
* `Include`: contains the P4 program files. The P4 file `main.p4` defines the "total pipeline" and the files contained in `Include` folder specifies:  headers, parser, tables, etc.
* `Command files`: These files contain a set of flow rules for configuring a P4 switch loaded with GTPV1-P4 pipeline. More in detail these three files are referred to a specified network topology.
* `Parsing_INT_pkt`: is a python script for parsing a report packet and send the telemetry infortaions, contained in the packet, to Grafana.
* `Simpe_network_topology`: is a python script for creating a mininet network.
* `Write_entries_scan`: is a python script for creating flow rules.

## Table0 in GTPV1-P4 pipeline

This table is redundant, because it's steer the traffic. In other word, the `table_encap_gtp` and  the `table_decap_gtp` have actions that are able to apply the GTP encap/decap and forward the traffic to a certain port. The `table0` have an action that simply forward a pkt from an input port to a certain aotput port. This table was introduced in the pipeline bacause during the development phase of the P4 program I used `iperf3` as a traffic generator, without this table the `iperf3` "management pkt" are not forwarded from the client to the server. In other word the `iperf3` connection fails. When I moved the GTPV1-P4 pipeline in a real enviroment I removed the `table0` from the pipeline and the real traffic generated in my real network is succesfully GTP encapsulated/decapsulated/steered.

## Steps to run GTPV1-P4 on Mininet

Copy the file `Simpe_network_topology` in the folder `behavioral-model/mininet`.

To run the mininet topology populated with [BMv2][BMv2] switches that have as a pipeline GTPV1-P4:

    sudo python Simpe_network_topology.py --behavioral-exe ../targets/simple_switch/simple_switch --json ../main.json --num-host 4

After running this command, you get a network topology formed by 3 bmv2 switches, `A,B,C`, connected in series. In the network are 4 hosts, `h1,h2,h3,h4`, where `h1,h2` are attached to `A`, `h3` is attached to `B` and `h4` is attached to `C`. 

To configure/inspect the flow rules in each switch by hand, you have to access the switch via `Simple_switch_CLI`, provided by behavioral model, e.g., 

    sudo Simple_switch_CLI --thrift-port portNumber
    
Once you accessed the switch via CLI you are able to configure the flow rules in each table via the commands provided by the CLI, e.g. `table_add`.

To load a set of flow rules in a switch from a file you can use:

    sudo Simple_switch_CLI --thrift-port portNumber < .../Commands_s1.txt

The `Command files`, in this repository, are written taking into account:
* `h1 -> h4`, the switch `A` provides GTP encap, `B` provides GTP steering ,`C` provides GTP decap.
* `h2 -> h3`, the switch `A` provides GTP encap, `B` provides GTP decap
* the switch `A` send the postcard telemetry related to the flow `h1 -> h4`, identified as a flow 1, and `h2 -> h3` identified as a flow 2.
* the switch `B` send the postcard telemetry related to the flow `h1 -> h4`, identified as a flow 1.

    
## Steps to run GTPV1-P4 on a single switch
   
[GTP.v1]: https://en.wikipedia.org/wiki/GPRS_Tunnelling_Protocol
[BMv2]: https://github.com/p4lang/behavioral-model
