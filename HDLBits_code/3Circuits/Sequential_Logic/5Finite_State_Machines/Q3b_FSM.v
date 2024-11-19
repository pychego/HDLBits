module top_module (
    input      clk,
    input      reset,
    input      x,
    output reg z
);

    // 这个很简单
    parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4;
    reg [2:0] state, next;

    always @(*) begin
        case (state)
            S0: next = x ? S1 : S0;
            S1: next = x ? S4 : S1;
            S2: next = x ? S1 : S2;
            S3: next = x ? S2 : S1;
            S4: next = x ? S4 : S3;
            default: ;
        endcase
    end

    always @(posedge clk) begin
        state <= reset ? S0 : next;
    end

    always @(posedge clk) begin
        if (reset) z <= 0;
        else begin
            if (next == S4 || next == S3) z <= 1;
            else z <= 0;
        end
    end

endmodule
