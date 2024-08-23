

#pin ft_rxf A28;
#pin ft_txe A27;

#pin ft_data[0] B24;
#pin ft_data[1] B23;
#pin ft_data[2] B21;
#pin ft_data[3] B20;
#pin ft_data[4] B18;
#pin ft_data[5] B17;
#pin ft_data[6] B15;
#pin ft_data[7] B14;
#pin ft_data[8] B27;
#pin ft_data[9] B28;
#pin ft_data[10] B30;
#pin ft_data[11] B31;
#pin ft_data[12] B36;
#pin ft_data[13] B37;

#pin ft_data[14] A21;
#pin ft_data[15] A20;
#pin ft_be[0] A18;
#pin ft_be[1] A17;

#pin ft_rd A31;
#pin ft_wr A30;
#pin ft_oe B34;

#set_property PACKAGE_PIN L4 [get_ports LVDS_RX_P]
#set_property IOSTANDARD LVDS_25 [get_ports LVDS_RX_P]
#set_property PACKAGE_PIN M4 [get_ports LVDS_RX_N]
#set_property IOSTANDARD LVDS_25 [get_ports LVDS_RX_N]

#set_property PACKAGE_PIN P4 [get_ports LVDS_TX_P]
#set_property IOSTANDARD LVDS_25 [get_ports LVDS_TX_P]
#set_property PACKAGE_PIN P3 [get_ports LVDS_TX_N]
#set_property IOSTANDARD LVDS_25 [get_ports LVDS_TX_N]

#alchitry 100mhz clock
set_property PACKAGE_PIN N14 [get_ports CLK]
set_property IOSTANDARD LVCMOS25 [get_ports CLK]

#alchitry leds
set_property PACKAGE_PIN K13 [get_ports LED[0]]
set_property IOSTANDARD LVCMOS25 [get_ports LED[0]]
set_property PACKAGE_PIN K12 [get_ports LED[1]]
set_property IOSTANDARD LVCMOS25 [get_ports LED[1]]
set_property PACKAGE_PIN L14 [get_ports LED[2]]
set_property IOSTANDARD LVCMOS25 [get_ports LED[2]]
set_property PACKAGE_PIN L13 [get_ports LED[3]]
set_property IOSTANDARD LVCMOS25 [get_ports LED[3]]
set_property PACKAGE_PIN M16 [get_ports LED[4]]
set_property IOSTANDARD LVCMOS25 [get_ports LED[4]]
set_property PACKAGE_PIN M14 [get_ports LED[5]]
set_property IOSTANDARD LVCMOS25 [get_ports LED[5]]
set_property PACKAGE_PIN M12 [get_ports LED[6]]
set_property IOSTANDARD LVCMOS25 [get_ports LED[6]]
set_property PACKAGE_PIN N16 [get_ports LED[7]]
set_property IOSTANDARD LVCMOS25 [get_ports LED[7]]


# FT601 USB Signals

set_property PACKAGE_PIN N6 [get_ports USB_BE[0]]
set_property IOSTANDARD LVCMOS25 [get_ports USB_BE[0]]
#FT601 K1 : FT600 H1
set_property PACKAGE_PIN N9 [get_ports USB_BE[1]]
set_property IOSTANDARD LVCMOS25 [get_ports USB_BE[1]]
set_property PACKAGE_PIN P9 [get_ports USB_BE[2]]
set_property IOSTANDARD LVCMOS25 [get_ports USB_BE[2]]
set_property PACKAGE_PIN P8 [get_ports USB_BE[3]]
set_property IOSTANDARD LVCMOS25 [get_ports USB_BE[3]]

