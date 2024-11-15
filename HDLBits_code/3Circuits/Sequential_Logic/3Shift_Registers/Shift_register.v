module top_module(
    input clk,
    input resetn,
    input in,
    output out
);

    // 使用submodule会更清晰简单, 这里不使用
    // q[3] 对应最左边寄存器的输出
    reg [3:0] q;

    always@(posedge clk) begin
        if(!resetn) q <= 0;
        else begin
            q <= {in, q[3:1]};
        end
    end

    assign out = q[0];

endmodule