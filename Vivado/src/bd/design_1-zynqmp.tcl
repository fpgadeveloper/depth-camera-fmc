################################################################
# Block diagram build script for Zynq MP designs
################################################################

# CHECKING IF PROJECT EXISTS
if { [get_projects -quiet] eq "" } {
   puts "ERROR: Please open or create a project!"
   return 1
}

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

create_bd_design $block_name

current_bd_design $block_name

set parentCell [get_bd_cells /]

# Get object for parentCell
set parentObj [get_bd_cells $parentCell]
if { $parentObj == "" } {
   puts "ERROR: Unable to find parent cell <$parentCell>!"
   return
}

# Make sure parentObj is hier blk
set parentType [get_property TYPE $parentObj]
if { $parentType ne "hier" } {
   puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
   return
}

# Save current instance; Restore later
set oldCurInst [current_bd_instance .]

# Set parent object as current
current_bd_instance $parentObj

dict set dp_dict zcu104 dpaux "MIO 27 .. 30"
dict set dp_dict zcu104 lane_sel "Dual Lower"
dict set dp_dict zcu104 ref_clk_freq "27"
dict set dp_dict zcu104 ref_clk_sel "Ref Clk3"
dict set dp_dict zcu102_hpc0 dpaux "MIO 27 .. 30"
dict set dp_dict zcu102_hpc0 lane_sel "Single Lower"
dict set dp_dict zcu102_hpc0 ref_clk_freq "27"
dict set dp_dict zcu102_hpc0 ref_clk_sel "Ref Clk3"
dict set dp_dict zcu102_hpc1 dpaux "MIO 27 .. 30"
dict set dp_dict zcu102_hpc1 lane_sel "Single Lower"
dict set dp_dict zcu102_hpc1 ref_clk_freq "27"
dict set dp_dict zcu102_hpc1 ref_clk_sel "Ref Clk3"
dict set dp_dict zcu106_hpc0 dpaux "MIO 27 .. 30"
dict set dp_dict zcu106_hpc0 lane_sel "Dual Lower"
dict set dp_dict zcu106_hpc0 ref_clk_freq "27"
dict set dp_dict zcu106_hpc0 ref_clk_sel "Ref Clk3"
dict set dp_dict uzev dpaux "MIO 27 .. 30"
dict set dp_dict uzev lane_sel "Single Higher"
dict set dp_dict uzev ref_clk_freq "27"
dict set dp_dict uzev ref_clk_sel "Ref Clk3"
dict set dp_dict pynqzu dpaux "MIO 27 .. 30"
dict set dp_dict pynqzu lane_sel "Dual Lower"
dict set dp_dict pynqzu ref_clk_freq "27"
dict set dp_dict pynqzu ref_clk_sel "Ref Clk1"
dict set dp_dict genesyszu dpaux "EMIO"
dict set dp_dict genesyszu lane_sel "Dual Higher"
dict set dp_dict genesyszu ref_clk_freq "108"
dict set dp_dict genesyszu ref_clk_sel "Ref Clk2"

