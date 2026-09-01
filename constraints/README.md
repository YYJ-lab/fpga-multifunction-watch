# constraints

这里存放 HX7A75C 开发板的 XDC 约束文件。

最终建议使用：`watch.xdc`

约束内容至少包括：

- 50 MHz `Clk`；
- 4 个按键；
- 4 个拨码开关；
- LED 输出；
- 8 位数码管 `LUT[7:0]`；
- 8 位位选 `SEL[7:0]`；
- 对应 `IOSTANDARD` 与时钟约束。

所有管脚均应按 HX7A75C 开发板手册核对后填写，不根据猜测分配。
