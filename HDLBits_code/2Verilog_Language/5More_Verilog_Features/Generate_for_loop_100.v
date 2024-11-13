module top_module(
    input [399:0] a, b,
    input cin,
    output cout,
    output [399:0] sum
);

    wire [99:0] temp;

    bcd_fadd(
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(cin),
        .cout(temp[0]),
        .sum(sum[3:0])
    );


    generate
        genvar i;
        for(i=1; i<100; i=i+1) begin:bcd
            bcd_fadd(
                .a(a[4*i+3:4*i]),
                .b(b[4*i+3:4*i]),
                .cin(temp[i-1]),
                .cout(temp[i]),
                .sum(sum[4*i+3:4*i])
            );   
        end
    endgenerate

    assign cout = temp[99];

endmodule