# Procedure for creating a MIPI pipe for one camera
proc create_mipi_pipe { index loc_dict } {
  set hier_obj [create_bd_cell -type hier mipi_$index]
  current_bd_instance $hier_obj
  
  # Create pins of the block
  create_bd_pin -dir I dphy_clk_200M
  create_bd_pin -dir I s_axi_lite_aclk
  create_bd_pin -dir I aresetn
  create_bd_pin -dir I video_aclk
  create_bd_pin -dir I video_aresetn
  create_bd_pin -dir O mipi_sub_irq
  create_bd_pin -dir O demosaic_irq
  create_bd_pin -dir O gamma_lut_irq
  create_bd_pin -dir O vdma_s2mm_irq
  create_bd_pin -dir O vdma_mm2s_irq
  create_bd_pin -dir O iic2intc_irpt
  
  # Create the interfaces of the block
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_MM2S
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:mipi_phy_rtl:1.0 mipi_phy_if
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 IIC
  
  # Add and configure the MIPI Subsystem IP
  set clk_pin [dict get $loc_dict clk pin]
  set clk_pin_name [dict get $loc_dict clk pin_name]
  set data0_pin [dict get $loc_dict data0 pin]
  set data0_pin_name [dict get $loc_dict data0 pin_name]
  set data1_pin [dict get $loc_dict data1 pin]
  set data1_pin_name [dict get $loc_dict data1 pin_name]
  set bank [dict get $loc_dict bank]
  set mipi_csi2_rx_subsyst [ create_bd_cell -type ip -vlnv xilinx.com:ip:mipi_csi2_rx_subsystem:5.1 mipi_csi2_rx_subsyst_0 ]
  # If this is a four lane interface
  if { [dict exists $loc_dict data2] } {
    set data2_pin [dict get $loc_dict data2 pin]
    set data2_pin_name [dict get $loc_dict data2 pin_name]
    set data3_pin [dict get $loc_dict data3 pin]
    set data3_pin_name [dict get $loc_dict data3 pin_name]
    set_property -dict [ list \
      CONFIG.SupportLevel {1} \
      CONFIG.CMN_NUM_LANES {4} \
      CONFIG.CMN_PXL_FORMAT {RAW10} \
      CONFIG.C_DPHY_LANES {4} \
      CONFIG.CMN_NUM_PIXELS {2} \
      CONFIG.C_EN_CSI_V2_0 {true} \
      CONFIG.C_HS_LINE_RATE {420} \
      CONFIG.C_HS_SETTLE_NS {158} \
      CONFIG.DPY_LINE_RATE {420} \
      CONFIG.CLK_LANE_IO_LOC $clk_pin \
      CONFIG.CLK_LANE_IO_LOC_NAME $clk_pin_name \
      CONFIG.DATA_LANE0_IO_LOC $data0_pin \
      CONFIG.DATA_LANE0_IO_LOC_NAME $data0_pin_name \
      CONFIG.DATA_LANE1_IO_LOC $data1_pin \
      CONFIG.DATA_LANE1_IO_LOC_NAME $data1_pin_name \
      CONFIG.DATA_LANE2_IO_LOC $data2_pin \
      CONFIG.DATA_LANE2_IO_LOC_NAME $data2_pin_name \
      CONFIG.DATA_LANE3_IO_LOC $data3_pin \
      CONFIG.DATA_LANE3_IO_LOC_NAME $data3_pin_name \
      CONFIG.HP_IO_BANK_SELECTION $bank \
    ] $mipi_csi2_rx_subsyst
  } else {
    set_property -dict [ list \
      CONFIG.SupportLevel {1} \
      CONFIG.CMN_NUM_LANES {2} \
      CONFIG.CMN_PXL_FORMAT {RAW10} \
      CONFIG.C_DPHY_LANES {2} \
      CONFIG.CMN_NUM_PIXELS {2} \
      CONFIG.C_EN_CSI_V2_0 {true} \
      CONFIG.C_HS_LINE_RATE {420} \
      CONFIG.C_HS_SETTLE_NS {158} \
      CONFIG.DPY_LINE_RATE {420} \
      CONFIG.CLK_LANE_IO_LOC $clk_pin \
      CONFIG.CLK_LANE_IO_LOC_NAME $clk_pin_name \
      CONFIG.DATA_LANE0_IO_LOC $data0_pin \
      CONFIG.DATA_LANE0_IO_LOC_NAME $data0_pin_name \
      CONFIG.DATA_LANE1_IO_LOC $data1_pin \
      CONFIG.DATA_LANE1_IO_LOC_NAME $data1_pin_name \
      CONFIG.HP_IO_BANK_SELECTION $bank \
    ] $mipi_csi2_rx_subsyst
  }
  
  # Add and configure the AXI Interconnect
  set axi_int_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect axi_int_0 ]
  set_property -dict [list \
  CONFIG.NUM_MI {6} \
  ] $axi_int_0
  
  # Add and configure the AXIS Subset Converter
  set subset_conv_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_subset_converter subset_conv_0 ]
  set_property -dict [ list \
   CONFIG.M_TDATA_NUM_BYTES {2} \
   CONFIG.S_TDATA_NUM_BYTES {3} \
   CONFIG.TDATA_REMAP {tdata[19:12],tdata[9:2]} \
  ] $subset_conv_0
  
  # Add and configure the ILA
  set ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ila ila_0 ]
  set_property -dict [ list \
    CONFIG.C_ENABLE_ILA_AXI_MON {true} \
    CONFIG.C_MONITOR_TYPE {AXI} \
    CONFIG.C_NUM_OF_PROBES {9} \
    CONFIG.C_SLOT_0_AXI_PROTOCOL {AXI4S} \
  ] $ila_0
  
  # Add and configure demosaic
  set v_demosaic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_demosaic demosaic_0 ]
  set_property -dict [ list \
    CONFIG.SAMPLES_PER_CLOCK {2} \
    CONFIG.MAX_COLS {1920} \
    CONFIG.MAX_DATA_WIDTH {8} \
    CONFIG.MAX_ROWS {1080} \
  ] $v_demosaic_0
  
  # Add and configure the V Gamma LUT
  set v_gamma_lut [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_gamma_lut v_gamma_lut ]
  set_property -dict [ list \
    CONFIG.SAMPLES_PER_CLOCK {2} \
    CONFIG.MAX_COLS {1920} \
    CONFIG.MAX_DATA_WIDTH {8} \
    CONFIG.MAX_ROWS {1080} \
  ] $v_gamma_lut
  
  # Add and configure the Pixel packer
  # set pixel_pack_0 [create_bd_cell -type ip -vlnv xilinx.com:hls:pixel_pack:1.0 pixel_pack_0]
 
  # Add and configure the VDMA for writing only
  set vdma_0 [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma axi_vdma_0]
  set_property -dict [list \
   CONFIG.c_include_mm2s {1} \
   CONFIG.c_m_axis_mm2s_tdata_width {24} \
   CONFIG.c_num_fstores {4} \
   CONFIG.c_s2mm_linebuffer_depth {512} \
   CONFIG.c_s2mm_max_burst_length {8} \
  ] $vdma_0
  
  # Add the AXIS Subset converter at output of VDMA
  set subset_conv_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_subset_converter subset_conv_1 ]
  set tdata_remap "tdata[15:8],tdata[23:16],tdata[7:0]"
  set_property -dict [ list \
   CONFIG.M_HAS_TKEEP {1} \
   CONFIG.M_HAS_TLAST {1} \
   CONFIG.M_TDATA_NUM_BYTES {3} \
   CONFIG.M_TUSER_WIDTH {1} \
   CONFIG.S_HAS_TKEEP {1} \
   CONFIG.S_HAS_TLAST {1} \
   CONFIG.S_TDATA_NUM_BYTES {3} \
   CONFIG.S_TUSER_WIDTH {1} \
   CONFIG.TDATA_REMAP $tdata_remap \
   CONFIG.TKEEP_REMAP {tkeep[2:0]} \
   CONFIG.TLAST_REMAP {tlast[0]} \
   CONFIG.TUSER_REMAP {tuser[0:0]} \
 ] $subset_conv_1

  # Add and configure AXI IIC
  set axi_iic [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic axi_iic_0]
  
  # Connect the 200M D-PHY clock
  connect_bd_net [get_bd_pins dphy_clk_200M] [get_bd_pins mipi_csi2_rx_subsyst_0/dphy_clk_200M]
  # Connect the 250M video clock
  connect_bd_net [get_bd_pins video_aclk] [get_bd_pins mipi_csi2_rx_subsyst_0/video_aclk]
  connect_bd_net [get_bd_pins video_aclk] [get_bd_pins subset_conv_0/aclk]
  connect_bd_net [get_bd_pins video_aclk] [get_bd_pins subset_conv_1/aclk]
  connect_bd_net [get_bd_pins video_aclk] [get_bd_pins axi_vdma_0/s_axis_s2mm_aclk]
  connect_bd_net [get_bd_pins video_aclk] [get_bd_pins axi_vdma_0/m_axis_mm2s_aclk]
  connect_bd_net [get_bd_pins video_aclk] [get_bd_pins ila_0/clk]
  connect_bd_net [get_bd_pins video_aclk] [get_bd_pins demosaic_0/ap_clk]
  # connect_bd_net [get_bd_pins video_aclk] [get_bd_pins pixel_pack_0/ap_clk]
  connect_bd_net [get_bd_pins video_aclk] [get_bd_pins v_gamma_lut/ap_clk]
  connect_bd_net [get_bd_pins video_aclk] [get_bd_pins axi_int_0/M01_ACLK]
  connect_bd_net [get_bd_pins video_aclk] [get_bd_pins axi_int_0/M02_ACLK]
  # Connect the 100M AXI-Lite clock
  connect_bd_net [get_bd_pins s_axi_lite_aclk] [get_bd_pins axi_int_0/ACLK]
  connect_bd_net [get_bd_pins s_axi_lite_aclk] [get_bd_pins axi_int_0/S00_ACLK]
  connect_bd_net [get_bd_pins s_axi_lite_aclk] [get_bd_pins axi_int_0/M00_ACLK]
  connect_bd_net [get_bd_pins s_axi_lite_aclk] [get_bd_pins axi_int_0/M03_ACLK]
  connect_bd_net [get_bd_pins s_axi_lite_aclk] [get_bd_pins axi_int_0/M04_ACLK]
  connect_bd_net [get_bd_pins s_axi_lite_aclk] [get_bd_pins axi_int_0/M05_ACLK]
  connect_bd_net [get_bd_pins s_axi_lite_aclk] [get_bd_pins mipi_csi2_rx_subsyst_0/lite_aclk]
  connect_bd_net [get_bd_pins s_axi_lite_aclk] [get_bd_pins axi_vdma_0/s_axi_lite_aclk]
  connect_bd_net [get_bd_pins s_axi_lite_aclk] [get_bd_pins axi_vdma_0/m_axi_s2mm_aclk]
  connect_bd_net [get_bd_pins s_axi_lite_aclk] [get_bd_pins axi_vdma_0/m_axi_mm2s_aclk]
  connect_bd_net [get_bd_pins s_axi_lite_aclk] [get_bd_pins axi_iic_0/s_axi_aclk]
  # Connect the video resets
  connect_bd_net [get_bd_pins video_aresetn] [get_bd_pins subset_conv_0/aresetn]
  connect_bd_net [get_bd_pins video_aresetn] [get_bd_pins subset_conv_1/aresetn]
  connect_bd_net [get_bd_pins video_aresetn] [get_bd_pins v_gamma_lut/ap_rst_n]
  connect_bd_net [get_bd_pins video_aresetn] [get_bd_pins axi_int_0/M01_ARESETN] -boundary_type upper
  connect_bd_net [get_bd_pins video_aresetn] [get_bd_pins axi_int_0/M02_ARESETN] -boundary_type upper
  connect_bd_net [get_bd_pins video_aresetn] [get_bd_pins mipi_csi2_rx_subsyst_0/video_aresetn]
  connect_bd_net [get_bd_pins video_aresetn] [get_bd_pins demosaic_0/ap_rst_n]
  # connect_bd_net [get_bd_pins video_aresetn] [get_bd_pins pixel_pack_0/ap_rst_n]
  # Connect the AXI-Lite resets
  connect_bd_net [get_bd_pins aresetn] [get_bd_pins axi_int_0/ARESETN] -boundary_type upper
  connect_bd_net [get_bd_pins aresetn] [get_bd_pins axi_int_0/S00_ARESETN] -boundary_type upper
  connect_bd_net [get_bd_pins aresetn] [get_bd_pins axi_int_0/M00_ARESETN] -boundary_type upper
  connect_bd_net [get_bd_pins aresetn] [get_bd_pins axi_int_0/M03_ARESETN] -boundary_type upper
  connect_bd_net [get_bd_pins aresetn] [get_bd_pins axi_int_0/M04_ARESETN] -boundary_type upper
  connect_bd_net [get_bd_pins aresetn] [get_bd_pins axi_int_0/M05_ARESETN] -boundary_type upper
  connect_bd_net [get_bd_pins aresetn] [get_bd_pins mipi_csi2_rx_subsyst_0/lite_aresetn]
  connect_bd_net [get_bd_pins aresetn] [get_bd_pins axi_vdma_0/axi_resetn]
  connect_bd_net [get_bd_pins aresetn] [get_bd_pins axi_iic_0/s_axi_aresetn]
  # Connect AXI Lite interfaces
  connect_bd_intf_net -boundary_type upper [get_bd_intf_pins S_AXI_LITE] [get_bd_intf_pins axi_int_0/S00_AXI]
  connect_bd_intf_net -boundary_type upper [get_bd_intf_pins axi_int_0/M00_AXI] [get_bd_intf_pins mipi_csi2_rx_subsyst_0/csirxss_s_axi]
  connect_bd_intf_net -boundary_type upper [get_bd_intf_pins axi_int_0/M01_AXI] [get_bd_intf_pins demosaic_0/s_axi_CTRL]
  connect_bd_intf_net -boundary_type upper [get_bd_intf_pins axi_int_0/M02_AXI] [get_bd_intf_pins v_gamma_lut/s_axi_CTRL]
  # connect_bd_intf_net -boundary_type upper [get_bd_intf_pins axi_int_0/M02_AXI] [get_bd_intf_pins pixel_pack_0/s_axi_control]
  connect_bd_intf_net -boundary_type upper [get_bd_intf_pins axi_int_0/M03_AXI] [get_bd_intf_pins axi_vdma_0/S_AXI_LITE]
  connect_bd_intf_net -boundary_type upper [get_bd_intf_pins axi_int_0/M04_AXI] [get_bd_intf_pins axi_iic_0/S_AXI]
  # Connect the AXI Streaming interfaces
  connect_bd_intf_net [get_bd_intf_pins mipi_csi2_rx_subsyst_0/video_out] [get_bd_intf_pins subset_conv_0/S_AXIS]
  connect_bd_intf_net [get_bd_intf_pins ila_0/SLOT_0_AXIS] [get_bd_intf_pins subset_conv_0/S_AXIS]
  connect_bd_intf_net [get_bd_intf_pins subset_conv_0/M_AXIS] [get_bd_intf_pins demosaic_0/s_axis_video]
  connect_bd_intf_net [get_bd_intf_pins demosaic_0/m_axis_video] [get_bd_intf_pins v_gamma_lut/s_axis_video]
  # connect_bd_intf_net [get_bd_intf_pins v_gamma_lut/m_axis_video] [get_bd_intf_pins pixel_pack_0/stream_in_24]
  # connect_bd_intf_net [get_bd_intf_pins pixel_pack_0/stream_out_32] [get_bd_intf_pins axi_vdma_0/S_AXIS_S2MM]
  connect_bd_intf_net [get_bd_intf_pins v_gamma_lut/m_axis_video] [get_bd_intf_pins axi_vdma_0/S_AXIS_S2MM]
  connect_bd_intf_net [get_bd_intf_pins axi_vdma_0/M_AXIS_MM2S] [get_bd_intf_pins subset_conv_1/S_AXIS]
  connect_bd_intf_net [get_bd_intf_pins subset_conv_1/M_AXIS] [get_bd_intf_pins M_AXIS_MM2S]
  # Connect the MIPI D-PHY interface
  connect_bd_intf_net -boundary_type upper [get_bd_intf_pins mipi_phy_if] [get_bd_intf_pins mipi_csi2_rx_subsyst_0/mipi_phy_if]
  # Connect the VDMA AXI MM interfaces
  connect_bd_intf_net [get_bd_intf_pins M_AXI_S2MM] [get_bd_intf_pins axi_vdma_0/M_AXI_S2MM]
  connect_bd_intf_net [get_bd_intf_pins M_AXI_MM2S] [get_bd_intf_pins axi_vdma_0/M_AXI_MM2S]
  # Connect the I2C interface
  connect_bd_intf_net [get_bd_intf_pins IIC] [get_bd_intf_pins axi_iic_0/IIC]
  # Connect interrupts
  connect_bd_net [get_bd_pins mipi_sub_irq] [get_bd_pins mipi_csi2_rx_subsyst_0/csirxss_csi_irq]
  connect_bd_net [get_bd_pins demosaic_irq] [get_bd_pins demosaic_0/interrupt]
  connect_bd_net [get_bd_pins gamma_lut_irq] [get_bd_pins v_gamma_lut/interrupt]
  connect_bd_net [get_bd_pins vdma_s2mm_irq] [get_bd_pins axi_vdma_0/s2mm_introut]
  connect_bd_net [get_bd_pins vdma_mm2s_irq] [get_bd_pins axi_vdma_0/mm2s_introut]
  connect_bd_net [get_bd_pins iic2intc_irpt] [get_bd_pins axi_iic_0/iic2intc_irpt]
  
  current_bd_instance \
}

