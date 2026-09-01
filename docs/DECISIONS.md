# DECISIONS

这里记录已经确认或当前默认采用的全局设计决策。任何 AI/成员在修改这些决定前，都应先说明原因并同步更新本文件。

## D001 开发平台

- 开发板：HX7A75C；
- FPGA：Xilinx Artix-7 XC7A75T-2FGG484-2；
- 系统时钟：50 MHz；
- Vivado 作为综合、实现、生成 bitstream 与上板下载工具。

## D002 时间内部表示

- 内部统一使用 24 小时制；
- `hour` 范围 0~23；
- `minute`、`second` 范围 0~59；
- 12 小时制作为显示层扩展，不改变内部真实时间。

## D003 模式选择

当前方案：使用 4 个拨码开关作为 4-bit 模式编码。

建议编码：

```text
0000 时间显示
0001 日期显示
0010 时间设置
0011 日期设置
0100 闹钟1设置
0101 闹钟2设置
0110 闹钟3设置
0111 倒计时
1000 秒表（扩展）
1001 12/24小时显示设置（扩展）
1010~1111 预留
```

如后续实际操作发现更适合的编码，可修改，但必须统一更新显示控制、顶层和交接文档。

## D004 按键语义

当前统一交互方案：

```text
KEY1 选择当前字段/子功能
KEY2 +1 / 增加
KEY3 -1 / 减少
KEY4 确认 / 开始 / 暂停 / 解除提醒
```

具体模式可以对 KEY4 做语义复用，但 KEY1~KEY3 尽量保持一致，降低操作复杂度。

## D005 按键输入

- 所有机械按键必须先经过 `key_filter`；
- 功能模块优先使用单周期按下事件，而不是直接读取原始按键电平；
- 避免把按键作为时钟使用；
- HX7A75C 按键默认松开为高电平、按下为低电平。

## D006 时钟与计时

- FPGA 主逻辑只使用板载 50 MHz 时钟；
- 通过计数器生成 `tick_1s`、`tick_10ms` 等时钟使能事件；
- `tick_*` 不是新的时钟，不用于 `always @(posedge tick_*)`；
- 不用 `#delay` 实现真实硬件计时；
- `#delay` 只允许用于 Testbench。

## D007 数码管

- 复用课程中已经验证过的 8 位动态扫描思路；
- `display_ctrl` 决定“显示什么”，`LED_disp` 负责“怎么扫描显示”；
- `LED_disp` 当前统一接收：

```text
disp_data[31:0]
digit_en[7:0]
dp_data[7:0]
```

- HX7A75C 数码管段码低电平点亮；
- HX7A75C 位选 `SEL` 高电平有效；
- 若课程 PPT 示例与实际开发板极性不一致，以已核对的开发板硬件为准，并在代码中注明。

## D008 GitHub 工作流

- `main`：只保存已经通过对应验证的版本；
- 功能开发使用 `feature/*` 分支；
- 合并前优先通过 Pull Request；
- AI 不得在没有说明的情况下推翻既有接口；
- 每个阶段完成后更新 `AI_HANDOFF.md` 和 `STATUS.md`。

## D009 代码风格

- 优先使用课程 PPT 中已经出现过的 Verilog 写法；
- 时序逻辑使用 `always @(posedge Clk or negedge Reset_n)` 与非阻塞赋值 `<=`；
- 组合逻辑优先使用 `always @(*)` 与阻塞赋值 `=`；
- 状态机优先使用 `localparam + case`；
- 不无必要引入复杂 SystemVerilog 特性；
- 允许在 Testbench 中使用 `task`、`defparam`、`#delay` 等仿真辅助写法；
- 允许在 RTL 中用简单 `function` 封装重复组合判断，例如 `days_in_month`。

详细规范见 `CODE_STYLE.md`。

## D010 验证状态必须与代码状态分开

- “代码已经写好”不等于“Vivado 已验证”；
- 新 RTL 在成员本地完成对应 Behavioral Simulation 前保持在 feature 分支；
- `STATUS.md` 单独记录 RTL、独立仿真、联合仿真、综合和上板状态；
- 当前 `feature/base-modules` 的前两批代码属于“已写，等待本地仿真验证”；
- PR #1 暂时保持 Draft，五个前两批 Testbench 全部通过后再转为 Ready for Review。
