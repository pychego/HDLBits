module moduleName (
    input a,
    input b,
    input sel,
    output out
);
    // This is a mux2 module
    assign out = sel == 1'b1 ? a : b;
endmodule