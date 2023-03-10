
# DCI_CASCADE is required since banks 67 does not have 240 ohm resistor on VRP pin
# https://support.xilinx.com/s/article/67565?language=en_US
set_property DCI_CASCADE {67} [get_iobanks 68] 

# I2C signals for Camera 0
set_property PACKAGE_PIN K18 [get_ports iic_0_scl_io]; # LA03_N
set_property PACKAGE_PIN K19 [get_ports iic_0_sda_io]; # LA03_P
set_property IOSTANDARD LVCMOS12 [get_ports iic_0_*]
set_property SLEW SLOW [get_ports iic_0_*]
set_property DRIVE 4 [get_ports iic_0_*]

# I2C signals for Camera 1
set_property PACKAGE_PIN J17 [get_ports iic_1_scl_io]; # LA05_N
set_property PACKAGE_PIN K17 [get_ports iic_1_sda_io]; # LA05_P
set_property IOSTANDARD LVCMOS12 [get_ports iic_1_*]
set_property SLEW SLOW [get_ports iic_1_*]
set_property DRIVE 4 [get_ports iic_1_*]

# I2C signals for Camera 2
set_property PACKAGE_PIN J10 [get_ports iic_2_scl_io]; # LA29_N
set_property PACKAGE_PIN K10 [get_ports iic_2_sda_io]; # LA29_P
set_property IOSTANDARD LVCMOS12 [get_ports iic_2_*]
set_property SLEW SLOW [get_ports iic_2_*]
set_property DRIVE 4 [get_ports iic_2_*]

# I2C signals for Camera 3
set_property PACKAGE_PIN E8 [get_ports iic_3_scl_io]; # LA32_N
set_property PACKAGE_PIN F8 [get_ports iic_3_sda_io]; # LA32_P
set_property IOSTANDARD LVCMOS12 [get_ports iic_3_*]
set_property SLEW SLOW [get_ports iic_3_*]
set_property DRIVE 4 [get_ports iic_3_*]

# CAM3 CLK_SEL signal
set_property PACKAGE_PIN F15 [get_ports {clk_sel[0]}]; # LA13_N
set_property IOSTANDARD LVCMOS12 [get_ports {clk_sel[0]}]

# GPIOs
set_property PACKAGE_PIN J15 [get_ports {gpio_tri_o[0]}]; # LA07_N Camera 0: CAM_RST (active low)
set_property PACKAGE_PIN J16 [get_ports {gpio_tri_o[1]}]; # LA07_P Camera 1: CAM_RST (active low)
set_property PACKAGE_PIN G16 [get_ports {gpio_tri_o[2]}]; # LA09_N Camera 2: CAM_RST (active low)
set_property PACKAGE_PIN H16 [get_ports {gpio_tri_o[3]}]; # LA09_P Camera 3: CAM_RST (active low)
set_property PACKAGE_PIN F18 [get_ports {gpio_tri_o[4]}]; # LA12_N All cameras: FSIN (for synchronization)
set_property PACKAGE_PIN G18 [get_ports {gpio_tri_o[5]}]; # LA12_P Reserved
set_property PACKAGE_PIN G15 [get_ports {gpio_tri_o[6]}]; # LA13_P Reserved
set_property IOSTANDARD LVCMOS12 [get_ports {gpio_tri_o[*]}]

# MIPI interface 0
set_property PACKAGE_PIN F17 [get_ports {mipi_phy_if_0_clk_p}]; # LA00_CC_P
set_property PACKAGE_PIN F16 [get_ports {mipi_phy_if_0_clk_n}]; # LA00_CC_N
set_property PACKAGE_PIN L20 [get_ports {mipi_phy_if_0_data_p[0]}]; # LA02_P
set_property PACKAGE_PIN K20 [get_ports {mipi_phy_if_0_data_n[0]}]; # LA02_N
set_property PACKAGE_PIN L17 [get_ports {mipi_phy_if_0_data_p[1]}]; # LA04_P
set_property PACKAGE_PIN L16 [get_ports {mipi_phy_if_0_data_n[1]}]; # LA04_N
set_property PACKAGE_PIN H19 [get_ports {mipi_phy_if_0_data_p[2]}]; # LA06_P
set_property PACKAGE_PIN G19 [get_ports {mipi_phy_if_0_data_n[2]}]; # LA06_N
set_property PACKAGE_PIN L15 [get_ports {mipi_phy_if_0_data_p[3]}]; # LA10_P
set_property PACKAGE_PIN K15 [get_ports {mipi_phy_if_0_data_n[3]}]; # LA10_N

set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_phy_if_0_clk_p]
set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_phy_if_0_clk_n]
set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_phy_if_0_data_p[*]]
set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_phy_if_0_data_n[*]]

set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_phy_if_0_clk_p]
set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_phy_if_0_clk_n]
set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_phy_if_0_data_p[*]]
set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_phy_if_0_data_n[*]]

