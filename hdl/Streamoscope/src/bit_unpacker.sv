`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2024 12:43:41 PM
// Design Name: 
// Module Name: bit_packer
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


module bit_unpacker#( parameter INPUT_WIDTH = 128,
                     parameter OUTPUTS_PER_INPUT = 4, //32-bit data chunks
                     
                     localparam OUTPUT_WIDTH = INPUT_WIDTH / OUTPUTS_PER_INPUT


                    ) ( input wire clk,
                        input wire rst,
                        
                        // Packed Data In
                        input wire s_axis_tvalid,
                        input wire [INPUT_WIDTH-1:0] s_axis_tdata,
                        output logic s_axis_tready,
                        
                        // Unpacked Data Out
                        output logic m_axis_tvalid,
                        output logic [OUTPUT_WIDTH-1:0] m_axis_tdata,
                        input wire m_axis_tready
                        
    );
    
    localparam COUNTER_BITS = $clog2(OUTPUTS_PER_INPUT);
    logic [COUNTER_BITS-1:0] data_index;
    
    logic [INPUT_WIDTH-1:0] s_axis_tdata_copy;
    
    logic pause;
    
//    assign s_axis_tready = m_axis_tready && data_index == 0;

    logic can_accept_data = 1; //initial value set since reset is really needed
    
    assign s_axis_tready = can_accept_data && m_axis_tready;
    
    always_ff @(posedge clk) begin
        if(rst) begin
            m_axis_tdata <= 0;
            data_index <= 0;
            m_axis_tvalid <= 0;
            pause <= 0;
            can_accept_data <= 1;
            s_axis_tdata_copy <= 128'b0;
        end else if(m_axis_tready) begin
            if(data_index == 0) begin // I want a fresh data chunk
                if(s_axis_tvalid && s_axis_tready) begin // And there's a nice juicy one for me >:)
                    s_axis_tdata_copy <= s_axis_tdata << OUTPUT_WIDTH;
                    m_axis_tdata <= s_axis_tdata[INPUT_WIDTH-1:INPUT_WIDTH-OUTPUT_WIDTH];
                    data_index <= data_index + 1;
                    m_axis_tvalid <= 1;
                    can_accept_data <= 0;
                end else begin
                    m_axis_tvalid <= 0;
                end   
            end else begin  //We're in the middle of processing a data chunk
                
                s_axis_tdata_copy <= s_axis_tdata_copy << OUTPUT_WIDTH;
                m_axis_tdata <= s_axis_tdata_copy[INPUT_WIDTH-1:INPUT_WIDTH-OUTPUT_WIDTH];
                m_axis_tvalid <= 1;
                
                //this was the last data chunk
                if(data_index == OUTPUTS_PER_INPUT - 1) begin
                    data_index <= 0;
                    can_accept_data <= 1;
                end else begin 
                    data_index <= data_index + 1;
                    can_accept_data <= 0;
                end
                
            end
        end
    end
    
    
endmodule
