
class vec4_wr_cov extends uvm_subscriber#(vec4_wr_itm);

    `uvm_component_utils(vec4_wr_cov)

    short i;

    covergroup wr_cg with function sample(bit signed [15:0]a_i,
                                          bit signed [15:0]b_i,
                                          bit [1:0] pos);

        a_sign : coverpoint a_i {
            bins negative = {[-32768:-1]};
            bins zero = {0};
            bins positive = {[1:32767]};
        }

        a_extremes : coverpoint a_i {
            bins max = {32767};
            bins min = {-32768};
        }

        b_sign : coverpoint b_i {
            bins negative = {[-32768:-1]};
            bins zero = {0};
            bins positive = {[1:32767]};
        }

        b_extremes : coverpoint b_i {
            bins max = {32767};
            bins min = {-32768};
        }

        all_positions : coverpoint pos {
            bins p1 = {0};
            bins p2 = {1};
            bins p3 = {2};
            bins p4 = {3};
        }

        a_sign_pos : cross a_sign, all_positions;
        b_sign_pos : cross b_sign, all_positions;

    endgroup

    covergroup gap_cg with function sample(int gap);

        gap_cp : coverpoint gap {
            bins zero = {0};
            bins one = {1};
            bins two = {2};
            bins three = {3};
            bins others = {[4:$]};
        }

    endgroup


    function new(string name = "vec4_wr_cov", uvm_component parent);
 
        super.new(name,parent);

        wr_cg = new();
        gap_cg = new();
 
    endfunction

    function void write(vec4_wr_itm wr_itm);

    if(!wr_itm.is_reset) begin

        for(i = 0;i<4;i++) begin
            wr_cg.sample(wr_itm.in_a[i], wr_itm.in_b[i], i);
        end

        gap_cg.sample(wr_itm.gap);

    end

    endfunction
  
endclass