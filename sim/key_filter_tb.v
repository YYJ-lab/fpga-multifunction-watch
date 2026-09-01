`timescale 1ns / 1ps

//============================================================
// Testbench: key_filter_tb
// Verify:
//   A bouncing key press produces only one Key_P_Flag pulse.
//   A bouncing key release produces only one Key_R_Flag pulse.
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

    // Press bounce
    #80  Key = 1'b0;
    #40  Key = 1'b1;
    #40  Key = 1'b0;
    #40  Key = 1'b1;
    #40  Key = 1'b0;

    // Stable pressed
    #300;

    // Release bounce
    Key = 1'b1;
    #40  Key = 1'b0;
    #40  Key = 1'b1;
    #40  Key = 1'b0;
    #40  Key = 1'b1;

    // Stable released
    #300;

    $finish;
end

// Real hardware: 1,000,000
// Simulation: use a very small value
defparam uut.MCNT = 5;

endmodule
