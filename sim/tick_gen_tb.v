`timescale 1ns / 1ps

//============================================================
// Testbench: tick_gen_tb
// Verify:
//   1. tick_1s is a one-clock-cycle pulse
//   2. tick_10ms is a one-clock-cycle pulse
//   3. blink_1hz toggles periodically
//
// Real count values are very large, so this testbench shortens
// the parameters only for simulation.
//============================================================

module tick_gen_tb();

reg Clk;
reg Reset_n;

wire tick_1s;
wire tick_10ms;
wire blink_1hz;

tick_gen uut(
    .Clk(Clk),
    .Reset_n(Reset_n),
    .tick_1s(tick_1s),
    .tick_10ms(tick_10ms),
    .blink_1hz(blink_1hz)
);

// 50 MHz clock: 20 ns period
initial Clk = 1'b0;
always #10 Clk = ~Clk;

initial
begin
    Reset_n = 1'b0;
    #100;
    Reset_n = 1'b1;

    #1200;
    $finish;
end

// Simulation-only shortened values
defparam uut.MCNT_1S    = 10;
defparam uut.MCNT_10MS  = 4;
defparam uut.MCNT_BLINK = 5;

endmodule