# AXI Lite ports
set axi_lite_ports {}

# List of interrupt pins
set intr_list {}

# Number of cameras
set num_cams [llength $cams]

# Add the Processor System and apply board preset
create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e zynq_ultra_ps_e_0
apply_bd_automation -rule xilinx.com:bd_rule:zynq_ultra_ps_e -config {apply_board_preset "1" }  [get_bd_cells zynq_ultra_ps_e_0]

# Configure the PS
set_property -dict [list CONFIG.PSU__USE__S_AXI_GP0 {1} \
  CONFIG.PSU__USE__M_AXI_GP0 {1} \
  CONFIG.PSU__USE__M_AXI_GP1 {0} \
  CONFIG.PSU__USE__M_AXI_GP2 {0} \
  CONFIG.PSU__USE__IRQ0 {1} \
  CONFIG.PSU__DISPLAYPORT__LANE0__ENABLE {1} \
  CONFIG.PSU__DISPLAYPORT__LANE0__IO {GT Lane1} \
  CONFIG.PSU__DISPLAYPORT__LANE1__ENABLE {1} \
  CONFIG.PSU__DISPLAYPORT__LANE1__IO {GT Lane0} \
  CONFIG.PSU__DISPLAYPORT__PERIPHERAL__ENABLE {1} \
  CONFIG.PSU__DPAUX__PERIPHERAL__ENABLE {1} \
  CONFIG.PSU__DPAUX__PERIPHERAL__IO [dict get $dp_dict $target dpaux] \
  CONFIG.PSU__DP__LANE_SEL [dict get $dp_dict $target lane_sel] \
  CONFIG.PSU__DP__REF_CLK_FREQ [dict get $dp_dict $target ref_clk_freq] \
  CONFIG.PSU__DP__REF_CLK_SEL [dict get $dp_dict $target ref_clk_sel] \
  CONFIG.PSU__USE__VIDEO {1} \
] [get_bd_cells zynq_ultra_ps_e_0]

