
/* 偶数分频电路
    10分频, 使用5进制计数器进行翻转
    4分频,使用2进制计数器进行翻转
    2分频, 遇到clk就翻转
*/

module ten_channel_division (
    input clk,
    input rst_n,

    output reg clk10
);

    reg [2:0] counter;
    always @(posedge clk, negedge rst_n) begin
        if (~rst_n) counter <= 0;
        else begin
            if (counter >= (10 / 2) - 1) counter <= 0;
            else counter <= counter + 1;
        end
    end

    always @(posedge clk, negedge rst_n) begin
        if (~rst_n) clk10 <= 0;
        else if(counter == 4) clk10 <= ~clk10;
        else clk10 <= clk10;
    end





endmodule
