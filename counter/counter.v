`timescale 1ns / 1ps

module counter(
    input clk,
    input reset,
    output reg [3:0] an,
    output reg [6:0] seg
    );
    
    reg [25:0] half_sec_counter; // counts to 0.5s
    reg [3:0] ones; // represents ones place
    reg [3:0] tens; // represents tens place
    reg [3:0] display; // single seven-segment output
    wire [1:0] led_select; // which seven-segment display
    wire en; // should digit increment
    
    always @(posedge clk or posedge reset) // count until 0.5s
    begin
        if (reset == 1)
            half_sec_counter <= 0;
        else begin
            if (half_sec_counter >= 49999999)
                half_sec_counter <= 0;
            else 
                half_sec_counter <= half_sec_counter + 1;
        end
    end
    
    assign en = (half_sec_counter == 49999999) ? 1 : 0;
    always @(posedge clk or posedge reset) // increment the digit
    begin // decade counter
        if (reset == 1)
            {ones, tens} <= 0;
        else if (en == 1) 
        begin
    	   ones <= ones < 9 ? ones + 1 : 0;
    	   tens <= ones < 9 ? tens : tens < 9 ? tens + 1 : 0;
        end 
    end
    
    assign led_select = half_sec_counter[19]; // bits for refresh interval   
    always @(posedge clk) // cycle through the digits of the display
    begin
        if (led_select == 1) begin
            an = 4'b1101; 
            display = tens;
        end else begin
            an = 4'b1110; 
            display = ones;  
        end
    end
    
    always @(posedge clk)
    begin
        case(display)// convert 4 digit binary to 7-segment output
        4'b0001: seg = 7'b1111001; // "1" 
        4'b0010: seg = 7'b0100100; // "2" 
        4'b0011: seg = 7'b0110000; // "3" 
        4'b0100: seg = 7'b0011001; // "4" 
        4'b0101: seg = 7'b0010010; // "5" 
        4'b0110: seg = 7'b0000010; // "6" 
        4'b0111: seg = 7'b1111000; // "7" 
        4'b1000: seg = 7'b0000000; // "8"     
        4'b1001: seg = 7'b0010000; // "9" 
        default: seg = 7'b1000000; // "0"
        endcase
    end  
endmodule
