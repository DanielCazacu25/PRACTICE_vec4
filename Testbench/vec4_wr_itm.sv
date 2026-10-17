`include "uvm_macros.svh"
import uvm_pkg::*;

typedef logic signed [15:0] in_type;

class vec4_wr_itm extends uvm_sequence_item;

    rand in_type [3:0] in_a;
    rand in_type [3:0] in_b;
    rand logic [1:0] delay;
    logic [3:0] in_tag;

    `uvm_object_utils(vec4_wr_itm)

function new(string name = "vec4_wr_itm");

        super.new(name);
        
    endfunction
endclass