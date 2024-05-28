// 改写自高的 my_BRAM_wr_controller 主要增加每个控制周期存放实际位移在addr=0的功能
// bram_count 就是是多少存放多少, 只是最后一个数据n的地址是n*4, 不是n*4-4
// 第一个数据存放的地址是 4

module BRAM_wr_Gen (
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


    reg [13:0] cnt2;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) cnt2 <= 14'd0;
        else if (cnt2 == 14'd4999) cnt2 <= 14'd0;
        else cnt2 <= cnt2 + 1'b1;
    end

    // bram_clk 20KHz 这个没什么硬性要求(这里改了)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) bram_clk <= 4'd0;
        else if (cnt2 == 14'd1) bram_clk <= 1'b1;
        else if (cnt2 >= 14'd2501) bram_clk <= 1'b0;
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

    reg [31:0] bram_addr_tmp;  // 用于存放bram_addr清零之前的值
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bram_en <= 1'b0;
            bram_we <= 4'h0;
            bram_addr <= 32'd4;
            bram_addr_tmp <= 32'd4;
        end else if (clk_10kHz_en) begin
            case (count_10kHz)
                // 4'd0:
                // 存放实时ssi到bram_addr=0
                4'd1: begin
                    bram_en <= 1'b1;
                    bram_we <= 4'hf;
                    bram_addr_tmp <= bram_addr;
                    bram_addr <= 32'd0;
                end
                // 4'd2:
                4'd3: begin
                    bram_en   <= 1'b1;
                    bram_we   <= 4'hf;  // we一直为 1
                    bram_addr <= bram_addr_tmp;
                end
                // 4'd4:
                4'd5: begin
                    bram_en <= 1'b0;
                    if (bram_addr >= (bram_count << 2)) begin
                        bram_addr <= 32'd4;
                        bram_addr_tmp <= 32'd4;
                    end
                    else begin
                        bram_addr <= bram_addr + 32'd4;
                        bram_addr_tmp <= bram_addr + 32'd4;
                    end
                end
                // 4'd6:
                // 4'd7:
                // 4'd8:
                // 4'd9:
                default: begin
                    bram_en <= 1'b0;
                    bram_addr <= bram_addr_tmp;
                end
            endcase
            // end
        end
    end

endmodule

// 最后使用乒乓操作感觉必要性不大,
// 存放实际位移的BRAM, 每个控制周期存放一个实际位移
/* 这个模块实际输出的地址数目是 bram_count*2, 当这么多地址全输出之后, 下一个地址就是0
*/
