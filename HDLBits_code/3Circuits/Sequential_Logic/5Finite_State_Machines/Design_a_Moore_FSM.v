module top_module (
    input            clk,
    input            reset,
    input      [3:1] s,
    output reg       fr3,
    output reg       fr2,
    output reg       fr1,
    output reg       dfr
);


    // 参考答案的方法, 显式设计状态机
    // A 无水
    // B1 水较少, 水在变多   B2 水较少, 水在变少
    // C1 水较多, 水在变多   C2 水较多, 水在变少
    // D 满水
    parameter A = 0, B1 = 1, B2 = 2, C1 = 3, C2 = 4, D = 5;
    reg [3:0] state, next;

    always @(*) begin
        case (state)
            A: next = s[1] ? B1 : A;
            B1: next = s[2] ? C1 : (s[1] ? B1 : A);
            B2: next = s[2] ? C1 : (s[1] ? B2 : A);
            C1: next = s[3] ? D : (s[2] ? C1 : B2);
            C2: next = s[3] ? D : (s[2] ? C2 : B2);
            D: next = s[3] ? D : C2;
            default: ;
        endcase
    end

    always @(posedge clk) begin
        state <= reset ? A : next;
    end

    always @(*) begin
        case (state)
            A: {fr3, fr2, fr1, dfr} = 4'b1111;
            B1: {fr3, fr2, fr1, dfr} = 4'b0110;
            B2: {fr3, fr2, fr1, dfr} = 4'b0111;
            C1: {fr3, fr2, fr1, dfr} = 4'b0010;
            C2: {fr3, fr2, fr1, dfr} = 4'b0011;
            D: {fr3, fr2, fr1, dfr} = 4'b0000;
            default: ;
        endcase
    end



    /*  // 自己写的方法, 写的时候没有想设计状态的事情,就直接写了, 不知道代码哪里有错误, 一直不匹配
    // 上一次的传感器
    // 这里关键是记录下来 s 改变之前的数据
    // 这个代码一直报错, 感觉是因为下面用了两个always块,当来了clk, 第二个块使用的previous还是修改之前的...
    reg [3:1] current_s, previous_s;
    // always @(posedge clk) begin
    //     if (reset) begin
    //         current_s  <= 0;
    //         previous_s <= 0;
    //     end else begin
    //         if (s != current_s) begin
    //             previous_s <= current_s;
    //             current_s  <= s;
    //         end
    //     end
    // end

    always @(*) begin
        if (reset) begin
            current_s  = 0;
            previous_s = 0;
        end else begin
            if (s != current_s) begin
                previous_s = current_s;
                current_s  = s;
            end
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            fr1 <= 1;
            fr2 <= 1;
            fr3 <= 1;
            dfr <= 1;
        end else begin
            case (s)
                3'b000: begin
                    fr1 <= 1;
                    fr2 <= 1;
                    fr3 <= 1;
                    dfr <= 1;
                end
                3'b001: begin
                    fr1 <= 1;
                    fr2 <= 1;
                    fr3 <= 0;
                    dfr <= (previous_s == 3'b011) ? 1 : 0;
                end
                3'b011: begin
                    fr1 <= 1;
                    fr2 <= 0;
                    fr3 <= 0;
                    dfr <= (previous_s == 3'b111) ? 1 : 0;
                end
                3'b111: begin
                    fr1 <= 0;
                    fr2 <= 0;
                    fr3 <= 0;
                    dfr <= 0;
                end
                default: ;
            endcase
        end
    end
*/
endmodule
