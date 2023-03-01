# I2C signals for Camera 2
set_property PACKAGE_PIN AK4 [get_ports iic_2_scl_io]; # LA29_N
set_property PACKAGE_PIN AJ4 [get_ports iic_2_sda_io]; # LA29_P
set_property IOSTANDARD LVCMOS12 [get_ports iic_2_*]
set_property SLEW SLOW [get_ports iic_2_*]
set_property DRIVE 4 [get_ports iic_2_*]

# I2C signals for Camera 3
set_property PACKAGE_PIN AJ9 [get_ports iic_3_scl_io]; # LA32_N
set_property PACKAGE_PIN AH9 [get_ports iic_3_sda_io]; # LA32_P
set_property IOSTANDARD LVCMOS12 [get_ports iic_3_*]
set_property SLEW SLOW [get_ports iic_3_*]
set_property DRIVE 4 [get_ports iic_3_*]

# CAM3 CLK_SEL signal
set_property PACKAGE_PIN AK15 [get_ports {clk_sel[0]}]; # LA13_N
set_property IOSTANDARD LVCMOS12 [get_ports {clk_sel[0]}]

# GPIOs
set_property PACKAGE_PIN AB16 [get_ports {gpio_tri_o[0]}]; # LA07_N Camera 0: CAM_RST (active low)
set_property PACKAGE_PIN AA16 [get_ports {gpio_tri_o[1]}]; # LA07_P Camera 1: CAM_RST (active low)
set_property PACKAGE_PIN AK18 [get_ports {gpio_tri_o[2]}]; # LA09_N Camera 2: CAM_RST (active low)
set_property PACKAGE_PIN AK17 [get_ports {gpio_tri_o[3]}]; # LA09_P Camera 3: CAM_RST (active low)
set_property PACKAGE_PIN AK14 [get_ports {gpio_tri_o[4]}]; # LA12_N All cameras: FSIN (for synchronization)
set_property PACKAGE_PIN AJ14 [get_ports {gpio_tri_o[5]}]; # LA12_P Reserved
set_property PACKAGE_PIN AJ15 [get_ports {gpio_tri_o[6]}]; # LA13_P Reserved
set_property IOSTANDARD LVCMOS12 [get_ports {gpio_tri_o[*]}]

# MIPI interface 2
set_property PACKAGE_PIN AH6 [get_ports {mipi_phy_if_2_clk_p}]; # LA18_CC_P
set_property PACKAGE_PIN AJ6 [get_ports {mipi_phy_if_2_clk_n}]; # LA18_CC_N
set_property PACKAGE_PIN AK7 [get_ports {mipi_phy_if_2_data_p[0]}]; # LA24_P
set_property PACKAGE_PIN AK6 [get_ports {mipi_phy_if_2_data_n[0]}]; # LA24_N
set_property PACKAGE_PIN AF6 [get_ports {mipi_phy_if_2_data_p[1]}]; # LA25_P
set_property PACKAGE_PIN AF5 [get_ports {mipi_phy_if_2_data_n[1]}]; # LA25_N

set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_phy_if_2_clk_p]
set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_phy_if_2_clk_n]
set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_phy_if_2_data_p[*]]
set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_phy_if_2_data_n[*]]

set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_phy_if_2_clk_p]
set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_phy_if_2_clk_n]
set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_phy_if_2_data_p[*]]
set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_phy_if_2_data_n[*]]

# MIPI interface 3
set_property PACKAGE_PIN AK9 [get_ports {mipi_phy_if_3_clk_p}]; # LA26_P
set_property PACKAGE_PIN AK8 [get_ports {mipi_phy_if_3_clk_n}]; # LA26_N
set_property PACKAGE_PIN AJ11 [get_ports {mipi_phy_if_3_data_p[0]}]; # LA28_P
set_property PACKAGE_PIN AK11 [get_ports {mipi_phy_if_3_data_n[0]}]; # LA28_N
set_property PACKAGE_PIN AG11 [get_ports {mipi_phy_if_3_data_p[1]}]; # LA33_P
set_property PACKAGE_PIN AH11 [get_ports {mipi_phy_if_3_data_n[1]}]; # LA33_N

set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_phy_if_3_clk_p]
set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_phy_if_3_clk_n]
set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_phy_if_3_data_p[*]]
set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_phy_if_3_data_n[*]]

set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_phy_if_3_clk_p]
set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_phy_if_3_clk_n]
set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_phy_if_3_data_p[*]]
set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_phy_if_3_data_n[*]]

