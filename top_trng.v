`timescale 1ns / 1ps

module top_trng(
    input clk,             // 100 MHz onboard crystal
    input enable_switch,   // Physical Switch 0
    output reg led_out,    // Physical LED 0
    output RsTx            // The physical wire going to the USB port
);

    wire ro_signal; // The chaotic wave

    // -------------------------------------------------------------------------
    // 1. The Physics Engine (15-Oscillator XOR Array)
    // -------------------------------------------------------------------------
    trng_xor_array ro_inst (
        .enable_switch(enable_switch),
        .final_chaos(ro_signal)
    );

    // -------------------------------------------------------------------------
    // 2. The Camera (Sub-Sampled D Flip-Flop)
    // -------------------------------------------------------------------------
    reg random_bit;
    reg [9:0] prescaler = 0; // 10-bit counter to divide the clock by 1024
    reg bit_trigger = 0;     // Flag to tell the byte packer a new picture was taken
    
    always @(posedge clk) begin
        bit_trigger <= 1'b0; // Default: do not trigger the packer
        
        if (enable_switch) begin
            prescaler <= prescaler + 1; // Count up every 10ns
            
            // Only take a picture when the counter rolls over to 0 (once every 1,024 ticks)
            if (prescaler == 0) begin
                random_bit <= ro_signal; // Take the snapshot!
                led_out <= random_bit;   // Send a copy to the LED
                bit_trigger <= 1'b1;     // Tell the shift register to grab this bit
            end
        end else begin
            random_bit <= 1'b0;
            led_out <= 1'b0;
            prescaler <= 0;
        end
    end

    // -------------------------------------------------------------------------
    // 3. The Byte Packer (Shift Register)
    // -------------------------------------------------------------------------
    reg [7:0] random_byte = 0;
    reg [2:0] bit_count = 0;
    reg tx_start = 0;
    wire tx_busy; // Wire coming back from the UART chip

    always @(posedge clk) begin
        tx_start <= 1'b0; // Default state: do not press the start button
        
        if (enable_switch) begin
            // Only collect if a NEW bit is ready AND the UART is NOT busy
            if (bit_trigger == 1'b1 && tx_busy == 1'b0 && tx_start == 1'b0) begin
                
                // Shift the newest random bit into the 8-bit vault
                random_byte <= {random_byte[6:0], random_bit};
                bit_count <= bit_count + 1;
                
                // Once we have collected 8 bits, press the UART start button!
                if (bit_count == 3'b111) begin // 3'b111 is 7 in binary
                    tx_start <= 1'b1;
                end
            end
        end
    end

    // -------------------------------------------------------------------------
    // 4. The USB Transmitter (UART Instantiation)
    // -------------------------------------------------------------------------
    uart_tx uart_inst (
        .clk(clk),
        .tx_start(tx_start),
        .tx_data(random_byte),
        .tx(RsTx),
        .tx_busy(tx_busy)
    );

endmodule