module top_module (
    input      [3:0] in,
    output reg [1:0] pos
);

    // 使用if生成优先编码器很容易未考虑到某些情况,容易产生latch
    always @(*) begin
        if (in[0] == 1 || in==4'b0000) begin
            pos = 0;
        end else if (in[0] == 0 && in[1] == 1) begin
            pos = 1;
        end else if (in[0] == 0 && in[1] == 0 && in[2] == 1) begin
            pos = 2;
        end else if(in == 4'b1000)begin
            pos = 3;
        end
    end


endmodule
