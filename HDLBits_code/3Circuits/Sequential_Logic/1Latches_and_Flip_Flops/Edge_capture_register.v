module top_module (
    input             clk,
    input             reset,
    input      [31:0] in,
    output reg [31:0] out
);

    reg [31:0] delay_in;
    always @(posedge clk) begin
        delay_in <= in;
    end

    /* 再一次弄混乱了bits和bit 导致程序发生了难以检测出来的错误
    always @(posedge clk) begin
        if (reset) out <= 0;
        else begin
            if (~in & delay_in) out <= 1;
            else out <= out;
            // 不明白为什么上面是错的, 下面是对的
            // out <= ~in & delay_in | out;
        end
    end
*/

    // always @(posedge clk) begin
    //     if (reset) out <= 0;
    //     else begin
    //         out <= ~in & delay_in | out;
    //     end
    // end

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : edge_capture
            always @(posedge clk) begin
                if (reset) out[i] <= 0;
                else begin
                    if (~in[i] & delay_in[i]) out[i] <= 1;
                    else out[i] <= out[i];
                end
            end
        end
    endgenerate


endmodule
