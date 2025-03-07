package counter_agent_pkg;
    import uvm_pkg::*,
    counter_seq_item_pkg::*,
    counter_driver_pkg::*,
    counter_main_sequence_pkg::*,
    counter_reset_sequence_pkg::*,
    counter_sequencer_pkg::*,
    counter_monitor_pkg::*,
    counter_config_pkg::*;
    `include "uvm_macros.svh"
 
    class counter_agent extends uvm_agent;

        `uvm_component_utils(counter_agent)
        counter_sequencer c_seqr;
        counter_driver c_drv;
        counter_monitor c_mon;
        counter_config c_cnfg;
        uvm_analysis_port #(counter_seq_item) agent_ap;

        function new(string name = "counter_agent", uvm_component parent);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            if(!uvm_config_db #(counter_config)::get(this,"","CFG",c_cnfg)) 
                `uvm_fatal ("build_phase","Unable to get configuration object from the database")
            
            c_drv = counter_driver::type_id::create("drv",this);
            c_seqr = counter_sequencer::type_id::create("c_seqr",this);
            c_mon = counter_monitor::type_id::create("mon",this);
            agent_ap = new("agent_ap",this);
        endfunction

        function void connect_phase(uvm_phase phase);

            c_drv.c_if = c_cnfg.c_if;
            c_mon.c_if = c_cnfg.c_if;

            c_drv.seq_item_port.connect(c_seqr.seq_item_export);
            c_mon.monitor_ap.connect(agent_ap);
        endfunction

    endclass : counter_agent

endpackage : counter_agent_pkg