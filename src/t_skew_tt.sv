/*
 * Copyright (c) 2025 Susumu Yamazaki
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module t_skew_tt #(
    parameter integer STAGES = 64
)(
    input  logic clk_a,
    input  logic clk_b,
    input  logic rst_n,
    output logic [ ($clog2(STAGES + 1) - 1) : 0 ] skew_code
);

    (* keep = "true", dont_touch = "true" *) logic [STAGES:0] chain;
    (* keep = "true", dont_touch = "true" *) logic [STAGES:0] sampled;

// delay chain
    assign chain[0] = clk_a;

    genvar i;
    generate
        for (i = 0; i < STAGES; i++)
            begin : gen_delay
                // two inverters to stabilize optimization
                (* keep = "true", dont_touch = "true" *) wire d;
                assign d = ~chain[i];
                assign chain[i+1] = ~d;
            end
    endgenerate

// sample with clk_b
    always_ff @(posedge clk_b or negedge rst_n)
        if (!rst_n)
            sampled <= 0;
        else
            sampled <= chain;

// thermometer to binary
    always_comb begin
        skew_code = 0;
        for (int k = 0; k <= STAGES; k++) begin
            if (sampled[k] == 1'b1)
                skew_code = k[ ($clog2(STAGES + 1) - 1) : 0 ];
        end
    end

endmodule
