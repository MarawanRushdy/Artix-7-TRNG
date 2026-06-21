`timescale 1ns / 1ps
module ring_oscillator(
    input enable_switch,
    output led_out
    );
    
    (*DONT_TOUCH = "true" *) wire w1, w2, w3, w4, w5;
    
    assign w1 = enable_switch ? ~w5 : 1'b0;
    assign w2 = ~w1;
    assign w3 = ~w2;
    assign w4 = ~w3;
    assign w5 = ~w4;
    assign led_out = w5;
    
endmodule
