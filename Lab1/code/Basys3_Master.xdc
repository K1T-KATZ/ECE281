## This file is a general .xdc for the Basys3 rev B board
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

 
## Switches
set_property PACKAGE_PIN V17 [get_ports sw[0]]					
	set_property IOSTANDARD LVCMOS33 [get_ports sw[0]]
set_property PACKAGE_PIN V16 [get_ports {sw[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[1]}]
set_property PACKAGE_PIN W16 [get_ports {sw[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[2]}]
set_property PACKAGE_PIN W17 [get_ports {sw[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[3]}]

## LEDs
set_property PACKAGE_PIN U16 [get_ports o_led0]					
	set_property IOSTANDARD LVCMOS33 [get_ports o_led0]