# Add a processor system reset
create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset rst_ps_100M
connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins rst_ps_100M/slowest_sync_clk]
connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0] [get_bd_pins rst_ps_100M/ext_reset_in]

# Add and configure the clock wizard
set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz clk_wiz_0 ]
set_property -dict [ list \
  CONFIG.CLKOUT1_JITTER {85.182} \
  CONFIG.CLKOUT1_PHASE_ERROR {76.967} \
  CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {200.000} \
  CONFIG.CLKOUT2_JITTER {89.612} \
  CONFIG.CLKOUT2_PHASE_ERROR {76.967} \
  CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {150.000} \
  CONFIG.CLKOUT2_USED {true} \
  CONFIG.CLKOUT3_JITTER {81.911} \
  CONFIG.CLKOUT3_PHASE_ERROR {76.967} \
  CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {250.000} \
  CONFIG.CLKOUT3_USED {true} \
  CONFIG.MMCM_CLKFBOUT_MULT_F {15.000} \
  CONFIG.MMCM_CLKOUT0_DIVIDE_F {7.500} \
  CONFIG.MMCM_CLKOUT1_DIVIDE {10} \
  CONFIG.MMCM_CLKOUT2_DIVIDE {6} \
  CONFIG.NUM_OUT_CLKS {3} \
  CONFIG.RESET_PORT {resetn} \
  CONFIG.RESET_TYPE {ACTIVE_LOW} \
] $clk_wiz_0
connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins clk_wiz_0/clk_in1]
connect_bd_net [get_bd_pins rst_ps_100M/peripheral_aresetn] [get_bd_pins clk_wiz_0/resetn]

