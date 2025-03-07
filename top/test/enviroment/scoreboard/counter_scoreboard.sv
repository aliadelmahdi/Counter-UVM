package counter_scoreboard_pkg;
    import uvm_pkg::*;
    import counter_seq_item_pkg::*;
    `include "uvm_macros.svh"
    class counter_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(counter_scoreboard)
        uvm_analysis_export #(counter_seq_item) sb_export;
        uvm_tlm_analysis_fifo #(counter_seq_item) sb_c;
        counter_seq_item seq_item_sb;

        logic [counter_seq_item_pkg::WIDTH-1:0] count_out_ref;//the logic of the counter
        logic max_count_ref; //when the counter reaches the maximum value; this signal is high; else low
        logic zero_flag_ref; //when the counter reaches the minimum value; this signal is high; else low

        int error_count = 0, correct_count = 0;

        function new(string name = "counter_scoreboard",uvm_component parent);
            super.new(name,parent);
        endfunction

        // Build Phase
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sb_export = new("sb_export",this);
            sb_c=new("sb_c",this);
        endfunction

        // Connect Phase
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sb_export.connect(sb_c.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                sb_c.get(seq_item_sb);
                check_results(seq_item_sb);
            end
        endtask

        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("report_phase",$sformatf("At time %0t: Simulation Ends and Error count= %0d, Correct count = %0d",$time,error_count,correct_count),UVM_MEDIUM);
        endfunction

        function void check_results(counter_seq_item seq_item_ch);
            golden_model(seq_item_ch);
            if (seq_item_ch.count_out != count_out_ref || seq_item_ch.zero_flag != zero_flag_ref || seq_item_ch.max_count != max_count_ref ) begin
                error_count++;
                `uvm_error("run_phase","Comparison Error between the golden model and the DUT")
            end
            else
                correct_count++;
        endfunction

        function void golden_model(counter_seq_item seq_item_chk);
            if (~seq_item_chk.rst_n) // Reset logic
                count_out_ref = 0; 
            else if (~seq_item_chk.load_n) 
                count_out_ref = seq_item_chk.data_load;
            else if (seq_item_chk.ce) 
                count_out_ref += seq_item_chk.up_down ? 1 : -1;
            zero_flag_ref = (count_out_ref == 0); // Update zero flag
            max_count_ref = (count_out_ref == {counter_seq_item_pkg::WIDTH{1'b1}}); // Update max count flag
        endfunction

    endclass : counter_scoreboard
    
endpackage : counter_scoreboard_pkg