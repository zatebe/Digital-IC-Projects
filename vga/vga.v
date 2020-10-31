`timescale 1ns / 1ps

module vga(
    input clk,
    input reset,
    output hsync,
    output vsync,
    output [9:0] xc,
    output [9:0] yc
    );
    
    localparam hva = 640; // visible horizontal area
    localparam hsr = 656; // start horizontal retrace
    localparam her = 751; // end horizontal retrace
    localparam hwl = 800; // whole line
    
    localparam vva = 480; // visible vertical area
    localparam ver = 491; // start retrace
    localparam vwf = 525; // whole frame
    
    
    reg [9:0] x; // x pos
    reg [9:0] y; // y pos
    reg h, v; // store info for hsync and sync
    reg [1:0] counter; // mod 4 counter for 25MHz clock
    wire enable; // enable for sync update
    
    always @(posedge clk or posedge reset)
    begin
        counter <= reset ? 0 : counter + 1;
    end
    
    // signal to update x and y
    assign enable = (counter == 0);
    always @(posedge clk or posedge reset)
    begin
        if (reset) begin
            x <= 0;
            y <= 0;
        end else begin
            // draw line for visible area
            x <= enable ? x < hwl ? x + 1 : 0 : x;
            // next line only when complete and draw for visible area
            y <= (enable && x >= hwl) ? y < vwf ? y + 1 : 0 : y;
        end
    end
    
    // assign outputs
    assign hsync = x < hsr || x > her;
    assign vsync = y != ver;
    assign xc = x;
    assign yc = y;
endmodule
