package counter_main_sequence_pkg;

    import uvm_pkg::*;
    import counter_seq_item_pkg::*;
    `include "uvm_macros.svh"

    class counter_main_sequence extends uvm_sequence #(counter_seq_item);

        `uvm_object_utils (counter_main_sequence);
        counter_seq_item seq_item;

        function new(string name = "counter_main_sequence");
            super.new(name);            
        endfunction
        
        task body;

            repeat(10000) begin
                seq_item = counter_seq_item::type_id::create("seq_item");
                start_item(seq_item);
                assert(seq_item.randomize()) else $error("Randomization Failed");
                finish_item(seq_item);
            end

        endtask
        
    endclass : counter_main_sequence

endpackage : counter_main_sequence_pkg