# Connect PS interface clocks
connect_bd_net [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins zynq_ultra_ps_e_0/maxihpm0_fpd_aclk]
connect_bd_net [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins zynq_ultra_ps_e_0/saxihpc0_fpd_aclk]

# Add and configure reset processor system for the AXI clock
set rst_ps_axi_150M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset rst_ps_axi_150M ]
connect_bd_net [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins rst_ps_axi_150M/slowest_sync_clk]
connect_bd_net [get_bd_pins rst_ps_100M/peripheral_aresetn] [get_bd_pins rst_ps_axi_150M/ext_reset_in]
connect_bd_net [get_bd_pins clk_wiz_0/locked] [get_bd_pins rst_ps_axi_150M/dcm_locked]

# Add and configure reset processor system for the video clock
set rst_video_250M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset rst_video_250M ]
connect_bd_net [get_bd_pins clk_wiz_0/clk_out3] [get_bd_pins rst_video_250M/slowest_sync_clk]
connect_bd_net [get_bd_pins rst_ps_100M/peripheral_aresetn] [get_bd_pins rst_video_250M/ext_reset_in]
connect_bd_net [get_bd_pins clk_wiz_0/locked] [get_bd_pins rst_video_250M/dcm_locked]

# # Add and configure AXI interrupt controller with concat
# set axi_interrupt [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc axi_intc_0]
# set_property -dict [list CONFIG.C_IRQ_CONNECTION {1}] $axi_interrupt
set concat_0 [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat xlconcat_0]
# connect_bd_net [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins axi_intc_0/s_axi_aclk]
# connect_bd_net [get_bd_pins xlconcat_0/dout] [get_bd_pins axi_intc_0/intr]
# connect_bd_net [get_bd_pins axi_intc_0/irq] [get_bd_pins zynq_ultra_ps_e_0/pl_ps_irq0]
# connect_bd_net [get_bd_pins rst_ps_axi_150M/peripheral_aresetn] [get_bd_pins axi_intc_0/s_axi_aresetn]
# lappend axi_lite_ports [list "axi_intc_0/s_axi" "clk_wiz_0/clk_out2" "rst_ps_axi_150M/peripheral_aresetn"]
connect_bd_net [get_bd_pins xlconcat_0/dout] [get_bd_pins zynq_ultra_ps_e_0/pl_ps_irq0]

# Add constant for the CAM3 CLK_SEL pin (1b for UltraZed-EV Carrier and Genesys ZU, 0b for all other boards)
set clk_sel [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant clk_sel]
set_property -dict [list CONFIG.CONST_WIDTH {1}] $clk_sel
if { $target == "uzev" } {
  set_property -dict [list CONFIG.CONST_VAL {0x01}] $clk_sel
} elseif { $target == "genesyszu" } {
  set_property -dict [list CONFIG.CONST_VAL {0x01}] $clk_sel
} else {
  set_property -dict [list CONFIG.CONST_VAL {0x00}] $clk_sel
}
create_bd_port -dir O clk_sel
connect_bd_net [get_bd_ports clk_sel] [get_bd_pins clk_sel/dout]

