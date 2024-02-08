open_project -project {/home/summer/projects/CGraph/firmware/DMInterface/TestFiles/designer/Blink/Blink_fp/Blink.pro}\
         -connect_programmers {FALSE}
load_programming_data \
    -name {M2S025} \
    -fpga {/home/summer/projects/CGraph/firmware/DMInterface/TestFiles/designer/Blink/Blink.map} \
    -header {/home/summer/projects/CGraph/firmware/DMInterface/TestFiles/designer/Blink/Blink.hdr} \
    -spm {/home/summer/projects/CGraph/firmware/DMInterface/TestFiles/designer/Blink/Blink.spm} \
    -dca {/home/summer/projects/CGraph/firmware/DMInterface/TestFiles/designer/Blink/Blink.dca}
export_single_ppd \
    -name {M2S025} \
    -file {/home/summer/projects/CGraph/firmware/DMInterface/TestFiles/designer/Blink/Blink.ppd}

save_project
close_project
