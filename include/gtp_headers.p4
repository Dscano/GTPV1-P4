/* -*- P4_16 -*- */
#ifndef __CUSTOM_HEADERS__
#define __CUSTOM_HEADERS__

#ifndef __GTP_HEADERS__
#define __GTP_HEADERS__

#include "telemetry_report_headers.p4"

// GTP v1 header
header gtp_header_t {
    bit<3>  ver;
    bit<1>  pt;
    bit<1>  rsvd;
    bit<1>  e;
    bit<1>  s;
    bit<1>  pn;
    bit<8>  msgtype;
    bit<16> total_len;
    bit<32> teid;
    //bit<16> sequence_number; 
    //bit<8>  npdu; 
    //bit<8>  next_ext_hdr;      // optional
}


struct headers_t {
    // INT Report Encapsulation
    ethernet_t report_ethernet;
    ipv4_t report_ipv4;
    udp_t report_udp;
    // INT Report Headers
    report_fixed_header_t report_fixed_header;
    //local_report_t report_local;
    // Original packet's headers
    ethernet_t ethernet;
    ipv4_t ipv4;
    udp_t udp;
    //ipv4_t internal_ipv4;
    gtp_header_t gtp_header;
    ipv4_t internal_ipv4;
    udp_t internal_udp;
}

struct int_metadata_t {
    bit<1>  report;
}

struct local_metadata_t {
    int_metadata_t int_meta;
    bool compute_checksum;
}

#endif // __GTP_HEADERS__
#endif // __CUSTOM_HEADERS__