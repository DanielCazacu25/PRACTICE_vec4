`include "uvm_macros.svh"
import uvm_pkg::*;

class vec4_sequencer extends uvm_sequencer #(vec4_wr_itm);

    `uvm_component_utils(vec4_sequencer)

    function new(string name = "vec4_sequencer", uvm_component parent);

        super.new(name,parent);
        
    endfunction
    
endclass