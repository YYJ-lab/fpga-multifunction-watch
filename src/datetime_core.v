//============================================================
// Module: datetime_core
// Function:
//   1. Keep current time: hour / minute / second
//   2. Keep current date: year / month / day
//   3. Advance time once every tick_1s
//   4. Handle 23:59:59 -> next day
//   5. Handle 30/31-day months and leap years
//   6. Support time setting and date setting
//
// Interface idea:
//   key_select / key_inc / key_dec are already debounced one-cycle pulses.
//   time_set_mode and date_set_mode come from the mode switch decoder later.
//
// Setting behavior:
//   - time set: select hour/minute, then +1 / -1
//   - date set: select year/month/day, then +1 / -1
//   - normal clock advancement pauses while a setting mode is active
//
// Notes:
//   The normal sequential logic uses always @(posedge Clk or negedge Reset_n)
//   and non-blocking assignment <=, matching the course style.
//============================================================

module datetime_core(
    Clk,
    Reset_n,
    tick_1s,

    time_set_mode,
    date_set_mode,
    key_select,
    key_inc,
    key_dec,

    hour,
    minute,
    second,
    year,
    month,
    day,

    time_field,
    date_field
);

input Clk;
input Reset_n;
input tick_1s;

input time_set_mode;
input date_set_mode;
input key_select;
input key_inc;
input key_dec;

output reg [4:0] hour;
output reg [5:0] minute;
output reg [5:0] second;

output reg [15:0] year;
output reg [3:0] month;
output reg [5:0] day;

// time_field:
//   0 = hour
//   1 = minute
output reg time_field;

// date_field:
//   0 = year
//   1 = month
//   2 = day
output reg [1:0] date_field;

// Default values after reset.
// They can also be overridden in the testbench if needed.
parameter INIT_YEAR   = 2026;
parameter INIT_MONTH  = 1;
parameter INIT_DAY    = 1;
parameter INIT_HOUR   = 0;
parameter INIT_MINUTE = 0;
parameter INIT_SECOND = 0;

// Allowed year range when the user manually sets the date.
// 2000~2199 is enough for this course project and still includes
// special years such as 2100 (not a leap year).
parameter YEAR_MIN = 2000;
parameter YEAR_MAX = 2199;

//------------------------------------------------------------
// Function: days_in_month
// Input : year + month
// Output: 28 / 29 / 30 / 31
//
// Leap-year rule:
//   divisible by 400
//   OR divisible by 4 but not by 100
//------------------------------------------------------------
function [5:0] days_in_month;
    input [15:0] y;
    input [3:0]  m;
    reg leap;
    begin
        if((y % 400 == 0) || ((y % 4 == 0) && (y % 100 != 0)))
            leap = 1'b1;
        else
            leap = 1'b0;

        case(m)
            4'd1, 4'd3, 4'd5, 4'd7,
            4'd8, 4'd10, 4'd12:
                days_in_month = 6'd31;

            4'd4, 4'd6, 4'd9, 4'd11:
                days_in_month = 6'd30;

            4'd2:
            begin
                if(leap)
                    days_in_month = 6'd29;
                else
                    days_in_month = 6'd28;
            end

            default:
                days_in_month = 6'd31;
        endcase
    end
endfunction

