`include "uvm_macros.svh"
import uvm_pkg::*;

class vec4_drv extends uvm_driver #(vec4_wr_itm);

    virtual vec4_inf.DRIVER drv_inf;

    bit [3:0] counter;

    `uvm_component_utils(vec4_drv)

    function new(string name = "vec4_drv", uvm_component parent);

        super.new(name,parent);
        
    endfunction

    function void build_phase(uvm_phase phase);
        
        super.build_phase(phase);

        if(!uvm_config_db#(virtual vec4_inf.DRIVER) :: get(this,"","inf",drv_inf))

            `uvm_fatal("NOINF","Interface not found")
        
    endfunction

    task reset(int nr_cycles);

        drv_inf.drv_cb.rst_n <= 0;
        drv_inf.drv_cb.in_valid <= 0;

        repeat(nr_cycles) begin
            @(drv_inf.drv_cb);
        end

        @(drv_inf.drv_cb);
        drv_inf.drv_cb.rst_n <= 1;
        
    endtask

    task drv_task(vec4_wr_itm itm);

        bit [63:0] temp_a, temp_b;
        bit [3:0] temp_tag;

        if(itm.random_reset == 1) begin

            @(drv_inf.drv_cb);
            reset(3);

        end

        repeat(itm.delay) begin
            
            @(drv_inf.drv_cb);
            drv_inf.drv_cb.in_valid <= 0;
            if(!std::randomize(temp_a,temp_b,temp_tag))
                `uvm_error(get_type_name(),"Error while trying to randomize")
            drv_inf.drv_cb.in_a <= temp_a;
            drv_inf.drv_cb.in_b <= temp_b;
            drv_inf.drv_cb.in_tag <= temp_tag;

        end

        @(drv_inf.drv_cb);
        drv_inf.drv_cb.in_valid <= 1'b1;
        drv_inf.drv_cb.in_a <= itm.in_a;
        drv_inf.drv_cb.in_b <= itm.in_b;
        drv_inf.drv_cb.in_tag <= counter;
        itm.in_tag = counter;
        counter++;
    endtask

    task run_phase(uvm_phase phase);

        vec4_wr_itm itm;

        reset(3);

        forever begin
            
            seq_item_port.try_next_item(itm);
            if(itm != null) begin

            drv_task(itm);

            seq_item_port.item_done();

            end

            else begin
                
                @(drv_inf.drv_cb);
                drv_inf.drv_cb.in_valid <= 0;

            end

        end
        
    endtask
    

endclass