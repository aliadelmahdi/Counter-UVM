package counter_env_pkg; 
    import  uvm_pkg::*,
            counter_driver_pkg::*,
            counter_scoreboard_pkg::*,
            counter_main_sequence_pkg::*,
            counter_reset_sequence_pkg::*,
            counter_seq_item_pkg::*,
            counter_sequencer_pkg::*,
            counter_monitor_pkg::*,
            counter_config_pkg::*,
            counter_agent_pkg::*,
            counter_coverage_pkg::*;
    `include "uvm_macros.svh"

    class counter_env extends uvm_env;
        `uvm_component_utils(counter_env)

        counter_agent c_agent;
        counter_scoreboard c_sb;
        counter_coverage c_cov;

        function new (string name = "counter_env", uvm_component parent);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase );
        super.build_phase (phase);
            c_agent = counter_agent ::type_id ::create("c_agent",this);
            c_sb= counter_scoreboard ::type_id ::create("sb",this);
            c_cov= counter_coverage ::type_id ::create("cov",this);
        endfunction

        function void connect_phase (uvm_phase phase );
            c_agent.agent_ap.connect(c_sb.sb_export);
            c_agent.agent_ap.connect(c_cov.cov_export);
        endfunction
    endclass : counter_env
endpackage : counter_env_pkg