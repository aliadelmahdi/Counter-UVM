package counter_seq_item_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
    parameter WIDTH = 16; // Define the width of the counter as 16 bits
 
    class counter_seq_item extends uvm_sequence_item;
        `uvm_object_utils(counter_seq_item)
        rand bit rst_n,load_n,ce,up_down;
        rand logic [WIDTH-1:0] data_load;//load data to count_out logic when the load signal is asserted
        logic [WIDTH-1:0] count_out;//the logic of the counter
        logic max_count; //when the counter reaches the maximum value; this signal is high; else low
        logic zero_flag; //when the counter reaches the minimum value; this signal is high; else low

        function new(string name = "counter_seq_item");
            super.new(name);
        endfunction

        constraint rst_cons {
            rst_n dist {
                0:= 3,
                1:= 97
            };
        }
        constraint load_cons {
            load_n dist {
                0:= 70,
                1:= 30
            };
        }
        constraint ce_cons {
            ce dist {
                0:= 30,
                1:= 70
            };
        }
        constraint up_down_con {
            up_down dist {
                0:= 50,
                1:= 50
            };
        }

    endclass : counter_seq_item

endpackage : counter_seq_item_pkg