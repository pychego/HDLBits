module top_module (
    input  [2:0] a,
    b,
    input        cin,
    output [2:0] cout,
    output [2:0] sum
);

    full_adder adder_0 (
        .a   (a[0]),
        .b   (b[0]),
        .cin (cin),
        .cout(cout[0]),
        .sum (sum[0])
    );

    genvar i;
    generate
        for (i = 1; i < 3; i = i + 1) begin : full
            full_adder adder_i (  // 这里实例化同一个名字没问题
                .a   (a[i]),
                .b   (b[i]),
                .cin (cout[i-1]),
                .cout(cout[i]),
                .sum (sum[i])
            );
        end
    endgenerate

endmodule



module full_adder (
    input  a,
    b,
    cin,
    output cout,
    sum
);

    assign {cout, sum} = a + b + cin;

endmodule
