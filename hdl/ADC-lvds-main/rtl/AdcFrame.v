`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/01/09 15:21:11
// Design Name: 
// Module Name: AdcFrame
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


module AdcFrame#(
    parameter AdcBits = 14,
    parameter FrmPattern = 16'b0011111110000000
)
(
    input FrmFCLK_p,
    input FrmFCLK_n,
    input FrmClk,
    input FrmClkb,
    input FrmClkDiv,
    input FrmRst,
    input BitClkDone,
    output FrmBitslip,
    output FrmAlignDone
);
    
    wire [15:0] wFrmPattern;
    
    reg rFrmBitslip;
    reg [7:0] rBitslipCnt;
    reg rFrmAlignDone;
    
    reg [7:0] rIgnoreCount; //I added this
   
    generate 
    
        if (AdcBits == 14) begin
            Serdes_1x14_DDR inst_Serdes_1x14_DDR_Data_Line
             (
                 .CLK     (FrmClk),
                 .CLKB    (FrmClkb),
                 .CLKDIV  (FrmClkDiv),
                 .BITSLIP (rFrmBitslip),
                 .D_p     (FrmFCLK_p),
                 .D_n     (FrmFCLK_n),
                 .RST     (FrmRst),
                 .Q       (wFrmPattern[AdcBits-1:0])
             );
        end else if (AdcBits == 12) begin
            Serdes_1x12_DDR inst_Serdes_1x12_DDR_Data_Line
             (
                 .CLK     (FrmClk),
                 .CLKB    (FrmClkb),
                 .CLKDIV  (FrmClkDiv),
                 .BITSLIP (rFrmBitslip),
                 .D_p     (FrmFCLK_p),
                 .D_n     (FrmFCLK_n),
                 .RST     (FrmRst),
                 .Q       (wFrmPattern[AdcBits-1:0])
             );
        end else if (AdcBits == 10) begin
            Serdes_1x10_DDR inst_Serdes_1x10_DDR_Data_Line
             (
                 .CLK     (FrmClk),
                 .CLKB    (FrmClkb),
                 .CLKDIV  (FrmClkDiv),
                 .BITSLIP (rFrmBitslip),
                 .D_p     (FrmFCLK_p),
                 .D_n     (FrmFCLK_n),
                 .RST     (FrmRst),
                 .Q       (wFrmPattern[AdcBits-1:0])
             );
        end else if (AdcBits == 8) begin
            Serdes_1x8_DDR inst_Serdes_1x8_DDR_Data_Line
             (
                 .CLK     (FrmClk),
                 .CLKB    (FrmClkb),
                 .CLKDIV  (FrmClkDiv),
                 .BITSLIP (rFrmBitslip),
                 .D_p     (FrmFCLK_p),
                 .D_n     (FrmFCLK_n),
                 .RST     (FrmRst),
                 .Q       (wFrmPattern[AdcBits-1:0])
             );
        end
    
    endgenerate

    always @(posedge FrmClkDiv) begin
        if ((FrmRst == 1) || (BitClkDone == 0))begin
            rFrmBitslip <= 0;
            rBitslipCnt <= 0;
            rFrmAlignDone <= 0;
            rIgnoreCount <= 0;
        end else begin
            if (rBitslipCnt == 31) begin
                rBitslipCnt <= 0;
                rFrmBitslip <= 0;
                rFrmAlignDone <= rFrmAlignDone;
            end else if (rBitslipCnt == 0) begin
                rBitslipCnt <= rBitslipCnt + 1;
                if (wFrmPattern[AdcBits-1:0] == FrmPattern[AdcBits-1:0]) begin
                    rFrmAlignDone <= 1;
                    rFrmBitslip <= 0;
                    rIgnoreCount <= 0;
                end else begin
                    rFrmAlignDone <= 0;//rIgnoreCount != 31;
                    rFrmBitslip <= 1;//rIgnoreCount == 31;
                    rIgnoreCount <= rIgnoreCount + 1;
                end
            end else begin
                rBitslipCnt <= rBitslipCnt + 1;
                rFrmBitslip <= 0;
                rFrmAlignDone <= rFrmAlignDone;
            end
        end
    end
    
    assign FrmBitslip = rFrmBitslip;
    assign FrmAlignDone = rFrmAlignDone;
    
//    // Debug
//    ila_1 ila_frame
//    (
//        .clk(FrmClkDiv),
//        .probe0(wFrmPattern),
//        .probe1(rFrmBitslip)
//     );

//    ila_frame_align_test my_frame_ila (
//        .clk(FrmClkDiv), // input wire clk
    
    
//        .probe0(wFrmPattern), // input wire [13:0]  probe0  
//        .probe1(rBitslipCnt), // input wire [7:0]  probe1 
//        .probe2(rFrmBitslip), // input wire [0:0]  probe2 
//        .probe3(FrmAlignDone) // input wire [0:0]  probe3
//    );
endmodule
