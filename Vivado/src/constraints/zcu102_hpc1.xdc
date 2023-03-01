
# As we use LA03_P, we need the following constraint
set_property UNAVAILABLE_DURING_CALIBRATION TRUE [get_ports iic_0_sda_io]

# I2C signals for Camera 0
set_property PACKAGE_PIN AJ1 [get_ports iic_0_scl_io]; # LA03_N
set_property PACKAGE_PIN AH1 [get_ports iic_0_sda_io]; # LA03_P
set_property IOSTANDARD LVCMOS12 [get_ports iic_0_*]
set_property SLEW SLOW [get_ports iic_0_*]
set_property DRIVE 4 [get_ports iic_0_*]

# I2C signals for Camera 1
set_property PACKAGE_PIN AH3 [get_ports iic_1_scl_io]; # LA05_N
set_property PACKAGE_PIN AG3 [get_ports iic_1_sda_io]; # LA05_P
set_property IOSTANDARD LVCMOS12 [get_ports iic_1_*]
set_property SLEW SLOW [get_ports iic_1_*]
set_property DRIVE 4 [get_ports iic_1_*]

# CAM3 CLK_SEL signal
set_property PACKAGE_PIN AH8 [get_ports {clk_sel[0]}]; # LA13_N
set_property IOSTANDARD LVCMOS12 [get_ports {clk_sel[0]}]

# GPIOs
set_property PACKAGE_PIN AE4 [get_ports {gpio_tri_o[0]}]; # LA07_N Camera 0: CAM_RST (active low)
set_property PACKAGE_PIN AD4 [get_ports {gpio_tri_o[1]}]; # LA07_P Camera 1: CAM_RST (active low)
set_property PACKAGE_PIN AE1 [get_ports {gpio_tri_o[2]}]; # LA09_N Camera 2: CAM_RST (active low)
set_property PACKAGE_PIN AE2 [get_ports {gpio_tri_o[3]}]; # LA09_P Camera 3: CAM_RST (active low)
set_property PACKAGE_PIN AD6 [get_ports {gpio_tri_o[4]}]; # LA12_N All cameras: FSIN (for synchronization)
set_property PACKAGE_PIN AD7 [get_ports {gpio_tri_o[5]}]; # LA12_P Reserved
set_property PACKAGE_PIN AG8 [get_ports {gpio_tri_o[6]}]; # LA13_P Reserved
set_property IOSTANDARD LVCMOS12 [get_ports {gpio_tri_o[*]}]

# MIPI interface 0
set_property PACKAGE_PIN AE5 [get_ports {mipi_phy_if_0_clk_p}]; # LA00_CC_P
set_property PACKAGE_PIN AF5 [get_ports {mipi_phy_if_0_clk_n}]; # LA00_CC_N
set_property PACKAGE_PIN AD2 [get_ports {mipi_phy_if_0_data_p[0]}]; # LA02_P
set_property PACKAGE_PIN AD1 [get_ports {mipi_phy_if_0_data_n[0]}]; # LA02_N
set_property PACKAGE_PIN AF2 [get_ports {mipi_phy_if_0_data_p[1]}]; # LA04_P
set_property PACKAGE_PIN AF1 [get_ports {mipi_phy_if_0_data_n[1]}]; # LA04_N
set_property PACKAGE_PIN AH2 [get_ports {mipi_phy_if_0_data_p[2]}]; # LA06_P
set_property PACKAGE_PIN AJ2 [get_ports {mipi_phy_if_0_data_n[2]}]; # LA06_N
set_property PACKAGE_PIN AH4 [get_ports {mipi_phy_if_0_data_p[3]}]; # LA10_P
set_property PACKAGE_PIN AJ4 [get_ports {mipi_phy_if_0_data_n[3]}]; # LA10_N

set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_phy_if_0_clk_p]
set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_phy_if_0_clk_n]
set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_phy_if_0_data_p[*]]
set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_phy_if_0_data_n[*]]

set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_phy_if_0_clk_p]
set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_phy_if_0_clk_n]
set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_phy_if_0_data_p[*]]
set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_phy_if_0_data_n[*]]

# MIPI interface 1
set_property PACKAGE_PIN AJ6 [get_ports {mipi_phy_if_1_clk_p}]; # LA01_CC_P
set_property PACKAGE_PIN AJ5 [get_ports {mipi_phy_if_1_clk_n}]; # LA01_CC_N
set_property PACKAGE_PIN AH7 [get_ports {mipi_phy_if_1_data_p[0]}]; # LA14_P
set_property PACKAGE_PIN AH6 [get_ports {mipi_phy_if_1_data_n[0]}]; # LA14_N
set_property PACKAGE_PIN AD10 [get_ports {mipi_phy_if_1_data_p[1]}]; # LA15_P
set_property PACKAGE_PIN AE9 [get_ports {mipi_phy_if_1_data_n[1]}]; # LA15_N
set_property PACKAGE_PIN AG10 [get_ports {mipi_phy_if_1_data_p[2]}]; # LA16_P
set_property PACKAGE_PIN AG9 [get_ports {mipi_phy_if_1_data_n[2]}]; # LA16_N
set_property PACKAGE_PIN AE3 [get_ports {mipi_phy_if_1_data_p[3]}]; # LA08_P
set_property PACKAGE_PIN AF3 [get_ports {mipi_phy_if_1_data_n[3]}]; # LA08_N

set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_phy_if_1_clk_p]
set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_phy_if_1_clk_n]
set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_phy_if_1_data_p[*]]
set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_phy_if_1_data_n[*]]

set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_phy_if_1_clk_p]
set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_phy_if_1_clk_n]
set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_phy_if_1_data_p[*]]
set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_phy_if_1_data_n[*]]

