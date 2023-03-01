
# As we use LA03_P, we need the following constraint
set_property UNAVAILABLE_DURING_CALIBRATION TRUE [get_ports iic_0_sda_io]

# DCI_CASCADE is required since banks 66 and 67 do not have 240 ohm resistor on VRP pins
# https://support.xilinx.com/s/article/67565?language=en_US
set_property DCI_CASCADE {66 67} [get_iobanks 65] 

# I2C signals for Camera 0
set_property PACKAGE_PIN Y1 [get_ports iic_0_scl_io]; # LA03_N
set_property PACKAGE_PIN Y2 [get_ports iic_0_sda_io]; # LA03_P
set_property IOSTANDARD LVCMOS12 [get_ports iic_0_*]
set_property SLEW SLOW [get_ports iic_0_*]
set_property DRIVE 4 [get_ports iic_0_*]

# I2C signals for Camera 1
set_property PACKAGE_PIN AC3 [get_ports iic_1_scl_io]; # LA05_N
set_property PACKAGE_PIN AB3 [get_ports iic_1_sda_io]; # LA05_P
set_property IOSTANDARD LVCMOS12 [get_ports iic_1_*]
set_property SLEW SLOW [get_ports iic_1_*]
set_property DRIVE 4 [get_ports iic_1_*]

# I2C signals for Camera 2
set_property PACKAGE_PIN U8 [get_ports iic_2_scl_io]; # LA29_N
set_property PACKAGE_PIN U9 [get_ports iic_2_sda_io]; # LA29_P
set_property IOSTANDARD LVCMOS12 [get_ports iic_2_*]
set_property SLEW SLOW [get_ports iic_2_*]
set_property DRIVE 4 [get_ports iic_2_*]

# I2C signals for Camera 3
set_property PACKAGE_PIN T11 [get_ports iic_3_scl_io]; # LA32_N
set_property PACKAGE_PIN U11 [get_ports iic_3_sda_io]; # LA32_P
set_property IOSTANDARD LVCMOS12 [get_ports iic_3_*]
set_property SLEW SLOW [get_ports iic_3_*]
set_property DRIVE 4 [get_ports iic_3_*]

# CAM3 CLK_SEL signal
set_property PACKAGE_PIN AC8 [get_ports {clk_sel[0]}]; # LA13_N
set_property IOSTANDARD LVCMOS12 [get_ports {clk_sel[0]}]

# GPIOs
set_property PACKAGE_PIN U4 [get_ports {gpio_tri_o[0]}]; # LA07_N Camera 0: CAM_RST (active low)
set_property PACKAGE_PIN U5 [get_ports {gpio_tri_o[1]}]; # LA07_P Camera 1: CAM_RST (active low)
set_property PACKAGE_PIN W1 [get_ports {gpio_tri_o[2]}]; # LA09_N Camera 2: CAM_RST (active low)
set_property PACKAGE_PIN W2 [get_ports {gpio_tri_o[3]}]; # LA09_P Camera 3: CAM_RST (active low)
set_property PACKAGE_PIN W6 [get_ports {gpio_tri_o[4]}]; # LA12_N All cameras: FSIN (for synchronization)
set_property PACKAGE_PIN W7 [get_ports {gpio_tri_o[5]}]; # LA12_P Reserved
set_property PACKAGE_PIN AB8 [get_ports {gpio_tri_o[6]}]; # LA13_P Reserved
set_property IOSTANDARD LVCMOS12 [get_ports {gpio_tri_o[*]}]

# MIPI interface 0
set_property PACKAGE_PIN Y4 [get_ports {mipi_phy_if_0_clk_p}]; # LA00_CC_P
set_property PACKAGE_PIN Y3 [get_ports {mipi_phy_if_0_clk_n}]; # LA00_CC_N
set_property PACKAGE_PIN V2 [get_ports {mipi_phy_if_0_data_p[0]}]; # LA02_P
set_property PACKAGE_PIN V1 [get_ports {mipi_phy_if_0_data_n[0]}]; # LA02_N
set_property PACKAGE_PIN AA2 [get_ports {mipi_phy_if_0_data_p[1]}]; # LA04_P
set_property PACKAGE_PIN AA1 [get_ports {mipi_phy_if_0_data_n[1]}]; # LA04_N
set_property PACKAGE_PIN AC2 [get_ports {mipi_phy_if_0_data_p[2]}]; # LA06_P
set_property PACKAGE_PIN AC1 [get_ports {mipi_phy_if_0_data_n[2]}]; # LA06_N
set_property PACKAGE_PIN W5 [get_ports {mipi_phy_if_0_data_p[3]}]; # LA10_P
set_property PACKAGE_PIN W4 [get_ports {mipi_phy_if_0_data_n[3]}]; # LA10_N

set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_phy_if_0_clk_p]
set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_phy_if_0_clk_n]
set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_phy_if_0_data_p[*]]
set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_phy_if_0_data_n[*]]

set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_phy_if_0_clk_p]
set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_phy_if_0_clk_n]
set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_phy_if_0_data_p[*]]
set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_phy_if_0_data_n[*]]

