module top_module(
    input [6:1] y,
    input w,
    output Y2,
    output Y4
);
    
    wire [6:1] next;

    assign next[1] =  y[1]&w | y[4]&w;
    assign next[2] =  y[1]&(~w);
    assign next[3] =  y[2]&(~w) | y[6]&w;
    assign next[4] =  w&(y[2] | y[3] | y[5] | y[6]);
    assign next[5] =  y[5]&(~w) | y[3]&(~w);
    assign next[6] =  y[4]&(~w);


    assign Y2 = next[2];
    assign Y4 = next[4];


endmodule