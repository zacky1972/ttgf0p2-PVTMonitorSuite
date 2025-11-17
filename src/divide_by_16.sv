/*
 * Copyright (c) 2025 Susumu Yamazaki
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module divide_by_16 (
    input  logic clk_in,
    input  logic rst_n,
    output logic clk_out
);

    logic [3:0] counter;

    always_ff @(posedge clk_in or negedge rst_n) begin
        if (!rst_n)
            counter <= 4'd0;
        else
            counter <= counter + 1'b1;
    end

    assign clk_out = counter[3];
endmodule
