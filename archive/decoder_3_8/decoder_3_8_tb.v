`timescale 1ns/1ns

module decoder_3_8();

    wire [7:0] out;
    reg a, b, c;  // 输入信号定义为reg类型， 输出定义为wire类型
    decoder_3_8 decoder_3_8(
        .a(a),
        .b(b),
        .c(c),
        .out(out)
    );
    
    initial begin
        a=0; b=0; c=0;
        #200;
        a=0; b=0; c=1;
        #200;
        a=0; b=1; c=0;
        #200;
        a=0; b=1; c=1;
        #200;
        a=1; b=0; c=0;
        #200;
        a=1; b=0; c=1;
        #200;
        a=1; b=1; c=0;
        #200;
        a=1; b=1; c=1;
        #200;
        $stop; // modelSim仿真结束
    end

endmodule