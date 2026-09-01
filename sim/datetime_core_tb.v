`timescale 1ns / 1ps

//============================================================
// Testbench: datetime_core_tb
//
// Main tests:
//   1. 2024-02-28 23:59:58 -> 2024-02-29 00:00:00  (leap year)
//   2. Change 2024-02-29 to 2023: day automatically clamps to 28
//   3. Time-setting field selection and +1/-1
//
// The testbench directly supplies tick_1s pulses.
// This isolates datetime_core from tick_gen, so debugging is easier.
//============================================================

module datetime_core_tb();

reg Clk;
reg Reset_n;
reg tick_1s;

reg time_set_mode;
reg date_set_mode;
reg key_select;
reg key_inc;
reg key_dec;

wire [4:0] hour;
wire [5:0] minute;
wire [5:0] second;
wire [15:0] year;
wire [3:0] month;
wire [5:0] day;
wire time_field;
wire [1:0] date_field;

datetime_core uut(
    .Clk(Clk),
    .Reset_n(Reset_n),
    .tick_1s(tick_1s),

    .time_set_mode(time_set_mode),
    .date_set_mode(date_set_mode),
    .key_select(key_select),
    .key_inc(key_inc),
    .key_dec(key_dec),

    .hour(hour),
    .minute(minute),
    .second(second),
    .year(year),
    .month(month),
    .day(day),

    .time_field(time_field),
    .date_field(date_field)
);

// Start very close to a leap-day boundary so the important behavior
// can be seen immediately.
defparam uut.INIT_YEAR   = 2024;
defparam uut.INIT_MONTH  = 2;
defparam uut.INIT_DAY    = 28;
defparam uut.INIT_HOUR   = 23;
defparam uut.INIT_MINUTE = 59;
defparam uut.INIT_SECOND = 58;

// 50 MHz clock
initial Clk = 1'b0;
always #10 Clk = ~Clk;

//------------------------------------------------------------
// The tasks below are only used in the TESTBENCH to avoid
// repeatedly writing the same pulse code.
// They are not synthesized into FPGA hardware.
//------------------------------------------------------------
task send_tick;
begin
    @(negedge Clk);
    tick_1s = 1'b1;
    @(negedge Clk);
    tick_1s = 1'b0;
end
endtask

task press_select;
begin
    @(negedge Clk);
    key_select = 1'b1;
    @(negedge Clk);
    key_select = 1'b0;
end
endtask

task press_inc;
begin
    @(negedge Clk);
    key_inc = 1'b1;
    @(negedge Clk);
    key_inc = 1'b0;
end
endtask

task press_dec;
begin
    @(negedge Clk);
    key_dec = 1'b1;
    @(negedge Clk);
    key_dec = 1'b0;
end
endtask

initial
begin
    Reset_n = 1'b0;
    tick_1s = 1'b0;

    time_set_mode = 1'b0;
    date_set_mode = 1'b0;

    key_select = 1'b0;
    key_inc = 1'b0;
    key_dec = 1'b0;

    #100;
    Reset_n = 1'b1;

    //--------------------------------------------------------
    // Test 1: leap-year rollover
    // 2024-02-28 23:59:58
    // -> first tick: 23:59:59
    // -> second tick: 2024-02-29 00:00:00
    //--------------------------------------------------------
    send_tick;
    send_tick;

    #40;

    //--------------------------------------------------------
    // Test 2: date setting
    // Current date is 2024-02-29.
    // date_field defaults to year.
    // Decrease year by 1:
    // 2024-02-29 -> 2023-02-28
    //--------------------------------------------------------
    date_set_mode = 1'b1;
    press_dec;

    #40;

    //--------------------------------------------------------
    // Test 3: move date field:
    // year -> month -> day
    // Then day +1. Since 2023-02-28 is the last day of Feb,
    // manual day editing wraps to 1.
    //--------------------------------------------------------
    press_select;  // month
    press_select;  // day
    press_inc;     // 28 -> 1

    #40;
    date_set_mode = 1'b0;

    //--------------------------------------------------------
    // Test 4: time setting
    // time_field defaults to hour.
    // hour +1, select minute, minute -1.
    //--------------------------------------------------------
    time_set_mode = 1'b1;
    press_inc;     // hour +1
    press_select;  // select minute
    press_dec;     // minute -1
    time_set_mode = 1'b0;

    #100;
    $finish;
end

endmodule
