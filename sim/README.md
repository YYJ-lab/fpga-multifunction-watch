# sim

这里存放 Testbench 和仿真辅助文件，不综合到 FPGA。

## 当前 Testbench

```text
tick_gen_tb.v        测试 tick_1s / tick_10ms / blink_1hz
key_filter_tb.v      测试按键抖动只产生一次有效事件
LED_disp_tb.v        测试 8 位扫描、段码、空白位和小数点
datetime_core_tb.v   测试时间/日期核心、闰年和设置事件
basic_watch_tb.v     联合测试 tick_gen -> datetime_core
```

## 推荐运行顺序

```text
1. tick_gen_tb
2. key_filter_tb
3. LED_disp_tb
4. datetime_core_tb
5. basic_watch_tb
```

每次在 Vivado 的 Simulation Sources 中将对应 Testbench 设为 Top，然后运行 Behavioral Simulation。

完整预期波形和通过标准见：`../docs/TESTING.md`。

## 后续原则

- 每个核心模块先有独立 Testbench；
- 再做模块间联合 Testbench；
- 最后建立系统级 `watch_top_tb.v`；
- 重点验证边界：进位、跨日、跨月、闰年、闹钟二次提醒、倒计时结束和按键单次事件。
