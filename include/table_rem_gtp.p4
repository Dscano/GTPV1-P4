#ifndef __TABLE_REMOVE_GTP__
#define __TABLE_REMOVE_GTP__

#include "headers.p4"
#include "defines.p4"


control table_rem_gtp(inout headers_t hdr,
                        inout local_metadata_t local_metadata,
                       inout standard_metadata_t standard_metadata) {

    action decap_gtp(port_t port, report_t report) {

        standard_metadata.egress_spec = port;

        hdr.ipv4.setInvalid();
        hdr.udp.setInvalid();
        hdr.gtp_header.setInvalid();

        local_metadata.int_meta.report = report;
    }


    action set_output_change_teid (port_t port, teid_t teid, report_t report) {

        standard_metadata.egress_spec = port;
        hdr.gtp_header.teid = teid;

        local_metadata.int_meta.report = report;
    }


    table table_decap_gtp {
        key = {
            hdr.gtp_header.teid    : exact;
        }
        actions = {
            decap_gtp;
            set_output_change_teid;
            NoAction;
        }
        const default_action = NoAction();
       
    }

    apply {
        table_decap_gtp.apply();
     }
}

#endif