`include "uvm_macros.svh"
import uvm_pkg::*;

class vec4_wr_agn extends uvm_agent;

    vec4_drv drv;
    vec4_sequencer seqr;
    vec4_wr_mon wr_mon;

    `uvm_component_utils(vec4_wr_agn)

    function new(string name = "vec4_wr_agn", uvm_component parent);
 
        super.new(name,parent);
 
    endfunction

    function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        drv = vec4_drv :: type_id :: create("drv",this);
        seqr = vec4_sequencer :: type_id :: create("seqr",this);
        wr_mon = vec4_wr_mon :: type_id :: create("wr_mon",this);
      
    endfunction

    function void connect_phase(uvm_phase phase);

        super.connect_phase(phase);

        drv.seq_item_port.connect(seqr.seq_item_export);
      
    endfunction
  
endclass