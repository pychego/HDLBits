module top_module(
    input [31:0] a, 
    input [31:0] b,
    input sub,
    output [31:0] sum
);
    
    wire [31:0] temp_b;
    assign temp_b = b^{32{sub}};

    wire cout1, cout2;

    add16 add16_inst1(
        .a(a[15:0]),
        .b(temp_b[15:0]),
        .cin(sub),
        .cout(cout1),
        .sum(sum[15:0])
    );

    add16 add16_inst2(
        .a(a[31:16]),
        .b(temp_b[31:16]),
        .cin(cout1),
        .cout(cout2),
        .sum(sum[31:16])
    );



endmodule