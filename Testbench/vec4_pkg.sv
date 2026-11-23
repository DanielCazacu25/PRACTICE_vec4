package vec4_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "vec4_wr_itm.sv"
    `include "vec4_rd_itm.sv"
    `include "vec4_sequencer.sv"
    `include "vec4_sequence.sv"
    `include "vec4_drv.sv"
    `include "vec4_wr_mon.sv"
    `include "vec4_wr_cov.sv"
    `include "vec4_rd_mon.sv"
    `include "vec4_wr_agn.sv"
    `include "vec4_rd_agn.sv"
    `include "vec4_ref_model.sv"
    `include "vec4_scoreboard.sv"

endpackage