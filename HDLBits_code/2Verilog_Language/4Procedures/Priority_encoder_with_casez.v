module top_module(
    input  [7:0] in,
    output reg [2:0] pos
);

    always@(*) begin
        casez (in)
        // casez中z和?同义,代表don't care bit
        // casex的x代表z,?和未知态,很少用
            8'b???????1: pos = 0;
            8'b??????10: pos = 1;
            8'b?????100: pos = 2;
            8'b????1000: pos = 3;
            8'b???10000: pos = 4;
            8'b??100000: pos = 5;
            8'b?1000000: pos = 6;
            8'b10000000: pos = 7;
            8'b00000000: pos = 8;
            default: pos = 0;
        endcase
    end


endmodule