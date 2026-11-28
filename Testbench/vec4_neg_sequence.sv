`include "uvm_macros.svh"
import uvm_pkg::*;

class vec4_neg_sequence extends vec4_sequence;

    `uvm_object_utils(vec4_neg_sequence)

    typedef struct{
        bit signed [15:0] a;
        bit signed [15:0] b;
        bit [2:0] poz;
    }inputs_pkg;

    shortint i;
    inputs_pkg trns[$];
    int vals[] = '{-1, -10, -50, -100, 10, 50, 100};

    function void add_trns(bit signed [15:0] a, bit signed [15:0] b, bit [2:0] poz);
        inputs_pkg res;
        res.a = a;
        res.b = b;
        res.poz = poz;
        trns.push_back(res);
    endfunction

    function new(string name = "vec4_neg_sequence");

        super.new(name);

        for(i = 0; i <= 3; i++) begin
            foreach(vals[k]) add_trns(-1, vals[k],i);
            foreach(vals[k]) add_trns(vals[k], -1,i);
            foreach(vals[k]) add_trns(1, vals[k],i);
            foreach(vals[k]) add_trns(vals[k], 1,i);
        end

    endfunction

    task body();

        vec4_wr_itm wr_itm;
        
        `uvm_info(get_type_name(),$sformatf("override succeed"),UVM_LOW)

        foreach(trns[k]) begin
            
            wr_itm = vec4_wr_itm :: type_id :: create("wr_itm");

            start_item(wr_itm);
            for(i = 0; i <= 3; i++)begin
                if(i == trns[k].poz) begin
                    wr_itm.in_a[i] = trns[k].a;
                    wr_itm.in_b[i] = trns[k].b;
                end
                else begin
                    wr_itm.in_a[i] = 0;
                    wr_itm.in_b[i] = 0;
                end
            end

            wr_itm.delay = 1;
            wr_itm.random_reset = 0;

            finish_item(wr_itm);
        end
        
    endtask

endclass