set_property PACKAGE_PIN P11 [get_ports USB_DATA[0]]
set_property IOSTANDARD LVCMOS25 [get_ports USB_DATA[0]]
set_property PACKAGE_PIN P10 [get_ports USB_DATA[1]]
set_property IOSTANDARD LVCMOS25 [get_ports USB_DATA[1]]
set_property PACKAGE_PIN N12 [get_ports USB_DATA[2]]
set_property IOSTANDARD LVCMOS25 [get_ports USB_DATA[2]]
set_property PACKAGE_PIN P13 [get_ports USB_DATA[3]]
set_property IOSTANDARD LVCMOS25 [get_ports USB_DATA[3]]
set_property PACKAGE_PIN N13 [get_ports USB_DATA[4]]
set_property IOSTANDARD LVCMOS25 [get_ports USB_DATA[4]]
set_property PACKAGE_PIN M1 [get_ports USB_DATA[5]]
set_property IOSTANDARD LVCMOS25 [get_ports USB_DATA[5]]
set_property PACKAGE_PIN M2 [get_ports USB_DATA[6]]
set_property IOSTANDARD LVCMOS25 [get_ports USB_DATA[6]]
set_property PACKAGE_PIN P1 [get_ports USB_DATA[7]]
set_property IOSTANDARD LVCMOS25 [get_ports USB_DATA[7]]
set_property PACKAGE_PIN N1 [get_ports USB_DATA[8]]
set_property IOSTANDARD LVCMOS25 [get_ports USB_DATA[8]]
set_property PACKAGE_PIN R1 [get_ports USB_DATA[9]]
set_property IOSTANDARD LVCMOS25 [get_ports USB_DATA[9]]
set_property PACKAGE_PIN R2 [get_ports USB_DATA[10]]
set_property IOSTANDARD LVCMOS25 [get_ports USB_DATA[10]]
set_property PACKAGE_PIN T2 [get_ports USB_DATA[11]]
set_property IOSTANDARD LVCMOS25 [get_ports USB_DATA[11]]
# B2 not E2!!!! The alchitry footprint has a mistake
set_property PACKAGE_PIN R3 [get_ports USB_DATA[12]] 
set_property IOSTANDARD LVCMOS25 [get_ports USB_DATA[12]]
set_property PACKAGE_PIN T3 [get_ports USB_DATA[13]]
set_property IOSTANDARD LVCMOS25 [get_ports USB_DATA[13]]
set_property PACKAGE_PIN T4 [get_ports USB_DATA[14]]
set_property IOSTANDARD LVCMOS25 [get_ports USB_DATA[14]]
set_property PACKAGE_PIN T13 [get_ports USB_DATA[15]]
set_property IOSTANDARD LVCMOS25 [get_ports USB_DATA[15]]
set_property PACKAGE_PIN R13 [get_ports USB_DATA[16]]
set_property IOSTANDARD LVCMOS25 [get_ports USB_DATA[16]]
set_property PACKAGE_PIN T12 [get_ports USB_DATA[17]]
set_property IOSTANDARD LVCMOS25 [get_ports USB_DATA[17]]
set_property PACKAGE_PIN P5 [get_ports USB_DATA[18]]
set_property IOSTANDARD LVCMOS25 [get_ports USB_DATA[18]]
set_property PACKAGE_PIN R12 [get_ports USB_DATA[19]]
set_property IOSTANDARD LVCMOS25 [get_ports USB_DATA[19]]
set_property PACKAGE_PIN R11 [get_ports USB_DATA[20]]
set_property IOSTANDARD LVCMOS25 [get_ports USB_DATA[20]]
set_property PACKAGE_PIN R10 [get_ports USB_DATA[21]]
set_property IOSTANDARD LVCMOS25 [get_ports USB_DATA[21]]
set_property PACKAGE_PIN L5 [get_ports USB_DATA[22]]
set_property IOSTANDARD LVCMOS25 [get_ports USB_DATA[22]]
set_property PACKAGE_PIN M5 [get_ports USB_DATA[23]]
set_property IOSTANDARD LVCMOS25 [get_ports USB_DATA[23]]
set_property PACKAGE_PIN N4 [get_ports USB_DATA[24]]
set_property IOSTANDARD LVCMOS25 [get_ports USB_DATA[24]]
set_property PACKAGE_PIN L4 [get_ports USB_DATA[25]]
set_property IOSTANDARD LVCMOS25 [get_ports USB_DATA[25]]
set_property PACKAGE_PIN M4 [get_ports USB_DATA[26]]
set_property IOSTANDARD LVCMOS25 [get_ports USB_DATA[26]]
set_property PACKAGE_PIN P4 [get_ports USB_DATA[27]]
set_property IOSTANDARD LVCMOS25 [get_ports USB_DATA[27]]
set_property PACKAGE_PIN P3 [get_ports USB_DATA[28]]
set_property IOSTANDARD LVCMOS25 [get_ports USB_DATA[28]]
set_property PACKAGE_PIN N3 [get_ports USB_DATA[29]]
set_property IOSTANDARD LVCMOS25 [get_ports USB_DATA[29]]
set_property PACKAGE_PIN N2 [get_ports USB_DATA[30]]
set_property IOSTANDARD LVCMOS25 [get_ports USB_DATA[30]]
set_property PACKAGE_PIN M6 [get_ports USB_DATA[31]]
set_property IOSTANDARD LVCMOS25 [get_ports USB_DATA[31]]

