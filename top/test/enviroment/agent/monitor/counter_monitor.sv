package counter_monitor_pkg;

    import uvm_pkg::*,
           counter_seq_item_pkg::*;

    `include "uvm_macros.svh"

    class counter_monitor extends uvm_monitor;

        `uvm_component_utils (counter_monitor)
        virtual counter_if c_if;
        counter_seq_item response_seq_item;
        uvm_analysis_port #(counter_seq_item) monitor_ap;

        function new(string name = "counter_monitor",uvm_component parent);
            super.new(name,parent);
        endfunction

        // Build Phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            monitor_ap = new ("monitor_ap",this);
        endfunction

        // Run Phase
        task run_phase (uvm_phase phase);
            super.run_phase(phase);
            forever begin
                response_seq_item = counter_seq_item::type_id::create("response_seq_item");
                @(negedge c_if.clk);
                response_seq_item.rst_n = c_if.rst_n;
                response_seq_item.data_load = c_if.data_load;
                response_seq_item.load_n = c_if.load_n;
                response_seq_item.up_down = c_if.up_down;
                response_seq_item.ce = c_if.ce;
                response_seq_item.count_out = c_if.count_out;
                response_seq_item.max_count = c_if.max_count;
                response_seq_item.zero_flag = c_if.zero_flag;

                monitor_ap.write(response_seq_item);
                `uvm_info("run_phase", response_seq_item.sprint(), UVM_HIGH)
            end

        endtask
        
    endclass : counter_monitor

endpackage : counter_monitor_pkg