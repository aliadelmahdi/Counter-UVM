package counter_coverage_pkg;
    import uvm_pkg::*;
    import counter_driver_pkg::*,
           counter_main_sequence_pkg::*,
           counter_reset_sequence_pkg::*,
           counter_seq_item_pkg::*,
           counter_config_pkg::*,
           counter_sequencer_pkg::*,
           counter_monitor_pkg::*,
           counter_config_pkg::*;
    `include "uvm_macros.svh"

    class counter_coverage extends uvm_component;
        `uvm_component_utils(counter_coverage)

        // Analysis Export for receiving transactions from monitors
        uvm_analysis_export #(counter_seq_item) cov_export;

        uvm_tlm_analysis_fifo #(counter_seq_item) cov_c;

        counter_seq_item seq_item_cov;
        covergroup counter_crg;
      
            // Coverpoint for seq_item_cov.data_load when reset is deasserted and load is asserted
            loadcov: coverpoint seq_item_cov.data_load iff (seq_item_cov.rst_n && !seq_item_cov.load_n);
            
            // Coverpoint for seq_item_cov.count_out when reset is deasserted, clock enable is asserted, and counting up
            count_binsupcov: coverpoint seq_item_cov.count_out iff (seq_item_cov.rst_n && seq_item_cov.ce && seq_item_cov.up_down);
            
            // Coverpoint for seq_item_cov.count_out when reset is deasserted, clock enable is asserted, and counting down
            count_binsdncov: coverpoint seq_item_cov.count_out iff (seq_item_cov.rst_n && seq_item_cov.ce && !seq_item_cov.up_down);
            
        endgroup 


        // Constructor
        function new (string name = "counter_coverage", uvm_component parent);
            super.new(name, parent);
            counter_crg = new();
        endfunction

        // Build Phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            cov_export = new("cov_export", this);
            cov_c = new("cov_c", this);
        endfunction

        // Connect Phase
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            cov_export.connect(cov_c.analysis_export);
        endfunction

        // Run Phase
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                // Get the next transaction from the analysis FIFO.
                cov_c.get(seq_item_cov);
                counter_crg.sample();
            end
        endtask
        
    endclass : counter_coverage

endpackage : counter_coverage_pkg