set_property PACKAGE_PIN T9 [get_ports USB_GPIO[0]]
set_property IOSTANDARD LVCMOS25 [get_ports USB_GPIO[0]]
set_property PACKAGE_PIN T10 [get_ports USB_GPIO[1]]
set_property IOSTANDARD LVCMOS25 [get_ports USB_GPIO[1]]

set_property PACKAGE_PIN T8 [get_ports USB_OE_N]
set_property IOSTANDARD LVCMOS25 [get_ports USB_OE_N]
set_property PACKAGE_PIN T7 [get_ports USB_RD_N]
set_property IOSTANDARD LVCMOS25 [get_ports USB_RD_N]
set_property PACKAGE_PIN R7 [get_ports USB_RESET_N]
set_property IOSTANDARD LVCMOS25 [get_ports USB_RESET_N]
set_property PACKAGE_PIN R5 [get_ports USB_RXF_N]
set_property IOSTANDARD LVCMOS25 [get_ports USB_RXF_N]
#set_property PACKAGE_PIN N6 [get_ports USB_SIWU_N]
#set_property IOSTANDARD LVCMOS25 [get_ports USB_SIWU_N]
set_property PACKAGE_PIN R8 [get_ports USB_TXE_N]
set_property IOSTANDARD LVCMOS25 [get_ports USB_TXE_N]
#set_property PACKAGE_PIN H11 [get_ports USB_WAKEUP_N]
#set_property IOSTANDARD LVCMOS25 [get_ports USB_WAKEUP_N]
set_property PACKAGE_PIN T5 [get_ports USB_WR_N]
set_property IOSTANDARD LVCMOS25 [get_ports USB_WR_N]

set_property PACKAGE_PIN N11 [get_ports USB_DATA_CLK]
set_property IOSTANDARD LVCMOS25 [get_ports USB_DATA_CLK]


# Opal Kelly ADC

set_property PACKAGE_PIN T12 [get_ports MCU_SDA_USCK]
set_property IOSTANDARD LVCMOS25 [get_ports MCU_SDA_USCK]
set_property PACKAGE_PIN R12 [get_ports MCU_SDA_MOSI]
set_property IOSTANDARD LVCMOS25 [get_ports MCU_SDA_MOSI]
set_property PACKAGE_PIN R16 [get_ports R_GA]
set_property IOSTANDARD LVCMOS25 [get_ports R_GA]
set_property PACKAGE_PIN P14 [get_ports SCK]
set_property IOSTANDARD LVCMOS25 [get_ports SCK]
set_property PACKAGE_PIN M15 [get_ports MOSI]
set_property IOSTANDARD LVCMOS25 [get_ports MOSI]
set_property PACKAGE_PIN T14 [get_ports MISO]
set_property IOSTANDARD LVCMOS25 [get_ports MISO]
set_property PACKAGE_PIN T15 [get_ports CS_B]
set_property IOSTANDARD LVCMOS25 [get_ports CS_B]


