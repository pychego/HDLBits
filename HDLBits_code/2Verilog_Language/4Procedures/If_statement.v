module top_module (
    input       a,
    input       b,
    input       sel_b1,
    input       sel_b2,
    output wire out_assign,
    output reg  out_always
);

    assign out_assign = (sel_b1 == 1 && sel_b2 == 1) ? b : a;

    always @(*) begin
        if (sel_b1 == 1 && sel_b2 == 1) out_always <= b;
        else out_always <= a;
    end


    // 两者综合出的电路一致, 但是要保证if语句中的out始终被赋值,该电路才是组合电路, 否则会出错


endmodule
