#Libero SoC uses “/” as the hierarchy separator and pin separators in the *.sdc file
create_clock -name CLK0_PAD -period 19.608
#create_generated_clock -name {<top_level_instance_name>/FCCC_C0_0/GL0} -multiply_by 2 -divide_by 1 -source [get_pins {<top_level_instance_name>/FCCC_C0_0/CCC_INST/GL0}]
#create_generated_clock -name {<top_level_instance_name>/FCCC_C0_0/GL1} -multiply_by 4 -divide_by 1 -source [get_pins {<top_level_instance_name>/FCCC_C0_0/CCC_INST/GL1}]
