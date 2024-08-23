`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/02/2023 10:34:23 AM
// Design Name: 
// Module Name: FT601_bram_dumper
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

//uses 245 mode for fastest throughput
module ft601_bram_dumper_dead_simple( input wire rst_in,
                             
                             //wire descriptions on page 16 of FT601 datasheet
                             input wire txe_n, //Transmit FIFO empty
                                                //It is active low and when active it indicates the 
                                                //Transmit FIFO has space and it is ready to receive
                                                //data from the FIFO master.
                             input wire rxf_n, //Receive FIFO full
                                                //Active low
                                                //Indicates receive FIFO has data for master
                                                //We don't read, so we're chilling
                             //output logic siwu_n, //Reserved. Add external pull up in normal operation
                             output logic wr_n, //Write Enable
                                                //Active low
                                                //Gives master write cycle access
                             output logic rd_n, //Read Enable
                                                //Active Low
                                                //Gives master read cycle access
                             output logic oe_n, //Output Enable
                                                //Active low
                                                //Slave will drive data and
                                                //byte enable buses
                             output logic [3:0] be, //Byte Enable
                                                    //Say which bytes valid in data
                                                    //Normally all valid, except at end of tx
                                                    //For reads, slave asserts this
                             input wire clk_in_ft601, //FT601 clock
                             input wire clk_in_ft601_inv,
                             output logic [31:0] data_out,
                             
                             
                             
                             // FIFO input bus
                             input wire s_axis_aclk,
                             input wire s_axis_tvalid,
                             input wire [31:0] s_axis_tdata,
                             output logic s_axis_tready,
                             
                             
                             output logic almost_full,
                             output logic almost_empty,
                             
                             output logic fifo_data_valid,
                             
                             output logic [31:0] raw_fifo_data,
                             
                             output logic raw_fifo_data_ready,
                             
                             output logic [31:0] prev_data_sent,
                             
                             output logic read_on
                            
                                    

    );
    
    assign be = 4'b1111;
    assign rd_n = 1'b1;
    assign oe_n = 1'b1;

    
    logic fifo_data_ready;
    logic [31:0] fifo_data;
    
    logic [1:0] txe_delayer;
    logic txe_delayed;
    
//    //Flashing logic
//    //------------
//    logic [31:0] flash_counter;
//    logic read_on;
    
//    always_ff @(posedge clk_in_ft601) begin
//        flash_counter <= flash_counter == 16777216 ? 0 : flash_counter + 1;
//        read_on <= flash_counter == 0 ? ~read_on : read_on;
//    end
    
    
//    //----------------
    
    assign raw_fifo_data = fifo_data;
    
    assign wr_n = ~fifo_data_valid || ~txe_delayed;// || ~read_on;
    assign fifo_data_ready = ~txe_n && txe_delayed;// && read_on;
    assign data_out = fifo_data;
    
    
    
    always_ff @(posedge clk_in_ft601) begin
        if(~txe_n) begin
            if(txe_delayed) begin
                //do nothing
                txe_delayer <= 0;
            end else begin
                txe_delayer <= txe_delayer + 1;
                txe_delayed <= txe_delayer == 3;
            end
        end else begin
            txe_delayed <= 0;
            txe_delayer <= 0;
        end
    end
    
    fifo_adc_to_ft601_big my_fifo (
      .s_axis_aresetn(~rst_in),
      .s_axis_aclk(s_axis_aclk),
      .s_axis_tvalid(s_axis_tvalid),
      .s_axis_tready(s_axis_tready),
      .s_axis_tdata(s_axis_tdata),
      
      .m_axis_aclk(clk_in_ft601),
      .m_axis_tvalid(fifo_data_valid),
      .m_axis_tready(fifo_data_ready),
      .m_axis_tdata(fifo_data),
      
      .almost_empty(almost_empty),
      .almost_full(almost_full)
    );
    
    
    
    //old legacy things so I can compile
    assign prev_data_sent = 0;
    assign raw_fifo_data_ready = 0;
    
    
    
    
endmodule
