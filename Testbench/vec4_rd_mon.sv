`include "uvm_macros.svh"
import uvm_pkg::*;

class vec4_rd_mon extends uvm_monitor;
    
    `uvm_component_utils(vec4_rd_mon)

    uvm_analysis_port#(vec4_rd_itm) rd_port;

    virtual vec4_inf.MONITOR mon_inf;
    function new(string name = "vec4_rd_mon", uvm_component parent);

        super.new(name,parent);
        
    endfunction

    function void build_phase(uvm_phase phase);

        super.build_phase(phase);

     rd_port = new("rd_port",this);

        if(!uvm_config_db#(virtual vec4_inf.MONITOR) :: get(this,"","inf",mon_inf))

            `uvm_fatal("NOINF","Interface not found")
      
    endfunction

    task run_phase(uvm_phase phase);
        
        vec4_rd_itm rd_itm;


        forever begin
            
            @(mon_inf.mon_cb);
            if(mon_inf.mon_cb.out_valid) begin
                rd_itm = vec4_rd_itm :: type_id :: create("rd_itm",this);
                rd_itm.out_result = mon_inf.mon_cb.out_result;
                rd_itm.out_tag = mon_inf.mon_cb.out_tag;
                rd_itm.out_sat = mon_inf.mon_cb.out_sat;
                rd_port.write(rd_itm);
            end
        end
    endtask

    function void end_of_elaboration_phase(uvm_phase phase);

        super.end_of_elaboration_phase(phase);

        if  (rd_port.size() == 0)
            `uvm_fatal(get_type_name(),  "rd_port has no subscribers - read operations will not reach the scoreboard")

    endfunction

endclass