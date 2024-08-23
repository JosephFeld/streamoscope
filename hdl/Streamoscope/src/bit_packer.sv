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


module bit_packer #( parameter OUTPUT_WIDTH = 128,
                     parameter INPUTS_PER_OUTPUT = 4, //32-bit data chunks
                     
                     localparam INPUT_WIDTH = OUTPUT_WIDTH / INPUTS_PER_OUTPUT


                    ) ( input wire clk,
                        input wire rst,
                        
                        // Unpacked Data In
                        input wire s_axis_tvalid,
                        input wire [INPUT_WIDTH-1:0] s_axis_tdata,
                        output logic s_axis_tready,
                        
                        // Packed Data Out
                        output logic m_axis_tvalid,
                        output logic [OUTPUT_WIDTH-1:0] m_axis_tdata,
                        input wire m_axis_tready
                        
    );
    
    localparam COUNTER_BITS = $clog2(INPUTS_PER_OUTPUT);
    logic [COUNTER_BITS-1:0] data_index;
    
    logic pause;
    
    assign s_axis_tready = !pause || m_axis_tready;
    
    always_ff @(posedge clk) begin
        if(rst) begin
            m_axis_tdata <= 0;
            data_index <= 0;
            m_axis_tvalid <= 0;
            pause <= 0;
        end else begin
            if(s_axis_tvalid && s_axis_tready) begin
                m_axis_tdata <= {m_axis_tdata, s_axis_tdata};
                if(data_index == INPUTS_PER_OUTPUT - 1) begin
                    data_index <= 0;
                    m_axis_tvalid <= 1;
                    pause <= 1;
                end else begin
                    data_index <= data_index + 1;
                    m_axis_tvalid <= 0;
                    pause <= 0;
                end
            end else if(m_axis_tready && m_axis_tvalid) begin
                m_axis_tvalid <= 0;
            end
        end
    end
    
    
    
    
    
    
    
    
endmodule
