/*
 * Copyright (c) 2025 Susumu Yamazaki
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

/*
 * The following code implements a NAND with 2 input gates. 
 * Warnings about circular combinational logic are suppressed,
 * as it is intended for use in a ring oscillator.
 */ 

module nand2
(
    input logic a,
    input logic b,
    /* verilator lint_off UNOPTFLAT */
    output logic y
);

    assign y = ~(a & b);

endmodule

/*
 * The following code creates a ring oscillator with 41 NAND2 stages,
 * which is expected to generate an oscillation signal of approximately 50 MHz
 * on the GF180MCU D process.
 */

module nand2_ring_osc
#(
    // The DEPTH value is set to 12, giving 20 * 2 + 1 = 41 stages.
    parameter DEPTH = 20
)(
    input  logic ena,
    output logic osc_out
);

    (* keep = "true", dont_touch = "true" *) logic [DEPTH*2:0] nand_in;
    (* keep = "true", dont_touch = "true" *) logic [DEPTH*2:0] nand_out;

    // forward chain
    genvar i;
    generate
        for (i = 0; i < DEPTH*2; i = i + 1) begin : gen_nand2
            (* keep = "true", dont_touch = "true" *)
            nand2 nand2_i (
                .a(nand_in[i]),
                .b(ena),
                .y(nand_out[i])
            );
            assign nand_in[i+1] = nand_out[i];
        end
    endgenerate

    // last stage
    (* keep = "true", dont_touch = "true" *)
    nand2 nand2_last (
        .a(nand_in[DEPTH*2]),
        .b(ena),
        .y(nand_out[DEPTH*2])
    );

    // loop back
    assign nand_in[0] = nand_out[DEPTH*2];

    assign osc_out = nand_in[0];
endmodule
