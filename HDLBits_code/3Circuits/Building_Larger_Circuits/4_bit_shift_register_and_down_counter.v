module top_module (
    input            clk,
    input            shift_ena,
    input            count_ena,
    input            data,
    output reg [3:0] q           // 默认定义的是无符号数
);

    always @(posedge clk) begin
        case ({
            shift_ena, count_ena
        })
            2'b01:   q <= q - 1;
            2'b10:   q <= {q[2:0], data};
            default: q <= q;
        endcase
    end

endmodule
