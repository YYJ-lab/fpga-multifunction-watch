# ARCHITECTURE

## 1. 总体结构

```text
50 MHz Clk
   │
   ├── tick_gen ─────────────→ tick_1s / tick_10ms / blink_1hz
   │
4 Keys ─→ key_filter ×4 ─────→ key events
   │
4 SWs ───────────────────────→ mode select
   │
   ├── datetime_core ────────→ hour/min/sec/year/month/day
   ├── alarm_core ───────────→ alarm state / LED request
   ├── countdown ────────────→ countdown time / done state
   ├── stopwatch ────────────→ stopwatch time
   │
   └── display_ctrl ─────────→ disp_data / digit_en / dp_data
                                  │
                                  ↓
                              LED_disp
                                  │
                                  ↓
                              LUT + SEL
```

最外层模块统一由 `watch_top.v` 完成连接。

当前已实现到 `tick_gen`、`key_filter`、`LED_disp`、`datetime_core`，其余模块后续继续完成。

## 2. 模块职责

### `tick_gen.v`
- 输入：50 MHz 系统时钟、复位；
- 输出：`tick_1s`、`tick_10ms`、`blink_1hz`；
- `tick_1s` 用于时钟/日期/闹钟/倒计时；
- `tick_10ms` 为秒表预留；
- `blink_1hz` 用于字段、分隔符和 LED 闪烁；
- 仿真时通过 parameter 缩短计数周期。

### `datetime_core.v`
- 保存当前时、分、秒、年、月、日；
- 完成正常时间推进；
- 处理 23:59:59 跨天；
- 识别 30/31 天月份、平年 2 月和闰年 2 月；
- 支持时间设置：小时 / 分钟；
- 支持日期设置：年 / 月 / 日；
- 当年份或月份变化导致当前日期非法时，自动修正到目标月份最大合法日期。

### `key_filter.v`
- 每个物理按键实例化一次；
- 采用课程 PPT 中的四状态消抖思路；
- 输出 `Key_P_Flag`、`Key_R_Flag` 与稳定 `Key_state`；
- 功能模块优先使用单周期 `Key_P_Flag`。

### `alarm_core.v`
- 尚未实现；
- 计划保存三个闹钟时间和启用状态；
- 比较当前时间与闹钟时间；
- 使用 FSM 实现第一次 5 秒提醒、10 秒等待、第二次 5 秒提醒；
- 输出 LED 提醒请求。

### `countdown.v`
- 尚未实现；
- 保存预设倒计时时间和当前剩余时间；
- 支持设置、开始、暂停、继续/重启；
- 到 00:00 后请求 LED 闪烁 5 秒。

### `stopwatch.v`
- 扩展模块，尚未实现；
- 使用 `tick_10ms`；
- 从 00:00.00 正向计时；
- 支持开始、暂停、继续和清零。

### `display_ctrl.v`
- 尚未实现；
- 根据工作模式选择当前显示内容；
- 输出统一的 `disp_data[31:0]`；
- 输出 `digit_en[7:0]` 控制每一位显示/熄灭；
- 输出 `dp_data[7:0]` 控制小数点；
- 后续负责字段闪烁、分隔符等界面逻辑；
- 不直接驱动具体数码管引脚。

### `LED_disp.v`
- 8 位数码管动态扫描；
- 输入 `disp_data[31:0]`、`digit_en[7:0]`、`dp_data[7:0]`；
- 输出 `LUT[7:0]` 与 `SEL[7:0]`；
- 0~9 段码和动态扫描思路优先复用课程实验实现；
- 根据 HX7A75C 实际硬件，段码低有效、位选 `SEL` 高有效。

### `watch_top.v`
- 尚未实现；
- 顶层模块只负责实例化和连接模块，不堆积大量功能逻辑；
- 顶层端口最终只保留开发板真实外部资源。

## 3. 当前关键数据流

前两批已经形成：

```text
50 MHz Clk
   ↓
tick_gen
   ↓ tick_1s
datetime_core
   ↓
hour / minute / second / year / month / day
```

独立的：

```text
Key
 ↓
key_filter
 ↓
单次按下/释放事件
```

以及：

```text
disp_data + digit_en + dp_data
 ↓
LED_disp
 ↓
LUT + SEL
```

后续 `display_ctrl` 会把 `datetime_core` 等各功能模块的数据转换成 `LED_disp` 的统一输入。

## 4. 设计原则

1. 一个模块只承担一类主要职责；
2. 各功能通过事件/状态接口连接，不跨模块直接操作内部寄存器；
3. 内部统一以 24 小时制保存时间，12 小时制仅作为显示层转换；
4. 时间推进由单一 50 MHz 时钟域完成，`tick_*` 仅作为使能事件；
5. 功能模块先单独仿真，再做联合仿真，再接入 `watch_top`；
6. 修改模块接口时同步更新 `INTERFACES.md` 和 `DECISIONS.md`；
7. 代码优先清晰易懂，并尽量沿用课程 PPT 中出现过的写法。

## 5. 建议验证边界

- `tick_1s` / `tick_10ms` 每次只高一个 Clk 周期；
- 按键抖动只产生一次有效事件；
- 数码管 8 位扫描与高低有效极性；
- 12:34:59 → 12:35:00；
- 23:59:59 → 00:00:00 并日期 +1；
- 30 天月、31 天月切换；
- 平年 2 月与闰年 2 月；
- 12 月 31 日跨年；
- 闹钟第一次提醒 / 手动解除 / 二次提醒；
- 倒计时 00:01 → 00:00。

详细当前 Testbench 流程见 `TESTING.md`。
