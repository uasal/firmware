open_project -project {C:\MicroSemiProj\LEDTest\designer\Blink\Blink_fp\Blink.pro}\
         -connect_programmers {FALSE}
load_programming_data \
    -name {M2S025} \
    -fpga {C:\MicroSemiProj\LEDTest\designer\Blink\Blink.map} \
    -header {C:\MicroSemiProj\LEDTest\designer\Blink\Blink.hdr} \
    -spm {C:\MicroSemiProj\LEDTest\designer\Blink\Blink.spm} \
    -dca {C:\MicroSemiProj\LEDTest\designer\Blink\Blink.dca}
export_single_ppd \
    -name {M2S025} \
    -file {C:\MicroSemiProj\LEDTest\designer\Blink\Blink.ppd}

save_project
close_project
