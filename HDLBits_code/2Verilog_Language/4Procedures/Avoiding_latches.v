module top_module (
    input      [15:0] scancode,
    output reg        left,
    output reg        down,
    output reg        right,
    output reg        up
);

    /*这种always@(*)里面有阻塞赋值,之后还有case的, 仿真时候是顺序执行, 但是硬件实现是并行的,可能会出现问题*/
    /*
    always@(*) begin
        left = 0;
        down = 0;
        right = 0;
        up = 0;
        case (scancode)
            16'he06b: left = 1;
            16'he072: down = 1;
            16'he074: right = 1;
            16'he075: up = 1;
        endcase
    end
*/

    always @(*) begin
        case (scancode)
            16'he06b: begin
                left = 1;
                down = 0;
                right = 0;
                up = 0;
            end
            16'he072: begin
                left = 0;
                down = 1;
                right = 0;
                up = 0;
            end
            16'he074: begin
                left = 0;
                down = 0;
                right = 1;
                up = 0;
            end
            16'he075: begin
                left = 0;
                down = 0;
                right = 0;
                up = 1;
            end
            default: begin
                left = 0;
                down = 0;
                right = 0;
                up = 0;
            end
        endcase
    end
endmodule
