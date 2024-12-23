/*异步fifo 参考文献  Simulation and Synthesis Techniques for Asynchronous FIFO Design*/
//源码：https://github.com/DeamonYang/FPGA_SYNC_ASYNC_FIFO

module async_fifo (
    input             rst_n,
    input             fifo_wr_en,
    input      [15:0] fifo_wr_data,
    input             fifo_rd_en,
    input             fifo_rd_clk,
    input             fifo_wr_clk,
    output reg        r_fifo_full,
    output     [15:0] fifo_rd_data,
    output reg        r_fifo_empty

    //		fifo_wr_err,
    //		fifo_rd_err

);




    //		output reg fifo_wr_err;
    //		output reg fifo_rd_err;

    //中间信号internal singles		
    reg  [9:0] rdaddress;  //RAM地址为9位地址 扩展一位用于同步
    reg  [9:0] wraddress;  //RAM写地址

    wire [9:0] gray_rdaddress;  //格雷码读写地址
    wire [9:0] gray_wraddress;

    /*同步寄存器*/
    reg [9:0] sync_w2r_r1, sync_w2r_r2;  // 写时钟域同步到读时钟域
    reg [9:0] sync_r2w_r1, sync_r2w_r2;  // 读时钟域同步到写时钟域

    wire fifo_empty;
    wire fifo_full;

    /*二进制转化为格雷码计数器*/
    assign gray_rdaddress = (rdaddress >> 1) ^ rdaddress;  //(({1'b0,rdaddress[9:1]}) ^ rdaddress);

    /*二进制转化为格雷码计数器*/
    assign gray_wraddress = (({1'b0, wraddress[9:1]}) ^ wraddress);

    assign fifo_empty = (gray_rdaddress == sync_w2r_r2);  //格雷码所有bit位均相同

    assign fifo_full = (gray_wraddress == {~sync_r2w_r2[9:8],sync_r2w_r2[7:0]});  //高两位不同，其余位相同
    //		
    //		assign fifo_wr_err = (w_fifo_full && fifo_wr_en);
    //		assign fifo_rd_err = (fifo_empty && fifo_rd_en);

    // RAM ？？？ 
    ram ram (
        .data     (fifo_wr_data),   // input
        .rdaddress(rdaddress[8:0]), // input
        .rdclock  (fifo_rd_clk),    // input

        .wraddress(wraddress[8:0]), // input
        .wrclock  (fifo_wr_clk),    // input
        .wren     (fifo_wr_en),     // input
        .q        (fifo_rd_data)    // output
    );

    /*在读时钟域同步FIFO空 sync_w2r_r2 为同步的写指针地址 延迟两拍非实际写指针值 但是确保不会发生未写入数据就读取*/
    always @(posedge fifo_rd_clk or negedge rst_n)
        if (!rst_n) r_fifo_empty <= 1'b0;
        else r_fifo_empty <= fifo_empty;


    /*在写时钟域判断FIFO满 sync_r2w_r2 实际延迟两个节拍 可能存在非满判断为满 但不会导致覆盖*/
    always @(posedge fifo_wr_clk or negedge rst_n)
        if (!rst_n) r_fifo_full <= 1'b0;
        else r_fifo_full <= fifo_full;  //格雷码判断追及问题			


    /*读数据地址生成*/
    always @(posedge fifo_rd_clk or negedge rst_n)
        if (!rst_n) rdaddress <= 10'b0;
        else if (fifo_rd_en && ~fifo_empty) begin
            rdaddress <= rdaddress + 1'b1;
        end

    /*写数据地址生成*/
    always @(posedge fifo_wr_clk or negedge rst_n)
        if (!rst_n) wraddress <= 10'b0;
        else if (fifo_wr_en && ~r_fifo_full) begin
            wraddress <= wraddress + 1'b1;
        end

    /*同步读地址到写时钟域*/
    always @(posedge fifo_wr_clk or negedge rst_n)
        if (!rst_n) begin
            sync_r2w_r1 <= 10'd0;
            sync_r2w_r2 <= 10'd0;
        end else begin
            sync_r2w_r1 <= gray_rdaddress;
            sync_r2w_r2 <= sync_r2w_r1;
        end

    /*同步写地址到读时钟域, 同步以后 存在延迟两个节拍*/
    always @(posedge fifo_rd_clk or negedge rst_n)
        if (!rst_n) begin
            sync_w2r_r1 <= 10'd0;
            sync_w2r_r2 <= 10'd0;
        end else begin
            sync_w2r_r1 <= gray_wraddress;
            sync_w2r_r2 <= sync_w2r_r1;
        end


endmodule
