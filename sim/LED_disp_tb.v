`timescale 1ns / 1ps

//============================================================
// Testbench: LED_disp_tb
// Purpose:
//   Verify digit scanning, number decoding, digit blanking and decimal points.
//============================================================

module LED_disp_tb();

reg [31:0] disp_data;
reg [7:0] digit_en;
reg [7:0] dp_data;
reg Clk;
reg Reset_n;

wire [7:0] LUT;
wire [7:0] SEL;

LED_disp uut(
    .disp_data(disp_data),
    .digit_en(digit_en),
    .dp_data(dp_data),
    .Clk(Clk),
    .Reset_n(Reset_n),
    .LUT(LUT),
    .SEL(SEL)
);

initial Clk = 1'b0;
always #10 Clk = ~Clk;

initial
begin
    Reset_n = 1'b0;

    // From high nibble to low nibble: 1 2 3 4 5 6 7 8
    disp_data = 32'h12345678;

    // Enable all eight digits.
    digit_en = 8'b11111111;

    // Turn on decimal points for scan positions 1 and 3.
    dp_data = 8'b00001010;

    #100;
    Reset_n = 1'b1;

    // Observe several complete scan frames.
    #1000;

    // Test digit blanking: disable scan positions 2 and 4.
    digit_en = 8'b11101011;
    #600;

    $finish;
end

// Shorten scan period only for simulation.
defparam uut.MCNT_SCAN = 4;

endmodule
