#ifndef __TABLEGTP__
#define __TABLEGTP__

#include "headers.p4"
#include "defines.p4"


control table_add_gtp(inout headers_t hdr,
                       inout local_metadata_t local_metadata,
                       inout standard_metadata_t standard_metadata) {

    action encap_gtp(teid_t teid, dst_t dst, port_t port, report_t report) {

    	standard_metadata.egress_spec = port;
    	
        //IP Gateway
        hdr.internal_ipv4 = hdr.ipv4;
        hdr.internal_udp = hdr.udp;

        hdr.ipv4.setValid();
        hdr.ipv4.src_addr = 0xa3a2ec56;
        hdr.ipv4.dst_addr = dst;
        hdr.ipv4.version  = IP_VERSION_4;
        hdr.ipv4.ihl = IPV4_MIN_IHL;
        hdr.ipv4.dscp = 0;
        hdr.ipv4.ecn = 0;
        hdr.ipv4.len = hdr.ipv4.len 
                + (IPV4_HDR_SIZE + UDP_HDR_SIZE+ GTP_HDR_SIZE);
        hdr.ipv4.identification = 0x1513;
        hdr.ipv4.flags = 0;
        hdr.ipv4.frag_offset = 0 ;
        hdr.ipv4.ttl = DEFAULT_IPV4_TTL;
        hdr.ipv4.protocol = IP_PROTO_UDP;

        //UDP
        hdr.udp.setValid();
        hdr.udp.src_port = 56005;
        hdr.udp.dst_port = UDP_PORT_GTP;
        hdr.udp.length_ = hdr.internal_ipv4.len + (UDP_HDR_SIZE +GTP_HDR_SIZE);
        hdr.udp.checksum = 0;

        //insert GTP header
        hdr.gtp_header.setValid();
        hdr.gtp_header.ver = GTP_VERSION;
        hdr.gtp_header.pt = 1;
        hdr.gtp_header.rsvd = 0;
        hdr.gtp_header.e = 0;
        hdr.gtp_header.s = 0;
        hdr.gtp_header.pn = 0;
        hdr.gtp_header.msgtype = GTP_MTYPE;
        hdr.gtp_header.total_len = hdr.ipv4.len;
        hdr.gtp_header.teid = teid;

        local_metadata.int_meta.report = report;


    }


    table table_encap_gtp {
        key = {
            hdr.ipv4.dst_addr   : exact;
            hdr.ipv4.src_addr   : exact;
            hdr.ipv4.protocol   : exact;
            
        }
        actions = {
            encap_gtp;
            NoAction;
        }
        const default_action = NoAction();
       
    }

    apply {
        table_encap_gtp.apply();
     }
}

#endif