package counter_reset_sequence_pkg;

    import uvm_pkg::*,
           counter_seq_item_pkg::*;

    `include "uvm_macros.svh"

    class counter_reset_sequence extends uvm_sequence #(counter_seq_item);

        `uvm_object_utils (counter_reset_sequence)
        counter_seq_item seq_item;

        function new (string name = "counter_reset_sequence");
            super.new(name);
        endfunction

        task body;
            seq_item = counter_seq_item::type_id::create("seq_item");

            start_item(seq_item);
                seq_item.rst_n = 1;
                seq_item.data_load = 0;
                seq_item.load_n = 0;
                seq_item.up_down = 0;
                seq_item.ce = 0;
            finish_item(seq_item);

        endtask
        
    endclass : counter_reset_sequence

endpackage : counter_reset_sequence_pkg