module top_module(
    input clk,
    input enable,
    input S,
    input A, B, C,
    output reg Z
);

    reg [7:0] Q; // 左边是高位
    always @(posedge clk) begin
        if(enable) Q <= {Q[6:0], S};
        else Q <= Q;
    end

    always @(*) begin
        case ({A, B})
        // 注意根据真值表填写
            0: Z = C ? Q[1] : Q[0]; 
            1: Z = C ? Q[3] : Q[2]; 
            2: Z = C ? Q[5] : Q[4]; 
            3: Z = C ? Q[7] : Q[6]; 
            default: ;
        endcase
    end


endmodule