module top_module( 
    input [99:0] a, b,
    input cin,
    output [99:0] cout,
    output [99:0] sum );

    reg [99:0] j;

// for 需要写在 always 内部
    always @(*) begin
        for (j = 0; j<100; j=j+1) begin
            if (j==0) begin
                cout[0] = cin & (a[0]^b[0]) + a[0]&b[0];
                sum[0] = a[0]^b[0]^cin;
            end else begin
                cout[j] = cout[j-1]&(a[j]^b[j]) + a[j]&b[j];
                sum[j] = a[j] ^ b[j] ^ cout[j-1];
            end
        end
    end

endmodule