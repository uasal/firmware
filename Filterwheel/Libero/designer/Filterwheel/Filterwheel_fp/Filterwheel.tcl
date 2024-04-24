open_project -project {/home/summer/projects/CGraph/firmware/Filterwheel/Libero/designer/Filterwheel/Filterwheel_fp/Filterwheel.pro}\
         -connect_programmers {FALSE}
load_programming_data \
    -name {M2S025} \
    -fpga {/home/summer/projects/CGraph/firmware/Filterwheel/Libero/designer/Filterwheel/Filterwheel.map} \
    -header {/home/summer/projects/CGraph/firmware/Filterwheel/Libero/designer/Filterwheel/Filterwheel.hdr} \
    -envm {/home/summer/projects/CGraph/firmware/Filterwheel/Libero/designer/Filterwheel/Filterwheel.efc} \
    -spm {/home/summer/projects/CGraph/firmware/Filterwheel/Libero/designer/Filterwheel/Filterwheel.spm} \
    -dca {/home/summer/projects/CGraph/firmware/Filterwheel/Libero/designer/Filterwheel/Filterwheel.dca}
export_single_ppd \
    -name {M2S025} \
    -file {/home/summer/projects/CGraph/firmware/Filterwheel/Libero/designer/Filterwheel/Filterwheel.ppd}

save_project
close_project
