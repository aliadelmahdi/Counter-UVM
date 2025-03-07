module counter (counter_if c_if);
    logic rst_n;
    logic [c_if.WIDTH-1:0] data_load;
    logic load_n;
    logic up_down;
    logic ce;
    logic clk;

    logic [c_if.WIDTH-1:0] count_out;
    logic max_count; 
    logic zero_flag;

    assign clk = c_if.clk;
    assign rst_n = c_if.rst_n;
    assign data_load = c_if.data_load;
    assign load_n = c_if.load_n;
    assign up_down = c_if.up_down;
    assign ce = c_if.ce;

    assign c_if.count_out = count_out;
    assign c_if.max_count = max_count;
    assign c_if.zero_flag = zero_flag;
  
    always @(posedge clk) begin
        // if rst = 0 count_out = 0
        if (~rst_n) begin
            count_out <= 0; // Reset the counter output to zero
        end
        else begin
            // Load the data when load_n is low
            if (~load_n) begin
                    count_out <= data_load; 
            end
            // Count up or down when enable is high
            else if (ce) begin
                // Increment or decrement based on the up_down signal
                count_out <= count_out + (up_down ? 1 : -1);
            end
        end 
    end

    // Always block to update zero and max_count flags
    always @(count_out) begin
        // Set zero_flag if count_out is zero
        zero_flag = (count_out == 0);
        
        // Set max_count if count_out is at its maximum value
        max_count = (count_out == {c_if.WIDTH{1'b1}});
    end

    // ------------- Cover Properties -------- \\

    property p_reset;
        @(posedge clk) disable iff(rst_n)
        !rst_n |=> (count_out == 0);
    endproperty

    property p_load;
        @(posedge clk) disable iff(~rst_n)
        (!load_n) |=> (count_out == $past(data_load));
    endproperty

    property p_count_up;    
        @(posedge clk) disable iff(~rst_n || ~load_n)
        (ce && up_down) |=> (count_out == $past(count_out) + 1);
    endproperty

    property p_count_down;
        @(posedge clk) disable iff(~rst_n || ~load_n || ~ce)
        (ce && !up_down) |=> (count_out == $past(count_out) - 1);
    endproperty

    property p_zero_flag;
        @(posedge clk) disable iff(~rst_n)
        (count_out == 0) |-> (zero_flag);
    endproperty

    property p_max_flag;
        @(posedge clk) disable iff (~rst_n)
        (count_out == {c_if.WIDTH{1'b1}}) |-> (max_count);
    endproperty

    property hold_value;
        @(posedge clk) disable iff (~rst_n || ~load_n)
        (!ce) |=> (count_out == $past(count_out));
    endproperty

    cover_reset: cover property (p_reset);
    cover_zero_flag: cover property (p_zero_flag);
    cover_max_flag: cover property (p_max_flag);
    cover_load: assert property (p_load) else $display("count out= %0d, data_load= %0d",count_out,data_load);
    cover_count_up: cover property (p_count_up);
    cover_count_down: cover property (p_count_down);
    cover_hold_value: cover property (hold_value);

endmodule : counter


