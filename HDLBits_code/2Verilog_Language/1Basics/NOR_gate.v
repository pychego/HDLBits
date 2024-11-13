module top_module (
    input a,
    input b,
    output out
);
    // 或非门 
    assign out = ~(a|b);

endmodule