`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/12/2024 01:10:12 PM
// Design Name: 
// Module Name: top_level_stupid_ft601
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


module top_level_stupid_ft601(  output logic [3:0] USB_BE,
                                output logic [31:0] USB_DATA,
                                output logic USB_OE_N,
                                output logic USB_RD_N,
                                output logic USB_RESET_N,
                                input wire USB_RXF_N,
    //                          output logic USB_SIWU_N,
                                input wire USB_TXE_N,
    //                          output logic USB_WAKEUP_N,
                                output logic USB_WR_N,
                                input wire USB_DATA_CLK,
                                
                                input wire [1:0] USB_GPIO

                

    );
    
    assign USB_BE = 4'b1111;
    assign USB_RD_N = 1'b1;
    assign USB_OE_N = 1'b1;
    assign USB_RESET_N = 1'b1;
    assign USB_WR_N = 1'b0;
    
    assign USB_DATA = 32'hDEADBEEF;
    
    
endmodule
