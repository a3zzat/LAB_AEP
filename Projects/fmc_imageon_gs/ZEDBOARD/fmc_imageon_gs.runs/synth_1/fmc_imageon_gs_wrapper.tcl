# 
# Synthesis run script generated by Vivado
# 

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7z020clg484-1

set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir E:/projects/xilinix/master_repo/LAB_AEP/Projects/fmc_imageon_gs/ZEDBOARD/fmc_imageon_gs.cache/wt [current_project]
set_property parent.project_path E:/projects/xilinix/master_repo/LAB_AEP/Projects/fmc_imageon_gs/ZEDBOARD/fmc_imageon_gs.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
set_property board_part em.avnet.com:zed:part0:1.3 [current_project]
set_property ip_repo_paths e:/projects/xilinix/master_repo/LAB_AEP/IP [current_project]
set_property vhdl_version vhdl_2k [current_fileset]
add_files E:/projects/xilinix/master_repo/LAB_AEP/Projects/fmc_imageon_gs/ZEDBOARD/fmc_imageon_gs.srcs/sources_1/bd/fmc_imageon_gs/fmc_imageon_gs.bd
set_property used_in_implementation false [get_files -all e:/projects/xilinix/master_repo/LAB_AEP/Projects/fmc_imageon_gs/ZEDBOARD/fmc_imageon_gs.srcs/sources_1/bd/fmc_imageon_gs/ip/fmc_imageon_gs_processing_system7_0_0/fmc_imageon_gs_processing_system7_0_0.xdc]
set_property used_in_implementation false [get_files -all e:/projects/xilinix/master_repo/LAB_AEP/Projects/fmc_imageon_gs/ZEDBOARD/fmc_imageon_gs.srcs/sources_1/bd/fmc_imageon_gs/ip/fmc_imageon_gs_v_cfa_0_0/fmc_imageon_gs_v_cfa_0_0_clocks.xdc]
set_property used_in_implementation false [get_files -all e:/projects/xilinix/master_repo/LAB_AEP/Projects/fmc_imageon_gs/ZEDBOARD/fmc_imageon_gs.srcs/sources_1/bd/fmc_imageon_gs/ip/fmc_imageon_gs_v_cfa_0_0/fmc_imageon_gs_v_cfa_0_0_ooc.xdc]
set_property used_in_implementation false [get_files -all e:/projects/xilinix/master_repo/LAB_AEP/Projects/fmc_imageon_gs/ZEDBOARD/fmc_imageon_gs.srcs/sources_1/bd/fmc_imageon_gs/ip/fmc_imageon_gs_v_cresample_0_0/fmc_imageon_gs_v_cresample_0_0_clocks.xdc]
set_property used_in_implementation false [get_files -all e:/projects/xilinix/master_repo/LAB_AEP/Projects/fmc_imageon_gs/ZEDBOARD/fmc_imageon_gs.srcs/sources_1/bd/fmc_imageon_gs/ip/fmc_imageon_gs_v_cresample_0_0/fmc_imageon_gs_v_cresample_0_0_ooc.xdc]
set_property used_in_implementation false [get_files -all e:/projects/xilinix/master_repo/LAB_AEP/Projects/fmc_imageon_gs/ZEDBOARD/fmc_imageon_gs.srcs/sources_1/bd/fmc_imageon_gs/ip/fmc_imageon_gs_v_osd_0_0/fmc_imageon_gs_v_osd_0_0_clocks.xdc]
set_property used_in_implementation false [get_files -all e:/projects/xilinix/master_repo/LAB_AEP/Projects/fmc_imageon_gs/ZEDBOARD/fmc_imageon_gs.srcs/sources_1/bd/fmc_imageon_gs/ip/fmc_imageon_gs_v_osd_0_0/fmc_imageon_gs_v_osd_0_0_ooc.xdc]
set_property used_in_implementation false [get_files -all e:/projects/xilinix/master_repo/LAB_AEP/Projects/fmc_imageon_gs/ZEDBOARD/fmc_imageon_gs.srcs/sources_1/bd/fmc_imageon_gs/ip/fmc_imageon_gs_v_rgb2ycrcb_0_0/fmc_imageon_gs_v_rgb2ycrcb_0_0_clocks.xdc]
set_property used_in_implementation false [get_files -all e:/projects/xilinix/master_repo/LAB_AEP/Projects/fmc_imageon_gs/ZEDBOARD/fmc_imageon_gs.srcs/sources_1/bd/fmc_imageon_gs/ip/fmc_imageon_gs_v_rgb2ycrcb_0_0/fmc_imageon_gs_v_rgb2ycrcb_0_0_ooc.xdc]
set_property used_in_implementation false [get_files -all e:/projects/xilinix/master_repo/LAB_AEP/Projects/fmc_imageon_gs/ZEDBOARD/fmc_imageon_gs.srcs/sources_1/bd/fmc_imageon_gs/ip/fmc_imageon_gs_v_tc_0_0/fmc_imageon_gs_v_tc_0_0_clocks.xdc]
set_property used_in_implementation false [get_files -all e:/projects/xilinix/master_repo/LAB_AEP/Projects/fmc_imageon_gs/ZEDBOARD/fmc_imageon_gs.srcs/sources_1/bd/fmc_imageon_gs/ip/fmc_imageon_gs_v_tc_0_0/fmc_imageon_gs_v_tc_0_0_ooc.xdc]
set_property used_in_implementation false [get_files -all e:/projects/xilinix/master_repo/LAB_AEP/Projects/fmc_imageon_gs/ZEDBOARD/fmc_imageon_gs.srcs/sources_1/bd/fmc_imageon_gs/ip/fmc_imageon_gs_xbar_0/fmc_imageon_gs_xbar_0_ooc.xdc]
set_property used_in_implementation false [get_files -all e:/projects/xilinix/master_repo/LAB_AEP/Projects/fmc_imageon_gs/ZEDBOARD/fmc_imageon_gs.srcs/sources_1/bd/fmc_imageon_gs/ip/fmc_imageon_gs_axi_vdma_0_0/fmc_imageon_gs_axi_vdma_0_0.xdc]
set_property used_in_implementation false [get_files -all e:/projects/xilinix/master_repo/LAB_AEP/Projects/fmc_imageon_gs/ZEDBOARD/fmc_imageon_gs.srcs/sources_1/bd/fmc_imageon_gs/ip/fmc_imageon_gs_axi_vdma_0_0/fmc_imageon_gs_axi_vdma_0_0_clocks.xdc]
set_property used_in_implementation false [get_files -all e:/projects/xilinix/master_repo/LAB_AEP/Projects/fmc_imageon_gs/ZEDBOARD/fmc_imageon_gs.srcs/sources_1/bd/fmc_imageon_gs/ip/fmc_imageon_gs_axi_vdma_0_0/fmc_imageon_gs_axi_vdma_0_0_ooc.xdc]
set_property used_in_implementation false [get_files -all e:/projects/xilinix/master_repo/LAB_AEP/Projects/fmc_imageon_gs/ZEDBOARD/fmc_imageon_gs.srcs/sources_1/bd/fmc_imageon_gs/ip/fmc_imageon_gs_axi_vdma_1_0/fmc_imageon_gs_axi_vdma_1_0.xdc]
set_property used_in_implementation false [get_files -all e:/projects/xilinix/master_repo/LAB_AEP/Projects/fmc_imageon_gs/ZEDBOARD/fmc_imageon_gs.srcs/sources_1/bd/fmc_imageon_gs/ip/fmc_imageon_gs_axi_vdma_1_0/fmc_imageon_gs_axi_vdma_1_0_clocks.xdc]
set_property used_in_implementation false [get_files -all e:/projects/xilinix/master_repo/LAB_AEP/Projects/fmc_imageon_gs/ZEDBOARD/fmc_imageon_gs.srcs/sources_1/bd/fmc_imageon_gs/ip/fmc_imageon_gs_axi_vdma_1_0/fmc_imageon_gs_axi_vdma_1_0_ooc.xdc]
set_property used_in_implementation false [get_files -all e:/projects/xilinix/master_repo/LAB_AEP/Projects/fmc_imageon_gs/ZEDBOARD/fmc_imageon_gs.srcs/sources_1/bd/fmc_imageon_gs/ip/fmc_imageon_gs_fmc_imageon_iic_0_0/fmc_imageon_gs_fmc_imageon_iic_0_0_board.xdc]
set_property used_in_implementation false [get_files -all e:/projects/xilinix/master_repo/LAB_AEP/Projects/fmc_imageon_gs/ZEDBOARD/fmc_imageon_gs.srcs/sources_1/bd/fmc_imageon_gs/ip/fmc_imageon_gs_fmc_imageon_iic_0_0/fmc_imageon_gs_fmc_imageon_iic_0_0_ooc.xdc]
set_property used_in_implementation false [get_files -all e:/projects/xilinix/master_repo/LAB_AEP/Projects/fmc_imageon_gs/ZEDBOARD/fmc_imageon_gs.srcs/sources_1/bd/fmc_imageon_gs/ip/fmc_imageon_gs_xbar_1/fmc_imageon_gs_xbar_1_ooc.xdc]
set_property used_in_implementation false [get_files -all e:/projects/xilinix/master_repo/LAB_AEP/Projects/fmc_imageon_gs/ZEDBOARD/fmc_imageon_gs.srcs/sources_1/bd/fmc_imageon_gs/ip/fmc_imageon_gs_rst_processing_system7_0_148_5M_0/fmc_imageon_gs_rst_processing_system7_0_148_5M_0_board.xdc]
set_property used_in_implementation false [get_files -all e:/projects/xilinix/master_repo/LAB_AEP/Projects/fmc_imageon_gs/ZEDBOARD/fmc_imageon_gs.srcs/sources_1/bd/fmc_imageon_gs/ip/fmc_imageon_gs_rst_processing_system7_0_148_5M_0/fmc_imageon_gs_rst_processing_system7_0_148_5M_0.xdc]
set_property used_in_implementation false [get_files -all e:/projects/xilinix/master_repo/LAB_AEP/Projects/fmc_imageon_gs/ZEDBOARD/fmc_imageon_gs.srcs/sources_1/bd/fmc_imageon_gs/ip/fmc_imageon_gs_rst_processing_system7_0_148_5M_0/fmc_imageon_gs_rst_processing_system7_0_148_5M_0_ooc.xdc]
set_property used_in_implementation false [get_files -all e:/projects/xilinix/master_repo/LAB_AEP/Projects/fmc_imageon_gs/ZEDBOARD/fmc_imageon_gs.srcs/sources_1/bd/fmc_imageon_gs/ip/fmc_imageon_gs_rst_processing_system7_0_149M_0/fmc_imageon_gs_rst_processing_system7_0_149M_0_board.xdc]
set_property used_in_implementation false [get_files -all e:/projects/xilinix/master_repo/LAB_AEP/Projects/fmc_imageon_gs/ZEDBOARD/fmc_imageon_gs.srcs/sources_1/bd/fmc_imageon_gs/ip/fmc_imageon_gs_rst_processing_system7_0_149M_0/fmc_imageon_gs_rst_processing_system7_0_149M_0.xdc]
set_property used_in_implementation false [get_files -all e:/projects/xilinix/master_repo/LAB_AEP/Projects/fmc_imageon_gs/ZEDBOARD/fmc_imageon_gs.srcs/sources_1/bd/fmc_imageon_gs/ip/fmc_imageon_gs_rst_processing_system7_0_149M_0/fmc_imageon_gs_rst_processing_system7_0_149M_0_ooc.xdc]
set_property used_in_implementation false [get_files -all e:/projects/xilinix/master_repo/LAB_AEP/Projects/fmc_imageon_gs/ZEDBOARD/fmc_imageon_gs.srcs/sources_1/bd/fmc_imageon_gs/ip/fmc_imageon_gs_rst_processing_system7_0_76M_0/fmc_imageon_gs_rst_processing_system7_0_76M_0_board.xdc]
set_property used_in_implementation false [get_files -all e:/projects/xilinix/master_repo/LAB_AEP/Projects/fmc_imageon_gs/ZEDBOARD/fmc_imageon_gs.srcs/sources_1/bd/fmc_imageon_gs/ip/fmc_imageon_gs_rst_processing_system7_0_76M_0/fmc_imageon_gs_rst_processing_system7_0_76M_0.xdc]
set_property used_in_implementation false [get_files -all e:/projects/xilinix/master_repo/LAB_AEP/Projects/fmc_imageon_gs/ZEDBOARD/fmc_imageon_gs.srcs/sources_1/bd/fmc_imageon_gs/ip/fmc_imageon_gs_rst_processing_system7_0_76M_0/fmc_imageon_gs_rst_processing_system7_0_76M_0_ooc.xdc]
set_property used_in_implementation false [get_files -all e:/projects/xilinix/master_repo/LAB_AEP/Projects/fmc_imageon_gs/ZEDBOARD/fmc_imageon_gs.srcs/sources_1/bd/fmc_imageon_gs/ip/fmc_imageon_gs_v_axi4s_vid_out_0_0/fmc_imageon_gs_v_axi4s_vid_out_0_0_clocks.xdc]
set_property used_in_implementation false [get_files -all e:/projects/xilinix/master_repo/LAB_AEP/Projects/fmc_imageon_gs/ZEDBOARD/fmc_imageon_gs.srcs/sources_1/bd/fmc_imageon_gs/ip/fmc_imageon_gs_v_axi4s_vid_out_0_0/fmc_imageon_gs_v_axi4s_vid_out_0_0_ooc.xdc]
set_property used_in_implementation false [get_files -all e:/projects/xilinix/master_repo/LAB_AEP/Projects/fmc_imageon_gs/ZEDBOARD/fmc_imageon_gs.srcs/sources_1/bd/fmc_imageon_gs/ip/fmc_imageon_gs_v_vid_in_axi4s_0_0/fmc_imageon_gs_v_vid_in_axi4s_0_0_clocks.xdc]
set_property used_in_implementation false [get_files -all e:/projects/xilinix/master_repo/LAB_AEP/Projects/fmc_imageon_gs/ZEDBOARD/fmc_imageon_gs.srcs/sources_1/bd/fmc_imageon_gs/ip/fmc_imageon_gs_v_vid_in_axi4s_0_0/fmc_imageon_gs_v_vid_in_axi4s_0_0_ooc.xdc]
set_property used_in_implementation false [get_files -all e:/projects/xilinix/master_repo/LAB_AEP/Projects/fmc_imageon_gs/ZEDBOARD/fmc_imageon_gs.srcs/sources_1/bd/fmc_imageon_gs/ip/fmc_imageon_gs_v_vid_in_axi4s_1_0/fmc_imageon_gs_v_vid_in_axi4s_1_0_clocks.xdc]
set_property used_in_implementation false [get_files -all e:/projects/xilinix/master_repo/LAB_AEP/Projects/fmc_imageon_gs/ZEDBOARD/fmc_imageon_gs.srcs/sources_1/bd/fmc_imageon_gs/ip/fmc_imageon_gs_v_vid_in_axi4s_1_0/fmc_imageon_gs_v_vid_in_axi4s_1_0_ooc.xdc]
set_property used_in_implementation false [get_files -all e:/projects/xilinix/master_repo/LAB_AEP/Projects/fmc_imageon_gs/ZEDBOARD/fmc_imageon_gs.srcs/sources_1/bd/fmc_imageon_gs/ip/fmc_imageon_gs_auto_pc_0/fmc_imageon_gs_auto_pc_0_ooc.xdc]
set_property used_in_implementation false [get_files -all e:/projects/xilinix/master_repo/LAB_AEP/Projects/fmc_imageon_gs/ZEDBOARD/fmc_imageon_gs.srcs/sources_1/bd/fmc_imageon_gs/ip/fmc_imageon_gs_auto_pc_1/fmc_imageon_gs_auto_pc_1_ooc.xdc]
set_property used_in_implementation false [get_files -all E:/projects/xilinix/master_repo/LAB_AEP/Projects/fmc_imageon_gs/ZEDBOARD/fmc_imageon_gs.srcs/sources_1/bd/fmc_imageon_gs/fmc_imageon_gs_ooc.xdc]
set_property is_locked true [get_files E:/projects/xilinix/master_repo/LAB_AEP/Projects/fmc_imageon_gs/ZEDBOARD/fmc_imageon_gs.srcs/sources_1/bd/fmc_imageon_gs/fmc_imageon_gs.bd]

read_vhdl -library xil_defaultlib E:/projects/xilinix/master_repo/LAB_AEP/Projects/fmc_imageon_gs/ZEDBOARD/fmc_imageon_gs.srcs/sources_1/bd/fmc_imageon_gs/hdl/fmc_imageon_gs_wrapper.vhd
read_xdc E:/projects/xilinix/master_repo/LAB_AEP/Projects/fmc_imageon_gs/zedboard_fmc_imageon_gs.xdc
set_property used_in_implementation false [get_files E:/projects/xilinix/master_repo/LAB_AEP/Projects/fmc_imageon_gs/zedboard_fmc_imageon_gs.xdc]

read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]
synth_design -top fmc_imageon_gs_wrapper -part xc7z020clg484-1
write_checkpoint -noxdef fmc_imageon_gs_wrapper.dcp
catch { report_utilization -file fmc_imageon_gs_wrapper_utilization_synth.rpt -pb fmc_imageon_gs_wrapper_utilization_synth.pb }
