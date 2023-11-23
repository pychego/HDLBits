`timescale 1ns/1ns

module fsm_tb();

    reg a;
    reg clk;
    reg reset_n;
    wire k1, k2;

    fsm fsm_inst(
        .a(a),
        .clk(clk),
        .reset_n(reset_n),
        .k1(k1),
        .k2(k2)
    );

    initial begin
        a = 0;
        reset_n = 1;
        clk = 0;
        #22 reset_n = 0;
        #133 reset_n = 1;   // 复位完成
    end

    always begin
        #50 clk = ~clk;
    end

    always @(posedge clk) begin
        #30 a = {$random} % 2;
        #(3*50+12);
    end

    initial begin
        #100000 $stop;
    end


endmodule