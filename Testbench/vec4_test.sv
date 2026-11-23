`include "uvm_macros.svh"
import uvm_pkg::*;

class vec4_test extends uvm_test;

    `uvm_component_utils(vec4_test)

    vec4_env env;
    vec4_sequence seq;

    function new(string name = "vec4_test", uvm_component parent);
 
        super.new(name,parent);
 
    endfunction

    function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        env = vec4_env :: type_id :: create("env",this);
      
    endfunction

    task run_phase(uvm_phase phase);

        phase.raise_objection(this);

        seq = vec4_sequence :: type_id :: create("seq");

        seq.start(env.wr_agn.seqr);

        phase.phase_done.set_drain_time(this,500ns);

        phase.drop_objection(this);
      
    endtask
  
endclass