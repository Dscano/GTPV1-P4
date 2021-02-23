#ifndef __TABLE0__
#define __TABLE0__

#include "headers.p4"
#include "defines.p4"

control table0_control(inout headers_t hdr,
                       inout local_metadata_t local_metadata,
                       inout standard_metadata_t standard_metadata) {

    action set_egress(port_t port) {
        standard_metadata.egress_spec = port;
    }

    action drop() {
        mark_to_drop(standard_metadata);
    }

    table table0 {
        key = {
    
            hdr.ethernet.ether_type          : exact;
            hdr.ethernet.src_addr            : exact;
            hdr.ethernet.dst_addr            : exact;

        }
        actions = {
            set_egress;
            NoAction;
         
        }
        const default_action = NoAction();
        
    }

    apply {
        table0.apply();
     }
}

#endif