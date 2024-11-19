module top_module (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output z
);

    parameter A = 0, B = 1;
    reg [2:0] state, next;

    reg [15:0] count;
    reg [ 2:0] w_data;

    always @(*) begin
        case (state)
            A: next = s ? B : A;
            B: next = B;
            default: ;
        endcase
    end

    always @(posedge clk) begin
        state <= reset ? A : next;
    end

    always @(posedge clk) begin
        if (reset) begin
            count  <= 0;
            w_data <= 0;
        end else begin
            case (state)
                A: begin
                    count  <= 0;
                    w_data <= 0;
                end
                B: begin
                    if (count < 2) count <= count + 1;
                    else count <= 0;
                    w_data[count] <= w;
                    // 这里w_data[0] + w_data[1] + w_data[2] == 2不对,因此此时上升沿采用的w_data[2]还未被赋值
                    // z <= (count == 2) & (w_data[0] + w_data[1] + w_data[2] == 2);
                end
                default: ;
            endcase
        end
    end

    // z 使用组合逻辑和时序逻辑的判断条件是完全不一样的,
    assign z = (count == 0) & (w_data[0] + w_data[1] + w_data[2] == 2);


endmodule
