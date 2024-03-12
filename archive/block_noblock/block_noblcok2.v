// 阻塞赋值和非阻塞赋值是针对于时序逻辑的，对于组合逻辑，不存在阻塞赋值和非阻塞赋值的区别。
// 原则，在时序逻辑中，一律使用非阻塞赋值
module blcok_noblock2 (
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
            d = a + b; 
            out = d + c;  
            // 相当于out = a + b + c; 
            
        end 
    end
    
endmodule 