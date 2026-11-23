`include "uvm_macros.svh"
import uvm_pkg::*;

class vec4_wr_mon extends uvm_monitor;
    
    `uvm_component_utils(vec4_wr_mon)

    uvm_analysis_port#(vec4_wr_itm) wr_port;

    virtual vec4_inf.MONITOR mon_inf;
    function new(string name = "vec4_wr_mon", uvm_component parent);

        super.new(name,parent);
        
    endfunction

    function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        wr_port = new("wr_port",this);

        if(!uvm_config_db#(virtual vec4_inf.MONITOR) :: get(this,"","inf",mon_inf))

            `uvm_fatal("NOINF","Interface not found")
      
    endfunction

    task run_phase(uvm_phase phase);
        
        vec4_wr_itm wr_itm;

        static bit past_rst = 0, current_rst = 0;

        int counter = 0;

        forever begin
            
            wr_itm = vec4_wr_itm :: type_id :: create("wr_itm",this);

            @(mon_inf.mon_cb);

            current_rst = mon_inf.mon_cb.rst_n;
            wr_itm.is_reset = !current_rst;
            if(past_rst && !current_rst)
                wr_port.write(wr_itm);
            past_rst = current_rst;
            if(current_rst && !mon_inf.mon_cb.in_valid) begin
                counter++;     
            end
            if(!current_rst)
                counter = 0;
            if(current_rst && mon_inf.mon_cb.in_valid) begin
                wr_itm.in_a = mon_inf.mon_cb.in_a;
                wr_itm.in_b = mon_inf.mon_cb.in_b;
                wr_itm.in_tag = mon_inf.mon_cb.in_tag;
                wr_itm.gap = counter;
                counter = 0;
                wr_port.write(wr_itm);
            end
        end
    endtask
    function void end_of_elaboration_phase(uvm_phase phase);

        super.end_of_elaboration_phase(phase);

        if (wr_port.size() == 0)
            `uvm_fatal(get_type_name(), "wr_port has no subscribers - write operations will not reach the scoreboard")

    endfunction

endclass