set_property PACKAGE_PIN N2 [get_ports C2P_CLK_N]
set_property IOSTANDARD LVDS_25 [get_ports C2P_CLK_N]
set_property PACKAGE_PIN N3 [get_ports C2P_CLK_P]
set_property IOSTANDARD LVDS_25 [get_ports C2P_CLK_P]

#AFE is one indexed and this is zero indexed. I'm sorry

#Channel 1 INVERT!
set_property PACKAGE_PIN K3 [get_ports DATA_P[0]]
set_property IOSTANDARD LVDS_25 [get_ports DATA_P[0]]
set_property PACKAGE_PIN K2 [get_ports DATA_N[0]]
set_property IOSTANDARD LVDS_25 [get_ports DATA_N[0]]

#Channel 2
set_property PACKAGE_PIN J5 [get_ports DATA_P[1]]
set_property IOSTANDARD LVDS_25 [get_ports DATA_P[1]]
set_property PACKAGE_PIN J4 [get_ports DATA_N[1]]
set_property IOSTANDARD LVDS_25 [get_ports DATA_N[1]]

#Channel 3
set_property PACKAGE_PIN C1 [get_ports DATA_P[2]]
set_property IOSTANDARD LVDS_25 [get_ports DATA_P[2]]
set_property PACKAGE_PIN B1 [get_ports DATA_N[2]]
set_property IOSTANDARD LVDS_25 [get_ports DATA_N[2]]

#Channel 4
set_property PACKAGE_PIN C3 [get_ports DATA_P[3]]
set_property IOSTANDARD LVDS_25 [get_ports DATA_P[3]]
set_property PACKAGE_PIN C2 [get_ports DATA_N[3]]
set_property IOSTANDARD LVDS_25 [get_ports DATA_N[3]]

#Channel 5
set_property PACKAGE_PIN G5 [get_ports DATA_P[4]]
set_property IOSTANDARD LVDS_25 [get_ports DATA_P[4]]
set_property PACKAGE_PIN G4 [get_ports DATA_N[4]]
set_property IOSTANDARD LVDS_25 [get_ports DATA_N[4]]

#Channel 6
set_property PACKAGE_PIN F5 [get_ports DATA_P[5]]
set_property IOSTANDARD LVDS_25 [get_ports DATA_P[5]]
set_property PACKAGE_PIN E5 [get_ports DATA_N[5]]
set_property IOSTANDARD LVDS_25 [get_ports DATA_N[5]]

#Channel 7
set_property PACKAGE_PIN D6 [get_ports DATA_P[6]]
set_property IOSTANDARD LVDS_25 [get_ports DATA_P[6]]
set_property PACKAGE_PIN D5 [get_ports DATA_N[6]]
set_property IOSTANDARD LVDS_25 [get_ports DATA_N[6]]

#Channel 8
set_property PACKAGE_PIN C7 [get_ports DATA_P[7]]
set_property IOSTANDARD LVDS_25 [get_ports DATA_P[7]]
set_property PACKAGE_PIN C6 [get_ports DATA_N[7]]
set_property IOSTANDARD LVDS_25 [get_ports DATA_N[7]]


set_property PACKAGE_PIN D3 [get_ports DCO_N] 
set_property IOSTANDARD LVDS_25 [get_ports DCO_N]
set_property PACKAGE_PIN E3 [get_ports DCO_P] 
set_property IOSTANDARD LVDS_25 [get_ports DCO_P]

set_property PACKAGE_PIN C4 [get_ports FR_N] 
set_property IOSTANDARD LVDS_25 [get_ports FR_N]
set_property PACKAGE_PIN D4 [get_ports FR_P] 
set_property IOSTANDARD LVDS_25 [get_ports FR_P]


