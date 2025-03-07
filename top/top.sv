module tb_top;

    import uvm_pkg::*;
    import counter_env_pkg::*;
    import counter_test_pkg::*;

    bit clk;

    // Clock Generation
    initial begin
        clk = 0;
        forever #1 clk = ~ clk;
    end

    counter_env env_instance;
    counter_test test;
    // Instantiate the interface
    counter_if c_if (clk);
    counter DUT (c_if);
    // Configure the UVM database and the test
    initial begin
        uvm_config_db #(virtual counter_if)::set (null,"*","c_if",c_if);
        run_test("counter_test");
    end
endmodule : tb_top