module decoder_3_8 (
    input            a,
    input            b,
    input            c,
    output reg [7:0] out  // [最高位：最低位]
);

    // 以always块描述的信号赋值，被赋值对象必须定义为reg类型
    always @(*) begin  // @ 关注 * 通配符
        case ({
            a, b, c
        })
            3'd0:   out = 8'b00000001;
            3'd1:   out = 8'b00000010;
            3'd2:   out = 8'b00000100;
            3'd3:   out = 8'b00001000;
            3'd4:   out = 8'b00010000;
            3'd5:   out = 8'b00100000;
            3'b110: out = 8'b01000000;
            3'b111: out = 8'b10000000;
        endcase
    end


endmodule
