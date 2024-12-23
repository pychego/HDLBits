// 二分频设计

module two_channel_division (
    input      clk,
    input      rst_n,
    output reg clk_out
);

    // 二分频直接clk翻转, 四分频使用一个2进制计数器
    always @(posedge clk, negedge rst_n) begin
        if (~rst_n) clk_out <= 0;
        else clk_out <= ~clk_out;
    end



endmodule
