module top_module(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);
    
    wire [5:0] next;

    assign next[0] =  y[0]&(~w) | y[3]&(~w);
    assign next[1] =  y[0]&(w);
    assign next[2] =  y[1]&(w) | y[5]&w;
    assign next[3] =  (~w)&(y[2] | y[4] | y[5] | y[1]);
    assign next[4] =  y[4]&(w) | y[3]&(w);
    assign next[5] =  y[3]&(w);


    assign Y1 = next[1];
    assign Y3 = next[3];


endmodule