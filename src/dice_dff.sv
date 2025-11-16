`default_nettype none

module dice_dff (
    input  logic clk,
    input  logic rst_n,
    input  logic d,
    output logic q
);

// Internal latches (2 sets for DICE structure)
    logic q1a, q1b;
    logic q2a, q2b;

// Latch set 1
    always_ff @(posedge clk or negedge rst_n)
        if (!rst_n)
            begin
                q1a <= 1'b0;
                q1b <= 1'b0;
            end else begin
                q1a <= d ^ q2b;
                q1b <= d ^ q2a;
            end

// Latch set 2
    always_ff @(posedge clk or negedge rst_n)
        if (!rst_n)
            begin
                q2a <= 1'b0;
                q2b <= 1'b0;
            end else begin
                q2a <= q1a;
                q2b <= q1b;
            end

// Output logic combines internal latch states
    assign q = q1a ^ q2a;

endmodule
