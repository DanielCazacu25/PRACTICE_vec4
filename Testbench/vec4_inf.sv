interface vec4_inf(input logic clk);

logic in_valid = 0;
logic [3:0] in_tag = 0;
logic [3:0][15:0] in_a = 0;
logic [3:0][15:0] in_b = 0;
logic rst_n = 0;

logic out_valid;
logic [3:0] out_tag;
logic [15:0] out_result;
logic out_sat;

clocking drv_cb @(posedge clk);
    default input #1step output #1;
    output in_a, in_b, in_tag, in_valid, rst_n;
    input  out_valid, out_sat, out_tag, out_result;
endclocking

clocking mon_cb @(posedge clk);
    default input #1step output #1;
    input out_tag, out_result, in_a, in_b, in_tag, in_valid, out_sat, rst_n;
endclocking

modport DRIVER(clocking drv_cb);
modport MONITOR(clocking mon_cb);
    
endinterface