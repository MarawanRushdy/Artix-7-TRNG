`timescale 1ns / 1ps

module trng_xor_array(
    input enable_switch,
    output final_chaos
    );

    // A 15-bit wide bus to catch the raw chaos from 15 separate physical engines
    wire [14:0] osc_out;

    // Instantiate an army of 15 identical ring oscillators.
    // Vivado will physically scatter these across the Artix-7 die.
    ring_oscillator ro00 ( .enable_switch(enable_switch), .led_out(osc_out[0]) );
    ring_oscillator ro01 ( .enable_switch(enable_switch), .led_out(osc_out[1]) );
    ring_oscillator ro02 ( .enable_switch(enable_switch), .led_out(osc_out[2]) );
    ring_oscillator ro03 ( .enable_switch(enable_switch), .led_out(osc_out[3]) );
    ring_oscillator ro04 ( .enable_switch(enable_switch), .led_out(osc_out[4]) );
    ring_oscillator ro05 ( .enable_switch(enable_switch), .led_out(osc_out[5]) );
    ring_oscillator ro06 ( .enable_switch(enable_switch), .led_out(osc_out[6]) );
    ring_oscillator ro07 ( .enable_switch(enable_switch), .led_out(osc_out[7]) );
    ring_oscillator ro08 ( .enable_switch(enable_switch), .led_out(osc_out[8]) );
    ring_oscillator ro09 ( .enable_switch(enable_switch), .led_out(osc_out[9]) );
    ring_oscillator ro10 ( .enable_switch(enable_switch), .led_out(osc_out[10]) );
    ring_oscillator ro11 ( .enable_switch(enable_switch), .led_out(osc_out[11]) );
    ring_oscillator ro12 ( .enable_switch(enable_switch), .led_out(osc_out[12]) );
    ring_oscillator ro13 ( .enable_switch(enable_switch), .led_out(osc_out[13]) );
    ring_oscillator ro14 ( .enable_switch(enable_switch), .led_out(osc_out[14]) );

    // THE COLLISION: Smash all 15 asynchronous waves together in a massive parity check
    assign final_chaos = osc_out[0] ^ osc_out[1] ^ osc_out[2] ^ osc_out[3] ^ 
                         osc_out[4] ^ osc_out[5] ^ osc_out[6] ^ osc_out[7] ^ 
                         osc_out[8] ^ osc_out[9] ^ osc_out[10] ^ osc_out[11] ^ 
                         osc_out[12] ^ osc_out[13] ^ osc_out[14];

endmodule