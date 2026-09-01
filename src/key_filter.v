//============================================================
// Module: key_filter
// Function:
//   Mechanical key debounce.
//
// This implementation follows the four-state debounce structure used in the
// course PPT. The main idea is:
//   stable release -> possible press -> stable press -> possible release.
//
// Key electrical level on HX7A75C:
//   released = 1
//   pressed  = 0
//
// Outputs:
//   Key_P_Flag : one-clock-cycle pulse after a valid press is confirmed
//   Key_R_Flag : one-clock-cycle pulse after a valid release is confirmed
//   Key_state  : debounced key level, 1=released, 0=pressed
//============================================================

module key_filter(
    Clk,
    Reset_n,
    Key,
    Key_P_Flag,
    Key_R_Flag,
    Key_state
);

input Clk;
input Reset_n;
input Key;

output reg Key_P_Flag;
output reg Key_R_Flag;
output reg Key_state;

// Four states, consistent with the course example.
localparam [1:0]
    s0 = 2'b00,    // stable release
    s1 = 2'b01,    // press debounce
    s2 = 2'b10,    // stable press
    s3 = 2'b11;    // release debounce

// 20 ms debounce time at 50 MHz:
// 50,000,000 * 0.02 = 1,000,000 cycles.
parameter MCNT = 1000000;

reg [1:0] r_Key;
reg [19:0] cnt;
reg [1:0] state;

// Two-sample register used to detect key edges.
// Reset to 11 because the key is normally released (high level).
always @(posedge Clk or negedge Reset_n)
begin
    if(!Reset_n)
        r_Key <= 2'b11;
    else
        r_Key <= {r_Key[0], Key};
end

wire pedge_key;
wire nedge_key;

// 01: low -> high, release edge
// 10: high -> low, press edge
assign pedge_key = (r_Key == 2'b01);
assign nedge_key = (r_Key == 2'b10);

// Main debounce state machine.
always @(posedge Clk or negedge Reset_n)
begin
    if(!Reset_n)
    begin
        state <= s0;
        cnt <= 0;
        Key_P_Flag <= 0;
        Key_R_Flag <= 0;
        Key_state <= 1;
    end
    else
    begin
        case(state)
            // Stable released state.
            // A falling edge means the key may have been pressed.
            s0:
            begin
                Key_P_Flag <= 0;
                Key_R_Flag <= 0;

                if(nedge_key)
                begin
                    state <= s1;
                    cnt <= 0;
                end
                else
                    state <= s0;
            end

            // Press debounce.
            // If the key bounces back high before MCNT, cancel the press.
            s1:
            begin
                Key_P_Flag <= 0;
                Key_R_Flag <= 0;

                if(pedge_key && (cnt < MCNT - 1))
                begin
                    state <= s0;
                    cnt <= 0;
                end
                else if(cnt >= MCNT - 1)
                begin
                    state <= s2;
                    cnt <= 0;
                    Key_P_Flag <= 1;
                    Key_state <= 0;
                end
                else
                begin
                    state <= s1;
                    cnt <= cnt + 1'b1;
                end
            end

            // Stable pressed state.
            // A rising edge means the key may have been released.
            s2:
            begin
                Key_P_Flag <= 0;
                Key_R_Flag <= 0;

                if(pedge_key)
                begin
                    state <= s3;
                    cnt <= 0;
                end
                else
                    state <= s2;
            end

            // Release debounce.
            // If the key bounces low again before MCNT, return to stable press.
            s3:
            begin
                Key_P_Flag <= 0;
                Key_R_Flag <= 0;

                if(nedge_key && (cnt < MCNT - 1))
                begin
                    state <= s2;
                    cnt <= 0;
                end
                else if(cnt >= MCNT - 1)
                begin
                    state <= s0;
                    cnt <= 0;
                    Key_R_Flag <= 1;
                    Key_state <= 1;
                end
                else
                begin
                    state <= s3;
                    cnt <= cnt + 1'b1;
                end
            end

            default:
            begin
                state <= s0;
                cnt <= 0;
                Key_P_Flag <= 0;
                Key_R_Flag <= 0;
                Key_state <= 1;
            end
        endcase
    end
end

endmodule
