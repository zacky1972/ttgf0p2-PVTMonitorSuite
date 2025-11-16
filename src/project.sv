/*
 * Copyright (c) 2025 Susumu Yamazaki
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_zacky1972_PVTMonitorSuite
(
    input  logic [7:0] ui_in,    // Dedicated inputs
    /* verilator lint_off UNDRIVEN */
    output logic [7:0] uo_out,   // Dedicated outputs
    input  logic [7:0] uio_in,   // IOs: Input path
    output logic [7:0] uio_out,  // IOs: Output path
    output logic [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  logic       ena,      // always 1 when the design is powered, so you can ignore it
    input  logic       clk,      // clock
    input  logic       rst_n     // reset_n - low to reset
);

  logic[7:0] measured_cnt;
  logic[7:0] skew_code;
  logic clk_a;

  // Use the ring oscillator
  inv_ring_osc dut1
  (
    .ena(ui_in[0]),
    .osc_out(uo_out[0])
  );

  nand2_ring_osc dut2
  (
    .ena(ui_in[0]),
    .osc_out(uo_out[1])
  );

  t_clkq_setup_measure dut3
  (
    .clk(ui_in[1]),
    .rst_n(ui_in[2]),
    .start(ui_in[3]),
    .measured_cnt(measured_cnt)
  );

  t_skew_tt #(.STAGES(64)) dut4
  (
    .clk_a(ui_in[1]),
    .clk_b(ui_in[5]),
    .rst_n(ui_in[2]),
    .skew_code(skew_code[6:0])
  );

  assign skew_code[7] = 1'b0;
  assign uio_out = (ui_in[4]) ? measured_cnt : skew_code;

  // Unused outputs must be tied
  assign uo_out[6:2] = 5'b0;
  assign uio_oe      = 8'b1111_1111;

  // List all unused inputs to prevent warnings
  assign uo_out[7] = &(ui_in[7:6], uio_in);

endmodule
