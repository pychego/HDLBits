module top_module (
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);

    //   一句话即可
    // assign sum = x + y;

    wire [3:0] cout;
    full_adder adder_0 (
        .a   (x[0]),
        .b   (y[0]),
        .cin (0),
        .cout(cout[0]),
        .sum (sum[0])
    );

    genvar i;
    generate
        for (i = 1; i < 4; i = i + 1) begin: full
            full_adder adder_i (
                .a   (x[i]),
                .b   (y[i]),
                .cin (cout[i-1]),
                .cout(cout[i]),
                .sum (sum[i])
            );
        end
    endgenerate

    assign sum[4] = cout[3];


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
