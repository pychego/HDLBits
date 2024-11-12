module top_module(
    input [99:0] in,
    output [99:0] out
);

    // 这个不熟悉
    generate
        genvar i; // 目前使用的工具如果声明在for中会报错
        for(i=0; i<100; i=i+1)begin: exchange
            assign out[i] = in[99-i];
            // generate for生成100个独立相同的结构
        end
    endgenerate

    //  2. 行为级for语句, 综合成为一个整体
 /* integer i;
    always@(*)begin
        for(i = 0; i <= 99; i = i + 1)begin
            out[i] = in[99 - i];
        end
    end
*/


endmodule