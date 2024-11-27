module ShowSSI_state_tb ();

    reg         clk;
    reg         rst_n;
    reg  [31:0] MAX_SSI;
    reg  [31:0] ssi0;
    reg  [31:0] ssi1;
    reg  [31:0] ssi2;
    reg  [31:0] ssi3;
    reg  [31:0] ssi4;
    reg  [31:0] ssi5;
    wire        SSI_No_Valid;
    wire        led;

    ShowSSI_state ShowSSI_state (
        .clk         (clk),
        .rst_n       (rst_n),
        .MAX_SSI     (MAX_SSI),
        .ssi0        (ssi0),
        .ssi1        (ssi1),
        .ssi2        (ssi2),
        .ssi3        (ssi3),
        .ssi4        (ssi4),
        .ssi5        (ssi5),
        .SSI_No_Valid(SSI_No_Valid),
        .led         (led)
    );

    initial begin
        clk = 0;
        forever begin
            #5 clk = ~clk;
        end
    end

    initial begin
        rst_n = 0;
        ssi0 = 0;
        ssi1 = 0;
        ssi2 = 0;
        ssi3 = 0;
        ssi4 = 0;
        ssi5 = 0;
        MAX_SSI = 60_0000;
        #10 rst_n = 1;
        #500 ssi2 = 700000;
        #600 ssi2 = 10;
    end





endmodule
