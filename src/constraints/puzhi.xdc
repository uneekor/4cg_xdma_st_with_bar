
set_property IOSTANDARD LVCMOS33 [get_ports pcie_rstn]
set_property PACKAGE_PIN AE12 [get_ports pcie_rstn]


set_property PACKAGE_PIN Y6 [get_ports {pcie_clk_clk_p[0]}]
# set_property IOSTANDARD LVDS [get_ports {pcie_clk_clk_p[0]}]
create_clock -period 10.000 -name {pcie_clk_clk_p[0]} -waveform {0.000 5.000} [get_ports {pcie_clk_clk_p[0]}]


set_property PACKAGE_PIN L3 [get_ports sys_clk_200M_clk_p]
set_property IOSTANDARD LVDS [get_ports sys_clk_200M_clk_p]
create_clock -period 5.000 -name {sys_clk_200M} -waveform {0.000 2.500} [get_ports {sys_clk_200M_clk_p}]





# Channel primitive location constraint
set_property PACKAGE_PIN Y2 [get_ports {pcie_7x_mgt_rtl_0_rxp[1]}]
set_property PACKAGE_PIN W4 [get_ports {pcie_7x_mgt_rtl_0_txp[1]}]
set_property LOC GTHE4_CHANNEL_X0Y4 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[1].*gen_gthe4_channel_inst[0].GTHE4_CHANNEL_PRIM_INST}]
set_property PACKAGE_PIN V2 [get_ports {pcie_7x_mgt_rtl_0_rxp[0]}]
set_property PACKAGE_PIN U4 [get_ports {pcie_7x_mgt_rtl_0_txp[0]}]
set_property LOC GTHE4_CHANNEL_X0Y5 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[1].*gen_gthe4_channel_inst[1].GTHE4_CHANNEL_PRIM_INST}]



# Test LED
set_property PACKAGE_PIN AH6 [get_ports {led[0]}]
set_property PACKAGE_PIN AB5 [get_ports {led[1]}]
set_property PACKAGE_PIN AE4 [get_ports {led[2]}]
set_property PACKAGE_PIN AD10 [get_ports {led[3]}]
set_property PACKAGE_PIN AD11 [get_ports {led[4]}]
set_property PACKAGE_PIN AF12 [get_ports {led[5]}]
set_property PACKAGE_PIN AB10 [get_ports {led[6]}]
set_property PACKAGE_PIN AB9 [get_ports {led[7]}]

set_property IOSTANDARD LVCMOS33 [get_ports {led[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led[0]}]

