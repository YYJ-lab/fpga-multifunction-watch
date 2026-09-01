`timescale 1ns / 1ps

//============================================================
// Testbench: tick_gen_tb
// Purpose:
//   Verify that tick_gen produces single-cycle timing events.
//
// Important:
//   Real hardware uses very large count values. For simulation, the parameters
//   are deliberately reduced so that the waveform can be observed quickly.
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

// 50 MHz clock in the real design: period = 20 ns.
initial Clk = 1'b0;
always #10 Clk = ~Clk;

initial
begin
    Reset_n = 1'b0;
    #100;
    Reset_n = 1'b1;

    // Run long enough to observe several pulses and blink transitions.
    #1000;
    $finish;
end

// Shorten counters only for simulation.
defparam uut.MCNT_1S    = 10;
defparam uut.MCNT_10MS  = 4;
defparam uut.MCNT_BLINK = 5;

endmodule