# Add and configure GPIO
set gpio [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio gpio]
set_property -dict [list CONFIG.C_GPIO_WIDTH {7} CONFIG.C_ALL_OUTPUTS {1}] $gpio
connect_bd_net [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins gpio/s_axi_aclk]
connect_bd_net [get_bd_pins rst_ps_axi_150M/peripheral_aresetn] [get_bd_pins gpio/s_axi_aresetn]
lappend axi_lite_ports [list "gpio/S_AXI" "clk_wiz_0/clk_out2" "rst_ps_axi_150M/peripheral_aresetn"]
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 gpio
connect_bd_intf_net [get_bd_intf_pins gpio/GPIO] [get_bd_intf_ports gpio]

# Add the AXI SmartConnect for the VDMAs
create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect smartconnect_0
connect_bd_net [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins smartconnect_0/aclk]
connect_bd_net [get_bd_pins rst_ps_axi_150M/peripheral_aresetn] [get_bd_pins smartconnect_0/aresetn]
connect_bd_intf_net [get_bd_intf_pins smartconnect_0/M00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HPC0_FPD]
set smartcon_ports [expr {$num_cams*2}]
set_property -dict [list CONFIG.NUM_SI $smartcon_ports] [get_bd_cells smartconnect_0]

# Add the MIPI pipes
set smartcon_index 0
foreach i $cams {
  # Create the MIPI pipe block
  create_mipi_pipe $i [dict get $mipi_loc_dict $target $i]
  # Externalize all of the strobe propagation pins
  set strobe_pins [get_bd_pins mipi_$i/mipi_csi2_rx_subsyst_0/bg*_nc]
  foreach strobe $strobe_pins {
    set strobe_pin_name [file tail $strobe]
    create_bd_port -dir I mipi_${i}_$strobe_pin_name
    connect_bd_net [get_bd_ports mipi_${i}_$strobe_pin_name] [get_bd_pins $strobe]
  }
  # Connect clocks
  connect_bd_net [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins mipi_$i/dphy_clk_200M]
  connect_bd_net [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins mipi_$i/s_axi_lite_aclk]
  connect_bd_net [get_bd_pins clk_wiz_0/clk_out3] [get_bd_pins mipi_$i/video_aclk]
  # Connect resets
  connect_bd_net [get_bd_pins rst_ps_axi_150M/peripheral_aresetn] [get_bd_pins mipi_$i/aresetn]
  connect_bd_net [get_bd_pins rst_video_250M/peripheral_aresetn] [get_bd_pins mipi_$i/video_aresetn]
  # Add interrupts to the interrupt list to be connected later
  lappend intr_list "mipi_$i/mipi_sub_irq"
  #lappend intr_list "mipi_$i/demosaic_irq"
  #lappend intr_list "mipi_$i/gamma_lut_irq"
  lappend intr_list "mipi_$i/vdma_s2mm_irq"
  lappend intr_list "mipi_$i/vdma_mm2s_irq"
  lappend intr_list "mipi_$i/iic2intc_irpt"
  
  # AXI Lite interfaces to be connected later
  lappend axi_lite_ports [list "mipi_$i/S_AXI_LITE" "clk_wiz_0/clk_out2" "rst_ps_axi_150M/peripheral_aresetn"]
  # Connect the MIPI D-Phy interface
  create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:mipi_phy_rtl:1.0 mipi_phy_if_$i
  connect_bd_intf_net [get_bd_intf_ports mipi_phy_if_$i] -boundary_type upper [get_bd_intf_pins mipi_$i/mipi_phy_if]
  # Connect the I2C interface
  create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_$i
  connect_bd_intf_net [get_bd_intf_ports iic_$i] [get_bd_intf_pins mipi_$i/IIC]
  # Connect the AXI MM interface of the VDMA
  connect_bd_intf_net -boundary_type upper [get_bd_intf_pins mipi_$i/M_AXI_S2MM] [get_bd_intf_pins smartconnect_0/S0${smartcon_index}_AXI]
  set smartcon_index [expr {$smartcon_index+1}]
  connect_bd_intf_net -boundary_type upper [get_bd_intf_pins mipi_$i/M_AXI_MM2S] [get_bd_intf_pins smartconnect_0/S0${smartcon_index}_AXI]
  set smartcon_index [expr {$smartcon_index+1}]
}

# Add a constant HIGH
set const_high [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant const_high]
set_property -dict [list CONFIG.CONST_WIDTH {1} CONFIG.CONST_VAL {1}] $const_high

# Add Clock Wizard to generate the DP video clock
set dp_vid_clk [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz dp_vid_clk ]
set_property -dict [ list \
  CONFIG.CLKOUT1_JITTER {138.108} \
  CONFIG.CLKOUT1_PHASE_ERROR {148.904} \
  CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {74.250} \
  CONFIG.MMCM_CLKFBOUT_MULT_F {24.875} \
  CONFIG.MMCM_CLKOUT0_DIVIDE_F {16.750} \
  CONFIG.MMCM_DIVCLK_DIVIDE {2} \
  CONFIG.USE_RESET {false} \
] $dp_vid_clk
connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins dp_vid_clk/clk_in1]

