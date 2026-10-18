`timescale 1ns / 1ps

module vec4_sva
(
    input logic clk,
    input logic in_valid,
    input logic [3:0] in_tag,
    input logic [3:0][15:0] in_a,
    input logic [3:0][15:0] in_b,
    input logic rst_n,

    input logic out_valid,
    input logic [3:0] out_tag,
    input logic [15:0] out_result,
    input logic out_sat
    );

    property low_valid_during_reset;
        @(posedge clk) !rst_n |-> !out_valid;
    endproperty

    property no_high_lost_transaction;
        @(posedge clk) disable iff (!rst_n)
        in_valid |-> ##3 out_valid;
    endproperty

    property no_low_lost_transaction;
        @(posedge clk) disable iff (!rst_n)
        !in_valid |-> ##3 !out_valid;
    endproperty

    property no_unexpected_data_after_reset;
        @(posedge clk) disable iff (!rst_n)
        $rose(rst_n) |-> !out_valid[*3];
    endproperty

    property equal_tag_after_three_cycles;
        logic [3:0] local_tag;
        @(posedge clk) disable iff (!rst_n)
        (in_valid, local_tag = in_tag) |-> ##3 local_tag == out_tag;
    endproperty

    property defined_valid_after_reset;
        @(posedge clk) disable iff (!rst_n)
        !$isunknown(out_valid);
    endproperty

    A1: assert property (low_valid_during_reset)        else $error("A1: out_valid != 0 during reset");
    A2: assert property (no_high_lost_transaction)      else $error("A2: in_valid not followed by out_valid after 3 cycles");
    A3: assert property (no_low_lost_transaction)       else $error("A3: out_valid without in_valid 3 cycles earlier");
    A4: assert property (no_unexpected_data_after_reset) else $error("A4: out_valid during the 3 cycles after reset release");
    A5: assert property (equal_tag_after_three_cycles)  else $error("A5: out_tag does not match in_tag from 3 cycles earlier");
    A6: assert property (defined_valid_after_reset)     else $error("A6: out_valid is X/Z after reset");

    C1: cover property (@(posedge clk) in_valid ##[1:2] !rst_n);
    C2: cover property (@(posedge clk) in_valid ##1 in_valid);
    C3: cover property (@(posedge clk) $rose(rst_n) ##0 in_valid);
endmodule

bind vec4_dot vec4_sva assertions(.*);