set_property PACKAGE_PIN T15 [get_ports GPIO[0]]
set_property IOSTANDARD LVCMOS25 [get_ports GPIO[0]]
set_property PACKAGE_PIN T14 [get_ports GPIO[1]]
set_property IOSTANDARD LVCMOS25 [get_ports GPIO[1]]
set_property PACKAGE_PIN R16 [get_ports GPIO[2]]
set_property IOSTANDARD LVCMOS25 [get_ports GPIO[2]]
set_property PACKAGE_PIN R15 [get_ports GPIO[3]]
set_property IOSTANDARD LVCMOS25 [get_ports GPIO[3]]
set_property PACKAGE_PIN P14 [get_ports GPIO[4]]
set_property IOSTANDARD LVCMOS25 [get_ports GPIO[4]]
set_property PACKAGE_PIN M15 [get_ports GPIO[5]]
set_property IOSTANDARD LVCMOS25 [get_ports GPIO[5]]



set_property PACKAGE_PIN D1 [get_ports COUPLED_SIGNALS[0]] 
set_property IOSTANDARD LVCMOS25 [get_ports COUPLED_SIGNALS[0]]
set_property PACKAGE_PIN J3 [get_ports COUPLED_SIGNALS[1]] 
set_property IOSTANDARD LVCMOS25 [get_ports COUPLED_SIGNALS[1]]


#set_property CLOCK_DEDICATED_ROUTE BACKBONE [get_nets data_clk_wiz/inst/clk_in1_clk_wiz_diffclk]
#set_property CLOCK_DEDICATED_ROUTE ANY_CMT_COLUMN [get_nets frame_clk_wiz/inst/clk_in1_clk_wiz_diffclk]

#for ip
#set_property CLOCK_DEDICATED_ROUTE BACKBONE [get_nets enc_clk_gen/inst/clk_in1_clk_wiz_3] 

#for rev 1 shenanigans without proper clock pins
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets my_adc_ip_yay/inst/inst_AdcClock/clk_in1_clk_wiz_0] 

#tell vivado about the dclk input
#create_clock -period 5.000 -name dclk_raw_p [get_ports DCO_P]

#set_property CLOCK_DEDICATED_ROUTE BACKBONE [get_nets instance_name/inst/clk_in1_clk_wiz_dclk_simple] 
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets instance_name2/inst/clk_in1_clk_wiz_dclk_simple]

set_property CLOCK_DEDICATED_ROUTE BACKBONE [get_nets clk_wiz_ft601/inst/clk_in1_clk_wiz_ft601_please_work]
set_property CLOCK_DEDICATED_ROUTE BACKBONE [get_nets clk_wiz_ft601/inst/clk_in1_clk_wiz_ft601_please_work_diff_deg]
set_property CLOCK_DEDICATED_ROUTE BACKBONE [get_nets clk_wiz_ft601/inst/clk_in1_clk_wiz_ft601_please_work_diff_deg_1]
set_property CLOCK_DEDICATED_ROUTE BACKBONE [get_nets my_ft601_clk_adj/my_adj_ft601_clk/inst/clk_in1_clk_wiz_ft601_adj]


#for testing just dclk's existence and frequency
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets instance_name/inst/clk_in1_clk_wiz_dclk_simple]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets instance_name2/inst/clk_in1_clk_wiz_frame_clock]

#triggering
set_property PACKAGE_PIN R16 [get_ports DATA_FLAGS[0]] 
set_property IOSTANDARD LVCMOS25 [get_ports DATA_FLAGS[0]]
set_property PACKAGE_PIN R15 [get_ports DATA_FLAGS[1]] 
set_property IOSTANDARD LVCMOS25 [get_ports DATA_FLAGS[1]]

set_property PACKAGE_PIN T14 [get_ports RESET_IN] 
set_property IOSTANDARD LVCMOS25 [get_ports RESET_IN]

set_property PACKAGE_PIN T15 [get_ports TRIGGER_IN] 
set_property IOSTANDARD LVCMOS25 [get_ports TRIGGER_IN]


#please forgive me for doing this line to override my bad clock placement
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets data_clk_wiz/inst/clk_in1_clk_wiz_diffclk]
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets frame_clk_wiz/inst/clk_in1_clk_wiz_diffclk]
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets LED_OBUF[7]]

