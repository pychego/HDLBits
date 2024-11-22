// 在SxiAxis_BRAM_rd_control基础上进行修改, 删除了bram_rd_count, 添加了Ts, epoch, addition
/*
    Ts - 参考波形的周期
    epoch - ILC参考波形的周期数,由于ILC设置, 最长 Ts*epoch = 100s
    addition - epoch周期输出之后再后面额外读取addition个点,这些点存放0,用于归中位
    例如, Ts=1, epoch=3, addition=100, 则bram_addr输出为
    0, 4, 8,..., 4*Ts*1000-4
    0, 4, 8,..., 4*Ts*1000-4
    0, 4, 8,..., 4*Ts*1000-4, 4*Ts*1000, 4*Ts*1000+4, 4*Ts*1000+8,..., 4*Ts*1000+addition-4
    以上输出完成之后再进行循环, 不过一般情况下不会到addition结束,就会设置start=0, 从而停止输出
*/

/* 该代码只是为了方便进行ILC控制, 对单轴和六轴控制没有要求, 两者通用
*/

module SxiAxis_BRAM_rd_control_roll (
    input        clk,
    input        rst_n,
    input        start,
    input [31:0] Ts,
    input [31:0] epoch,
    input [31:0] addition,

    (*mark_DEBUG = "TRUE"*) output reg        bram_en,
    (*mark_DEBUG = "TRUE"*) output reg [31:0] bram_addr,
    (*mark_DEBUG = "TRUE"*) output reg        bram_clk    // 10Khz
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


    // 2024.10.23新加  内部计数器
    reg       state;
    reg [7:0] epoch_cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bram_en   <= 1'b0;
            bram_addr <= 32'd0;
            state     <= 1'b0;
            epoch_cnt <= 8'd0;
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
                    // if (bram_addr >= (bram_rd_count << 2) - 32'd4) bram_addr <= 32'd0;
                    // else bram_addr <= bram_addr + 'd4;
                    case (state)
                        0: begin
                            if (bram_addr >= (Ts * 4000 - 4)) begin
                                if (epoch_cnt >= epoch - 1) begin
                                    bram_addr <= bram_addr + 32'd4;
                                    state <= 1'b1;
                                end else begin
                                    bram_addr <= 0;
                                    epoch_cnt <= epoch_cnt + 8'd1;
                                end
                            end else begin
                                bram_addr <= bram_addr + 32'd4;
                            end
                        end
                        1: begin
                            if (bram_addr >= ((1000*Ts+addition)*4-4)) begin
                                bram_addr <= 0;
                                state <= 1'b0;
                                epoch_cnt <= 0;
                            end else begin
                                bram_addr <= bram_addr + 32'd4;
                            end
                        end
                    endcase
                end
                default: begin
                    bram_en <= 1'b0;
                end
            endcase
        end
    end

endmodule

/* 
 何时从BRAM中读取数据是由bram_en控制, 这里通过仿真波形可知在count_10kHz=2时使能, 注意,是2, 不是1
*/
