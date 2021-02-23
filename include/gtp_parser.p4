/* -*- P4_16 -*- */
#ifndef __GTP_PARSER__
#define __GTP_PARSER__

parser gtp_parser (
    packet_in packet,
    out headers_t hdr,
    inout local_metadata_t local_metadata,
    inout standard_metadata_t standard_metadata) {
    state start {
        transition select(standard_metadata.ingress_port) {
            default: parse_ethernet;
        }
    }

    state parse_ethernet {
        packet.extract(hdr.ethernet);
        transition select(hdr.ethernet.ether_type) {
            ETH_TYPE_IPV4 : parse_ipv4;
        }
    }

    state parse_ipv4 {
        packet.extract(hdr.ipv4);
        transition select(hdr.ipv4.protocol) {
            IP_PROTO_UDP : parse_udp;
        }
    }
  
    state parse_udp {
        packet.extract(hdr.udp);
        transition select(hdr.udp.dst_port) {
            UDP_PORT_GTP: parse_gtp_header;
            default: accept;
        }
    }

    state parse_gtp_header {
        packet.extract(hdr.gtp_header);
        transition parse_internal_ipv4;
    }

     state parse_internal_ipv4 {
        packet.extract(hdr.internal_ipv4);
        transition select(hdr.internal_ipv4.protocol){
        IP_PROTO_UDP: internal_parse_udp;
        default: accept;
        }
        // transition accept;
    }

     state internal_parse_udp {
        packet.extract(hdr.internal_udp);
        transition accept;
       
    }

}

control gtp_deparser(
    packet_out packet,
    in headers_t hdr) {
    apply {

        // INT Report 
        packet.emit(hdr.report_ethernet);
        packet.emit(hdr.report_ipv4);
        packet.emit(hdr.report_udp);
        packet.emit(hdr.report_fixed_header);
        // PKT
        packet.emit(hdr.ethernet);
        packet.emit(hdr.ipv4);
        packet.emit(hdr.udp);
        packet.emit(hdr.gtp_header);
        packet.emit(hdr.internal_ipv4);
        packet.emit(hdr.internal_udp);
    
    }
}

#endif
