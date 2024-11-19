module top_module (
    input        clk,
    input  [2:0] y,
    input        x,
    output       Y0,
    output       z
);

    // 这题有点迷, 根本没用到clk
    parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4;
    reg [2:0] next;

    always @(*) begin
        case (y)
            S0: next = x ? S1 : S0;
            S1: next = x ? S4 : S1;
            S2: next = x ? S1 : S2;
            S3: next = x ? S2 : S1;
            S4: next = x ? S4 : S3;
            default: ;
        endcase
    end

    assign z = (y==3'b011) || (y==3'b100);
    assign Y0 = (next==S1) || (next==S3);


endmodule
