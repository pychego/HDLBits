module top_module (
    input            clk,
    input            reset,
    input            ena,
    output reg       pm,
    output     [7:0] hh,
    output     [7:0] mm,
    output     [7:0] ss
);

    // 先按照十进制的方式计算, 最后将结果转化为bcd码
    reg [7:0] hh_d, mm_d, ss_d;
    // 将结果转化为bcd码
    assign hh = (hh_d / 10) * 8'h10 + (hh_d % 10);
    assign mm = (mm_d / 10) * 8'h10 + (mm_d % 10);
    assign ss = (ss_d / 10) * 8'h10 + (ss_d % 10);

    always @(posedge clk) begin
        if (reset) pm <= 0;
        else begin
            if (ss_d == 59 && mm_d == 59 && hh_d == 11) pm <= ~pm;
            else pm <= pm;
        end
    end

    // 处理 秒
    always @(posedge clk) begin
        if (reset) ss_d <= 0;
        else begin
            if (ena) begin
                if (ss_d == 59) ss_d <= 0;
                else ss_d <= ss_d + 1;
            end else ss_d <= ss_d;
        end
    end

    // 处理 分
    always @(posedge clk) begin
        if (reset) mm_d <= 0;
        else begin
            if (ena) begin
                if (ss_d == 59 && mm_d == 59) mm_d <= 0;
                else if (ss_d == 59) mm_d <= mm_d + 1;
                else mm_d <= mm_d;
            end else mm_d <= mm_d;
        end
    end

    // 处理 时
    always @(posedge clk) begin
        if (reset) hh_d <= 12;
        else begin
            if (ena) begin
                if (ss_d == 59 && mm_d == 59 && hh_d == 12) hh_d <= 1;
                else if (ss_d == 59 && mm_d == 59) hh_d <= hh_d + 1;
                else hh_d <= hh_d;
            end else hh_d <= hh_d;
        end
    end

endmodule
