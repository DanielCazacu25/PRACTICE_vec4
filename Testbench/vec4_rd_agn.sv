`include "uvm_macros.svh"
import uvm_pkg::*;

//Note for everything commented:since the testbench has driver and sequencer only for wr_itm, they would not fit here. Even tho, I have decided to keep them to have an example of passive agent

class vec4_rd_agn extends uvm_agent;

    // vec4_drv drv;
    // vec4_sequencer seqr;
    vec4_rd_mon rd_mon;

    `uvm_component_utils(vec4_rd_agn)

    function new(string name = "vec4_rd_agn", uvm_component parent);
 
        super.new(name,parent);
 
    endfunction

    function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        rd_mon = vec4_rd_mon :: type_id :: create("rd_mon",this);

        // if(get_is_active() == UVM_ACTIVE) begin

        //     drv = vec4_drv :: type_id :: create("drv",this);
        //     seqr = vec4_sequencer :: type_id :: create("seqr",this);

        // end
      
    endfunction

    function void connect_phase(uvm_phase phase);

        super.connect_phase(phase);

        // if(get_is_active() == UVM_ACTIVE)

        //     drv.seq_item_port.connect(seqr.seq_item_export);
      
    endfunction
  
endclass