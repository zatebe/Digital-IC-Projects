`timescale 1ns / 1ps

module testbench;

reg clk;
reg reset;
wire [3:0] an;
wire [6:0] seg;

counter uut (
.clk (clk),
.reset (reset),
.an (an),
.seg (seg)
);

initial begin
    clk = 0;
    reset = 1;
    #5 reset = 0;
end

always #5 clk = ~clk;

endmodule
