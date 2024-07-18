module ShowSSI_state_tb ();

    reg         clk;
    reg         rst_n;
    reg  [31:0] data0;
    reg  [31:0] data1;
    reg  [31:0] data2;
    reg  [31:0] data3;
    reg  [31:0] data4;
    reg  [31:0] data5;
    wire        SSI_No_Valid;
    wire        led;

    ShowSSI_state ShowSSI_state (
        .clk         (clk),
        .rst_n       (rst_n),
        .data0       (data0),
        .data1       (data1),
        .data2       (data2),
        .data3       (data3),
        .data4       (data4),
        .data5       (data5),
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
        data0 = 0;
        data1 = 0;
        data2 = 0;
        data3 = 0;
        data4 = 0;
        data5 = 0;
        #10 rst_n = 1;
        #500 data4 = 700000;
        #600 data4 = 10;
    end





endmodule
