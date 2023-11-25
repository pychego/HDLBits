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
    wire          wr_rst_busy;
    wire          rd_rst_busy;

    /*
        学习fifo的每个端口含义
        rst下降沿到来即为复位结束，fifo要反应一段时间才能工作
        full almost_full有设置选项在复位时设置为0或1，这里选0
        rst    配置ip核时选择了高电平有效
        din    input wire [15 : 0] din
        wr_en   
        rd_en  
        dout   output wire [7 : 0] dout
        full   在fifo写最后一个深度 要用尽了为高电平
        empty  在fifo读最后一个read width为高电平
        almost_full  写到自定义深度时为高电平
        almost_empty 
        wr_ack      指示一次成功的写入
        overflow    指示一次不成功的写  
        valid       指示有效的输出
        underflow   指示无效的读操作
        rd_data_count 指示fifo中有多少个read width可以供读取
        wr_data_count 记录fifo中已经使用多少个write widt
        wr_rst_busy  (wr_rst_busy),    // output wire wr_rst_busy; Enable safety ci
        rd_rst_busy  (rd_rst_busy)     // output wire rd_rst_busy;

    */

    fifo your_instance_name (
        .clk          (clk),            // input wire clk
        .rst          (rst),            // input wire rst 配置ip核时选择了高电平有效
        .din          (din),            // input wire [15 : 0] din
        .wr_en        (wr_en),          // input wire wr_en
        .rd_en        (rd_en),          // input wire rd_en
        .dout         (dout),           // output wire [7 : 0] dout
        .full         (full),           // output wire full
        .almost_full  (almost_full),    // output wire almost_full
        .wr_ack       (wr_ack),         // output wire wr_ack 指示一次成功的写入
        .overflow     (overflow),       // output wire overflow; 指示一次不成功的写入
        .empty        (empty),          // output wire empty;
        .almost_empty (almost_empty),   // output wire almost_empty;
        .valid        (valid),          // output wire valid; 指示有效的输出
        .underflow    (underflow),      // output wire underflow; 指示无效的读操作
        .rd_data_count(rd_data_count),  // output wire [9 : 0] rd_data_count;
        .wr_data_count(wr_data_count),  // output wire [8 : 0] wr_data_count;
        .wr_rst_busy  (wr_rst_busy),    // output wire wr_rst_busy; Enable safety circuit
        .rd_rst_busy  (rd_rst_busy)     // output wire rd_rst_busy;
    );

    initial clk = 1;
    always #10 clk = ~clk;
    initial begin
        rst   = 1;
        wr_en = 0;
        rd_en = 0;
        din   = 0;
        #405;
        rst   = 0;
        #300;
        wr_en = 1;
        repeat (300) begin
            #20;
            din = din + 1;
        end
        wr_en = 0;
        rd_en = 1;
        #100000;
        $stop;

    end

endmodule
