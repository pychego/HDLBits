`timescale 1ns / 1ns

module uart_cmd_tb ();

    reg         clk;
    reg         reset_n;
    reg  [ 7:0] data;
    reg         rx_done;
    wire [31:0] new_time;
    wire        agree_done;

    uart_cmd uart_cmd_inst (
        .clk       (clk),
        .reset_n   (reset_n),
        .data      (data),
        .rx_done   (rx_done),
        .new_time  (new_time),   // output
        .agree_done(agree_done)
    );

    // 信号激励
    initial clk = 1'b0;
    always #10 clk = ~clk;

    initial begin
        reset_n = 1'b0;
        data    = 8'h00;
        rx_done = 1'b0;
        #201;

        reset_n = 1'b1;

        send_new_time(32'h00123456);

        $stop;


    end

    task send_new_time(input [31:0] new_time);

        begin
            data = 8'h55;
            #100;
            rx_done = 1'b1;
            #20;
            rx_done = 1'b0;

            data    = 8'ha5;
            #100;
            rx_done = 1'b1;
            #20;
            rx_done = 1'b0;

            data    = 8'haa;
            #100;
            rx_done = 1'b1;
            #20;
            rx_done = 1'b0;

            data    = new_time[31:24];
            #100;
            rx_done = 1'b1;
            #20;
            rx_done = 1'b0;

            data    = new_time[23:16];
            #100;
            rx_done = 1'b1;
            #20;
            rx_done = 1'b0;

            data    = new_time[15:8];
            #100;
            rx_done = 1'b1;
            #20;
            rx_done = 1'b0;

            data    = new_time[7:0];
            #100;
            rx_done = 1'b1;
            #20;
            rx_done = 1'b0;

            data    = 8'hf0;
            #100;
            rx_done = 1'b1;
            #20;
            rx_done = 1'b0;
            #1000;
        end



    endtask

endmodule
