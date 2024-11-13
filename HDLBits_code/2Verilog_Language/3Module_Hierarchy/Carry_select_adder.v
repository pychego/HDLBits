module top_module(
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] sum
);


    wire cout1, cout2, cout3;

    add16 add16_inst1(
        .a(a[15:0]),
        .b(b[15:0]),
        .cin(0),
        .cout(cout1),
        .sum(sum[15:0])
    );

    wire [15:0] sum_sel1, sum_sel2;
    add16 add16_inst2(
        .a(a[31:16]),
        .b(b[31:16]),
        .cin(0),
        .cout(cout2),
        .sum(sum_sel1)
    );

    add16 add16_inst3(
        .a(a[31:16]),
        .b(b[31:16]),
        .cin(1),
        .cout(cout3),
        .sum(sum_sel2)
    );

    always @(*) begin
        case(cout1)
            0: sum[31:16] = sum_sel1;
            1: sum[31:16] = sum_sel2;
        endcase
    end


endmodule