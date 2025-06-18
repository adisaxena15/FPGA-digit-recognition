//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2022.2 (win64) Build 3671981 Fri Oct 14 05:00:03 MDT 2022
//Date        : Thu May  8 21:25:57 2025
//Host        : DESKTOP-HCESJA8 running 64-bit major release  (build 9200)
//Command     : generate_target mb_ddr3_wrapper.bd
//Design      : mb_ddr3_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module mb_ddr3_wrapper
   (LED,
    SYS_CLK_clk_n,
    SYS_CLK_clk_p,
    data,
    ddr3_addr,
    ddr3_ba,
    ddr3_cas_n,
    ddr3_ck_n,
    ddr3_ck_p,
    ddr3_cke,
    ddr3_dm,
    ddr3_dq,
    ddr3_dqs_n,
    ddr3_dqs_p,
    ddr3_odt,
    ddr3_ras_n,
    ddr3_reset_n,
    ddr3_we_n,
    hex_grid_right,
    hex_seg_right,
    hsync,
    pclk,
    photo_btn,
    pwdn,
    read_btn,
    reset,
    reset_rtl_0,
    uart_rxd,
    uart_txd,
    vsync,
    xclk);
  output [15:0]LED;
  input SYS_CLK_clk_n;
  input SYS_CLK_clk_p;
  input [7:0]data;
  output [12:0]ddr3_addr;
  output [2:0]ddr3_ba;
  output ddr3_cas_n;
  output [0:0]ddr3_ck_n;
  output [0:0]ddr3_ck_p;
  output [0:0]ddr3_cke;
  output [1:0]ddr3_dm;
  inout [15:0]ddr3_dq;
  inout [1:0]ddr3_dqs_n;
  inout [1:0]ddr3_dqs_p;
  output [0:0]ddr3_odt;
  output ddr3_ras_n;
  output ddr3_reset_n;
  output ddr3_we_n;
  output [3:0]hex_grid_right;
  output [7:0]hex_seg_right;
  input hsync;
  input pclk;
  input photo_btn;
  output pwdn;
  input read_btn;
  output reset;
  input reset_rtl_0;
  input uart_rxd;
  output uart_txd;
  input vsync;
  output xclk;

  wire [15:0]LED;
  wire SYS_CLK_clk_n;
  wire SYS_CLK_clk_p;
  wire [7:0]data;
  wire [12:0]ddr3_addr;
  wire [2:0]ddr3_ba;
  wire ddr3_cas_n;
  wire [0:0]ddr3_ck_n;
  wire [0:0]ddr3_ck_p;
  wire [0:0]ddr3_cke;
  wire [1:0]ddr3_dm;
  wire [15:0]ddr3_dq;
  wire [1:0]ddr3_dqs_n;
  wire [1:0]ddr3_dqs_p;
  wire [0:0]ddr3_odt;
  wire ddr3_ras_n;
  wire ddr3_reset_n;
  wire ddr3_we_n;
  wire [3:0]hex_grid_right;
  wire [7:0]hex_seg_right;
  wire hsync;
  wire pclk;
  wire photo_btn;
  wire pwdn;
  wire read_btn;
  wire reset;
  wire reset_rtl_0;
  wire uart_rxd;
  wire uart_txd;
  wire vsync;
  wire xclk;

  mb_ddr3 mb_ddr3_i
       (.LED(LED),
        .SYS_CLK_clk_n(SYS_CLK_clk_n),
        .SYS_CLK_clk_p(SYS_CLK_clk_p),
        .data(data),
        .ddr3_addr(ddr3_addr),
        .ddr3_ba(ddr3_ba),
        .ddr3_cas_n(ddr3_cas_n),
        .ddr3_ck_n(ddr3_ck_n),
        .ddr3_ck_p(ddr3_ck_p),
        .ddr3_cke(ddr3_cke),
        .ddr3_dm(ddr3_dm),
        .ddr3_dq(ddr3_dq),
        .ddr3_dqs_n(ddr3_dqs_n),
        .ddr3_dqs_p(ddr3_dqs_p),
        .ddr3_odt(ddr3_odt),
        .ddr3_ras_n(ddr3_ras_n),
        .ddr3_reset_n(ddr3_reset_n),
        .ddr3_we_n(ddr3_we_n),
        .hex_grid_right(hex_grid_right),
        .hex_seg_right(hex_seg_right),
        .hsync(hsync),
        .pclk(pclk),
        .photo_btn(photo_btn),
        .pwdn(pwdn),
        .read_btn(read_btn),
        .reset(reset),
        .reset_rtl_0(reset_rtl_0),
        .uart_rxd(uart_rxd),
        .uart_txd(uart_txd),
        .vsync(vsync),
        .xclk(xclk));
endmodule
