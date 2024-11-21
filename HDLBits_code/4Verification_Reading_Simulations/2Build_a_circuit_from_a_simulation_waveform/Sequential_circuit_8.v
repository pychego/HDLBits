module top_module (
    input      clock,
    input      a,
    output reg p,
    output reg q
);

    // 电平触发, clock高电平时, q跟随a, 否则保持不变
    always @(*) begin
        p <= clock ? a : p;
    end

    always @(negedge clock) begin
        q <= a;
    end


endmodule
