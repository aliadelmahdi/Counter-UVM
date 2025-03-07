package counter_test_pkg;

    import  uvm_pkg::*,
            counter_env_pkg::*,
            counter_config_pkg::*,
            counter_driver_pkg::*,
            counter_main_sequence_pkg::*,
            counter_reset_sequence_pkg::*,
            counter_seq_item_pkg::*;
    `include "uvm_macros.svh"
    class counter_test extends uvm_test;

        `uvm_component_utils(counter_test)
        counter_env c_env;
        counter_config c_cnfg;
        virtual counter_if c_if;
        counter_main_sequence c_main_seq;
        counter_reset_sequence c_reset_seq;

        function new(string name = "counter_test", uvm_component parent);
            super.new(name,parent);
        endfunction

        // Build Phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            c_env = counter_env::type_id::create("env",this);
            c_cnfg = counter_config::type_id::create("counter_config",this);
            c_main_seq = counter_main_sequence::type_id::create("main_seq",this);
            c_reset_seq = counter_reset_sequence::type_id::create("reset_seq",this);

            if(!uvm_config_db #(virtual counter_if)::get(this,"","c_if",c_cnfg.c_if))  
                `uvm_fatal("build_phase" , " test - Unable to get the virtual interface of the counter form the configuration database");

            uvm_config_db # (counter_config)::set (this , "*" , "CFG",c_cnfg );
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);

            // Reset sequence
            `uvm_info("run_phase","stimulus Generation started",UVM_LOW)
            c_reset_seq.start(c_env.c_agent.c_seqr);
            `uvm_info("run_phase","Reset Deasserted",UVM_LOW)
            
            // Main Sequence
            `uvm_info("run_phase", "Stimulus Generation Started",UVM_LOW)
            c_main_seq.start(c_env.c_agent.c_seqr);
            `uvm_info("run_phase", "Stimulus Generation Ended",UVM_LOW) 

            phase.drop_objection(this);
        endtask

    endclass : counter_test
    
endpackage : counter_test_pkg