# MIPI interface 1
set_property PACKAGE_PIN AB4 [get_ports {mipi_phy_if_1_clk_p}]; # LA01_CC_P
set_property PACKAGE_PIN AC4 [get_ports {mipi_phy_if_1_clk_n}]; # LA01_CC_N
set_property PACKAGE_PIN AC7 [get_ports {mipi_phy_if_1_data_p[0]}]; # LA14_P
set_property PACKAGE_PIN AC6 [get_ports {mipi_phy_if_1_data_n[0]}]; # LA14_N
set_property PACKAGE_PIN Y10 [get_ports {mipi_phy_if_1_data_p[1]}]; # LA15_P
set_property PACKAGE_PIN Y9 [get_ports {mipi_phy_if_1_data_n[1]}]; # LA15_N
set_property PACKAGE_PIN Y12 [get_ports {mipi_phy_if_1_data_p[2]}]; # LA16_P
set_property PACKAGE_PIN AA12 [get_ports {mipi_phy_if_1_data_n[2]}]; # LA16_N
set_property PACKAGE_PIN V4 [get_ports {mipi_phy_if_1_data_p[3]}]; # LA08_P
set_property PACKAGE_PIN V3 [get_ports {mipi_phy_if_1_data_n[3]}]; # LA08_N

set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_phy_if_1_clk_p]
set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_phy_if_1_clk_n]
set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_phy_if_1_data_p[*]]
set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_phy_if_1_data_n[*]]

set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_phy_if_1_clk_p]
set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_phy_if_1_clk_n]
set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_phy_if_1_data_p[*]]
set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_phy_if_1_data_n[*]]

# MIPI interface 2
set_property PACKAGE_PIN N9 [get_ports {mipi_phy_if_2_clk_p}]; # LA18_CC_P
set_property PACKAGE_PIN N8 [get_ports {mipi_phy_if_2_clk_n}]; # LA18_CC_N
set_property PACKAGE_PIN L12 [get_ports {mipi_phy_if_2_data_p[0]}]; # LA24_P
set_property PACKAGE_PIN K12 [get_ports {mipi_phy_if_2_data_n[0]}]; # LA24_N
set_property PACKAGE_PIN M11 [get_ports {mipi_phy_if_2_data_p[1]}]; # LA25_P
set_property PACKAGE_PIN L11 [get_ports {mipi_phy_if_2_data_n[1]}]; # LA25_N
set_property PACKAGE_PIN L13 [get_ports {mipi_phy_if_2_data_p[2]}]; # LA19_P
set_property PACKAGE_PIN K13 [get_ports {mipi_phy_if_2_data_n[2]}]; # LA19_N
set_property PACKAGE_PIN N13 [get_ports {mipi_phy_if_2_data_p[3]}]; # LA20_P
set_property PACKAGE_PIN M13 [get_ports {mipi_phy_if_2_data_n[3]}]; # LA20_N

set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_phy_if_2_clk_p]
set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_phy_if_2_clk_n]
set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_phy_if_2_data_p[*]]
set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_phy_if_2_data_n[*]]

set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_phy_if_2_clk_p]
set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_phy_if_2_clk_n]
set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_phy_if_2_data_p[*]]
set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_phy_if_2_data_n[*]]

# MIPI interface 3
set_property PACKAGE_PIN V8 [get_ports {mipi_phy_if_3_clk_p}]; # LA31_P
set_property PACKAGE_PIN V7 [get_ports {mipi_phy_if_3_clk_n}]; # LA31_N
set_property PACKAGE_PIN T7 [get_ports {mipi_phy_if_3_data_p[0]}]; # LA28_P
set_property PACKAGE_PIN T6 [get_ports {mipi_phy_if_3_data_n[0]}]; # LA28_N
set_property PACKAGE_PIN V12 [get_ports {mipi_phy_if_3_data_p[1]}]; # LA33_P
set_property PACKAGE_PIN V11 [get_ports {mipi_phy_if_3_data_n[1]}]; # LA33_N
set_property PACKAGE_PIN M15 [get_ports {mipi_phy_if_3_data_p[2]}]; # LA22_P
set_property PACKAGE_PIN M14 [get_ports {mipi_phy_if_3_data_n[2]}]; # LA22_N
set_property PACKAGE_PIN V6 [get_ports {mipi_phy_if_3_data_p[3]}]; # LA30_P
set_property PACKAGE_PIN U6 [get_ports {mipi_phy_if_3_data_n[3]}]; # LA30_N

set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_phy_if_3_clk_p]
set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_phy_if_3_clk_n]
set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_phy_if_3_data_p[*]]
set_property IOSTANDARD MIPI_DPHY_DCI [get_ports mipi_phy_if_3_data_n[*]]

set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_phy_if_3_clk_p]
set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_phy_if_3_clk_n]
set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_phy_if_3_data_p[*]]
set_property DIFF_TERM_ADV TERM_100 [get_ports mipi_phy_if_3_data_n[*]]

