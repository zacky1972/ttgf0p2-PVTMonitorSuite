/*
 * Copyright (c) 2025 Susumu Yamazaki
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

/*
 * The following code implements to measure $t_{clkq} + t_{setup}$,
 * for 50MHz measurement clock and 1% precision.
 */

module t_clkq_setup_measure
#(
    parameter N = 16,           // Number of stages in the delay chain
    parameter CNT_WIDTH = 8     // Counter width
)(
    input  logic clk,
    input  logic rst_n,
    input  logic start,
    output logic [CNT_WIDTH-1:0] measured_cnt
);

/*
 * Delay chain using DFFs and NAND buffers.
 * Each stage propagates the signal sequentially to create measurable delay.
 */

    logic [N-1:0] dff_chain;
    logic [N-1:0] nand_buf1;
    logic [N-1:0] nand_buf2;

// Free-running counter to measure elapsed clock cycles.

    logic [CNT_WIDTH-1:0] counter;

// Sequential logic: delay chain update and counter increment.

    always_ff @(posedge clk or negedge rst_n)
        if (!rst_n)
            for (int i = 0; i < N; i++)
                dff_chain[i] <= 1'b0;
        else if (start)
            begin
                dff_chain[0] <= 1'b1;
                for (int i = 1; i < N; i++)
                    dff_chain[i] <= 1'b0;
            end
        else
            begin
                dff_chain[0] <= dff_chain[N - 1];
                for (int i = 1; i < N; i++)
                    dff_chain[i] <= nand_buf2[i - 1];
            end
        
// NAND buffers (slow gates)
    generate
        genvar i;

        for (i = 0; i < N; i++)
            begin
                assign nand_buf1[i] = ~(dff_chain[i] & 1'b1);
                assign nand_buf2[i] = ~(nand_buf1[i] & 1'b1);
            end
    endgenerate

// Counter
    always_ff @(posedge clk or negedge rst_n)
        if (!rst_n)
            counter <= {CNT_WIDTH{1'b0}};
        else
            counter <= counter + 1'b1;

    assign measured_cnt = counter;
endmodule


