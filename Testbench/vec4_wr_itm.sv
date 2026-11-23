`include "uvm_macros.svh"
import uvm_pkg::*;

typedef logic signed [15:0] in_type;

class vec4_wr_itm extends uvm_sequence_item;

    rand in_type [3:0] in_a;
    rand in_type [3:0] in_b;
    rand logic [1:0] delay;
    rand bit random_reset;
    logic [3:0] in_tag;
    bit is_reset;
    int gap;

    `uvm_object_utils(vec4_wr_itm)

function new(string name = "vec4_wr_itm");

        super.new(name);
        
    endfunction

    constraint rare_reset {
        random_reset dist{
            1 := 5,
            0 := 95
        };
    }
    constraint common_back_to_back {
        delay dist{
            0 := 65,
            [1:3] :/ 35
        };
    }
    constraint value_distribution {
        foreach(in_a[i]) {
            in_a[i] dist{
                -32768, 32767 :/ 10,
                0 := 10,
                [-128:-1],[1:127] :/ 60,
                [-32767:-129],[128:32766] :/ 20
            };
        }
        foreach(in_b[i]) {
            in_b[i] dist{
                -32768, 32767 :/ 10,
                0 := 10,
                [-128:-1],[1:127] :/ 60,
                [-32767:-129],[128:32766] :/ 20
            };
        }
    }
endclass