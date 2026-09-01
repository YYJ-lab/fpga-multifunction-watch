# src

这里仅放最终可综合到 FPGA 的 Verilog 设计源码。

## 当前已经写入

```text
tick_gen.v       时基事件：1 s / 10 ms / 1 Hz blink
key_filter.v     机械按键四状态消抖
LED_disp.v       8 位数码管动态扫描
datetime_core.v  时分秒 + 年月日 + 闰年/大小月 + 设置接口
```

当前代码状态以 `../docs/STATUS.md` 为准；“文件存在”不代表已经完成 Vivado 验证。

## 后续计划

```text
alarm_core.v
downcount.v / countdown.v
stopwatch.v
display_ctrl.v
watch_top.v
```

正式新增模块前，先在 `../docs/INTERFACES.md` 中确定接口名称和位宽。

## 规则

- 不把 Testbench 放进本目录；
- 不放 Vivado 自动生成文件或临时备份；
- 时序逻辑优先使用课程 PPT 中熟悉的写法；
- 具体代码规范见 `../docs/CODE_STYLE.md`。
