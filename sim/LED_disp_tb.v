`timescale 1ns / 1ps

//============================================================
// Testbench: LED_disp_tb
// Verify:
//   - SEL scans through 8 digits
//   - number decoding is correct
//   - digit_en can blank digits
//   - dp_data can turn decimal points on
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

    // Nibbles from high to low are: 1 2 3 4 5 6 7 8
    disp_data = 32'h12345678;

    // Enable all digits
    digit_en = 8'b11111111;

    // Turn on decimal points at two scan positions
    dp_data = 8'b00001010;

    #100;
    Reset_n = 1'b1;

    #1000;

    // Blank two digits
    digit_en = 8'b11101011;
    #600;

    $finish;
end

// Shorten scan time only for simulation
defparam uut.MCNT_SCAN = 4;

endmodule
