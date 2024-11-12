module top_module(
    input [254:0] in,
    output reg [7:0] out
);


    integer i;
    always@(*) begin
        out = 0;  // 仿真顺序执行, 但是综合并行执行, 综合工具会正确处理
        for(i=0; i<255; i=i+1) begin
            out = out + in[i];
        end
    end

endmodule