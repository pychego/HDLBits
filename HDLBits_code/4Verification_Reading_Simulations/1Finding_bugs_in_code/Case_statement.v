module top_module (
    input      [7:0] code,
    output reg [3:0] out,
    output reg       valid
);  //

    always @(*) begin
        out   = 0;  // 编程中预赋值, 避免出现latch
        valid = 1;  // 在实际电路实现中, 是通过组合逻辑将预赋值考虑到实际电路实现中的,
        // 实现过程并没有编程中的预赋值

        // 默认值的实现
        // 对out=0, 可能通过mux将一个输入设置为0来实现
        // 对 valid=1, 可能通过mux将一个输入设置为1来实现
        case (code)
            8'h45:   out = 0;
            8'h16:   out = 1;
            8'h1e:   out = 2;
            8'h26:   out = 3;
            8'h25:   out = 4;
            8'h2e:   out = 5;
            8'h36:   out = 6;
            8'h3d:   out = 7;
            8'h3e:   out = 8;
            8'h46:   out = 9;
            default: valid = 0;
        endcase
    end


endmodule
