`include "uvm_macros.svh"
import uvm_pkg::*;

`uvm_analysis_imp_decl(_wr)
`uvm_analysis_imp_decl(_rd)

class vec4_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(vec4_scoreboard)

    int pass_count, fail_count, nr_elem;
    
    vec4_ref_model :: exp_pkg results_queue[$];

    uvm_analysis_imp_wr#(vec4_wr_itm, vec4_scoreboard) wr_imp;

    uvm_analysis_imp_rd#(vec4_rd_itm, vec4_scoreboard) rd_imp;

    function new(string name = "vec4_scoreboard", uvm_component parent);
 
        super.new(name,parent);
 
    endfunction

    function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        wr_imp = new("wr_imp",this);

        rd_imp = new("rd_imp",this);

        pass_count = 0;

        fail_count = 0;

        nr_elem = 0;
      
    endfunction

    function void write_wr(vec4_wr_itm item);

    vec4_ref_model :: exp_pkg struct_inst;

        if(item.is_reset)
            results_queue.delete();

        else begin
            
            struct_inst = vec4_ref_model::vec4_reference(item.in_a, item.in_b);
            struct_inst.exp_tag = item.in_tag;
            results_queue.push_back(struct_inst);

        end

    endfunction

    function void write_rd(vec4_rd_itm item);

    vec4_ref_model :: exp_pkg struct_inst;
    bit ok = 1;

        if(!results_queue.size()) begin
            fail_count++;
            `uvm_error(get_type_name(),$sformatf("Error, queue is empty when trying to read!"))
        end

        else begin
            struct_inst = results_queue.pop_front();
            if(struct_inst.exp_result !== item.out_result) begin
                ok = 0;
                fail_count++;
                `uvm_error(get_type_name(),$sformatf("Error, expected result : %0d | DUT result : %0d",struct_inst.exp_result,item.out_result))
            end
            if(struct_inst.exp_tag !== item.out_tag) begin
                if(ok == 1) begin
                    ok = 0;
                    fail_count++;
                end
                `uvm_error(get_type_name(),$sformatf("Error, expected tag : %0d | DUT tag : %0d",struct_inst.exp_tag,item.out_tag))
            end
            if(struct_inst.exp_sat !== item.out_sat) begin
                if(ok == 1) begin
                    ok = 0;
                    fail_count++;
                end
                `uvm_error(get_type_name(),$sformatf("Error, expected sat : %0d | DUT sat : %0d",struct_inst.exp_sat,item.out_sat))
            end
            if(ok == 1)
                pass_count++;
        end
    endfunction

    function void report_phase(uvm_phase phase);

        `uvm_info(get_type_name(), $sformatf("========== SUMMARY =========="), UVM_LOW)
        `uvm_info(get_type_name(), $sformatf("Transactions: %0d", pass_count + fail_count), UVM_LOW)
        `uvm_info(get_type_name(), $sformatf("Nr. of elements remained in queue: %0d",nr_elem),UVM_LOW)
        if(!fail_count && !nr_elem)
            `uvm_info(get_type_name(), $sformatf("Test PASSED with 0 FAILS"),UVM_LOW)
        else
            `uvm_info(get_type_name(), $sformatf("Test FAILED with %0d FAILS or/and %0d elements in queue",fail_count, nr_elem),UVM_LOW)
        `uvm_info(get_type_name(), $sformatf("=================================="), UVM_LOW)
      
    endfunction

    function void check_phase(uvm_phase phase);

        super.check_phase(phase);

        if(results_queue.size()) begin
            vec4_ref_model :: exp_pkg struct_inst;
            `uvm_error(get_type_name(), $sformatf("Queue is not empty, there are %0d items remained",results_queue.size()))
            nr_elem = results_queue.size();
            `uvm_info(get_type_name(),$sformatf("=================================="), UVM_LOW)
            `uvm_info(get_type_name(),$sformatf("Remained items in queue are:"), UVM_LOW)
            while(results_queue.size()) begin
                struct_inst = results_queue.pop_front();
                `uvm_info(get_type_name(),$sformatf("result : %0d | tag : %0d | sat : %0d",struct_inst.exp_result,struct_inst.exp_tag,struct_inst.exp_sat),UVM_LOW)
            end
            `uvm_info(get_type_name(),$sformatf("=================================="), UVM_LOW)
        end

      
    endfunction

endclass