# MIPI interface 1
set_property PACKAGE_PIN H18 [get_ports {mipi_phy_if_1_clk_p}]; # LA01_CC_P
set_property PACKAGE_PIN H17 [get_ports {mipi_phy_if_1_clk_n}]; # LA01_CC_N
set_property PACKAGE_PIN C13 [get_ports {mipi_phy_if_1_data_p[0]}]; # LA14_P
set_property PACKAGE_PIN C12 [get_ports {mipi_phy_if_1_data_n[0]}]; # LA14_N
set_property PACKAGE_PIN D16 [get_ports {mipi_phy_if_1_data_p[1]}]; # LA15_P
set_property PACKAGE_PIN C16 [get_ports {mipi_phy_if_1_data_n[1]}]; # LA15_N
set_property PACKAGE_PIN D17 [get_ports {mipi_phy_if_1_data_p[2]}]; # LA16_P
set_property PACKAGE_PIN C17 [get_ports {mipi_phy_if_1_data_n[2]}]; # LA16_N
set_property PACKAGE_PIN E18 [get_ports {mipi_phy_if_1_data_p[3]}]; # LA08_P
set_property PACKAGE_PIN E17 [get_ports {mipi_phy_if_1_data_n[3]}]; # LA08_N

set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_phy_if_1_clk_p]
set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_phy_if_1_clk_n]
set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_phy_if_1_data_p[*]]
set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_phy_if_1_data_n[*]]

set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_phy_if_1_clk_p]
set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_phy_if_1_clk_n]
set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_phy_if_1_data_p[*]]
set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_phy_if_1_data_n[*]]

# MIPI interface 2
set_property PACKAGE_PIN D11 [get_ports {mipi_phy_if_2_clk_p}]; # LA18_CC_P
set_property PACKAGE_PIN D10 [get_ports {mipi_phy_if_2_clk_n}]; # LA18_CC_N
set_property PACKAGE_PIN B6 [get_ports {mipi_phy_if_2_data_p[0]}]; # LA24_P
set_property PACKAGE_PIN A6 [get_ports {mipi_phy_if_2_data_n[0]}]; # LA24_N
set_property PACKAGE_PIN C7 [get_ports {mipi_phy_if_2_data_p[1]}]; # LA25_P
set_property PACKAGE_PIN C6 [get_ports {mipi_phy_if_2_data_n[1]}]; # LA25_N
set_property PACKAGE_PIN D12 [get_ports {mipi_phy_if_2_data_p[2]}]; # LA19_P
set_property PACKAGE_PIN C11 [get_ports {mipi_phy_if_2_data_n[2]}]; # LA19_N
set_property PACKAGE_PIN F12 [get_ports {mipi_phy_if_2_data_p[3]}]; # LA20_P
set_property PACKAGE_PIN E12 [get_ports {mipi_phy_if_2_data_n[3]}]; # LA20_N

set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_phy_if_2_clk_p]
set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_phy_if_2_clk_n]
set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_phy_if_2_data_p[*]]
set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_phy_if_2_data_n[*]]

set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_phy_if_2_clk_p]
set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_phy_if_2_clk_n]
set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_phy_if_2_data_p[*]]
set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_phy_if_2_data_n[*]]

# MIPI interface 3
set_property PACKAGE_PIN F7 [get_ports {mipi_phy_if_3_clk_p}]; # LA31_P
set_property PACKAGE_PIN E7 [get_ports {mipi_phy_if_3_clk_n}]; # LA31_N
set_property PACKAGE_PIN M13 [get_ports {mipi_phy_if_3_data_p[0]}]; # LA28_P
set_property PACKAGE_PIN L13 [get_ports {mipi_phy_if_3_data_n[0]}]; # LA28_N
set_property PACKAGE_PIN C9 [get_ports {mipi_phy_if_3_data_p[1]}]; # LA33_P
set_property PACKAGE_PIN C8 [get_ports {mipi_phy_if_3_data_n[1]}]; # LA33_N
set_property PACKAGE_PIN H13 [get_ports {mipi_phy_if_3_data_p[2]}]; # LA22_P
set_property PACKAGE_PIN H12 [get_ports {mipi_phy_if_3_data_n[2]}]; # LA22_N
set_property PACKAGE_PIN E9 [get_ports {mipi_phy_if_3_data_p[3]}]; # LA30_P
set_property PACKAGE_PIN D9 [get_ports {mipi_phy_if_3_data_n[3]}]; # LA30_N

set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_phy_if_3_clk_p]
set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_phy_if_3_clk_n]
set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_phy_if_3_data_p[*]]
set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_phy_if_3_data_n[*]]

set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_phy_if_3_clk_p]
set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_phy_if_3_clk_n]
set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_phy_if_3_data_p[*]]
set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_phy_if_3_data_n[*]]

