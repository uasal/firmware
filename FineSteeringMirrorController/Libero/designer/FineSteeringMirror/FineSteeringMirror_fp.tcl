new_project \
         -name {FineSteeringMirror} \
         -location {/home/summer/projects/CGraph/firmware/FineSteeringMirrorTq144/Libero/designer/FineSteeringMirror/FineSteeringMirror_fp} \
         -mode {chain} \
         -connect_programmers {FALSE}
add_actel_device \
         -device {M2S010} \
         -name {M2S010}
enable_device \
         -name {M2S010} \
         -enable {TRUE}
save_project
close_project
