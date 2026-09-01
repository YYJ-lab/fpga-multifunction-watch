//============================================================
// Module: LED_disp
// Function:
//   Drive the 8-digit seven-segment display by dynamic scanning.
//
// Basis:
//   The scanning counter and segment-code idea follow the course PPT example.
//   Two small project extensions are added:
//     1. digit_en : allows individual digits to be blanked;
//     2. dp_data  : independently controls each decimal point.
//
// HX7A75C board notes:
//   - seven-segment display is common-anode;
//   - segment output is LOW active: 0 = segment ON;
//   - digit select SEL is HIGH active on this board.
//============================================================

module LED_disp(
    disp_data,
    digit_en,
    dp_data,
    Clk,
    Reset_n,
    LUT,
    SEL
);

input [31:0] disp_data;
input [7:0] digit_en;
input [7:0] dp_data;
input Clk;
input Reset_n;

output reg [7:0] LUT;
output reg [7:0] SEL;

// At 50 MHz, 50,000 clock cycles = 1 ms.
// Each digit is selected for about 1 ms, so a full 8-digit frame is about 8 ms.
parameter MCNT_SCAN = 50000;

reg [15:0] count_clk;
reg [2:0] cnt;
reg [3:0] disp_tmp;

//--------------------------
// Scan timing counter
//--------------------------
always @(posedge Clk or negedge Reset_n)
begin
    if(!Reset_n)
        count_clk <= 0;
    else if(count_clk >= MCNT_SCAN - 1)
        count_clk <= 0;
    else
        count_clk <= count_clk + 1'b1;
end

//--------------------------
// Select next digit every scan period
//--------------------------
always @(posedge Clk or negedge Reset_n)
begin
    if(!Reset_n)
        cnt <= 0;
    else if(count_clk >= MCNT_SCAN - 1)
        cnt <= cnt + 1'b1;
end

//--------------------------
// Digit select
// HX7A75C SEL is HIGH active.
//--------------------------
always @(*)
begin
    case(cnt)
        3'd0: SEL = 8'b00000001;
        3'd1: SEL = 8'b00000010;
        3'd2: SEL = 8'b00000100;
        3'd3: SEL = 8'b00001000;
        3'd4: SEL = 8'b00010000;
        3'd5: SEL = 8'b00100000;
        3'd6: SEL = 8'b01000000;
        3'd7: SEL = 8'b10000000;
        default: SEL = 8'b00000000;
    endcase
end

//--------------------------
// Choose the 4-bit value corresponding to the selected digit.
// Compared with the original course example, this is written as combinational
// logic so that the selected digit and selected data always stay aligned.
//--------------------------
always @(*)
begin
    case(cnt)
        3'd0: disp_tmp = disp_data[3:0];
        3'd1: disp_tmp = disp_data[7:4];
        3'd2: disp_tmp = disp_data[11:8];
        3'd3: disp_tmp = disp_data[15:12];
        3'd4: disp_tmp = disp_data[19:16];
        3'd5: disp_tmp = disp_data[23:20];
        3'd6: disp_tmp = disp_data[27:24];
        3'd7: disp_tmp = disp_data[31:28];
        default: disp_tmp = 4'hF;
    endcase
end

//--------------------------
// Seven-segment decoding
// LUT[7:0] = a b c d e f g dp
// LOW level turns a segment on.
//
// Codes 0~9 reuse the segment table from the course PPT.
// 4'hF is reserved by this project as a blank code.
//--------------------------
always @(*)
begin
    // If the current digit is disabled, turn all segments off.
    if(!digit_en[cnt])
    begin
        LUT = 8'b11111111;
    end
    else
    begin
        case(disp_tmp)
            4'h0: LUT = 8'b00000011;
            4'h1: LUT = 8'b10011111;
            4'h2: LUT = 8'b00100101;
            4'h3: LUT = 8'b00001101;
            4'h4: LUT = 8'b10011001;
            4'h5: LUT = 8'b01001001;
            4'h6: LUT = 8'b01000001;
            4'h7: LUT = 8'b00011111;
            4'h8: LUT = 8'b00000001;
            4'h9: LUT = 8'b00001001;
            default: LUT = 8'b11111111;
        endcase

        // Decimal point is also LOW active.
        if(dp_data[cnt])
            LUT[0] = 1'b0;
        else
            LUT[0] = 1'b1;
    end
end

endmodule
