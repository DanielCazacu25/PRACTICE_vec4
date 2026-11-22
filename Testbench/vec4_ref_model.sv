class vec4_ref_model;

    typedef struct{
        bit signed [15:0] exp_result;
        bit [3:0] exp_tag;
        bit exp_sat;
    } exp_pkg;

    static function exp_pkg vec4_reference(in_type [3:0] in_a, in_type [3:0] in_b);

        bit signed [33:0] Sum;
        bit signed [25:0] Round;
        exp_pkg pkg;
        
        Sum = ($signed(in_a[0]) * $signed(in_b[0])) + ($signed(in_a[1]) * $signed(in_b[1])) + 
              ($signed(in_a[2]) * $signed(in_b[2])) + ($signed(in_a[3]) * $signed(in_b[3]));
        
        Round = (Sum + 128) >>> 8;

        if(Round > 32767) begin
            pkg.exp_sat = 1;
            pkg.exp_result = 16'h7FFF;
        end
        else if(Round < -32768) begin
            pkg.exp_sat = 1;
            pkg.exp_result = 16'h8000;
        end
        else begin
            pkg.exp_sat = 0;
            pkg.exp_result = Round;
        end

        return pkg;

    endfunction
  
endclass