`timescale 1ns / 1ps

//============================================================
// Testbench: key_filter_tb
// Purpose:
//   Verify that mechanical bounce does not create multiple valid key presses.
//============================================================

module key_filter_tb();

reg Clk;
reg Reset_n;
reg Key;

wire Key_P_Flag;
wire Key_R_Flag;
wire Key_state;

key_filter uut(
    .Clk(Clk),
    .Reset_n(Reset_n),
    .Key(Key),
    .Key_P_Flag(Key_P_Flag),
    .Key_R_Flag(Key_R_Flag),
    .Key_state(Key_state)
);

initial Clk = 1'b0;
always #10 Clk = ~Clk;

initial
begin
    Reset_n = 1'b0;
    Key = 1'b1;
    #100;
    Reset_n = 1'b1;

    // Simulate several fast bounces when the key is pressed.
    #80  Key = 1'b0;
    #40  Key = 1'b1;
    #40  Key = 1'b0;
    #40  Key = 1'b1;
    #40  Key = 1'b0;

    // Keep the key stably pressed long enough.
    #300;

    // Simulate several fast bounces when the key is released.
    Key = 1'b1;
    #40  Key = 1'b0;
    #40  Key = 1'b1;
    #40  Key = 1'b0;
    #40  Key = 1'b1;

    // Keep the key stably released long enough.
    #300;

    $finish;
end

// Real hardware uses MCNT = 1,000,000 (20 ms).
// The testbench shortens it only to make simulation fast.
defparam uut.MCNT = 5;

endmodule
