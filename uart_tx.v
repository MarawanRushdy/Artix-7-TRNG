`timescale 1ns / 1ps

module uart_tx(
    input clk,             // 100 MHz board clock
    input tx_start,        // Trigger to send a byte
    input [7:0] tx_data,   // The 8 random bits to send
    output reg tx,         // The physical wire going to the USB port
    output reg tx_busy     // Tells the system "Wait, I'm currently sending!"
);

    // 115200 Baud Rate (100,000,000 Hz / 115200 = 868 clock ticks per bit)
    parameter CLKS_PER_BIT = 868; 

    parameter IDLE = 3'b000;
    parameter START = 3'b001;
    parameter DATA = 3'b010;
    parameter STOP = 3'b011;

    reg [2:0] state = IDLE;
    reg [9:0] clock_count = 0;
    reg [2:0] bit_index = 0;
    reg [7:0] data_reg = 0;

    initial begin
        tx = 1'b1; // UART lines idle high
        tx_busy = 1'b0;
    end

    always @(posedge clk) begin
        case (state)
            IDLE: begin
                tx <= 1'b1;
                clock_count <= 0;
                bit_index <= 0;
                if (tx_start == 1'b1) begin
                    tx_busy <= 1'b1;
                    data_reg <= tx_data;
                    state <= START;
                end else begin
                    tx_busy <= 1'b0;
                end
            end

            START: begin
                tx <= 1'b0; // Send Start Bit (Low)
                if (clock_count < CLKS_PER_BIT - 1) begin
                    clock_count <= clock_count + 1;
                end else begin
                    clock_count <= 0;
                    state <= DATA;
                end
            end

            DATA: begin
                tx <= data_reg[bit_index]; // Send actual data bits
                if (clock_count < CLKS_PER_BIT - 1) begin
                    clock_count <= clock_count + 1;
                end else begin
                    clock_count <= 0;
                    if (bit_index < 7) begin
                        bit_index <= bit_index + 1;
                    end else begin
                        bit_index <= 0;
                        state <= STOP;
                    end
                end
            end

            STOP: begin
                tx <= 1'b1; // Send Stop Bit (High)
                if (clock_count < CLKS_PER_BIT - 1) begin
                    clock_count <= clock_count + 1;
                end else begin
                    clock_count <= 0;
                    state <= IDLE;
                end
            end

            default: state <= IDLE;
        endcase
    end
endmodule