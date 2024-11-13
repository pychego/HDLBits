module top_module(
    input [2:0] in,
    output reg [1:0] out
);
    
    // assign out = in[0] + in[1] + in[2];

    // always@(*) 中语句仿真是顺序执行, 综合实现时会自动设置为并行的正确电路
    integer i;
    always@(*) begin
        out = 0;
        for (i = 0; i<3; i=i+1) begin
            out = out + in[i];
        end
    end

    // 这个可以用generate-for语句吗, generate-for可以初始化吗

endmodule