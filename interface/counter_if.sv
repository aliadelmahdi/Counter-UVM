interface counter_if (clk);

    input bit clk;

    parameter WIDTH = 16; // Define the width of the counter as 16 bits
    logic rst_n;//active low sync reset
    logic [WIDTH-1:0] data_load;//load data to count_out logic when the load signal is asserted
    logic load_n;// active low load signal When load_n is low; the counter is loaded with the value provided by data_load
    logic up_down;//when the logic is high then increment counter; else decrement the counter
    logic ce;//enable signal to increment or decrement the counter depending on the up_down
    logic [WIDTH-1:0] count_out;//the logic of the counter
    logic max_count; //when the counter reaches the maximum value; this signal is high; else low
    logic zero_flag; //when the counter reaches the minimum value; this signal is high; else low

    // DUT modport
    modport DUT (
        input clk, rst_n, load_n, up_down, ce, data_load,
        output count_out, max_count, zero_flag
    );


endinterface : counter_if