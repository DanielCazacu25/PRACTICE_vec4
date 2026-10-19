`include "uvm_macros.svh"
import uvm_pkg::*;

class vec4_sequence extends uvm_sequence #(vec4_wr_itm);

    int nr_transactions = 1000;

    `uvm_object_utils(vec4_sequence)

    function new(string name = "vec4_sequence");

        super.new(name);
        
    endfunction

    task body();

        vec4_wr_itm wr_itm;

        repeat(nr_transactions) begin
            
            wr_itm = vec4_wr_itm :: type_id :: create("wr_itm");

            start_item(wr_itm);

            if(!wr_itm.randomize())
                `uvm_error(get_type_name(),"Error while trying to randomize")

            finish_item(wr_itm);
        end
        
    endtask

endclass