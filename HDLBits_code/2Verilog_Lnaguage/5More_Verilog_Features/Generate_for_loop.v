module top_module(
    input [99:0] a, b,
    input cin,
    output [99:0] cout,
    output [99:0] sum
);

    // 该句也可放在genearte的内部
    assign {cout[0], sum[0]} = a[0] + b[0] + cin;

    // generate-for中的begin块需要名字
    generate
        genvar i;
        for(i=1; i<100; i=i+1) begin: full_adder
            assign {cout[i], sum[i]} = a[i] + b[i] + cout[i-1];
        end
    endgenerate



endmodule