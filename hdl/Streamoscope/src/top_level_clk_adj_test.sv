`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/11/2024 10:11:52 AM
// Design Name: 
// Module Name: top_level_clk_adj_test
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


module top_level_clk_adj_test( input wire CLK,
                               output logic [7:0] LED

    );
    
    logic clk_10mhz;
    logic clk_10mhz_adj;
    logic trigger;
    logic [5:0] num_incs;
    
    logic out_state;
    
    assign LED[0] = clk_10mhz;
    assign LED[7] = clk_10mhz_adj;
    assign LED[4:1] = num_incs;
    assign LED[6] = trigger;
    assign LED[5] = out_state;
    
    
    
    logic [$clog2(100000000)-1:0] counter;
    
    always_ff @(posedge clk_10mhz) begin
        counter <= counter == 49999 ? 0 : counter + 1;
        trigger <= counter == 49999 ? ~trigger : trigger;
    end
    
    clk_wiz_slower my_clk_wiz_slower
   (
        // Clock out ports
        .clk_out1(clk_10mhz),     // output clk_out1
       // Clock in ports
        .clk_in1(CLK)      // input clk_in1
    );
    
    
    adj_clk_wrapper#( .STARTUP_INCS(0)) my_ft601_clk_adj 
                        (   .clk(clk_10mhz), //sys clk for incrementing logic
                            .rst_in(0),
                        
                            .clk_in1(clk_10mhz), //ft601 clock
                            .clk_out1(clk_10mhz_adj), //ft601 clock with phase adjustment
                            .inc_trigger(trigger), //inc on a rising edge
                            .num_incs(num_incs),
                            .out_state(out_state)
    );
endmodule
