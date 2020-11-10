`timescale 1ns / 1ps

module moore(
    input clk,
    input reset,
    input  in,
    output out
    );
    
    // define the nine possible states - 3 bits minimum
    localparam A = 3'b000;
    localparam B = 3'b001;
    localparam C = 3'b010;
    localparam D = 3'b011;
    localparam E = 3'b100;
    
    reg [3:0] state;// store current state
    reg [3:0] next; // store next stae
    
    // on reset bring state back to A or update it to next
    always @(posedge clk or posedge reset)
    begin
        if (reset)
            state <= A;
        else
            state <= next;
    end
    
    // calculate next state using combinational logic
    always @(*)
    begin
        case(state)
            A: next = in ? B : D;
            B: next = in ? C : D;
            C: next = in ? E : C;
            D: next = in ? E : D;
            E: next = in ? E : E;
            default: next = A;
        endcase    
    end
    
    // wire output to be only high if in state C or E
    assign out = (state == C || state == E);
    
endmodule
