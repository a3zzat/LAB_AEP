`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:        Xilinx
// Engineer:       bwiec
// Create Date:    07/31/2013 09:11:18 AM
// Design Name:    dma_polled_ex
// Module Name:    dma_polled_top
// Project Name:   dma_ex
// Target Devices: Zedboard, ZC702
// Tool Versions:  Vivado 2013.2
// Description: 
//   - Wrapper for IPI block diagram and custom logic to drive the DMA S2MM port
// Dependencies:   None
// Revision:
//   - Revision 1.0 - Initial release
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module dma_polled_top
(
    inout [14:0] DDR_addr,
    inout [2:0]  DDR_ba,
    inout        DDR_cas_n,
    inout        DDR_ck_n,
    inout        DDR_ck_p,
    inout        DDR_cke,
    inout        DDR_cs_n,
    inout [3:0]  DDR_dm,
    inout [31:0] DDR_dq,
    inout [3:0]  DDR_dqs_n,
    inout [3:0]  DDR_dqs_p,
    inout        DDR_odt,
    inout        DDR_ras_n,
    inout        DDR_reset_n,
    inout        DDR_we_n,
    inout        FIXED_IO_ddr_vrn,
    inout        FIXED_IO_ddr_vrp,
    inout [53:0] FIXED_IO_mio,
    inout        FIXED_IO_ps_clk,
    inout        FIXED_IO_ps_porb,
    inout        FIXED_IO_ps_srstb
);

    // ***** Parameters *****
    localparam MAX_CNT = 32'd512 / 4; // Convert from bytes to beats
    
    // ***** Internal signals *****
    wire        FCLK_CLK0;
    wire [7:0]  gpio_tri_o;
    wire        S_AXIS_S2MM_tready;
	wire        S_AXIS_S2MM_tlast;
    reg         S_AXIS_S2MM_tvalid = 0;
    reg  [31:0] S_AXIS_S2MM_tdata  = 0;
    
    // ***** Counter for driving DMA S2MM channel *****
    always @ (posedge FCLK_CLK0)
        if (gpio_tri_o[0] == 1'b0)
            begin
            S_AXIS_S2MM_tvalid <= 1'b0;
            S_AXIS_S2MM_tdata  <= 0;
            end 
        else
            begin
            
            S_AXIS_S2MM_tvalid <= 1'b1;
            if (S_AXIS_S2MM_tready)
                S_AXIS_S2MM_tdata  <= S_AXIS_S2MM_tdata + 1'b1;
                
            end

    assign S_AXIS_S2MM_tlast = (S_AXIS_S2MM_tdata == MAX_CNT) ? 1'b1 : 1'b0;

    // ***** Instantiate PS *****
    design_1_wrapper design_1_wrapper_i
    (
        .DDR_addr(DDR_addr),
        .DDR_ba(DDR_ba),
        .DDR_cas_n(DDR_cas_n),
        .DDR_ck_n(DDR_ck_n),
        .DDR_ck_p(DDR_ck_p),
        .DDR_cke(DDR_cke),
        .DDR_cs_n(DDR_cs_n),
        .DDR_dm(DDR_dm),
        .DDR_dq(DDR_dq),
        .DDR_dqs_n(DDR_dqs_n),
        .DDR_dqs_p(DDR_dqs_p),
        .DDR_odt(DDR_odt),
        .DDR_ras_n(DDR_ras_n),
        .DDR_reset_n(DDR_reset_n),
        .DDR_we_n(DDR_we_n),
        .FCLK_CLK0(FCLK_CLK0),
        .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
        .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
        .FIXED_IO_mio(FIXED_IO_mio),
        .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
        .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
        .S_AXIS_S2MM_tdata(S_AXIS_S2MM_tdata),
        .S_AXIS_S2MM_tkeep(4'hF),
        .S_AXIS_S2MM_tlast(S_AXIS_S2MM_tlast),
        .S_AXIS_S2MM_tready(S_AXIS_S2MM_tready),
        .S_AXIS_S2MM_tvalid(S_AXIS_S2MM_tvalid),
        .gpio_tri_o(gpio_tri_o)
    );
	
endmodule
