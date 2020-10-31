`timescale 1ns / 1ps

module square(
    input clk,
    input reset,
    output Hsync,
    output Vsync,
    output [11:0] vga
    );
    
    localparam size = 20;
    
    reg [11:0] rgb; // 12-bit RBG (port order as GBR)
    wire enable; // 60Hz enable signal
    wire [9:0] x; // x pos
    wire [9:0] y; // y pos
    reg [9:0] sqx; // x pos of square
    reg [9:0] sqy; // y pos of square
    reg drx; // horizontal direction
    reg dry; // vertical direction
    
    // create vga signal generator
    vga gen(
    .clk (clk),
    .reset (reset),
    .hsync(Hsync),
    .vsync(Vsync),
    .xc(x),
    .yc(y));
    
    //enable drawing at end of frame
    assign enable = (y == 480 && x == 800);
    always @(posedge clk or posedge reset)
    begin
        if (reset) begin
            sqx <= 0;
            sqx <= 0;
            drx <= 0;
            dry <= 0;
        end else begin
            if (enable) begin
                sqx <= drx ? sqx - 1 : sqx + 1;
                sqy <= dry ? sqy - 1 : sqy + 1;
                
                if (sqx + size == 640)
                    drx <= 1;
                if (sqx == 0)
                    drx <= 0;
                if (sqy + size == 480)
                    dry <= 1;
                if (sqy == 0)
                    dry <= 0;                
            end
        end
    end
    
    // color square green on black background
    always @(posedge clk or posedge reset)
    begin
        if (reset)
            rgb = 0;
        else begin
            if (x >= sqx && x <= sqx + size) begin
                if (y >= sqy && y <= sqy + size)
                    rgb = 12'b111100000000;
            end else
                rgb = 0;
        end
    end
    
    // assign outputs
    assign vga = rgb;
endmodule
