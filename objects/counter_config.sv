package counter_config_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class counter_config extends uvm_object;

        `uvm_object_utils (counter_config);
        virtual counter_if c_if;

        function new(string name = "counter_config");
            super.new(name);
        endfunction
        
    endclass : counter_config

endpackage : counter_config_pkg