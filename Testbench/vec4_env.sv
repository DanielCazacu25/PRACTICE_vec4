`include "uvm_macros.svh"
import uvm_pkg::*;

class vec4_env extends uvm_env;

    `uvm_component_utils(vec4_env)

    vec4_scoreboard scrb;

    vec4_wr_agn wr_agn;

    vec4_rd_agn rd_agn;

    vec4_wr_cov wr_cov;

    vec4_rd_cov rd_cov;


    function new(string name = "vec4_env", uvm_component parent);
 
        super.new(name,parent);
 
    endfunction

    function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        scrb = vec4_scoreboard :: type_id :: create("scrb",this);

        wr_agn = vec4_wr_agn :: type_id :: create("wr_agn",this);

        rd_agn = vec4_rd_agn :: type_id :: create("rd_agn",this);

        wr_cov = vec4_wr_cov :: type_id :: create("wr_cov",this);

        rd_cov = vec4_rd_cov :: type_id :: create("rd_cov",this);

      
    endfunction

    function void connect_phase(uvm_phase phase);

        super.connect_phase(phase);

        wr_agn.wr_mon.wr_port.connect(scrb.wr_imp);

        wr_agn.wr_mon.wr_port.connect(wr_cov.analysis_export);

        rd_agn.rd_mon.rd_port.connect(scrb.rd_imp);

        rd_agn.rd_mon.rd_port.connect(rd_cov.analysis_export);
      
    endfunction
  
endclass