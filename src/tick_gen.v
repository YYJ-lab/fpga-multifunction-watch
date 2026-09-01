//============================================================
// Module: tick_gen
// Function:
//   Generate commonly used timing events from the 50 MHz board clock.
//
// Design idea:
//   Follow the course-style "counter + always block" method.
//   We do NOT create a new clock. We only generate one-clock-cycle
//   enable pulses (tick), which is easier to understand and safer.
//
// Outputs:
//   tick_1s    : one Clk cycle high every 1 second
//   tick_10ms  : one Clk cycle high every 10 ms (for stopwatch)
//   blink_1hz  : toggles every 0.5 second, full blink period = 1 second
//============================================================

module tick_gen(
    Clk,
    Reset_n,
    tick_1s,
    tick_10ms,
    blink_1hz
);

input Clk;
input Reset_n;

output reg tick_1s;
output reg tick_10ms;
output reg blink_1hz;

// 50 MHz clock:
// 1 s   = 50,000,000 cycles
// 10 ms =    500,000 cycles
// 0.5 s = 25,000,000 cycles
//
// Parameters are used so the testbench can shorten them during simulation.
parameter MCNT_1S    = 50000000;
parameter MCNT_10MS  =   500000;
parameter MCNT_BLINK = 25000000;

reg [25:0] cnt_1s;
reg [18:0] cnt_10ms;
reg [24:0] cnt_blink;

//------------------------------------------------------------
// 1-second tick
//------------------------------------------------------------
always @(posedge Clk or negedge Reset_n)
begin
    if(!Reset_n)
    begin
        cnt_1s <= 0;
        tick_1s <= 0;
    end
    else if(cnt_1s >= MCNT_1S - 1)
    begin
        cnt_1s <= 0;
        tick_1s <= 1;
    end
    else
    begin
        cnt_1s <= cnt_1s + 1'b1;
        tick_1s <= 0;
    end
end

//------------------------------------------------------------
// 10 ms tick
//------------------------------------------------------------
always @(posedge Clk or negedge Reset_n)
begin
    if(!Reset_n)
    begin
        cnt_10ms <= 0;
        tick_10ms <= 0;
    end
    else if(cnt_10ms >= MCNT_10MS - 1)
    begin
        cnt_10ms <= 0;
        tick_10ms <= 1;
    end
    else
    begin
        cnt_10ms <= cnt_10ms + 1'b1;
        tick_10ms <= 0;
    end
end

//------------------------------------------------------------
// 1 Hz blink state
// Toggle once every 0.5 s.
//------------------------------------------------------------
always @(posedge Clk or negedge Reset_n)
begin
    if(!Reset_n)
    begin
        cnt_blink <= 0;
        blink_1hz <= 0;
    end
    else if(cnt_blink >= MCNT_BLINK - 1)
    begin
        cnt_blink <= 0;
        blink_1hz <= ~blink_1hz;
    end
    else
    begin
        cnt_blink <= cnt_blink + 1'b1;
    end
end

endmodule
