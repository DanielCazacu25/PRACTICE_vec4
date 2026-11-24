`include "uvm_macros.svh"
import uvm_pkg::*;

class vec4_sat_test extends vec4_test;

    `uvm_component_utils(vec4_sat_test)

    function new(string name = "vec4_sat_test", uvm_component parent);
 
        super.new(name, parent);
 
    endfunction

    function void build_phase(uvm_phase phase);

        set_type_override_by_type(vec4_sequence::get_type(), vec4_sat_sequence::get_type());
        
        super.build_phase(phase);
        
    endfunction
  
endclass