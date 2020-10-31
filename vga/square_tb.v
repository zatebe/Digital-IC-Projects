`timescale 1ns / 1ps

module square_tb;

    reg clk;
    reg reset;
    wire hsync, vsync;
    wire [11:0] vga;

    square uut(
    .clk (clk),
    .reset (reset),
    .Hsync(hsync),
    .Vsync(vsync),
    .vga(vga)
    );
    
    initial begin
        clk = 0;
        reset = 1;
        #5 reset = 0;
    end
    
    always #5 clk = ~clk;
endmodule
