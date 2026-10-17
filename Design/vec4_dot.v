`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////
// vec4_dot - pipelined fixed-point dot product of two 4-element vectors
//
// Number format : signed Q8.8 (16 bits: 8 integer bits incl. sign, 8 fraction bits)
// Function      : result = round(a0*b0 + a1*b1 + a2*b2 + a3*b3), saturated to Q8.8
// Latency       : 3 clock cycles, throughput 1 result per cycle
// Reset         : asynchronous, active-low
//
// See vec4_dot_spec.md for the full specification.
//////////////////////////////////////////////////////////////////////////////

module vec4_dot (
    input  wire        clk,
    input  wire        rst_n,

    input  wire        in_valid,
    input  wire [3:0]  in_tag,
    input  wire [63:0] in_a,        // {a3, a2, a1, a0}
    input  wire [63:0] in_b,        // {b3, b2, b1, b0}

    output reg         out_valid,
    output reg  [3:0]  out_tag,
    output reg  [15:0] out_result,
    output reg         out_sat
);

    // ------------------------------------------------------------------
    // Input unpacking
    // ------------------------------------------------------------------
    wire signed [15:0] a0 = in_a[15:0];
    wire signed [15:0] a1 = in_a[31:16];
    wire signed [15:0] a2 = in_a[47:32];
    wire        [15:0] a3 = in_a[63:48];

    wire signed [15:0] b0 = in_b[15:0];
    wire signed [15:0] b1 = in_b[31:16];
    wire signed [15:0] b2 = in_b[47:32];
    wire signed [15:0] b3 = in_b[63:48];

    // ------------------------------------------------------------------
    // Stage 1: four parallel multiplications (Q8.8 x Q8.8 = Q16.16)
    // ------------------------------------------------------------------
    reg signed [31:0] p0, p1, p2, p3;
    reg               v1;
    reg        [3:0]  tag1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            v1   <= 1'b0;
            tag1 <= 4'd0;
            p0   <= 32'sd0;
            p1   <= 32'sd0;
            p2   <= 32'sd0;
            p3   <= 32'sd0;
        end else begin
            v1   <= in_valid;
            tag1 <= in_tag;
            p0   <= a0 * b0;
            p1   <= a1 * b1;
            p2   <= a2 * b2;
            p3   <= a3 * b3;
        end
    end

    // ------------------------------------------------------------------
    // Stage 2: first level of the adder tree
    // ------------------------------------------------------------------
    reg signed [32:0] s01, s23;
    reg               v2;
    reg        [3:0]  tag2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tag2 <= 4'd0;
            s01  <= 33'sd0;
            s23  <= 33'sd0;
        end else begin
            v2   <= v1;
            tag2 <= tag1;
            s01  <= p0 + p1;
            s23  <= p2 + p3;
        end
    end

    // ------------------------------------------------------------------
    // Stage 3: final add, rounding, saturation
    // ------------------------------------------------------------------
    wire signed [33:0] sum3 = s01 + s23;            // Q18.16
    wire signed [33:0] rnd3 = sum3 + 34'sd128;      // round half up
    wire signed [33:0] shr3 = rnd3 >>> 8;           // back to Q.8

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            out_valid  <= 1'b0;
            out_tag    <= 4'd0;
            out_result <= 16'd0;
            out_sat    <= 1'b0;
        end else begin
            out_valid <= v2;
            out_tag   <= tag2;
            if (shr3 > 32767) begin
                out_result <= 16'h7FFF;
                out_sat    <= 1'b1;
            end else if (shr3 < -32768) begin
                out_result <= 16'h8000;
                out_sat    <= 1'b0;
            end else begin
                out_result <= shr3[15:0];
                out_sat    <= 1'b0;
            end
        end
    end

endmodule