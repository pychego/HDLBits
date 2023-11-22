`timescale 1ns / 1ns

module fifo_tb ();

    reg           clk;
    reg           rst;
    reg  [15 : 0] din;
    reg           wr_en;
    reg           rd_en;

    wire [ 7 : 0] dout;
    wire          full;
    wire          almost_full;
    wire          wr_ack;
    wire          overflow;
    wire          empty;
    wire          almost_empty;
    wire          valid;
    wire          underflow;
    wire [ 9 : 0] rd_data_count;
    wire [ 8 : 0] wr_data_count;
    wire          prog_full;
    wire          prog_empty;
    wire          wr_rst_busy;
    wire          rd_rst_busy;


    fifo your_instance_name (
        .clk          (clk),            // input wire clk
        .rst          (rst),            // input wire rst
        .din          (din),            // input wire [15 : 0] din
        .wr_en        (wr_en),          // input wire wr_en
        .rd_en        (rd_en),          // input wire rd_en
        .dout         (dout),           // output wire [7 : 0] dout
        .full         (full),           // output wire full
        .almost_full  (almost_full),    // output wire almost_full
        .wr_ack       (wr_ack),         // output wire wr_ack
        .overflow     (overflow),       // output wire overflow;
        .empty        (empty),          // output wire empty;
        .almost_empty (almost_empty),   // output wire almost_empty;
        .valid        (valid),          // output wire valid;
        .underflow    (underflow),      // output wire underflow;
        .rd_data_count(rd_data_count),  // output wire [9 : 0] rd_data_count;
        .wr_data_count(wr_data_count),  // output wire [8 : 0] wr_data_count;
        .prog_full    (prog_full),      // output wire prog_full;
        .prog_empty   (prog_empty),     // output wire prog_empty;
        .wr_rst_busy  (wr_rst_busy),    // output wire wr_rst_busy;
        .rd_rst_busy  (rd_rst_busy)     // output wire rd_rst_busy;
    );

    initial clk = 1;
    always #10 clk = ~clk;
    initial begin
        rst = 1;
        wr_en = 0;
        rd_en = 0;
        din = 0;
        #205;
        rst = 0;
        wr_en = 1;
        repeat (100) begin
            #20;
            din = din + 1;
        end
        wr_en = 0;
        rd_en = 1;
        # 1000;
        $stop;

    end

endmodule
