module top_module(
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

    always @(posedge clk ) begin
        if(load) q <= data;
        else begin
            if(ena) 
            case (amount)
                0: q <= {q[62:0], 1'b0};
                1: q <= {q[55:0], 8'b0};
                2: q <= {q[63], q[63:1]};
                3: q <= {{8{q[63]}}, q[63:8]};
                // 3: q <= {8{q[63]}, q[63:8]};   // 错误写法
                default: ;
            endcase
        end
    end


endmodule