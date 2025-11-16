/*
 * Copyright (c) 2025 Susumu Yamazaki
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module leap_dice_dff
(
    input  logic clk,
    input  logic rst_n,
    input  logic d,
    output logic q
);

// Internal nodes for DICE storage
    logic a, b, c, d_int;

// Positive-edge triggered DICE D-FF
    always_ff @(posedge clk or negedge rst_n)
        if (!rst_n)
            begin
                a     <= 1'b0;
                b     <= 1'b0;
                c     <= 1'b0;
                d_int <= 1'b0;
            end else begin
                // Dual Interlocked Storage Cell updates
                a     <= d & ~b;
                b     <= d | a;
                c     <= a & d_int;
                d_int <= c | b;
            end

// Output assignments
    assign q  = d_int;

endmodule
