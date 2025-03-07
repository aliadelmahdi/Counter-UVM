package counter_sequencer_pkg;

    import uvm_pkg::*;
    import counter_seq_item_pkg::*;
    `include "uvm_macros.svh"

    class counter_sequencer extends uvm_sequencer #(counter_seq_item);

        `uvm_component_utils(counter_sequencer);

        function new(string name = "counter_sequence", uvm_component parent);
            super.new(name,parent);
        endfunction

    endclass : counter_sequencer

endpackage : counter_sequencer_pkg