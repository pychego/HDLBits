// 阻塞赋值和非阻塞赋值是针对于时序逻辑的，对于组合逻辑，不存在阻塞赋值和非阻塞赋值的区别。

module blcok_noblock (
    input a,
    input b,
    input c,
    input clock,
    input reset_n,
    output reg [1:0] out
);
    reg [1:0] d;

    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) begin
            d <= 0;
            out <= 0;
        end
        else begin
            out = d + c;   // 这两句和使用非阻塞赋值效果一样！
            d = a + b;     // 和block_noblock1.v中的代码效果一样！
        end 
    end
    
endmodule