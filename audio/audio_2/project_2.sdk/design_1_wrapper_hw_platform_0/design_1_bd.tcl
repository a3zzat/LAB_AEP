
################################################################
# This is a generated script based on design: design_1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2015.4
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   puts "ERROR: This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_1_script.tcl

# If you do not already have a project created,
# you can create a project using the following command:
#    create_project project_1 myproj -part xc7z020clg484-1
#    set_property BOARD_PART em.avnet.com:zed:part0:1.3 [current_project]

# CHECKING IF PROJECT EXISTS
if { [get_projects -quiet] eq "" } {
   puts "ERROR: Please open or create a project!"
   return 1
}



# CHANGE DESIGN NAME HERE
set design_name design_1

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "ERROR: Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      puts "INFO: Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   puts "INFO: Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   puts "INFO: Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   puts "INFO: Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

puts "INFO: Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   puts $errMsg
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

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


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]

  # Create ports
  set adau1761_adc_sdata [ create_bd_port -dir I adau1761_adc_sdata ]
  set adau1761_bclk [ create_bd_port -dir I adau1761_bclk ]
  set adau1761_cclk [ create_bd_port -dir O adau1761_cclk ]
  set adau1761_cdata [ create_bd_port -dir O adau1761_cdata ]
  set adau1761_clatchn [ create_bd_port -dir O adau1761_clatchn ]
  set adau1761_cout [ create_bd_port -dir I adau1761_cout ]
  set adau1761_dac_sdata [ create_bd_port -dir O adau1761_dac_sdata ]
  set adau1761_lrclk [ create_bd_port -dir I adau1761_lrclk ]
  set adau1761_mclk [ create_bd_port -dir O adau1761_mclk ]
  set led0 [ create_bd_port -dir O led0 ]

  # Create instance: adau1761_controller_0, and set properties
  set adau1761_controller_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:adau1761_controller:1.0 adau1761_controller_0 ]

  # Create instance: adau1761_data_0, and set properties
  set adau1761_data_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:adau1761_data:1.0 adau1761_data_0 ]

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.2 clk_wiz_0 ]
  set_property -dict [ list \
CONFIG.CLKOUT1_JITTER {305.592} \
CONFIG.CLKOUT1_PHASE_ERROR {298.923} \
CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {24} \
CONFIG.FEEDBACK_SOURCE {FDBK_AUTO} \
CONFIG.MMCM_CLKFBOUT_MULT_F {50.250} \
CONFIG.MMCM_CLKOUT0_DIVIDE_F {41.875} \
CONFIG.MMCM_COMPENSATION {ZHOLD} \
CONFIG.MMCM_DIVCLK_DIVIDE {5} \
CONFIG.RESET_PORT {resetn} \
CONFIG.RESET_TYPE {ACTIVE_LOW} \
 ] $clk_wiz_0

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list \
CONFIG.preset {ZedBoard} \
 ] $processing_system7_0

  # Create instance: processing_system7_0_axi_periph, and set properties
  set processing_system7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 processing_system7_0_axi_periph ]
  set_property -dict [ list \
CONFIG.NUM_MI {2} \
 ] $processing_system7_0_axi_periph

  # Create instance: rst_processing_system7_0_100M, and set properties
  set rst_processing_system7_0_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_processing_system7_0_100M ]

  # Create interface connections
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins processing_system7_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M00_AXI [get_bd_intf_pins adau1761_controller_0/S00_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M01_AXI [get_bd_intf_pins adau1761_data_0/S00_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M01_AXI]

  # Create port connections
  connect_bd_net -net adau1761_adc_sdata_1 [get_bd_ports adau1761_adc_sdata] [get_bd_pins adau1761_data_0/adau1761_adc_sdata]
  connect_bd_net -net adau1761_bclk_1 [get_bd_ports adau1761_bclk] [get_bd_pins adau1761_data_0/adau1761_bclk]
  connect_bd_net -net adau1761_controller_0_adau1761_cclk [get_bd_ports adau1761_cclk] [get_bd_pins adau1761_controller_0/adau1761_cclk]
  connect_bd_net -net adau1761_controller_0_adau1761_cdata [get_bd_ports adau1761_cdata] [get_bd_pins adau1761_controller_0/adau1761_cdata]
  connect_bd_net -net adau1761_controller_0_adau1761_clatchn [get_bd_ports adau1761_clatchn] [get_bd_pins adau1761_controller_0/adau1761_clatchn]
  connect_bd_net -net adau1761_cout_1 [get_bd_ports adau1761_cout] [get_bd_pins adau1761_controller_0/adau1761_cout]
  connect_bd_net -net adau1761_data_0_adau1761_dac_sdata [get_bd_ports adau1761_dac_sdata] [get_bd_pins adau1761_data_0/adau1761_dac_sdata]
  connect_bd_net -net adau1761_lrclk_1 [get_bd_ports adau1761_lrclk] [get_bd_pins adau1761_data_0/adau1761_lrclk]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_ports adau1761_mclk] [get_bd_pins clk_wiz_0/clk_out1]
  connect_bd_net -net clk_wiz_0_locked [get_bd_ports led0] [get_bd_pins clk_wiz_0/locked]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins adau1761_controller_0/s00_axi_aclk] [get_bd_pins adau1761_data_0/s00_axi_aclk] [get_bd_pins clk_wiz_0/clk_in1] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0_axi_periph/ACLK] [get_bd_pins processing_system7_0_axi_periph/M00_ACLK] [get_bd_pins processing_system7_0_axi_periph/M01_ACLK] [get_bd_pins processing_system7_0_axi_periph/S00_ACLK] [get_bd_pins rst_processing_system7_0_100M/slowest_sync_clk]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins clk_wiz_0/resetn] [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_processing_system7_0_100M/ext_reset_in]
  connect_bd_net -net rst_processing_system7_0_100M_interconnect_aresetn [get_bd_pins processing_system7_0_axi_periph/ARESETN] [get_bd_pins rst_processing_system7_0_100M/interconnect_aresetn]
  connect_bd_net -net rst_processing_system7_0_100M_peripheral_aresetn [get_bd_pins adau1761_controller_0/s00_axi_aresetn] [get_bd_pins adau1761_data_0/s00_axi_aresetn] [get_bd_pins processing_system7_0_axi_periph/M00_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M01_ARESETN] [get_bd_pins processing_system7_0_axi_periph/S00_ARESETN] [get_bd_pins rst_processing_system7_0_100M/peripheral_aresetn]

  # Create address segments
  create_bd_addr_seg -range 0x10000 -offset 0x43C00000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs adau1761_controller_0/S00_AXI/S00_AXI_reg] SEG_adau1761_controller_0_S00_AXI_reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C10000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs adau1761_data_0/S00_AXI/S00_AXI_reg] SEG_adau1761_data_0_S00_AXI_reg

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   guistr: "# # String gsaved with Nlview 6.5.5  2015-06-26 bk=1.3371 VDI=38 GEI=35 GUI=JA:1.6
#  -string -flagsOSRD
preplace port DDR -pg 1 -y 40 -defaultsOSRD
preplace port adau1761_dac_sdata -pg 1 -y 380 -defaultsOSRD
preplace port adau1761_lrclk -pg 1 -y 460 -defaultsOSRD
preplace port adau1761_clatchn -pg 1 -y 220 -defaultsOSRD
preplace port adau1761_cdata -pg 1 -y 240 -defaultsOSRD
preplace port adau1761_cclk -pg 1 -y 200 -defaultsOSRD
preplace port led0 -pg 1 -y 530 -defaultsOSRD
preplace port adau1761_cout -pg 1 -y 250 -defaultsOSRD
preplace port FIXED_IO -pg 1 -y 60 -defaultsOSRD
preplace port adau1761_mclk -pg 1 -y 510 -defaultsOSRD
preplace port adau1761_bclk -pg 1 -y 440 -defaultsOSRD
preplace port adau1761_adc_sdata -pg 1 -y 480 -defaultsOSRD
preplace inst rst_processing_system7_0_100M -pg 1 -lvl 1 -y 360 -defaultsOSRD
preplace inst clk_wiz_0 -pg 1 -lvl 3 -y 520 -defaultsOSRD
preplace inst adau1761_data_0 -pg 1 -lvl 3 -y 380 -defaultsOSRD
preplace inst adau1761_controller_0 -pg 1 -lvl 3 -y 220 -defaultsOSRD
preplace inst processing_system7_0_axi_periph -pg 1 -lvl 2 -y 200 -defaultsOSRD
preplace inst processing_system7_0 -pg 1 -lvl 1 -y 120 -defaultsOSRD
preplace netloc processing_system7_0_DDR 1 1 3 NJ 40 NJ 40 NJ
preplace netloc adau1761_bclk_1 1 0 3 NJ 450 NJ 410 NJ
preplace netloc clk_wiz_0_locked 1 3 1 NJ
preplace netloc processing_system7_0_axi_periph_M00_AXI 1 2 1 N
preplace netloc processing_system7_0_M_AXI_GP0 1 1 1 410
preplace netloc processing_system7_0_FCLK_RESET0_N 1 0 3 30 270 430 530 NJ
preplace netloc rst_processing_system7_0_100M_peripheral_aresetn 1 1 2 450 400 820
preplace netloc adau1761_adc_sdata_1 1 0 3 NJ 470 NJ 430 NJ
preplace netloc adau1761_data_0_adau1761_dac_sdata 1 3 1 NJ
preplace netloc adau1761_controller_0_adau1761_cclk 1 3 1 NJ
preplace netloc processing_system7_0_FIXED_IO 1 1 3 NJ 60 NJ 60 NJ
preplace netloc adau1761_lrclk_1 1 0 3 NJ 460 NJ 420 NJ
preplace netloc clk_wiz_0_clk_out1 1 3 1 NJ
preplace netloc adau1761_cout_1 1 0 3 NJ 250 NJ 350 NJ
preplace netloc adau1761_controller_0_adau1761_clatchn 1 3 1 NJ
preplace netloc rst_processing_system7_0_100M_interconnect_aresetn 1 1 1 410
preplace netloc processing_system7_0_FCLK_CLK0 1 0 3 20 260 460 340 790
preplace netloc adau1761_controller_0_adau1761_cdata 1 3 1 NJ
preplace netloc processing_system7_0_axi_periph_M01_AXI 1 2 1 760
levelinfo -pg 1 0 220 610 970 1140 -top 0 -bot 580
",
}

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