//------------------------------------------------------------
// Main time/date logic
//------------------------------------------------------------
always @(posedge Clk or negedge Reset_n)
begin
    if(!Reset_n)
    begin
        hour <= INIT_HOUR;
        minute <= INIT_MINUTE;
        second <= INIT_SECOND;

        year <= INIT_YEAR;
        month <= INIT_MONTH;
        day <= INIT_DAY;

        time_field <= 1'b0;
        date_field <= 2'd0;
    end
    else
    begin
        //----------------------------------------------------
        // 1. Time setting mode
        //----------------------------------------------------
        if(time_set_mode)
        begin
            // KEY1: select hour or minute
            if(key_select)
                time_field <= ~time_field;

            // KEY2: +1
            if(key_inc)
            begin
                if(time_field == 1'b0)
                begin
                    if(hour >= 5'd23)
                        hour <= 0;
                    else
                        hour <= hour + 1'b1;
                end
                else
                begin
                    if(minute >= 6'd59)
                        minute <= 0;
                    else
                        minute <= minute + 1'b1;
                end
            end

            // KEY3: -1
            if(key_dec)
            begin
                if(time_field == 1'b0)
                begin
                    if(hour == 0)
                        hour <= 5'd23;
                    else
                        hour <= hour - 1'b1;
                end
                else
                begin
                    if(minute == 0)
                        minute <= 6'd59;
                    else
                        minute <= minute - 1'b1;
                end
            end
        end

        //----------------------------------------------------
        // 2. Date setting mode
        //----------------------------------------------------
        else if(date_set_mode)
        begin
            // KEY1: year -> month -> day -> year
            if(key_select)
            begin
                if(date_field >= 2'd2)
                    date_field <= 2'd0;
                else
                    date_field <= date_field + 1'b1;
            end

            // KEY2: +1
            if(key_inc)
            begin
                case(date_field)

                    // Year +1
                    2'd0:
                    begin
                        if(year >= YEAR_MAX)
                        begin
                            year <= YEAR_MIN;

                            // If Feb 29 becomes invalid after changing year,
                            // clamp the day to the last valid day.
                            if(day > days_in_month(YEAR_MIN, month))
                                day <= days_in_month(YEAR_MIN, month);
                        end
                        else
                        begin
                            year <= year + 1'b1;

                            if(day > days_in_month(year + 1'b1, month))
                                day <= days_in_month(year + 1'b1, month);
                        end
                    end

                    // Month +1
                    2'd1:
                    begin
                        if(month >= 4'd12)
                        begin
                            month <= 4'd1;

                            if(day > days_in_month(year, 4'd1))
                                day <= days_in_month(year, 4'd1);
                        end
                        else
                        begin
                            month <= month + 1'b1;

                            if(day > days_in_month(year, month + 1'b1))
                                day <= days_in_month(year, month + 1'b1);
                        end
                    end

                    // Day +1
                    2'd2:
                    begin
                        if(day >= days_in_month(year, month))
                            day <= 6'd1;
                        else
                            day <= day + 1'b1;
                    end

                    default:
                        date_field <= 2'd0;

                endcase
            end

            // KEY3: -1
            if(key_dec)
            begin
                case(date_field)

                    // Year -1
                    2'd0:
                    begin
                        if(year <= YEAR_MIN)
                        begin
                            year <= YEAR_MAX;

                            if(day > days_in_month(YEAR_MAX, month))
                                day <= days_in_month(YEAR_MAX, month);
                        end
                        else
                        begin
                            year <= year - 1'b1;

                            if(day > days_in_month(year - 1'b1, month))
                                day <= days_in_month(year - 1'b1, month);
                        end
                    end

                    // Month -1
                    2'd1:
                    begin
                        if(month <= 4'd1)
                        begin
                            month <= 4'd12;

                            if(day > days_in_month(year, 4'd12))
                                day <= days_in_month(year, 4'd12);
                        end
                        else
                        begin
                            month <= month - 1'b1;

                            if(day > days_in_month(year, month - 1'b1))
                                day <= days_in_month(year, month - 1'b1);
                        end
                    end

                    // Day -1
                    2'd2:
                    begin
                        if(day <= 6'd1)
                            day <= days_in_month(year, month);
                        else
                            day <= day - 1'b1;
                    end

                    default:
                        date_field <= 2'd0;

                endcase
            end
        end

        //----------------------------------------------------
        // 3. Normal clock running
        //----------------------------------------------------
        else if(tick_1s)
        begin
            if(second >= 6'd59)
            begin
                second <= 0;

                if(minute >= 6'd59)
                begin
                    minute <= 0;

                    if(hour >= 5'd23)
                    begin
                        hour <= 0;

                        // New day
                        if(day >= days_in_month(year, month))
                        begin
                            day <= 6'd1;

                            if(month >= 4'd12)
                            begin
                                month <= 4'd1;

                                if(year >= YEAR_MAX)
                                    year <= YEAR_MIN;
                                else
                                    year <= year + 1'b1;
                            end
                            else
                            begin
                                month <= month + 1'b1;
                            end
                        end
                        else
                        begin
                            day <= day + 1'b1;
                        end
                    end
                    else
                    begin
                        hour <= hour + 1'b1;
                    end
                end
                else
                begin
                    minute <= minute + 1'b1;
                end
            end
            else
            begin
                second <= second + 1'b1;
            end
        end
    end
end

endmodule
