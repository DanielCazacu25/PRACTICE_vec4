import uvm_pkg::*;

module vec4_top;

    bit clk;

    vec4_inf inf(clk);

    vec4_dot DUT(.clk(inf.clk),
                 .rst_n(inf.rst_n),
                 .in_valid(inf.in_valid),
                 .in_tag(inf.in_tag),
                 .in_a(inf.in_a),
                 .in_b(inf.in_b),
                 .out_valid(inf.out_valid),
                 .out_tag(inf.out_tag),
                 .out_result(inf.out_result),
                 .out_sat(inf.out_sat));

    always #5 clk = ~clk;

    initial begin

        uvm_config_db#(virtual vec4_inf.DRIVER) :: set(null,"*","inf",inf);
        uvm_config_db#(virtual vec4_inf.MONITOR) :: set(null,"*","inf",inf);
        run_test();

    end
endmodule