module top_module(
    input c, 
    input d,
    output [3:0] mux_in
);
    
    // always@(*) begin
    //     case({c,d})
    //         0: mux_in = 4'b0100;
    //         1: mux_in = 4'b0001;
    //         2: mux_in = 4'b0101;
    //         3: mux_in = 4'b1001;
    //     endcase
    // end

    assign mux_in[0] = c ? 1 : d;
    assign mux_in[1] = 0;
    assign mux_in[2] = ~d;
    assign mux_in[3] = c ? d : 0;


endmodule