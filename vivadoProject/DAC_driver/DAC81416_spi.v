// convert parallel dac_cmd to spi serial data
module DAC81416_spi (
                            input             clk,
                            input             rst_n,
                            input      [23:0] dac_cmd,
                            input             dac_cmd_valid,
    (*mark_DEBUG = "TRUE"*) output reg        DAC_CSn,
    (*mark_DEBUG = "TRUE"*) output reg        DAC_SCLK,
    (*mark_DEBUG = "TRUE"*) output reg        DAC_SDI
);

    // cnt_div is two divided-frequency
    reg [3:0] cnt_div;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) cnt_div <= 4'd0;
        else if (cnt_div == 4'd1) cnt_div <= 4'd0;
        else cnt_div <= cnt_div + 1'b1;
    end

    // DAC_SCLK is four divided-frequency of clk, 25MHz, T = 40ns
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) DAC_SCLK <= 1'b0;
        else if (cnt_div == 4'd1) DAC_SCLK <= ~DAC_SCLK;
        else DAC_SCLK <= DAC_SCLK;
    end

    reg [13:0] cnt;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) cnt <= 14'd0;
        else if (dac_cmd_valid) cnt <= cnt + 1'b1;
        else cnt <= 14'd0;
    end

    (*mark_DEBUG = "TRUE"*) wire [13:0] cnt_SCLK;
    // assign cnt_SCLK = cnt >> 1;
    assign cnt_SCLK = cnt >> 2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) DAC_CSn <= 1'b1;
        // cnt[1:0] is low positions
        else if (cnt[1:0] == 2'b11) begin
            if (dac_cmd_valid) begin
                if (cnt_SCLK <= 5)  
                    //the DAC_CSn high time has to 240ns+, meeting with tCSHIGH
                    DAC_CSn <= 1'b1;
                else if (cnt_SCLK <= 29) DAC_CSn <= 1'b0;   //  ???
                // CSn low keeps 960ns,SCLK cycle is 40ns, so 24 cycles
                else DAC_CSn <= 1'b1;
            end else DAC_CSn <= 1'b1;
        end
    end

    (*mark_DEBUG = "TRUE"*) reg [23:0] dac_cmd_shift;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) dac_cmd_shift <= 24'd0;
        else if (cnt[1:0] == 2'b11) begin
            if (dac_cmd_valid) begin
                if (cnt_SCLK <= 5) dac_cmd_shift <= dac_cmd;
                else if (cnt_SCLK <= 29) dac_cmd_shift <= dac_cmd_shift << 1;
                else dac_cmd_shift <= dac_cmd_shift;
            end else dac_cmd_shift <= 24'd0;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) DAC_SDI <= 1'b0;
        else if (cnt[1:0] == 2'b11) begin
            if (dac_cmd_valid) begin
                if (cnt_SCLK <= 5) DAC_SDI <= 1'b0;
                // The shift operation was performed in the previous always statement
                else if (cnt_SCLK <= 29) DAC_SDI <= dac_cmd_shift[23];
                else DAC_SDI <= 1'b0;
            end else DAC_SDI <= 1'b0;
        end
    end

endmodule
