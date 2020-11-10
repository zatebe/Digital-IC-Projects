`timescale 1ns / 1ps

module moore_tb;

    reg clk;
    wire out;

    reg reset; // input read
    reg in;  // input read
    reg exp; // expected output 
    reg [31:0] vecNum; // vector line
    reg [31:0] errs; // num of errors    
    reg [2:0] vectors[0:9]; // read in vectors 
    
    moore dut(
    .clk (clk),
    .reset (reset),
    .in (in),
    .out (out)      
    );
    
    initial begin
        $readmemb("mooreTV.tv", vectors); // read vectors from file
        vecNum <= 0;
        errs <= 0;
        in <= 0;
        reset <= 1; #10;
    end
    
    // update reset, in, and exp with vector
    always @(posedge clk)
    begin
        {reset, in, exp} <= vectors[vecNum];
    end
    
    // check that output is expected
    always @(negedge clk)
    begin
        if (exp !== out) begin
            errs = errs + 1;
            $display("Bad input for %b", {reset, in});
            $display("Expected %b Got %b", exp, out);
        end 
        
        vecNum = vecNum + 1;
    end
    
    // 10ns period
    always begin
        clk <= 1; #5;
        clk <= 0; #5;
    end
endmodule
