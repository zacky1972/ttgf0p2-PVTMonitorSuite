/*
 * Copyright (c) 2025 Susumu Yamazaki
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module leap_dice_dff_t_clkq_setup_measure
#(
    parameter integer N = 16,
    parameter integer CNT_WIDTH = 8
)(
    input  logic clk,
    input  logic rst_n,
    input  logic start,
    output logic [CNT_WIDTH-1:0] measured_cnt
);

// Delay chain
    logic [N-1:0] dff_chain;
    logic [CNT_WIDTH-1:0] counter;

    leap_dice_dff u_dff (
        .clk(clk),
        .rst_n(rst_n),
        .d(start ? 0 : dff_chain[N - 1]),
        .q(dff_chain[0])
    );

    genvar i;
    generate
        for (i = 1; i < N; i=i+1)            
            leap_dice_dff u_dff (
                .clk(clk),
                .rst_n(rst_n),
                .d(start ? 0 : dff_chain[i - 1]),
                .q(dff_chain[i])
            );
    endgenerate

// Counter
    logic measuring;
    
    always_ff @(posedge clk or negedge rst_n)
        if (!rst_n)
            begin
                counter <= {CNT_WIDTH{1'b0}};
                measured_cnt <= {CNT_WIDTH{1'b0}};
                measuring <= 0;
            end
        else if (start)
            begin
                counter <= {CNT_WIDTH{1'b0}};
                measured_cnt <= {CNT_WIDTH{1'b0}};
                measuring <= 1;
            end
        else if (measuring)
            begin
                counter <= counter + 1'b1;
                if (dff_chain[N - 1])
                    begin
                        measured_cnt <= counter;
                        measuring <= 0;
                    end
            end
endmodule
