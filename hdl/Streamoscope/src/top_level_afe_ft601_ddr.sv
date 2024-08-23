`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/23/2024 01:01:04 PM
// Design Name: 
// Module Name: top_level_afe_ft601_ddr
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module top_level_afe_ft601_ddr ( 
                                input wire CLK, //100mhz

                                /* DDR3 Connections */
                                inout [15:0] ddr3_dq,
                                inout [1:0] ddr3_dqs_n,
                                inout [1:0] ddr3_dqs_p,
                                output [13:0] ddr3_addr,
                                output [2:0] ddr3_ba,
                                output ddr3_ras_n,
                                output ddr3_cas_n,
                                output ddr3_we_n,
                                output ddr3_reset_n,
                                output ddr3_ck_p,
                                output ddr3_ck_n,
                                output ddr3_cke,
                                output ddr3_cs_n,
                                output [1:0] ddr3_dm,
                                output ddr3_odt,
                                
                                //AFE
                                input wire OUT1A_N,
                                input wire OUT1A_P,
//                                input wire OUT1B_N,
//                                input wire OUT1B_P,
                                input wire OUT2A_N,
                                input wire OUT2A_P,
//                                input wire OUT2B_P,
//                                input wire OUT2B_N,
                                input wire DCO_N,
                                input wire DCO_P,
                                input wire FR_N,
                                input wire FR_P,
                                
                                //FT601 USB-3
                                
                                output logic [3:0] USB_BE,
                                output logic [31:0] USB_DATA,
                                output logic USB_OE_N,
                                output logic USB_RD_N,
    //                          output logic USB_RESET_N,
                                input wire USB_RXF_N,
    //                          output logic USB_SIWU_N,
                                input wire USB_TXE_N,
    //                          output logic USB_WAKEUP_N,
                                output logic USB_WR_N,
                                input wire USB_DATA_CLK
                                

    );
    
    logic clk_100mhz;
    logic clk_200mhz;
    logic clk_60mhz;
    
    logic rst; //active high reset for everything
    

    
    
    
    
    // The beast of an AXI interface - yikes
    logic [29:0]S_AXI_0_araddr;
    logic [1:0]S_AXI_0_arburst;
    logic [3:0]S_AXI_0_arcache;
    logic [3:0]S_AXI_0_arid;
    logic [7:0]S_AXI_0_arlen;
    logic S_AXI_0_arlock;
    logic [2:0]S_AXI_0_arprot;
    logic [3:0]S_AXI_0_arqos;
    logic S_AXI_0_arready;
    logic [2:0]S_AXI_0_arsize;
    logic S_AXI_0_arvalid;
    logic [29:0]S_AXI_0_awaddr;
    logic [1:0]S_AXI_0_awburst;
    logic [3:0]S_AXI_0_awcache;
    logic [3:0]S_AXI_0_awid;
    logic [7:0]S_AXI_0_awlen;
    logic S_AXI_0_awlock;
    logic [2:0]S_AXI_0_awprot;
    logic [3:0]S_AXI_0_awqos;
    logic S_AXI_0_awready;
    logic [2:0]S_AXI_0_awsize;
    logic S_AXI_0_awvalid;
    logic [3:0]S_AXI_0_bid;
    logic S_AXI_0_bready;
    logic [1:0]S_AXI_0_bresp;
    logic S_AXI_0_bvalid;
    logic [127:0]S_AXI_0_rdata;
    logic [3:0]S_AXI_0_rid;
    logic S_AXI_0_rlast;
    logic S_AXI_0_rready;
    logic [1:0] S_AXI_0_rresp;
    logic S_AXI_0_rvalid;
    logic [127:0]S_AXI_0_wdata;
    logic S_AXI_0_wlast;
    logic S_AXI_0_wready;
    logic [31:0]S_AXI_0_wstrb;
    logic S_AXI_0_wvalid;
    logic aresetn;
    logic init_calib_complete;
    logic mmcm_locked;
    logic sys_diff_clock_clk_n;
    logic sys_diff_clock_clk_p;
    logic sys_rst;
    logic ui_clk;
    logic ui_clk_sync_rst;
    
//    assign ui_clk = clk_200mhz;
    
    
    logic i_reset;
    logic o_err;
    logic o_overflow;
    logic o_mm2s_full;
    logic o_empty;
    logic [30-($clog2(256)-3):0] o_fill; //30-5=25:0
    
    //  Info about fullness of vfifo
    logic [7 : 0] vfifo_mm2s_channel_full;
    logic [7 : 0] vfifo_s2mm_channel_full;
    logic [7 : 0] vfifo_mm2s_channel_empty;
    logic [7 : 0] vfifo_idle;
    
    // MIG ports
//    logic ui_clk; //82.25 MHz for memory controller
//    logic ui_clk_sync_rst;
//    logic mmcm_locked;
//    logic aresetn;
    logic app_sr_req;
    logic app_ref_req;
    logic app_zq_req;
    logic app_sr_active;
    logic app_ref_ack;
    logic app_zq_ack;
    
    always_comb begin
        app_sr_req = 0;
        app_ref_req = 0;
        app_zq_req = 0;
        
        rst = 0;
        i_reset = 0;
        
        vfifo_mm2s_channel_full = 8'h00;
    end
    
    logic okClk;
    logic [31:0] btpoa0_ep_datain;
    logic btpoa0_ep_read;
    logic btpoa0_ep_blockstrobe;
    logic btpoa0_ep_ready;
    
    logic AdcFrmClk;
    logic [7:0] AdcDataValid;
    logic [15:0] AdcDataCh0;
    logic [15:0] AdcDataCh1;
    logic [15:0] AdcDataCh2;
    logic [15:0] AdcDataCh3;
    
    logic drain_fifo;
    
    // Cheap bit packing
//    logic [15:0] AdcDataCh0_prev;
//    logic valid_strobe;
//    always_ff @(posedge AdcFrmClk) begin
//        AdcDataCh0_prev <= AdcDataCh0;
//        valid_strobe <= AdcDataValid[0] ? ~valid_strobe : 0;
//    end
    
    //FIFO 0
    logic s_axis_tvalid_0;
    logic s_axis_tready_0;
    logic [31:0] s_axis_tdata_0;
    
    logic m_axis_tvalid_0;
    logic m_axis_tready_0;
    logic [31:0] m_axis_tdata_0;
    
    logic prog_full_0; //for canary checking
    
    
    //FIFO 1
    logic s_axis_tvalid_1;
    logic s_axis_tready_1;
    logic [127:0] s_axis_tdata_1;
    
    logic m_axis_tvalid_1;
    logic m_axis_tready_1;
    logic [127:0] m_axis_tdata_1;
    
    
    //FIFO 2
    logic s_axis_tvalid_2;
    logic s_axis_tready_2;
    logic [127:0] s_axis_tdata_2;
    
    logic m_axis_tvalid_2;
    logic m_axis_tready_2;
    logic [127:0] m_axis_tdata_2;
    
    logic prog_empty_2;
    
    //FIFO 3
    logic s_axis_tvalid_3;
    logic s_axis_tready_3;
    logic [31:0] s_axis_tdata_3;
    
    logic m_axis_tvalid_3;
    logic m_axis_tready_3;
    logic [31:0] m_axis_tdata_3;
    
    //FIFO 4
    logic s_axis_tvalid_4;
    logic s_axis_tready_4;
    logic [31:0] s_axis_tdata_4;
    
    logic m_axis_tvalid_4;
    logic m_axis_tready_4;
    logic [31:0] m_axis_tdata_4;
    logic [31 : 0] axis_rd_data_count_4;
    logic prog_full_4;
    
    // Packer
    logic s_axis_tvalid_packer;
    logic [31:0] s_axis_tdata_packer;
    logic s_axis_tready_packer;
    
    logic m_axis_tvalid_packer;
    logic [127:0] m_axis_tdata_packer;
    logic m_axis_tready_packer;
    
    
    // Unpacker
    logic s_axis_tvalid_unpacker;
    logic [127:0] s_axis_tdata_unpacker;
    logic s_axis_tready_unpacker;
    
    logic m_axis_tvalid_unpacker;
    logic [31:0] m_axis_tdata_unpacker;
    logic m_axis_tready_unpacker;
    
    // VFIFO
    logic s_axis_ddr_fifo_tvalid;
    logic s_axis_ddr_fifo_tready;
    logic [127:0] s_axis_ddr_fifo_tdata;
    
    logic m_axis_ddr_fifo_tvalid;
    logic m_axis_ddr_fifo_tready;
    logic [127:0] m_axis_ddr_fifo_tdata;
    
    
    //FT601
    logic clk_in_ft601;
    logic clk_in_ft601_inv;
    
    logic s_axis_tvalid_ft601, s_axis_tready_ft601, almost_empty_ft601, almost_full_ft601;
    logic [31:0] s_axis_tdata_ft601;
    
    
    
    
    
    logic vfifo_connected;
    logic [8:0] vfifo_connected_counter;
    
    always_ff @(posedge ui_clk) begin
        if(prog_empty_2) begin
            vfifo_connected <= 1;
            vfifo_connected_counter <= 0;
        end else begin
            if(vfifo_connected) begin
                vfifo_connected <= vfifo_connected_counter != 511;
                vfifo_connected_counter <= vfifo_connected_counter + 1;
            end else begin
                vfifo_connected_counter <= 0;
            end
        end
    end
    
    
    always_comb begin
        //AFE to FIFO 0
        s_axis_tdata_0 = {2'b00, AdcDataCh1[13:0], 2'b00, AdcDataCh0[13:0]};
        s_axis_tvalid_0 = AdcDataValid[0];
        
    
        //FIFO 0 to packer
        s_axis_tvalid_packer = m_axis_tvalid_0;
        s_axis_tdata_packer = m_axis_tdata_0;
        m_axis_tready_0 = s_axis_tready_packer;
        
        //Packer to FIFO 1
        s_axis_tvalid_1 = m_axis_tvalid_packer;
        s_axis_tdata_1 = m_axis_tdata_packer;
        m_axis_tready_packer = s_axis_tready_1;
        
        //FIFO 1 to VFIFO
        s_axis_ddr_fifo_tvalid = m_axis_tvalid_1;
        m_axis_tready_1 = s_axis_ddr_fifo_tready;
        s_axis_ddr_fifo_tdata = m_axis_tdata_1;
        
        //VFIFO to FIFO 2
        s_axis_tvalid_2 = m_axis_ddr_fifo_tvalid;// && vfifo_connected;
        m_axis_ddr_fifo_tready = s_axis_tready_2;// && vfifo_connected;
        s_axis_tdata_2 = m_axis_ddr_fifo_tdata;
        
        //FIFO 2 to Unpacker
        s_axis_tvalid_unpacker = m_axis_tvalid_2;
        m_axis_tready_2 = s_axis_tready_unpacker;
        s_axis_tdata_unpacker = m_axis_tdata_2;
        
        //Unpacker to FIFO 3
        s_axis_tvalid_3 = m_axis_tvalid_unpacker;
        s_axis_tdata_3 = m_axis_tdata_unpacker;
        m_axis_tready_unpacker = s_axis_tready_3;
        
        //FIFO 3 to FIFO 4
        s_axis_tvalid_4 = m_axis_tvalid_3;
        m_axis_tready_3 = s_axis_tready_4;
        s_axis_tdata_4 = m_axis_tdata_3;
        
        
        //FIFO 4 to FT601
        s_axis_tvalid_ft601 = m_axis_tvalid_4;
        s_axis_tdata_ft601 = m_axis_tdata_4;
        m_axis_tready_4 = s_axis_tready_ft601;
        
        drain_fifo = 0;//prog_full_0; // canary fifo is filling up yikes - time to drain
        
        
    end
    
//    ila_post_unpacker u_ila_post_unpacker (
//        .clk(ui_clk), // input wire clk
    
    
//        .probe0(m_axis_tvalid_unpacker), // input wire [0:0]  probe0  
//        .probe1(m_axis_tready_unpacker), // input wire [0:0]  probe1 
//        .probe2(m_axis_tdata_unpacker), // input wire [31:0]  probe2 
//        .probe3(s_axis_tvalid_4), // input wire [0:0]  probe3 
//        .probe4(s_axis_tready_4), // input wire [0:0]  probe4 
//        .probe5(s_axis_tdata_4), // input wire [31:0]  probe5 
//        .probe6(m_axis_tvalid_3), // input wire [0:0]  probe6 
//        .probe7(m_axis_tready_3), // input wire [0:0]  probe7 
//        .probe8(m_axis_tdata_3) // input wire [31:0]  probe8
//    );
    
    
    // ADC LVDS IP
    adc_lvds_afe my_adc_ip_yay_afe (
      .DCLK_p_pin(DCO_P),      // input wire DCLK_p_pin
      .DCLK_n_pin(DCO_N),      // input wire DCLK_n_pin
      .FCLK_p_pin(FR_P),      // input wire FCLK_p_pin
      .FCLK_n_pin(FR_N),      // input wire FCLK_n_pin
      .DATA_p_pin({OUT2B_P,OUT1B_P,OUT1A_P,OUT2A_P}),      // input wire [3 : 0] DATA_p_pin
      .DATA_n_pin({OUT2B_N,OUT1B_N,OUT1A_N,OUT2A_N}),      // input wire [3 : 0] DATA_n_pin
      .AdcSampClk(clk_60mhz),      // input wire AdcSampClk
      .AdcFrmClk(AdcFrmClk),        // output wire AdcFrmClk
      .AdcFrmClk2x(),    // output wire AdcFrmClk2x
      .AdcDataValid(AdcDataValid),  // output wire [7 : 0] AdcDataValid
      .AdcDataCh0(AdcDataCh0),      // output wire [15 : 0] AdcDataCh0
      .AdcDataCh1(AdcDataCh1),      // output wire [15 : 0] AdcDataCh1
      .AdcDataCh2(AdcDataCh2),      // output wire [15 : 0] AdcDataCh2
      .AdcDataCh3(AdcDataCh3),      // output wire [15 : 0] AdcDataCh3
      .AdcDataCh4(),      // output wire [15 : 0] AdcDataCh4
      .AdcDataCh5(),      // output wire [15 : 0] AdcDataCh5
      .AdcDataCh6(),      // output wire [15 : 0] AdcDataCh6
      .AdcDataCh7()      // output wire [15 : 0] AdcDataCh7
    );
    
    
    //TODO update clock to okclk
    
    axis_data_fifo_afe_4 u_axis_data_fifo_afe_4 (
      .s_axis_aresetn(~rst),          // input wire s_axis_aresetn
      .s_axis_aclk(ui_clk),                // input wire s_axis_aclk
      .s_axis_tvalid(s_axis_tvalid_4),            // input wire s_axis_tvalid
      .s_axis_tready(s_axis_tready_4),            // output wire s_axis_tready
      .s_axis_tdata(s_axis_tdata_4),              // input wire [31 : 0] s_axis_tdata
      .m_axis_aclk(clk_in_ft601),                // input wire m_axis_aclk
      .m_axis_tvalid(m_axis_tvalid_4),            // output wire m_axis_tvalid
      .m_axis_tready(m_axis_tready_4),            // input wire m_axis_tready
      .m_axis_tdata(m_axis_tdata_4),              // output wire [31 : 0] m_axis_tdata
      .axis_rd_data_count(axis_rd_data_count_4),  // output wire [31 : 0] axis_rd_data_count
      .prog_full(prog_full_4)                    // output wire prog_full
    );
    
    
    axis_data_fifo_afe_3 u_axis_data_fifo_afe_3 (
      .s_axis_aresetn(~rst),  // input wire s_axis_aresetn
      .s_axis_aclk(ui_clk),        // input wire s_axis_aclk
      .s_axis_tvalid(s_axis_tvalid_3),    // input wire s_axis_tvalid
      .s_axis_tready(s_axis_tready_3),    // output wire s_axis_tready
      .s_axis_tdata(s_axis_tdata_3),      // input wire [31 : 0] s_axis_tdata
      .m_axis_tvalid(m_axis_tvalid_3),    // output wire m_axis_tvalid
      .m_axis_tready(m_axis_tready_3),    // input wire m_axis_tready
      .m_axis_tdata(m_axis_tdata_3)      // output wire [31 : 0] m_axis_tdata
    );
    
    axis_data_fifo_afe_2 u_axis_data_fifo_afe_2 (
      .s_axis_aresetn(~rst),  // input wire s_axis_aresetn
      .s_axis_aclk(ui_clk),        // input wire s_axis_aclk
      .s_axis_tvalid(s_axis_tvalid_2),    // input wire s_axis_tvalid
      .s_axis_tready(s_axis_tready_2),    // output wire s_axis_tready
      .s_axis_tdata(s_axis_tdata_2),      // input wire [255 : 0] s_axis_tdata
      .m_axis_tvalid(m_axis_tvalid_2),    // output wire m_axis_tvalid
      .m_axis_tready(m_axis_tready_2),    // input wire m_axis_tready
      .m_axis_tdata(m_axis_tdata_2),      // output wire [255 : 0] m_axis_tdata
      .prog_empty(prog_empty_2)
    );
    
    
    
    axis_data_fifo_afe_1 u_axis_data_fifo_afe_1 (
      .s_axis_aresetn(~rst),  // input wire s_axis_aresetn
      .s_axis_aclk(ui_clk),        // input wire s_axis_aclk
      .s_axis_tvalid(s_axis_tvalid_1),    // input wire s_axis_tvalid
      .s_axis_tready(s_axis_tready_1),    // output wire s_axis_tready
      .s_axis_tdata(s_axis_tdata_1),      // input wire [255 : 0] s_axis_tdata
      .m_axis_tvalid(m_axis_tvalid_1),    // output wire m_axis_tvalid
      .m_axis_tready(m_axis_tready_1),    // input wire m_axis_tready
      .m_axis_tdata(m_axis_tdata_1)      // output wire [255 : 0] m_axis_tdata
    );
    
    
    axis_data_fifo_afe_0 u_axis_data_fifo_afe_0 (
      .s_axis_aresetn(~rst),  // input wire s_axis_aresetn
      .s_axis_aclk(AdcFrmClk),        // input wire s_axis_aclk
      .s_axis_tvalid(s_axis_tvalid_0),    // input wire s_axis_tvalid
      .s_axis_tready(s_axis_tready_0),    // output wire s_axis_tready
      .s_axis_tdata(s_axis_tdata_0),      // input wire [31 : 0] s_axis_tdata
      .m_axis_aclk(ui_clk),        // input wire m_axis_aclk
      .m_axis_tvalid(m_axis_tvalid_0),    // output wire m_axis_tvalid
      .m_axis_tready(m_axis_tready_0),    // input wire m_axis_tready
      .m_axis_tdata(m_axis_tdata_0),      // output wire [31 : 0] m_axis_tdata
      .prog_full(prog_full_0)            // output wire prog_full
    );
    
    
    bit_packer #(.OUTPUT_WIDTH(128),
                 .INPUTS_PER_OUTPUT(4) //32-bit data chunks
                     
                    ) u_bit_packer ( .clk(ui_clk),
                        .rst(rst),
                        
                        // Unpacked Data In
                        .s_axis_tvalid(s_axis_tvalid_packer),
                        .s_axis_tdata(s_axis_tdata_packer),
                        .s_axis_tready(s_axis_tready_packer),
                        
                        // Packed Data Out
                        .m_axis_tvalid(m_axis_tvalid_packer),
                        .m_axis_tdata(m_axis_tdata_packer),
                        .m_axis_tready(m_axis_tready_packer)
                        
    );
    
//    ila_bit_packer u_ila_bit_packer (
//        .clk(ui_clk), // input wire clk
    
    
//        .probe0(s_axis_tvalid_packer), // input wire [0:0]  probe0  
//        .probe1(s_axis_tready_packer), // input wire [0:0]  probe1 
//        .probe2(s_axis_tdata_packer), // input wire [31:0]  probe2 
//        .probe3(m_axis_tvalid_packer), // input wire [0:0]  probe3 
//        .probe4(m_axis_tready_packer), // input wire [0:0]  probe4 
//        .probe5(m_axis_tdata_packer) // input wire [255:0]  probe5
//    );
    
//    ila_bit_packer u_ila_bit_unpacker (
//        .clk(ui_clk), // input wire clk
    
    
//        .probe0(m_axis_tvalid_unpacker), // input wire [0:0]  probe0  
//        .probe1(m_axis_tready_unpacker), // input wire [0:0]  probe1 
//        .probe2(m_axis_tdata_unpacker), // input wire [31:0]  probe2 
//        .probe3(s_axis_tvalid_unpacker), // input wire [0:0]  probe3 
//        .probe4(s_axis_tready_unpacker), // input wire [0:0]  probe4 
//        .probe5(s_axis_tdata_unpacker) // input wire [255:0]  probe5
//    );
    
    
    bit_unpacker#(.INPUT_WIDTH(128),
                  .OUTPUTS_PER_INPUT(4) //32-bit data chunks
                    ) u_bit_unpacker ( .clk(ui_clk),
                        .rst(rst),
                        
                        // Packed Data In
                        .s_axis_tvalid(s_axis_tvalid_unpacker),
                        .s_axis_tdata(s_axis_tdata_unpacker),
                        .s_axis_tready(s_axis_tready_unpacker),
                        
                        // Unpacked Data Out
                        .m_axis_tvalid(m_axis_tvalid_unpacker),
                        .m_axis_tdata(m_axis_tdata_unpacker),
                        .m_axis_tready(m_axis_tready_unpacker)
                        
    );


//    ila_fifo_ends my_ila_yayyyyy (
//        .clk(AdcFrmClk), // input wire clk
    
    
//        .probe0(s_axis_tvalid_0), // input wire [0:0]  probe0  
//        .probe1(s_axis_tready_0), // input wire [0:0]  probe1 
//        .probe2(s_axis_tdata_0), // input wire [31:0]  probe2 
//        .probe3(0), // input wire [0:0]  probe3 
//        .probe4(0), // input wire [0:0]  probe4 
//        .probe5(0), // input wire [31:0]  probe5 
//        .probe6(0), // input wire [31:0]  probe6 
//        .probe7(0) // input wire [0:0]  probe7
//    );
    
//    ila_fifo_4_out u_ila_fifo_4_out (
//        .clk(okClk), // input wire clk
    
    
//        .probe0(m_axis_tvalid_4), // input wire [0:0]  probe0  
//        .probe1(m_axis_tready_4), // input wire [0:0]  probe1 
//        .probe2(m_axis_tdata_4), // input wire [31:0]  probe2 
//        .probe3(axis_rd_data_count_4), // input wire [31:0]  probe3 
//        .probe4(prog_full_4) // input wire [0:0]  probe4
//    );
    

//    ila_ddr_fifo my_ila_ddr_fifo_test (
//        .clk(ui_clk), // input wire clk
    
    
//        .probe0(s_axis_ddr_fifo_tvalid), // input wire [0:0]  probe0  
//        .probe1(s_axis_ddr_fifo_tready), // input wire [0:0]  probe1 
//        .probe2(s_axis_ddr_fifo_tdata), // input wire [127:0]  probe2 
//        .probe3(m_axis_ddr_fifo_tvalid), // input wire [0:0]  probe8 
//        .probe4(m_axis_ddr_fifo_tready), // input wire [0:0]  probe9 
//        .probe5(m_axis_ddr_fifo_tdata), // input wire [127:0]  probe10 
//        .probe6(o_err),
//        .probe7(o_overflow),
//        .probe8(o_empty),
//        .probe9(o_fill),
//        .probe10(init_calib_complete)
//    );
    
    
    //VFIFO meme signals
    
    logic [31 : 0] s_axis_ddr_fifo_tstrb;
    logic [31 : 0] s_axis_ddr_fifo_tkeep;
    logic s_axis_ddr_fifo_tlast;
    logic s_axis_ddr_fifo_tid;
    logic s_axis_ddr_fifo_tdest;
    
    logic [31 : 0] m_axis_ddr_fifo_tstrb;
    logic [31 : 0] m_axis_ddr_fifo_tkeep;
    logic m_axis_ddr_fifo_tlast;
    logic m_axis_ddr_fifo_tdest;
    
    always_comb begin
        s_axis_ddr_fifo_tstrb = 32'hff_ff_ff_ff;
        s_axis_ddr_fifo_tkeep = 32'hff_ff_ff_ff;
        s_axis_ddr_fifo_tlast = 0;
        s_axis_ddr_fifo_tid = 0;
        s_axis_ddr_fifo_tdest = 0;
    end
    
    axi_vfifo_ctrl_ddr xilinx_vfifo (
      .aclk(ui_clk),                                          // input wire aclk
      .aresetn(~rst),                                    // input wire aresetn
      
      .s_axis_tvalid(s_axis_ddr_fifo_tvalid),                        // input wire s_axis_tvalid
      .s_axis_tready(s_axis_ddr_fifo_tready),                        // output wire s_axis_tready
      .s_axis_tdata(s_axis_ddr_fifo_tdata),                          // input wire [255 : 0] s_axis_tdata
      .s_axis_tstrb(s_axis_ddr_fifo_tstrb),                          // input wire [31 : 0] s_axis_tstrb
      .s_axis_tkeep(s_axis_ddr_fifo_tkeep),                          // input wire [31 : 0] s_axis_tkeep
      .s_axis_tlast(s_axis_ddr_fifo_tlast),                          // input wire s_axis_tlast
      .s_axis_tid(s_axis_ddr_fifo_tid),                              // input wire [0 : 0] s_axis_tid
      .s_axis_tdest(s_axis_ddr_fifo_tdest),                          // input wire [0 : 0] s_axis_tdest
      .m_axis_tvalid(m_axis_ddr_fifo_tvalid),                        // output wire m_axis_tvalid
      .m_axis_tready(m_axis_ddr_fifo_tready),                        // input wire m_axis_tready
      .m_axis_tdata(m_axis_ddr_fifo_tdata),                          // output wire [255 : 0] m_axis_tdata
      .m_axis_tstrb(m_axis_ddr_fifo_tstrb),                          // output wire [31 : 0] m_axis_tstrb
      .m_axis_tkeep(m_axis_ddr_fifo_tkeep),                          // output wire [31 : 0] m_axis_tkeep
      .m_axis_tlast(m_axis_ddr_fifo_tlast),                          // output wire m_axis_tlast
      .m_axis_tid(m_axis_ddr_fifo_tid),                              // output wire [0 : 0] m_axis_tid
      .m_axis_tdest(m_axis_ddr_fifo_tdest),                          // output wire [0 : 0] m_axis_tdest
      
      .m_axi_awid(S_AXI_0_awid),                              // output wire [0 : 0] m_axi_awid
      .m_axi_awaddr(S_AXI_0_awaddr),                          // output wire [31 : 0] m_axi_awaddr
      .m_axi_awlen(S_AXI_0_awlen),                            // output wire [7 : 0] m_axi_awlen
      .m_axi_awsize(S_AXI_0_awsize),                          // output wire [2 : 0] m_axi_awsize
      .m_axi_awburst(S_AXI_0_awburst),                        // output wire [1 : 0] m_axi_awburst
      .m_axi_awlock(S_AXI_0_awlock),                          // output wire [0 : 0] m_axi_awlock
      .m_axi_awcache(S_AXI_0_awcache),                        // output wire [3 : 0] m_axi_awcache
      .m_axi_awprot(S_AXI_0_awprot),                          // output wire [2 : 0] m_axi_awprot
      .m_axi_awqos(S_AXI_0_awqos),                            // output wire [3 : 0] m_axi_awqos
      .m_axi_awregion(m_axi_awregion),                      // output wire [3 : 0] m_axi_awregion
      .m_axi_awuser(m_axi_awuser),                          // output wire [0 : 0] m_axi_awuser
      .m_axi_awvalid(S_AXI_0_awvalid),                        // output wire m_axi_awvalid
      .m_axi_awready(S_AXI_0_awready),                        // input wire m_axi_awready
      .m_axi_wdata(S_AXI_0_wdata),                            // output wire [255 : 0] m_axi_wdata
      .m_axi_wstrb(S_AXI_0_wstrb),                            // output wire [31 : 0] m_axi_wstrb
      .m_axi_wlast(S_AXI_0_wlast),                            // output wire m_axi_wlast
      .m_axi_wuser(m_axi_wuser),                            // output wire [0 : 0] m_axi_wuser
      .m_axi_wvalid(S_AXI_0_wvalid),                          // output wire m_axi_wvalid
      .m_axi_wready(S_AXI_0_wready),                          // input wire m_axi_wready
      .m_axi_bid(S_AXI_0_bid),                                // input wire [0 : 0] m_axi_bid
      .m_axi_bresp(S_AXI_0_bresp),                            // input wire [1 : 0] m_axi_bresp
      .m_axi_buser(0),                            // input wire [0 : 0] m_axi_buser
      .m_axi_bvalid(S_AXI_0_bvalid),                          // input wire m_axi_bvalid
      .m_axi_bready(S_AXI_0_bready),                          // output wire m_axi_bready
      .m_axi_arid(S_AXI_0_arid),                              // output wire [0 : 0] m_axi_arid
      .m_axi_araddr(S_AXI_0_araddr),                          // output wire [31 : 0] m_axi_araddr
      .m_axi_arlen(S_AXI_0_arlen),                            // output wire [7 : 0] m_axi_arlen
      .m_axi_arsize(S_AXI_0_arsize),                          // output wire [2 : 0] m_axi_arsize
      .m_axi_arburst(S_AXI_0_arburst),                        // output wire [1 : 0] m_axi_arburst
      .m_axi_arlock(S_AXI_0_arlock),                          // output wire [0 : 0] m_axi_arlock
      .m_axi_arcache(S_AXI_0_arcache),                        // output wire [3 : 0] m_axi_arcache
      .m_axi_arprot(S_AXI_0_arprot),                          // output wire [2 : 0] m_axi_arprot
      .m_axi_arqos(S_AXI_0_arqos),                            // output wire [3 : 0] m_axi_arqos
      .m_axi_arregion(m_axi_arregion),                      // output wire [3 : 0] m_axi_arregion
      .m_axi_aruser(m_axi_aruser),                          // output wire [0 : 0] m_axi_aruser
      .m_axi_arvalid(S_AXI_0_arvalid),                        // output wire m_axi_arvalid
      .m_axi_arready(S_AXI_0_arready),                        // input wire m_axi_arready
      .m_axi_rid(S_AXI_0_rid),                                // input wire [0 : 0] m_axi_rid
      .m_axi_rdata(S_AXI_0_rdata),                            // input wire [255 : 0] m_axi_rdata
      .m_axi_rresp(S_AXI_0_rresp),                            // input wire [1 : 0] m_axi_rresp
      .m_axi_rlast(S_AXI_0_rlast),                            // input wire m_axi_rlast
      .m_axi_ruser(0),                            // input wire [0 : 0] m_axi_ruser
      .m_axi_rvalid(S_AXI_0_rvalid),                          // input wire m_axi_rvalid
      .m_axi_rready(S_AXI_0_rready),                          // output wire m_axi_rready
      .vfifo_mm2s_channel_full(vfifo_mm2s_channel_full),    // input wire [1 : 0] vfifo_mm2s_channel_full
      .vfifo_s2mm_channel_full(vfifo_s2mm_channel_full),    // output wire [1 : 0] vfifo_s2mm_channel_full
      .vfifo_mm2s_channel_empty(vfifo_mm2s_channel_empty),  // output wire [1 : 0] vfifo_mm2s_channel_empty
      .vfifo_idle(vfifo_idle)                              // output wire [1 : 0] vfifo_idle
    );
    
    
    
    
    
  
    mig_7series_0 my_mig (



    // Memory interface ports

    .ddr3_addr                      (ddr3_addr),  // output [14:0]		ddr3_addr

    .ddr3_ba                        (ddr3_ba),  // output [2:0]		ddr3_ba

    .ddr3_cas_n                     (ddr3_cas_n),  // output			ddr3_cas_n

    .ddr3_ck_n                      (ddr3_ck_n),  // output [0:0]		ddr3_ck_n

    .ddr3_ck_p                      (ddr3_ck_p),  // output [0:0]		ddr3_ck_p

    .ddr3_cke                       (ddr3_cke),  // output [0:0]		ddr3_cke

    .ddr3_ras_n                     (ddr3_ras_n),  // output			ddr3_ras_n

    .ddr3_reset_n                   (ddr3_reset_n),  // output			ddr3_reset_n

    .ddr3_we_n                      (ddr3_we_n),  // output			ddr3_we_n

    .ddr3_dq                        (ddr3_dq),  // inout [31:0]		ddr3_dq

    .ddr3_dqs_n                     (ddr3_dqs_n),  // inout [3:0]		ddr3_dqs_n

    .ddr3_dqs_p                     (ddr3_dqs_p),  // inout [3:0]		ddr3_dqs_p

    .init_calib_complete            (init_calib_complete),  // output			init_calib_complete

      
    .ddr3_cs_n                      (ddr3_cs_n),  // output [0:0]		ddr3_cs_n

    .ddr3_dm                        (ddr3_dm),  // output [3:0]		ddr3_dm

    .ddr3_odt                       (ddr3_odt),  // output [0:0]		ddr3_odt

    // Application interface ports

    .ui_clk                         (ui_clk),  // output			ui_clk

    .ui_clk_sync_rst                (ui_clk_sync_rst),  // output			ui_clk_sync_rst

    .mmcm_locked                    (mmcm_locked),  // output			mmcm_locked

    .aresetn                        (~rst),  // input			aresetn

    .app_sr_req                     (app_sr_req),  // input			app_sr_req

    .app_ref_req                    (app_ref_req),  // input			app_ref_req

    .app_zq_req                     (app_zq_req),  // input			app_zq_req

    .app_sr_active                  (app_sr_active),  // output			app_sr_active

    .app_ref_ack                    (app_ref_ack),  // output			app_ref_ack

    .app_zq_ack                     (app_zq_ack),  // output			app_zq_ack

    // Slave Interface Write Address Ports

    .s_axi_awid                     (S_AXI_0_awid),  // input [3:0]			s_axi_awid

    .s_axi_awaddr                   (S_AXI_0_awaddr),  // input [29:0]			s_axi_awaddr

    .s_axi_awlen                    (S_AXI_0_awlen),  // input [7:0]			s_axi_awlen

    .s_axi_awsize                   (S_AXI_0_awsize),  // input [2:0]			s_axi_awsize

    .s_axi_awburst                  (S_AXI_0_awburst),  // input [1:0]			s_axi_awburst

    .s_axi_awlock                   (S_AXI_0_awlock),  // input [0:0]			s_axi_awlock

    .s_axi_awcache                  (S_AXI_0_awcache),  // input [3:0]			s_axi_awcache

    .s_axi_awprot                   (S_AXI_0_awprot),  // input [2:0]			s_axi_awprot

    .s_axi_awqos                    (S_AXI_0_awqos),  // input [3:0]			s_axi_awqos

    .s_axi_awvalid                  (S_AXI_0_awvalid),  // input			s_axi_awvalid

    .s_axi_awready                  (S_AXI_0_awready),  // output			s_axi_awready

    // Slave Interface Write Data Ports

    .s_axi_wdata                    (S_AXI_0_wdata),  // input [255:0]			s_axi_wdata

    .s_axi_wstrb                    (S_AXI_0_wstrb),  // input [31:0]			s_axi_wstrb

    .s_axi_wlast                    (S_AXI_0_wlast),  // input			s_axi_wlast

    .s_axi_wvalid                   (S_AXI_0_wvalid),  // input			s_axi_wvalid

    .s_axi_wready                   (S_AXI_0_wready),  // output			s_axi_wready

    // Slave Interface Write Response Ports

    .s_axi_bid                      (S_AXI_0_bid),  // output [3:0]			s_axi_bid

    .s_axi_bresp                    (S_AXI_0_bresp),  // output [1:0]			s_axi_bresp

    .s_axi_bvalid                   (S_AXI_0_bvalid),  // output			s_axi_bvalid

    .s_axi_bready                   (S_AXI_0_bready),  // input			s_axi_bready

    // Slave Interface Read Address Ports

    .s_axi_arid                     (S_AXI_0_arid),  // input [3:0]			s_axi_arid

    .s_axi_araddr                   (S_AXI_0_araddr),  // input [29:0]			s_axi_araddr

    .s_axi_arlen                    (S_AXI_0_arlen),  // input [7:0]			s_axi_arlen

    .s_axi_arsize                   (S_AXI_0_arsize),  // input [2:0]			s_axi_arsize

    .s_axi_arburst                  (S_AXI_0_arburst),  // input [1:0]			s_axi_arburst

    .s_axi_arlock                   (S_AXI_0_arlock),  // input [0:0]			s_axi_arlock

    .s_axi_arcache                  (S_AXI_0_arcache),  // input [3:0]			s_axi_arcache

    .s_axi_arprot                   (S_AXI_0_arprot),  // input [2:0]			s_axi_arprot

    .s_axi_arqos                    (S_AXI_0_arqos),  // input [3:0]			s_axi_arqos

    .s_axi_arvalid                  (S_AXI_0_arvalid),  // input			s_axi_arvalid

    .s_axi_arready                  (S_AXI_0_arready),  // output			s_axi_arready

    // Slave Interface Read Data Ports

    .s_axi_rid                      (S_AXI_0_rid),  // output [3:0]			s_axi_rid

    .s_axi_rdata                    (S_AXI_0_rdata),  // output [255:0]			s_axi_rdata

    .s_axi_rresp                    (S_AXI_0_rresp),  // output [1:0]			s_axi_rresp

    .s_axi_rlast                    (S_AXI_0_rlast),  // output			s_axi_rlast

    .s_axi_rvalid                   (S_AXI_0_rvalid),  // output			s_axi_rvalid

    .s_axi_rready                   (S_AXI_0_rready),  // input			s_axi_rready

    // System Clock Ports

    //.sys_clk_p                       (sys_clkp),  // input				sys_clk_p

    //.sys_clk_n                       (sys_clkn),  // input				sys_clk_n

    // System Clock Ports

    .sys_clk_i                       (clk_100mhz),

    // Reference Clock Ports

    .clk_ref_i                      (clk_200mhz),


    .sys_rst                        (rst) // input sys_rst

    );

    
    assign USB_RESET_N = 1;
    assign USB_SIWU_N = 1;
    assign USB_WAKEUP_N = 0;
    
    logic [31:0] ft601_data_bus;
    logic [3:0] ft601_be;
    
    assign USB_DATA = ft601_data_bus; //temp
    assign USB_BE = ft601_be;
    
    
    clk_wiz_ft601_please_work clk_wiz_ft601
   (
    // Clock out ports
    .clk_out1(clk_in_ft601),     // output clk_out1
    // Status and control signals
    .reset(RESET), // input reset
   // Clock in ports
    .clk_in1(USB_DATA_CLK)      // input clk_in1
);
    
//    assign USB_WR_N = 0;
    logic wr_n;
    logic oe_n;
    logic rd_n;
    assign USB_WR_N = wr_n;
    assign USB_RD_N = rd_n;
    assign USB_OE_N = oe_n;

    logic fifo_data_valid;
    logic [31:0] raw_fifo_data;
    logic raw_fifo_data_ready;
    
    logic [31:0] prev_data_sent;
    
    
    
    ft601_bram_dumper_dead_simple bram_dumper( .rst_in(rst),
                                             .txe_n(USB_TXE_N),
                                             .rxf_n(USB_RXF_N),
                                             //.siwu_n(FMC1_HPC_LA08_N),
                                             .wr_n(wr_n),//todo change
                                             .rd_n(rd_n),
                                             .oe_n(oe_n),
                                             .be(ft601_be),
                                             .clk_in_ft601(clk_in_ft601), //FT601 clock
                                             .clk_in_ft601_inv(clk_in_ft601_inv),
                                             .data_out(ft601_data_bus),
                                             
                                             .s_axis_aclk(clk_in_ft601),
                                             .s_axis_tvalid(s_axis_tvalid_ft601),
                                             .s_axis_tdata(s_axis_tdata_ft601),
                                             .s_axis_tready(s_axis_tready_ft601),
                                             
                                             .fifo_data_valid(fifo_data_valid),
                                             
                                             .raw_fifo_data(raw_fifo_data),
                                             .raw_fifo_data_ready(raw_fifo_data_ready),
                                             
                                             .prev_data_sent(prev_data_sent)
    );
    
    
//    ila_frontpanel_pipe my_ila_frontpanel_pipe (
//        .clk(okClk), // input wire clk
    
    
//        .probe0(m_axis_tvalid), // input wire [0:0]  probe0  
//        .probe1(m_axis_tready), // input wire [0:0]  probe1 
//        .probe2(btpoa0_ep_datain), // input wire [31:0]  probe2 
//        .probe3(btpoa0_ep_read), // input wire [0:0]  probe3 
//        .probe4(btpoa0_ep_blockstrobe), // input wire [0:0]  probe4 
//        .probe5(btpoa0_ep_ready), // input wire [0:0]  probe5
//        .probe6(block_counter),
//        .probe7(is_block_transferring),
//        .probe8(almost_full),
//        .probe9(drain_fifo)
//    );
    
//    ila_mig_pain u_ila_mig_pain (
//        .clk(ui_clk), // input wire clk
    
    
//        .probe0(S_AXI_0_wready), // input wire [0:0] probe0  
//        .probe1( S_AXI_0_awaddr), // input wire [29:0]  probe1 
//        .probe2( S_AXI_0_bresp), // input wire [1:0]  probe2 
//        .probe3( S_AXI_0_bvalid), // input wire [0:0]  probe3 
//        .probe4( S_AXI_0_bready), // input wire [0:0]  probe4 
//        .probe5( S_AXI_0_araddr), // input wire [29:0]  probe5 
//        .probe6( S_AXI_0_rready), // input wire [0:0]  probe6 
//        .probe7( S_AXI_0_wvalid), // input wire [0:0]  probe7 
//        .probe8( S_AXI_0_arvalid), // input wire [0:0]  probe8 
//        .probe9( S_AXI_0_arready), // input wire [0:0]  probe9 
//        .probe10( S_AXI_0_rdata), // input wire [255:0]  probe10 
//        .probe11( S_AXI_0_awvalid), // input wire [0:0]  probe11 
//        .probe12( S_AXI_0_awready), // input wire [0:0]  probe12 
//        .probe13( S_AXI_0_rresp), // input wire [1:0]  probe13 
//        .probe14( S_AXI_0_wdata), // input wire [255:0]  probe14 
//        .probe15( S_AXI_0_wstrb), // input wire [31:0]  probe15 
//        .probe16( S_AXI_0_rvalid), // input wire [0:0]  probe16 
//        .probe17( S_AXI_0_arprot), // input wire [2:0]  probe17 
//        .probe18( S_AXI_0_awprot), // input wire [2:0]  probe18 
//        .probe19( S_AXI_0_awid), // input wire [3:0]  probe19 
//        .probe20( S_AXI_0_bid), // input wire [3:0]  probe20 
//        .probe21( S_AXI_0_awlen), // input wire [7:0]  probe21 
//        .probe22( 0), // BUSER input wire [0:0]  probe22 
//        .probe23( S_AXI_0_awsize), // input wire [2:0]  probe23 
//        .probe24( S_AXI_0_awburst), // input wire [1:0]  probe24 
//        .probe25( S_AXI_0_arid), // input wire [3:0]  probe25 
//        .probe26( S_AXI_0_awlock), // input wire [0:0]  probe26 
//        .probe27( S_AXI_0_arlen), // input wire [7:0]  probe27 
//        .probe28( S_AXI_0_arsize), // input wire [2:0]  probe28 
//        .probe29( S_AXI_0_arburst), // input wire [1:0]  probe29 
//        .probe30( S_AXI_0_arlock), // input wire [0:0]  probe30 
//        .probe31( S_AXI_0_arcache), // input wire [3:0]  probe31 
//        .probe32( S_AXI_0_awcache), // input wire [3:0]  probe32 
//        .probe33( 0), //ARREGION input wire [3:0]  probe33 
//        .probe34( S_AXI_0_arqos), // input wire [3:0]  probe34 
//        .probe35( 0), //ARUSER input wire [0:0]  probe35 
//        .probe36( 0), //AWREGION input wire [3:0]  probe36 
//        .probe37( S_AXI_0_awqos), // input wire [3:0]  probe37 
//        .probe38( S_AXI_0_rid), // input wire [3:0]  probe38 
//        .probe39( 0), //AWUSER input wire [0:0]  probe39 
//        .probe40( 0), //WID input wire [0:0]  probe40 
//        .probe41( S_AXI_0_rlast), // input wire [0:0]  probe41 
//        .probe42( 0), //RUSER input wire [0:0]  probe42  
//        .probe43( S_AXI_0_wlast) // input wire [0:0]  probe43
//    );
    
    
//    ila_0 my_ila (
//        .clk(AdcFrmClk), // input wire clk
    
    
//        .probe0(AdcDataValid), // input wire [7:0]  probe0  
//        .probe1(AdcDataCh0), // input wire [15:0]  probe1 
//        .probe2(AdcDataCh1), // input wire [15:0]  probe2 
//        .probe3(AdcDataCh2), // input wire [15:0]  probe3 
//        .probe4(AdcDataCh3), // input wire [15:0]  probe4
//        .probe5(s_axis_tready)
//    );
    

    clk_wiz_au_afe_mig my_clk_wiz
   (
        // Clock out ports
        .clk_out1(clk_100mhz),     // output clk_out1 100mhz
        .clk_out2(clk_200mhz),     // output clk_out2 200mhz
        .clk_out3(clk_60mhz),     // output clk_out3 60mhz
       // Clock in ports
        .clk_in1(CLK)      // input clk_in1
    );
    
    
    
    
   
    

    
endmodule
