`include "uvm_macros.svh"
import uvm_pkg::*;

class vec4_rd_itm extends uvm_sequence_item;

    logic signed [15:0] out_result;
    logic [3:0] out_tag;
    logic out_sat;

    `uvm_object_utils(vec4_rd_itm)

function new(string name = "vec4_rd_itm");

        super.new(name);
        
    endfunction
endclass