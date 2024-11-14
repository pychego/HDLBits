module top_module (
    input  clk,
    input  d,
    output q
);

    /*
    // 错误做法1
    wire nclk;
    assign nclk = ~clk;
    always @(posedge clk or posedge nclk) begin
        q <= d;
    end
    */

    /* 错误做法2  这个如果不是在上升下降沿,d发生变化也会误触发
    reg q1, q2;
    always @(*) begin
        if(clk) q1 <= d;
    end
    always @(*) begin
        if(~clk) q2 <= d;
    end
    assign q = clk ? q1 : q2;
    */

    // 正确做法1
    // 利用了异或的特性: A^A=0;   A^0=A;
    reg q1, q2;
    always@(posedge clk) begin
        q1 <= d ^ q2;
    end

    always@(negedge clk) begin
        q2 <= d ^ q1;
    end

    assign q = q1 ^ q2;




    // 正确做法2
    // reg q1, q2;
    // always @(posedge clk) begin
    //     q1 <= d;
    // end
    // always @(negedge clk) begin
    //     q2 <= d;
    // end
    // assign q = clk ? q1 : q2;

endmodule
