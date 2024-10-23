// bram_count is the number of data in one of the ping-pang buffer, 
// consisting of two data buffers in total
// 已经修改bram_count即为实际可存放的点数，同时BRAM_en使能和rd_BRAM在同一时候
module SxiAxis_BRAM_wr_control (
    input        clk,
    input        rst_n,
    input        start,
    input [31:0] bram_count,

    (*mark_DEBUG = "TRUE"*) output reg        bram_en,
    (*mark_DEBUG = "TRUE"*) output reg [ 3:0] bram_we,    // 4 bits width, write enable
    (*mark_DEBUG = "TRUE"*) output reg [31:0] bram_addr,
    (*mark_DEBUG = "TRUE"*) output reg        bram_clk    // 10kHz
);

    reg [13:0] cnt;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) cnt <= 14'd0;
        else if (cnt == 14'd9999) cnt <= 14'd0;
        else cnt <= cnt + 1'b1;
    end

    wire clk_10kHz_en;
    assign clk_10kHz_en = (cnt == 14'd1);

    // bram_clk 10KHz 周期为 100us, 这个没什么硬性要求
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) bram_clk <= 4'd0;
        else if (cnt == 14'd1) bram_clk <= 1'b1;
        else if (cnt == 14'd5001) bram_clk <= 1'b0;
        else bram_clk <= bram_clk;
    end

    // One round of count_10kHz is 1ms, which is a control cycle
    reg [3:0] count_10kHz;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) count_10kHz <= 4'd0;
        else if (clk_10kHz_en && start) begin
            if (count_10kHz == 4'd10 - 1) count_10kHz <= 4'd0;
            else count_10kHz <= count_10kHz + 1'b1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bram_en   <= 1'b0;
            bram_we   <= 4'h0;
            bram_addr <= 32'd0;
        end else if (clk_10kHz_en) begin
            case (count_10kHz)
                // 4'd0:
                // 4'd1:
                // 4'd2:
                4'd7: begin
                    bram_en <= 1'b1;
                    bram_we <= 4'hf;  // This signal maintains one bram_clk cycle
                end
                // 4'd4:
                4'd9: begin
                    bram_en <= 1'b0;
                    if (bram_addr >= (bram_count << 2) - 32'd4) bram_addr <= 32'd0;
                    else bram_addr <= bram_addr + 32'd4;
                end
                // 4'd6:
                // 4'd7:
                // 4'd8:
                // 4'd9:
                default: begin
                    bram_en <= 1'b0;
                end
            endcase
            // end
        end
    end

endmodule

// 最后使用乒乓操作感觉必要性不大,
// 存放实际位移的BRAM, 每个控制周期存放一个实际位移
/* 这个模块实际输出的地址数目就是是bram_count, 当这么多地址全输出之后, 下一个地址就是0
例如,
    bram_count = 10,则输出地址为0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 0, 4, 8, 12, 16, 20, 24, 28, 32, 36, ...
*/
