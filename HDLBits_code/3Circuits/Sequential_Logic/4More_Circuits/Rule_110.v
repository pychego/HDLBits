// 规则真难看懂
module top_module (
    input              clk,
    input              load,
    input      [511:0] data,
    output reg [511:0] q
);


    // 尝试方法2, 使用for循环试试
    integer i;
    always @(posedge clk) begin
        if (load) q <= data;
        else begin
            q[511] <= q[511] | q[510];  // 这里容易写错成+, 就不对了
            q[0]   <= q[0];
            for (i = 1; i < 511; i = i + 1) begin
                q[i] <= ~((~q[i+1])&(~q[i])&(~q[i-1]) | q[i+1]&q[i]&q[i-1] | q[i+1]&(~q[i])&(~q[i-1]));
            end
        end
    end
endmodule
