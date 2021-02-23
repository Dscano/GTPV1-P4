#include <core.p4>
#include <v1model.p4>

#include "include/defines.p4"
#include "include/int_definitions.p4"
#include "include/headers.p4"
#include "include/actions.p4"
#include "include/checksums.p4"

#include "include/gtp_headers.p4"
#include "include/gtp_parser.p4"

#include "include/table0.p4"
#include "include/table_add_gtp.p4"
#include "include/table_rem_gtp.p4"
#include "include/int_report.p4"





control ingress (
    inout headers_t hdr,
    inout local_metadata_t local_metadata,
    inout standard_metadata_t standard_metadata) {

    apply {
        table0_control.apply(hdr, local_metadata, standard_metadata);
        
        if(!hdr.gtp_header.isValid()) {
            table_add_gtp.apply(hdr, local_metadata, standard_metadata);
        }
        else {
             table_rem_gtp.apply(hdr, local_metadata, standard_metadata);
        }

        if (local_metadata.int_meta.report == 0x01) {
                //clone packet for Telemetry Report
                clone3(CloneType.I2E, REPORT_MIRROR_SESSION_ID, standard_metadata);
        }
       
    }
}

control egress (
    inout headers_t hdr,
    inout local_metadata_t local_metadata,
    inout standard_metadata_t standard_metadata) {
    
    apply {

    	if (IS_I2E_CLONE(standard_metadata)) {
                process_int_report.apply(hdr, local_metadata, standard_metadata);
            }
	}
}

V1Switch(
    gtp_parser(),
    verify_checksum_control(),
    ingress(),
    egress(),
    compute_checksum_control(),
    gtp_deparser()
) main;
