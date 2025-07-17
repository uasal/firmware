open_project -project {/home/summer/projects/CGraph/firmware/FineSteeringMirrorController/Liberopeekfifos/designer/FineSteeringMirror/FineSteeringMirror_fp/FineSteeringMirror.pro}\
         -connect_programmers {FALSE}
load_programming_data \
    -name {M2S010} \
    -fpga {/home/summer/projects/CGraph/firmware/FineSteeringMirrorController/Liberopeekfifos/designer/FineSteeringMirror/FineSteeringMirror.map} \
    -header {/home/summer/projects/CGraph/firmware/FineSteeringMirrorController/Liberopeekfifos/designer/FineSteeringMirror/FineSteeringMirror.hdr} \
    -envm {/home/summer/projects/CGraph/firmware/FineSteeringMirrorController/Liberopeekfifos/designer/FineSteeringMirror/FineSteeringMirror.efc} \
    -spm {/home/summer/projects/CGraph/firmware/FineSteeringMirrorController/Liberopeekfifos/designer/FineSteeringMirror/FineSteeringMirror.spm} \
    -dca {/home/summer/projects/CGraph/firmware/FineSteeringMirrorController/Liberopeekfifos/designer/FineSteeringMirror/FineSteeringMirror.dca}
export_single_ppd \
    -name {M2S010} \
    -file {/home/summer/projects/CGraph/firmware/FineSteeringMirrorController/Liberopeekfifos/designer/FineSteeringMirror/FineSteeringMirror.ppd}

save_project
close_project
