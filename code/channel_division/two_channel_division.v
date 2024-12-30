// 二分频设计
/* 偶数分频, n个触发器可以实现2n分频, 所以2分频只需要一个触发器
*/

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
