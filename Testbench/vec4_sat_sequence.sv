`include "uvm_macros.svh"
import uvm_pkg::*;

class vec4_sat_sequence extends vec4_sequence;

    `uvm_object_utils(vec4_sat_sequence)

    shortint i;
    shortint temp;
    int transaction_index;

    function new(string name = "vec4_sat_sequence");

        super.new(name);
        nr_transactions = 200;
        transaction_index = 0;
        
    endfunction

    task body();

        vec4_wr_itm wr_itm;
        
        `uvm_info(get_type_name(),$sformatf("override succeed"),UVM_LOW)

        repeat(nr_transactions) begin
            
            wr_itm = vec4_wr_itm :: type_id :: create("wr_itm");

            start_item(wr_itm);

            for(i = 0; i <= 3; i++) begin
                temp = (transaction_index) % 10;
                case(temp)
                    0 : begin
                        wr_itm.in_a[i] = 1449;
                        wr_itm.in_b[i] = 1449;
                    end
                    1 : begin
                        wr_itm.in_a[i] = 1449;
                        wr_itm.in_b[i] = -1449;
                        end
                    2 : begin
                        wr_itm.in_a[i] = 1000;
                        wr_itm.in_b[i] = 1000;
                    end
                    3 : begin
                        wr_itm.in_a[i] = -1449;
                        wr_itm.in_b[i] = -1449;
                    end
                    4 : begin
                        wr_itm.in_a[i] = -1449;
                        wr_itm.in_b[i] = 1449;
                    end
                    5 : begin
                        wr_itm.in_a[i] = 1448;
                        wr_itm.in_b[i] = 1448;
                    end
                    6 : begin
                        wr_itm.in_a[i] = -1000;
                        wr_itm.in_b[i] = 1000;
                    end
                    7 : begin
                        wr_itm.in_a[i] = 1000;
                        wr_itm.in_b[i] = -1000;
                    end
                    8 : begin
                        wr_itm.in_a[i] = -1000;
                        wr_itm.in_b[i] = -1000;
                    end
                    9 : begin
                        wr_itm.in_a[i] = 50;
                        wr_itm.in_b[i] = -1000;
                    end
                endcase
            end
            `uvm_info(get_type_name(), $sformatf("Transaction index : %0d |in_a = %0d | in_b = %0d",transaction_index,wr_itm.in_a[0],wr_itm.in_b[0]),UVM_HIGH)

            wr_itm.delay = 1;
            wr_itm.random_reset = 0;
            transaction_index++;

            finish_item(wr_itm);
        end
        
    endtask

endclass