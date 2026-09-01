# INTERFACES

本文件记录已经写入代码的模块接口。两个成员或 AI 在继续开发前，应优先以这里和实际 RTL 为准，避免出现同一信号使用不同名称、位宽或含义的问题。

## 1. 全局约定

- 主时钟：`Clk`，50 MHz；
- 复位：`Reset_n`，低电平有效；
- 时序逻辑尽量只使用 `Clk` 这一主时钟；
- `tick_*` 是单周期时钟使能事件，不作为新的时钟使用；
- 机械按键先经过 `key_filter`，功能模块只接收消抖后的事件；
- 当前内部时间统一使用 24 小时制；
- 数码管数据与动态扫描分离。

---

## 2. `tick_gen`

文件：`src/tick_gen.v`

### 输入

```text
Clk       1 bit   50 MHz 系统时钟
Reset_n   1 bit   低有效复位
```

### 输出

```text
tick_1s    1 bit   每 1 s 拉高一个 Clk 周期
tick_10ms  1 bit   每 10 ms 拉高一个 Clk 周期
blink_1hz  1 bit   每 0.5 s 翻转一次，完整闪烁周期为 1 s
```

### 可调参数

```text
MCNT_1S
MCNT_10MS
MCNT_BLINK
```

真实硬件使用 50 MHz 对应的默认值；Testbench 可以用 `defparam` 缩短计数周期。

---

## 3. `key_filter`

文件：`src/key_filter.v`

### 输入

```text
Clk       1 bit
Reset_n   1 bit
Key       1 bit   原始机械按键，松开=1，按下=0
```

### 输出

```text
Key_P_Flag   1 bit   确认一次有效按下后，高一个 Clk 周期
Key_R_Flag   1 bit   确认一次有效释放后，高一个 Clk 周期
Key_state    1 bit   消抖后的稳定状态，松开=1，按下=0
```

### 可调参数

```text
MCNT = 1000000
```

50 MHz 下对应约 20 ms 消抖时间。

---

## 4. `LED_disp`

文件：`src/LED_disp.v`

### 输入

```text
disp_data  [31:0]   8 个 4-bit 数字
 digit_en   [7:0]   每位显示使能，1=显示，0=熄灭
 dp_data    [7:0]   每位小数点使能，1=点亮小数点
 Clk         1 bit
 Reset_n     1 bit
```

### 输出

```text
LUT  [7:0]   段码，顺序 a b c d e f g dp，低电平点亮
SEL  [7:0]   位选，HX7A75C 上高电平有效
```

### `disp_data` 与扫描位置

```text
cnt=0 -> disp_data[3:0]
cnt=1 -> disp_data[7:4]
...
cnt=7 -> disp_data[31:28]
```

因此写 `32'h12345678` 时，扫描位置 0 首先取得数字 8。

`4'hF` 在本项目中保留为空白显示值。

---

## 5. `datetime_core`

文件：`src/datetime_core.v`

### 输入

```text
Clk             1 bit
Reset_n         1 bit
tick_1s         1 bit   单周期 1 s 事件

time_set_mode   1 bit   时间设置模式
date_set_mode   1 bit   日期设置模式
key_select      1 bit   已消抖单周期事件
key_inc         1 bit   已消抖单周期事件
key_dec         1 bit   已消抖单周期事件
```

### 输出

```text
hour        [4:0]    0~23
minute      [5:0]    0~59
second      [5:0]    0~59
year       [15:0]    当前年份
month       [3:0]    1~12
day         [5:0]    1~28/29/30/31

time_field   1 bit   0=hour，1=minute
date_field  [1:0]    0=year，1=month，2=day
```

### 当前设置行为

时间设置模式：

```text
KEY1事件 -> hour / minute 切换
KEY2事件 -> 当前字段 +1
KEY3事件 -> 当前字段 -1
```

日期设置模式：

```text
KEY1事件 -> year -> month -> day -> year
KEY2事件 -> 当前字段 +1
KEY3事件 -> 当前字段 -1
```

设置模式期间正常时间推进暂停。

---

## 6. 计划模块

以下模块还未实现，接口暂未冻结：

```text
alarm_core
countdown
stopwatch
display_ctrl
watch_top
```

开始写这些模块前，应先在本文件补充接口，再写 RTL。不要让两个分支分别自行定义不同接口。
