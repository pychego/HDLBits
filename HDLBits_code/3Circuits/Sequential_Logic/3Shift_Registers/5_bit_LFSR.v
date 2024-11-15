module top_module(
    input clk,
    input reset,
    output reg [4:0] q
);

    always @(posedge clk ) begin
        if(reset) q <= 1;
        else begin
            q <= {q[0], q[4], q[3]^q[0], q[2], q[1]};
        end
    end



endmodule


// 如果采用5个分离的dff, 有reset感觉不好操作
module dff(
    input clk,
    input d,
    output reg q
);

    always@(posedge clk) begin
        q <= d;
    end

endmodule