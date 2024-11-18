module top_module (
    clk,
    reset,
    in,
    out
);
    input clk;
    input reset;
    input in;
    output out;
    reg out;

    parameter A = 0, B = 1;
    parameter A_out = 0, B_out = 1;
    reg state;

    always @(posedge clk) begin
        if (reset) begin
            state <= B;
            out   <= B_out;
        end else begin
            case (state)
                A: begin
                    if (in == 0) begin
                        state <= B;
                        out   <= B_out;
                    end else begin
                        state <= A;
                        out   <= A_out;
                    end
                end
                B: begin
                    if (in == 0) begin
                        state <= A;
                        out   <= A_out;
                    end else begin
                        state <= B;
                        out   <= B_out;
                    end
                end
                default: ;
            endcase
        end
    end


    /*  // 在时序always块中尽量不混合阻塞赋值和非阻塞赋值
    reg present_state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            present_state <= B;
            out <= 1;
        end else begin
            case (present_state)
                A: begin
                    if (in == 0) next_state <= B;
                    else next_state <= A;
                end
                B: begin
                    if (in == 0) next_state <= A;
                    else next_state <= B;
                end
                default: ;
            endcase
            
            present_state = next_state;

            case (present_state)
                A: out <= 0;
                B: out <= 1;
            endcase
        end
    end

    */


endmodule
