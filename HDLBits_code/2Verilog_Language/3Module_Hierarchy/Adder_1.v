module top_module(
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);

    wire cout1, cout2;
    wire [15:0] sum1, sum2;

    add16 add16_inst1(
        .a(a[15:0]),
        .b(b[15:0]),
        .cin(0),
        .sum(sum1),
        .cout(cout1)
    );

    add16 add16_inst2(
        .a(a[31:16]),
        .b(b[31:16]),
        .cin(cout1),
        .sum(sum2),
        .cout(cout2)
    );

    assign sum = {sum2, sum1};

endmodule