#ifndef __TELEMETRY_REPORT_HEADERS__
#define __TELEMETRY_REPORT_HEADERS__

const bit<3> NPROTO_ETHERNET = 0;

// Report Telemetry Headers
header report_fixed_header_t {
    bit<4>  ver;
    bit<4>  len;
    bit<3>  nproto;
    bit<6>  rep_md_bits;
    bit<1>  d;
    bit<1>  q;
    bit<1>  f;
    bit<6>  rsvd;
    bit<6>  hw_id;
    bit<32> sw_id;
    bit<32> seq_no;
    bit<32> ingress_tstamp;
    bit<32> engress_tstamp;
}
const bit<8> REPORT_FIXED_HEADER_LEN = 16;

#endif