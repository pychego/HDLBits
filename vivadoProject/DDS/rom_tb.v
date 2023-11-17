`timescale 1ns / 1ns

module rom_tb ();


    reg        clka;
    reg  [9:0] addra;  // ip核中定义为10位，如果定义为8位，输出就是高阻态
    wire [9:0] douta;

    rom rom_inst (
        .clka (clka),
        .addra(addra),
        .douta(douta)
    );

    initial clka = 0;
    always #10 clka = ~clka;

    initial begin
        addra = 100;
        #501;
        repeat (3000) begin
            addra = addra + 1;
            #20;
        end
        #200000;
        $stop;
    end

endmodule
