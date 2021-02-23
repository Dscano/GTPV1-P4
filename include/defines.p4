#ifndef __DEFINES__
#define __DEFINES__

#define ETH_TYPE_IPV4 0x0800
#define IP_PROTO_UDP 8w17
#define IP_PROTO_TCP 8w6
#define IP_VERSION_4 4w4
#define MAX_PORTS 511

//REPORT
#define ETH_REPORT_IPV4 0x1212
#define IP_PROTO_TCP 8w6
#define IPV4_IHL_MIN 4w5
#define UDP_PORT_REPO 54321
#define RETURN_PORT 2

#ifndef _BOOL
#define _BOOL bool
#endif
#ifndef _TRUE
#define _TRUE true
#endif
#ifndef _FALSE
#define _FALSE false
#endif

typedef bit<32> ip_address_t;
typedef bit<32> teid_t;
typedef bit<32> dst_t;
typedef bit<9>  port_t;
typedef bit<48> mac_t;
typedef bit<16> l4_port_t;
typedef bit<32> sw_id_t;
typedef bit<32> seq_t;
typedef bit<1> report_t;
const port_t CPU_PORT = 255;

#define ETH_HDR_SIZE 14
#define IPV4_HDR_SIZE 20
#define UDP_HDR_SIZE 8
#define GTP_HDR_SIZE 8

#define UDP_PORT_GTP 2152
#define GTP_VERSION 0x01
#define GTP_MTYPE 0xff

const bit<4> IPV4_MIN_IHL = 5;
const bit<8> DEFAULT_IPV4_TTL = 57;

#endif
