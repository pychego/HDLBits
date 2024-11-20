module top_module (
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);
    wire cout1; // 存放中间结果
    wire cout2;
    add16 a1(a[15:0], b[15:0], 0, sum[15:0], cout1);
    add16 a2(a[31:16], b[31:16], cout1, sum[31:16], cout2);

    
endmodule

module add1 (   // 一位加法器
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    
    assign sum = a + b + cin;
    wire [1: 0] q1 = a + b + cin;
    assign cout = q1[1];

endmodule