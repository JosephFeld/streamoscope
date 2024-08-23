`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/10/2024 07:19:39 PM
// Design Name: 
// Module Name: adj_clk_wrapper
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


module adj_clk_wrapper#( parameter STARTUP_INCS = 0) 
                        (   input wire clk, //sys clk for incrementing logic
                            input wire rst_in,
                        
                            input wire clk_in1, //ft601 clock
                            output logic clk_out1, //ft601 clock with phase adjustment
                            input wire inc_trigger, //inc on a rising edge
                            output logic [5:0] num_incs,
                            
                            output logic out_state
                        
                        

    );
    
    logic psclk;
    logic psen;
    logic psincdec;
    logic psdone;
    
    assign psclk = clk; 
    assign psincdec = 1;
    
    typedef enum {IDLE, INCREMENTING} adj_state;
    
    adj_state state;
    
    logic prev_inc_trigger;
    
    assign out_state = state == IDLE;
    
    logic [7:0] timeout_counter;
    
    always_ff @(posedge clk) begin
        if(rst_in) begin
            state <= IDLE;
            prev_inc_trigger <= 1;
            psen <= 0;
            num_incs <= 0;
            timeout_counter <= 0;
        end else begin
            case(state)
                IDLE: begin
                    if(inc_trigger && ~prev_inc_trigger) begin //rising edge of inc_trigger
                        state <= INCREMENTING;
                        //send a single cycle pulse to increment phase
                        psen <= 1;
                        timeout_counter <= 0;
                    end else begin
                        state <= IDLE;
                        psen <= 0;
                        timeout_counter <= 0;
                    end
                end
                INCREMENTING: begin
                    psen <= 0;
                    if(psdone) begin
                        state <= IDLE;
                        //and increment the counter mod 56
                        num_incs <= num_incs == 55 ? 0 : num_incs + 1;
                    end else if(timeout_counter >= 15) begin
                        state <= IDLE; //failed increment due to timeout
                        timeout_counter <= 0;
                    end else begin
                        state <= INCREMENTING;
                        timeout_counter <= timeout_counter + 1;
                    end
                end
                default: begin
                    state <= IDLE;
                    timeout_counter <= 0;
                end
            endcase
            prev_inc_trigger <= inc_trigger;
        end
    end
    
    
    
    
    clk_wiz_ft601_adj my_adj_ft601_clk
    (
        // Clock out ports
        .clk_out1(clk_out1),     // output clk_out1
        // Dynamic phase shift ports
        .psclk(psclk), // input psclk
        .psen(psen), // input psen
        .psincdec(psincdec),     // input psincdec
        .psdone(psdone),       // output psdone
       // Clock in ports
        .clk_in1(clk_in1)      // input clk_in1
    );
endmodule
