`include "uvm_macros.svh"
import uvm_pkg::*;

class vec4_sat_sequence extends vec4_sequence;

    `uvm_object_utils(vec4_sat_sequence)

    typedef struct{
        bit signed [15:0] a;
        bit signed [15:0] b;
    }inputs_pkg;

    shortint i;
    inputs_pkg trns[$];
    int vals[] = '{-1000, 0, 1, 1000, 8191, 8192, 16383, 16384, 20000, 32767,
               -1, -100, -8192, -8193, -16384, -16385, -20000, -32767, -32768};

    function void add_trns(bit signed [15:0] a, bit signed [15:0] b);
        inputs_pkg res;
        res.a = a;
        res.b = b;
        trns.push_back(res);
    endfunction

    function new(string name = "vec4_sat_sequence");

        super.new(name);
        foreach(vals[k]) add_trns(64, vals[k]);
        foreach(vals[k]) add_trns(vals[k], 64);
        
    endfunction

    task body();

        vec4_wr_itm wr_itm;
        
        `uvm_info(get_type_name(),$sformatf("override succeed"),UVM_LOW)

        foreach(trns[k]) begin
            
            wr_itm = vec4_wr_itm :: type_id :: create("wr_itm");

            start_item(wr_itm);
            for(i = 0; i <= 3; i++)begin
                wr_itm.in_a[i] = trns[k].a;
                wr_itm.in_b[i] = trns[k].b;
            end

            wr_itm.delay = 1;
            wr_itm.random_reset = 0;

            finish_item(wr_itm);
        end
        
    endtask

endclass