open_project -project {/home/summer/projects/CGraph/firmware/FineSteeringMirrorTq144/Libero/designer/FineSteeringMirror/FineSteeringMirror_fp/FineSteeringMirror.pro}\
         -connect_programmers {FALSE}
set_programming_file -name {M2S010} -file {/home/summer/projects/CGraph/firmware/FineSteeringMirrorTq144/Libero/designer/FineSteeringMirror/FineSteeringMirror.ppd}
enable_procedure -name {M2S010} -action {PROGRAM} -procedure {DO_VERIFY} -enable {TRUE}
save_project
close_project