# Add and configure reset processor system for the DP video clock
set rst_dp_vid_74M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset rst_dp_vid_74M ]
connect_bd_net [get_bd_pins dp_vid_clk/clk_out1] [get_bd_pins rst_dp_vid_74M/slowest_sync_clk]
connect_bd_net [get_bd_pins rst_ps_100M/peripheral_aresetn] [get_bd_pins rst_dp_vid_74M/ext_reset_in]
connect_bd_net [get_bd_pins dp_vid_clk/locked] [get_bd_pins rst_dp_vid_74M/dcm_locked]

# Add the AXI4-Stream to Video Out IP
set axi4s_vid_out [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_axi4s_vid_out axi4s_vid_out ]
set_property -dict [ list \
  CONFIG.C_ADDR_WIDTH {12} \
  CONFIG.C_HAS_ASYNC_CLK {1} \
  CONFIG.C_NATIVE_COMPONENT_WIDTH {12} \
  CONFIG.C_S_AXIS_VIDEO_DATA_WIDTH {8} \
] $axi4s_vid_out
connect_bd_net [get_bd_pins clk_wiz_0/clk_out3] [get_bd_pins axi4s_vid_out/aclk]
connect_bd_net [get_bd_pins const_high/dout] [get_bd_pins axi4s_vid_out/aclken]
connect_bd_net [get_bd_pins const_high/dout] [get_bd_pins axi4s_vid_out/vid_io_out_ce]
connect_bd_net [get_bd_pins rst_video_250M/peripheral_aresetn] [get_bd_pins axi4s_vid_out/aresetn]
connect_bd_net [get_bd_pins dp_vid_clk/clk_out1] [get_bd_pins axi4s_vid_out/vid_io_out_clk]
connect_bd_net [get_bd_pins rst_dp_vid_74M/peripheral_reset] [get_bd_pins axi4s_vid_out/vid_io_out_reset]

# Add the Video Timing Controller IP
set v_tc [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_tc v_tc ]
set_property -dict [ list \
  CONFIG.VIDEO_MODE {1080p} \
  CONFIG.GEN_F0_VSYNC_VSTART {1083} \
  CONFIG.GEN_F1_VSYNC_VSTART {1083} \
  CONFIG.GEN_HACTIVE_SIZE {1920} \
  CONFIG.GEN_HSYNC_END {2052} \
  CONFIG.GEN_HFRAME_SIZE {2200} \
  CONFIG.GEN_F0_VSYNC_HSTART {1004} \
  CONFIG.GEN_F1_VSYNC_HSTART {1004} \
  CONFIG.GEN_F0_VSYNC_HEND {1004} \
  CONFIG.GEN_F1_VSYNC_HEND {1004} \
  CONFIG.GEN_F0_VFRAME_SIZE {1125} \
  CONFIG.GEN_F1_VFRAME_SIZE {1125} \
  CONFIG.GEN_F0_VSYNC_VEND {1088} \
  CONFIG.GEN_F1_VSYNC_VEND {1088} \
  CONFIG.GEN_F0_VBLANK_HEND {960} \
  CONFIG.GEN_F1_VBLANK_HEND {960} \
  CONFIG.GEN_HSYNC_START {2008} \
  CONFIG.GEN_VACTIVE_SIZE {1080} \
  CONFIG.GEN_F0_VBLANK_HSTART {960} \
  CONFIG.GEN_F1_VBLANK_HSTART {960} \
  CONFIG.enable_detection {false} \
  CONFIG.enable_generation {true} \
] $v_tc
connect_bd_net [get_bd_pins dp_vid_clk/clk_out1] [get_bd_pins v_tc/clk]
connect_bd_net [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins v_tc/s_axi_aclk]
connect_bd_net [get_bd_pins rst_dp_vid_74M/peripheral_aresetn] [get_bd_pins v_tc/resetn]
connect_bd_net [get_bd_pins rst_ps_axi_150M/peripheral_aresetn] [get_bd_pins v_tc/s_axi_aresetn]
connect_bd_intf_net [get_bd_intf_pins v_tc/vtiming_out] [get_bd_intf_pins axi4s_vid_out/vtiming_in]
lappend axi_lite_ports [list "v_tc/ctrl" "clk_wiz_0/clk_out2" "rst_ps_axi_150M/peripheral_aresetn"]
connect_bd_net [get_bd_pins axi4s_vid_out/vtg_ce] [get_bd_pins v_tc/gen_clken]
connect_bd_net [get_bd_pins const_high/dout] [get_bd_pins v_tc/clken]
connect_bd_net [get_bd_pins const_high/dout] [get_bd_pins v_tc/s_axi_aclken]

