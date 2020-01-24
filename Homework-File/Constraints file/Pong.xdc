## This file is a general .xdc for the PYNQ-Z2 board
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

## Clock signal 125 MHz

#set_property -dict { PACKAGE_PIN H16   IOSTANDARD LVCMOS33 } [get_ports { sysclk }]; #IO_L13P_T2_MRCC_35 Sch=sysclk
#create_clock -add -name sys_clk_pin -period 8.00 -waveform {0 4} [get_ports { sysclk }];

##Switches

set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS33} [get_ports {sws_2bits_tri_i[0]}]
#set_property -dict { PACKAGE_PIN M19   IOSTANDARD LVCMOS33 } [get_ports { sw[1] }]; #IO_L7P_T1_AD2P_35 Sch=sw[1]


##Buttons

set_property -dict {PACKAGE_PIN D19 IOSTANDARD LVCMOS33} [get_ports {btn_4bits_tri_i[0]}]
set_property -dict {PACKAGE_PIN D20 IOSTANDARD LVCMOS33} [get_ports {btn_4bits_tri_i[1]}]
set_property -dict {PACKAGE_PIN L20 IOSTANDARD LVCMOS33} [get_ports {btn_4bits_tri_i[2]}]
set_property -dict {PACKAGE_PIN L19 IOSTANDARD LVCMOS33} [get_ports {btn_4bits_tri_i[3]}]

##HDMI Rx

#set_property -dict { PACKAGE_PIN H17   IOSTANDARD LVCMOS33 } [get_ports { hdmi_rx_cec }]; #IO_L13N_T2_MRCC_35 Sch=hdmi_rx_cec
#set_property -dict { PACKAGE_PIN P19   IOSTANDARD TMDS_33  } [get_ports { hdmi_rx_clk_n }]; #IO_L13N_T2_MRCC_34 Sch=hdmi_rx_clk_n
#set_property -dict { PACKAGE_PIN N18   IOSTANDARD TMDS_33  } [get_ports { hdmi_rx_clk_p }]; #IO_L13P_T2_MRCC_34 Sch=hdmi_rx_clk_p
#set_property -dict { PACKAGE_PIN W20   IOSTANDARD TMDS_33  } [get_ports { hdmi_rx_d_n[0] }]; #IO_L16N_T2_34 Sch=hdmi_rx_d_n[0]
#set_property -dict { PACKAGE_PIN V20   IOSTANDARD TMDS_33  } [get_ports { hdmi_rx_d_p[0] }]; #IO_L16P_T2_34 Sch=hdmi_rx_d_p[0]
#set_property -dict { PACKAGE_PIN U20   IOSTANDARD TMDS_33  } [get_ports { hdmi_rx_d_n[1] }]; #IO_L15N_T2_DQS_34 Sch=hdmi_rx_d_n[1]
#set_property -dict { PACKAGE_PIN T20   IOSTANDARD TMDS_33  } [get_ports { hdmi_rx_d_p[1] }]; #IO_L15P_T2_DQS_34 Sch=hdmi_rx_d_p[1]
#set_property -dict { PACKAGE_PIN P20   IOSTANDARD TMDS_33  } [get_ports { hdmi_rx_d_n[2] }]; #IO_L14N_T2_SRCC_34 Sch=hdmi_rx_d_n[2]
#set_property -dict { PACKAGE_PIN N20   IOSTANDARD TMDS_33  } [get_ports { hdmi_rx_d_p[2] }]; #IO_L14P_T2_SRCC_34 Sch=hdmi_rx_d_p[2]
#set_property -dict { PACKAGE_PIN T19   IOSTANDARD LVCMOS33 } [get_ports { hdmi_rx_hpd }]; #IO_25_34 Sch=hdmi_rx_hpd
#set_property -dict { PACKAGE_PIN U14   IOSTANDARD LVCMOS33 } [get_ports { hdmi_rx_scl }]; #IO_L11P_T1_SRCC_34 Sch=hdmi_rx_scl
#set_property -dict { PACKAGE_PIN U15   IOSTANDARD LVCMOS33 } [get_ports { hdmi_rx_sda }]; #IO_L11N_T1_SRCC_34 Sch=hdmi_rx_sda

##HDMI Tx

#set_property -dict { PACKAGE_PIN G15   IOSTANDARD LVCMOS33 } [get_ports { hdmi_tx_cec }]; #IO_L19N_T3_VREF_35 Sch=hdmi_tx_cec
set_property -dict {PACKAGE_PIN L17 IOSTANDARD TMDS_33} [get_ports clk_n_0]
set_property -dict {PACKAGE_PIN L16 IOSTANDARD TMDS_33} [get_ports clk_p_0]
set_property -dict {PACKAGE_PIN K18 IOSTANDARD TMDS_33} [get_ports {data_n_0[0]}]
set_property -dict {PACKAGE_PIN K17 IOSTANDARD TMDS_33} [get_ports {data_p_0[0]}]
set_property -dict {PACKAGE_PIN J19 IOSTANDARD TMDS_33} [get_ports {data_n_0[1]}]
set_property -dict {PACKAGE_PIN K19 IOSTANDARD TMDS_33} [get_ports {data_p_0[1]}]
set_property -dict {PACKAGE_PIN H18 IOSTANDARD TMDS_33} [get_ports {data_n_0[2]}]
set_property -dict {PACKAGE_PIN J18 IOSTANDARD TMDS_33} [get_ports {data_p_0[2]}]
#set_property -dict { PACKAGE_PIN R19   IOSTANDARD LVCMOS33 } [get_ports { hdmi_tx_hpdn }]; #IO_0_34 Sch=hdmi_tx_hpdn


##Crypto SDA

#set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { crypto_sda }]; #IO_25_35 Sch=crypto_sda

set_clock_groups -asynchronous -group [get_clocks clk_fpga_0] -group [get_clocks pclk_Pong_clk_wiz_0_0]
