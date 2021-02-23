#ifndef __CHECKSUMS__
#define __CHECKSUMS__

#include "headers.p4"
#include "gtp_headers.p4"

control verify_checksum_control(inout headers_t hdr,
                                inout local_metadata_t local_metadata) {
    apply {
        // Assume checksum is always correct.
    }
}

control compute_checksum_control(inout headers_t hdr,
                                 inout local_metadata_t local_metadata) {
    apply {
        update_checksum(hdr.ipv4.isValid(),
            {
                hdr.ipv4.version,
                hdr.ipv4.ihl,
                hdr.ipv4.dscp,
                hdr.ipv4.ecn,
                hdr.ipv4.len,
                hdr.ipv4.identification,
                hdr.ipv4.flags,
                hdr.ipv4.frag_offset,
                hdr.ipv4.ttl,
                hdr.ipv4.protocol,
                hdr.ipv4.src_addr,
                hdr.ipv4.dst_addr
            },
            hdr.ipv4.hdr_checksum,
            HashAlgorithm.csum16
        );

        
        update_checksum(hdr.internal_ipv4.isValid(),
            {
                hdr.internal_ipv4.version,
                hdr.internal_ipv4.ihl,
                hdr.internal_ipv4.dscp,
                hdr.internal_ipv4.ecn,
                hdr.internal_ipv4.len,
                hdr.internal_ipv4.identification,
                hdr.internal_ipv4.flags,
                hdr.internal_ipv4.frag_offset,
                hdr.internal_ipv4.ttl,
                hdr.internal_ipv4.protocol,
                hdr.internal_ipv4.src_addr,
                hdr.internal_ipv4.dst_addr
            },
            hdr.internal_ipv4.hdr_checksum,
            HashAlgorithm.csum16
        );
         
    }
}

#endif
