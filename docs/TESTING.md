# TESTING

本文件用于统一两名成员在本地 Vivado 中的测试方法。当前阶段先做 Behavioral Simulation，不把未验证 RTL 直接合入 `main`。

## 1. 新建 Vivado 工程

当前仓库保存的是源码和项目资料，不是一个可以直接用 `Open Project` 打开的 `.xpr` 工程。

在 Vivado 中：

```text
Create Project
-> RTL Project
-> 选择器件 xc7a75tfgg484-2
```

工程名建议：

```text
fpga_multifunction_watch
```

以后真正的 Vivado 工程文件扩展名是 `.xpr`。`README.md`、`.v` 等文件不能作为 Vivado Project 直接打开。

## 2. 加入 Design Sources

当前将以下文件加入 **Design Sources**：

```text
src/tick_gen.v
src/key_filter.v
src/LED_disp.v
src/datetime_core.v
```

这些文件是可综合 RTL。

## 3. 加入 Simulation Sources

将以下文件加入 **Simulation Sources**：

```text
sim/tick_gen_tb.v
sim/key_filter_tb.v
sim/LED_disp_tb.v
sim/datetime_core_tb.v
sim/basic_watch_tb.v
```

Testbench 只用于仿真，不进入最终 FPGA 硬件。

## 4. 推荐测试顺序

### 4.1 `tick_gen_tb`

设置为 Simulation Top 后运行：

```text
Run Simulation
-> Run Behavioral Simulation
-> Run All
```

重点观察：

```text
Clk
Reset_n
tick_1s
tick_10ms
blink_1hz
```

预期：

- `tick_1s` 每次只拉高一个 `Clk` 周期；
- `tick_10ms` 每次只拉高一个 `Clk` 周期；
- `blink_1hz` 周期性 0/1 翻转。

Testbench 使用缩短后的 parameter，因此仿真不会真的等待 1 s。

### 4.2 `key_filter_tb`

重点观察：

```text
Key
Key_P_Flag
Key_R_Flag
Key_state
```

虽然 `Key` 被故意制造多次抖动，但最终应只产生：

- 一次有效按下 `Key_P_Flag`；
- 一次有效释放 `Key_R_Flag`。

### 4.3 `LED_disp_tb`

重点观察：

```text
SEL
LUT
disp_data
digit_en
dp_data
```

预期：

- `SEL` 依次扫描 8 个 one-hot 位；
- `LUT` 随当前数字变化；
- `digit_en=0` 的扫描位置输出全灭；
- `dp_data=1` 的对应位置小数点点亮。

### 4.4 `datetime_core_tb`

建议将年月日、时分秒的 Radix 设成 `Unsigned Decimal`。

第一段应出现：

```text
2024-02-28 23:59:58
-> 2024-02-28 23:59:59
-> 2024-02-29 00:00:00
```

随后测试：

```text
2024-02-29
-> 年份 -1
2023-02-28
```

用于验证从闰年切换到平年时，非法的 2 月 29 日会自动修正。

### 4.5 `basic_watch_tb`

这是当前前两批的联合测试：

```text
tick_gen -> datetime_core
```

预期：

```text
2026-12-31 23:59:58
-> 2026-12-31 23:59:59
-> 2027-01-01 00:00:00
```

## 5. 当前阶段的通过标准

前两批只有在以下项目全部通过后，才能把 Draft PR 合入 `main`：

- [ ] `tick_gen_tb` 通过；
- [ ] `key_filter_tb` 通过；
- [ ] `LED_disp_tb` 通过；
- [ ] `datetime_core_tb` 通过；
- [ ] `basic_watch_tb` 通过；
- [ ] Vivado 无编译 Error；
- [ ] 波形与预期边界一致。

当前还没有完整 `watch_top`、XDC、闹钟、倒计时和秒表，因此不要求上板。

## 6. 报错处理规则

如果仿真失败：

1. 先记录 Vivado 最前面的第一条 Error；
2. 不要一次修改多个模块；
3. 优先确认 Simulation Top、Source 类型和模块接口；
4. 再检查 RTL；
5. 修复后重新跑对应最小 Testbench；
6. 通过后再跑 `basic_watch_tb` 或后续系统级 Testbench。
