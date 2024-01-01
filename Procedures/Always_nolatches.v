// synthesis verilog_input_version verilog_2001
// 综合成电路看一看 left 的值受到什么影响
module top_module (
    input [15:0] scancode,
    output reg left,
    output reg down,
    output reg right,
    output reg up  ); 

// 这个 always 内部是顺序执行还是并行执行????/
// begin-end 是顺序执行的!!!
    always @(*) begin
        left = 0; down = 0; right = 0; up = 0;
        case (scancode)
            16'he06b: left = 1;
            16'he072: down = 1;
            16'he074: right = 1;
            16'he075: up = 1;
            default: ;
        endcase
    end

    /* // 这种情况和上面不一样, 上面是只要输入有变化 四个输出都会刷新为 0
    always @(*) begin
        case (scancode)
            16'he06b: left = 1;
            16'he072: down = 1;
            16'he074: right = 1;
            16'he075: up = 1;
            default: begin 
                left = 0; down = 0; right = 0; up = 0;
            end
        endcase
    end
    */

endmodule
