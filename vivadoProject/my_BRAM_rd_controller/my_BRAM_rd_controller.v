// rd_module is not refered in ping-pang, bram_rd_count is the total number of data in the BRAM
// Loop reading data from BRAM
// 读取参考波形, 高的这个module不涉及到ping-pang, bram_rd_count是BRAM中数据的总数
module my_BRAM_rd_controller (
    input        clk,
    input        rst_n,
    input        start,
    input [31:0] bram_rd_count,

    (*mark_DEBUG = "TRUE"*) output reg        bram_en,
    (*mark_DEBUG = "TRUE"*) output reg [31:0] bram_addr,
    (*mark_DEBUG = "TRUE"*) output reg        bram_clk      // 10Khz
);

    reg [13:0] cnt;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) cnt <= 14'd0;
        else if (cnt == 14'd9999) cnt <= 14'd0;
        else cnt <= cnt + 1'b1;
    end

    (*mark_DEBUG = "TRUE"*) wire clk_10kHz_en;
    assign clk_10kHz_en = (cnt == 14'd1);

    // assign bram_clk = clk_10kHz_en;
    // The cycle of bram_clk is 0.1ms  (10KHz)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) bram_clk <= 4'd0;
        else if (cnt == 14'd1) bram_clk <= 1'b1;
        else if (cnt == 14'd5001) bram_clk <= 1'b0;
        else bram_clk <= bram_clk;
    end

    (*mark_DEBUG = "TRUE"*) reg [3:0] count_10kHz;
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
            bram_addr <= 32'd0;
        end else if (clk_10kHz_en) begin
            // clk_10kHz_en 在count_10kHz=1的最后时间才是1
            // 因此在count_10kHz=2的状况下bram_en=1
            case (count_10kHz)
                4'd1: begin
                    bram_en <= 1'b1;
                end
                4'd2: begin
                    bram_en <= 1'b0;
                end
                4'd9: begin
                    // (bram_rd_count << 2) - 32'd4 is the last address
                    if (bram_addr >= (bram_rd_count << 2) - 32'd4) bram_addr <= 32'd0;
                    else bram_addr <= bram_addr + 'd4;
                end
                default: begin
                    bram_en <= 1'b0;
                end
            endcase
        end
    end

endmodule

/* 
 通过仿真波形,从start信号给出, 每一个控制周期即(1ms) bram_addr+4, 满了之后再次归零, 第一个控制周期bram_addr=0
 假设bram_rd_count=10, 则bram_addr依次 0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 0,......
 何时从BRAM中读取数据是由bram_en控制, 这里通过仿真波形可知在count_10kHz=2时使能, 注意,是2, 不是1
*/
