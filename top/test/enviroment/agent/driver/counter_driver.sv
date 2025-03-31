package counter_driver_pkg;

    import  uvm_pkg::*,
            counter_config_pkg::*,
            counter_seq_item_pkg::*;

    `include "uvm_macros.svh"

    class counter_driver extends uvm_driver #(counter_seq_item);
        `uvm_component_utils(counter_driver)
        virtual counter_if c_if;
        counter_seq_item stimulus_seq_item;

        function new(string name = "counter_driver", uvm_component parent);
            super.new(name,parent);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                stimulus_seq_item = counter_seq_item::type_id::create("stimulus_seq_item");
                seq_item_port.get_next_item(stimulus_seq_item);

                c_if.rst_n = stimulus_seq_item.rst_n;
                c_if.data_load = stimulus_seq_item.data_load;
                c_if.load_n = stimulus_seq_item.load_n;
                c_if.up_down = stimulus_seq_item.up_down;
                c_if.ce = stimulus_seq_item.ce;
                @(negedge c_if.clk)
                seq_item_port.item_done();
                `uvm_info("run_phase",stimulus_seq_item.sprint(),UVM_HIGH)
            end
        endtask
        
    endclass : counter_driver

endpackage : counter_driver_pkg