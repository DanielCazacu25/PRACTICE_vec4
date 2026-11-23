
class vec4_rd_cov extends uvm_subscriber#(vec4_rd_itm);

    `uvm_component_utils(vec4_rd_cov)

    covergroup rd_cg with function sample(bit signed [15:0] res,
                                          bit sat);

        extremes_cp : coverpoint res{
            bins max = {32767};
            bins min = {-32768};
        }

        sat_cp : coverpoint sat{
            bins zero = {0};
            bins one = {1};
        }

        sat_cross : cross extremes_cp, sat_cp;

    endgroup


    function new(string name = "vec4_rd_cov", uvm_component parent);
 
        super.new(name,parent);

        rd_cg = new();
 
    endfunction

    function void write(vec4_rd_itm rd_itm);

        rd_cg.sample(rd_itm.out_result, rd_itm.out_sat);

    endfunction
  
endclass