module blcok_noblock1 (
    input a,
    input b,
    input c,
    input clock,
    input reset_n,
    output reg [1:0] out
);
    reg [1:0] d;

    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) begin
            d <= 0;
            out <= 0;
        end
        else begin
            out <= d + c;
            d <= a + b;
        end
    end
    
endmodule