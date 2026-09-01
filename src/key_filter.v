//============================================================
// Module: key_filter
// Function:
//   Mechanical key debounce.
//
// This module follows the four-state debounce idea used in the
// course PPT:
//   s0: stable release
//   s1: press debounce
//   s2: stable press
//   s3: release debounce
//
// HX7A75C key level:
//   released = 1
//   pressed  = 0
//
// Outputs:
//   Key_P_Flag : one-clock-cycle pulse after a valid press
//   Key_R_Flag : one-clock-cycle pulse after a valid release
//   Key_state  : debounced key state, 1=released, 0=pressed
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

localparam [1:0]
    s0 = 2'b00,
    s1 = 2'b01,
    s2 = 2'b10,
    s3 = 2'b11;

// 50 MHz × 20 ms = 1,000,000 cycles
parameter MCNT = 1000000;

reg [1:0] r_Key;
reg [19:0] cnt;
reg [1:0] state;

//------------------------------------------------------------
// Synchronize/sample key level with two registers.
// Reset to 11 because the key is normally released.
//------------------------------------------------------------
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

//------------------------------------------------------------
// Debounce state machine
//------------------------------------------------------------
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

            // Stable released state
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

            // Press debounce
            s1:
            begin
                Key_P_Flag <= 0;
                Key_R_Flag <= 0;

                // If the signal returns high before debounce finishes,
                // treat it as bounce and cancel this press.
                if(pedge_key)
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

            // Stable pressed state
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

            // Release debounce
            s3:
            begin
                Key_P_Flag <= 0;
                Key_R_Flag <= 0;

                if(nedge_key)
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
