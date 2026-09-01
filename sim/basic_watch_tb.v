`timescale 1ns / 1ps

//============================================================
// Integration test: basic_watch_tb
//
// Connect:
//   tick_gen -> datetime_core
//
// This verifies that the first two batches can work together.
// The 1-second counter is shortened in simulation.
//============================================================

module basic_watch_tb();

reg Clk;
reg Reset_n;

wire tick_1s;
wire tick_10ms;
wire blink_1hz;

wire [4:0] hour;
wire [5:0] minute;
wire [5:0] second;
wire [15:0] year;
wire [3:0] month;
wire [5:0] day;
wire time_field;
wire [1:0] date_field;

tick_gen tick_gen_inst(
    .Clk(Clk),
    .Reset_n(Reset_n),
    .tick_1s(tick_1s),
    .tick_10ms(tick_10ms),
    .blink_1hz(blink_1hz)
);

datetime_core datetime_core_inst(
    .Clk(Clk),
    .Reset_n(Reset_n),
    .tick_1s(tick_1s),

    .time_set_mode(1'b0),
    .date_set_mode(1'b0),
    .key_select(1'b0),
    .key_inc(1'b0),
    .key_dec(1'b0),

    .hour(hour),
    .minute(minute),
    .second(second),
    .year(year),
    .month(month),
    .day(day),

    .time_field(time_field),
    .date_field(date_field)
);

// Start near midnight for an obvious integration test.
defparam datetime_core_inst.INIT_YEAR   = 2026;
defparam datetime_core_inst.INIT_MONTH  = 12;
defparam datetime_core_inst.INIT_DAY    = 31;
defparam datetime_core_inst.INIT_HOUR   = 23;
defparam datetime_core_inst.INIT_MINUTE = 59;
defparam datetime_core_inst.INIT_SECOND = 58;

// Make "1 second" equal to only 5 clock cycles in simulation.
defparam tick_gen_inst.MCNT_1S = 5;
defparam tick_gen_inst.MCNT_10MS = 2;
defparam tick_gen_inst.MCNT_BLINK = 3;

initial Clk = 1'b0;
always #10 Clk = ~Clk;

initial
begin
    Reset_n = 1'b0;
    #100;
    Reset_n = 1'b1;

    // Enough time to see:
    // 2026-12-31 23:59:58
    // -> 23:59:59
    // -> 2027-01-01 00:00:00
    #700;

    $finish;
end

endmodule
