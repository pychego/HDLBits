module top_module (
    input  [15:0] a,
    b,
    input         cin,
    output        cout,
    output [15:0] sum
);

    wire [3:0] temp;

    bcd_fadd bcd_fadd_0 (
        .a   (a[3:0]),
        .b   (b[3:0]),
        .cin (cin),
        .cout(temp[0]),
        .sum (sum[3:0])
    );

    genvar i;
    generate
        for (i = 1; i < 4; i = i + 1) begin: bcd
            bcd_fadd bcd_fadd_i (
                .a   (a[i*4+3:i*4]),
                .b   (b[i*4+3:i*4]),
                .cin (temp[i-1]),
                .cout(temp[i]),
                .sum (sum[i*4+3:i*4])
            );
        end
    endgenerate

    assign cout = temp[3];


endmodule
