module top_module(
    input [7:0] a, b,
    output [7:0] s,
    output overflow
);

/* 10001的补码: 11110+1=11111 用钟表想象, 11点就是负数-1, 用补码表示就是最大值11
   溢出判断: 两个正数相加, 符号位为-,则溢出; 两个负数相加, 符号位为+, 则溢出
*/

    assign s = a + b;

    assign overflow = a[7]&b[7]&(~s[7]) | (~a[7])&(~b[7])&s[7];

endmodule