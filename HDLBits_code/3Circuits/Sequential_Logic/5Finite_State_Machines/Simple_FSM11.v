module top_module (
    input  clk,
    input  areset,
    input  in,
    output out
);

    parameter A = 0, B = 1;
    reg state, next_state;

    // 将state和next_state写在两个always中了, out也单独写出来了, 这样可能更清晰一些
    always @(*) begin
        case (state)
            A: begin
                if (in == 0) next_state = B;
                else next_state = A;
            end
            B: begin
                if (in == 0) next_state = A;
                else next_state = B;
            end
            default: ;
        endcase
    end

    // 异步置位
    always@(posedge clk, posedge areset) begin
        if(areset)
            state <= B;
        else
            state <= next_state; 
    end

    // out 如果不和state写在同一个always中, 那就只能使用组合逻辑写out, 否则就会有延迟
    assign out = (state == B);



endmodule