# Connect DP signals
connect_bd_net [get_bd_pins axi4s_vid_out/vid_active_video] [get_bd_pins zynq_ultra_ps_e_0/dp_live_video_in_de]
connect_bd_net [get_bd_pins axi4s_vid_out/vid_data] [get_bd_pins zynq_ultra_ps_e_0/dp_live_video_in_pixel1]
connect_bd_net [get_bd_pins axi4s_vid_out/vid_hsync] [get_bd_pins zynq_ultra_ps_e_0/dp_live_video_in_hsync]
connect_bd_net [get_bd_pins axi4s_vid_out/vid_vsync] [get_bd_pins zynq_ultra_ps_e_0/dp_live_video_in_vsync]
connect_bd_net [get_bd_pins dp_vid_clk/clk_out1] [get_bd_pins zynq_ultra_ps_e_0/dp_video_in_clk]
# Connect DP Auxiliary channel on targets that route it via EMIO
if {[dict get $dp_dict $target dpaux] == "EMIO"} {
  # Inverter for the dp_aux_data_oe_n signal
  set invert_dp_aux_doe [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic invert_dp_aux_doe ]
  set_property -dict [ list \
    CONFIG.C_OPERATION {not} \
    CONFIG.C_SIZE {1} \
    CONFIG.LOGO_FILE {data/sym_notgate.png} \
  ] $invert_dp_aux_doe
  # Create the external ports
  set dp_aux_din [ create_bd_port -dir I dp_aux_din ]
  set dp_aux_doe [ create_bd_port -dir O -from 0 -to 0 dp_aux_doe ]
  set dp_aux_dout [ create_bd_port -dir O dp_aux_dout ]
  set dp_aux_hotplug_detect [ create_bd_port -dir I dp_aux_hotplug_detect ]
  # Connect the ports
  connect_bd_net [get_bd_ports dp_aux_din] [get_bd_pins zynq_ultra_ps_e_0/dp_aux_data_in]
  connect_bd_net [get_bd_ports dp_aux_hotplug_detect] [get_bd_pins zynq_ultra_ps_e_0/dp_hot_plug_detect]
  connect_bd_net [get_bd_ports dp_aux_doe] [get_bd_pins invert_dp_aux_doe/Res]
  connect_bd_net [get_bd_pins invert_dp_aux_doe/Op1] [get_bd_pins zynq_ultra_ps_e_0/dp_aux_data_oe_n]  
  connect_bd_net [get_bd_ports dp_aux_dout] [get_bd_pins zynq_ultra_ps_e_0/dp_aux_data_out]
}

# Add the AXIS Switch to select between the potential four video outputs
set axis_switch [create_bd_cell -type ip -vlnv xilinx.com:ip:axis_switch axis_switch]
set_property -dict [list \
  CONFIG.ROUTING_MODE {1} \
  CONFIG.NUM_SI $num_cams \
  ] $axis_switch
connect_bd_net [get_bd_pins clk_wiz_0/clk_out3] [get_bd_pins axis_switch/aclk]
connect_bd_net [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins axis_switch/s_axi_ctrl_aclk]
connect_bd_net [get_bd_pins rst_video_250M/peripheral_aresetn] [get_bd_pins axis_switch/aresetn]
connect_bd_net [get_bd_pins rst_ps_axi_150M/peripheral_aresetn] [get_bd_pins axis_switch/s_axi_ctrl_aresetn]
set switch_index 0
foreach i $cams {
  connect_bd_intf_net [get_bd_intf_pins mipi_$i/M_AXIS_MM2S] [get_bd_intf_pins axis_switch/S0${switch_index}_AXIS]
  set switch_index [expr {$switch_index+1}]
}
connect_bd_intf_net [get_bd_intf_pins axis_switch/M00_AXIS] [get_bd_intf_pins axi4s_vid_out/video_in]

# Add AXI Interconnect for the AXI Lite interfaces

set n_periph_ports [llength $axi_lite_ports]
set axi_periph_0 [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect axi_periph_0]
set_property -dict [list CONFIG.NUM_MI $n_periph_ports] $axi_periph_0
connect_bd_net [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins axi_periph_0/ACLK]
connect_bd_net [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins axi_periph_0/S00_ACLK]
connect_bd_net [get_bd_pins rst_ps_axi_150M/peripheral_aresetn] [get_bd_pins axi_periph_0/ARESETN]
connect_bd_net [get_bd_pins rst_ps_axi_150M/peripheral_aresetn] [get_bd_pins axi_periph_0/S00_ARESETN]
connect_bd_intf_net [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM0_FPD] -boundary_type upper [get_bd_intf_pins axi_periph_0/S00_AXI]
# Attach all of the ports, their clocks and resets
set port_num 0
foreach port $axi_lite_ports {
  puts $port
  set port_label [lindex $port 0]
  connect_bd_intf_net -boundary_type upper [get_bd_intf_pins axi_periph_0/M0${port_num}_AXI] [get_bd_intf_pins $port_label]
  set port_clk [lindex $port 1]
  connect_bd_net [get_bd_pins $port_clk] [get_bd_pins axi_periph_0/M0${port_num}_ACLK]
  set port_rst [lindex $port 2]
  connect_bd_net [get_bd_pins $port_rst] [get_bd_pins axi_periph_0/M0${port_num}_ARESETN]
  set port_num [expr {$port_num+1}]
}

# Connect the interrupts
set n_interrupts [llength $intr_list]
if { $n_interrupts > 8 } {
  set_property -dict [list CONFIG.NUM_PORTS 8] $concat_0
  set_property -dict [list CONFIG.PSU__USE__IRQ1 {1}] [get_bd_cells zynq_ultra_ps_e_0]
  set concat_1 [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat xlconcat_1]
  connect_bd_net [get_bd_pins xlconcat_1/dout] [get_bd_pins zynq_ultra_ps_e_0/pl_ps_irq1]
  set extra_intrs [expr {$n_interrupts-8}]
  set_property -dict [list CONFIG.NUM_PORTS $extra_intrs] $concat_1
} else {
  set_property -dict [list CONFIG.NUM_PORTS $n_interrupts] $concat_0
}
set intr_index 0
set concat_target xlconcat_0
foreach intr $intr_list {
  connect_bd_net [get_bd_pins $intr] [get_bd_pins ${concat_target}/In$intr_index]
  if { $intr_index == 7 } {
    set intr_index 0
    set concat_target xlconcat_1
  } else {
    set intr_index [expr {$intr_index+1}]
  }
}

# Assign addresses
assign_bd_address

# Restore current instance
current_bd_instance $oldCurInst

save_bd_design
