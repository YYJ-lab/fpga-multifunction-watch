# AI_HANDOFF

> 这是成员与 AI 之间的共享交接文件。每次完成一个可验证阶段后更新。

## 当前项目状态

更新时间：2026-09-01

分支：`feature/base-modules`

PR：`#1 base timing, debounce, display and datetime modules`

### 已写入仓库并完成本地 Vivado Behavioral Simulation

RTL：

- `src/tick_gen.v`
- `src/key_filter.v`
- `src/LED_disp.v`
- `src/datetime_core.v`

Testbench：

- `sim/tick_gen_tb.v`
- `sim/key_filter_tb.v`
- `sim/LED_disp_tb.v`
- `sim/datetime_core_tb.v`
- `sim/basic_watch_tb.v`

### 验证结果

5 个 Behavioral Simulation 均已由成员本地 Vivado 运行并确认：

1. `tick_gen_tb`：通过；
2. `key_filter_tb`：通过；
3. `LED_disp_tb`：通过；
4. `datetime_core_tb`：通过；
5. `basic_watch_tb`：通过。

关键确认：

```text
2024-02-28 23:59:58
-> 2024-02-28 23:59:59
-> 2024-02-29 00:00:00
```

```text
2026-12-31 23:59:58
-> 2026-12-31 23:59:59
-> 2027-01-01 00:00:00
```

`LED_disp_tb` 中还确认：

```text
digit_en: FF -> EB
```

扫描到禁用位时 `LUT=FF`，说明 blanking 功能正确。

### 当前默认设计

- 开发板：HX7A75C；
- FPGA：XC7A75T-2FGG484-2；
- 系统时钟：50 MHz；
- 内部时间使用 24 小时制；
- 4 个开关采用 4-bit 模式编码；
- 4 个按键采用“字段选择 / +1 / -1 / 确认或开始暂停”的统一语义；
- 所有物理按键先进行消抖；
- 数码管显示与时间核心逻辑分离；
- `tick_*` 是单周期使能事件，不作为新时钟；
- 代码优先采用课程 PPT 中熟悉的 Verilog 写法。

### 当前关键接口

请优先阅读 `docs/INTERFACES.md`。当前已固定：

```text
tick_gen -> tick_1s / tick_10ms / blink_1hz
key_filter -> Key_P_Flag / Key_R_Flag / Key_state
datetime_core -> hour/minute/second/year/month/day/time_field/date_field
LED_disp <- disp_data/digit_en/dp_data -> LUT/SEL
```

### 当前已知设计行为

`datetime_core`：

- 设置模式期间正常时钟推进暂停；
- 时间设置当前只选择小时/分钟；
- 日期设置选择年/月/日；
- 修改年份或月份后，如果当前日期在目标年月非法，会自动修正到该月最大合法日期；
- 目前重新进入设置模式时会保留上一次 `time_field/date_field` 选择；
- 修改时/分不会自动把秒清零。

最后两点不是当前错误，后续 UI 阶段再决定是否调整。

## 下一步

进入第三批功能开发：

1. `alarm_core.v` + `alarm_core_tb.v`
2. `countdown.v` + `countdown_tb.v`
3. `stopwatch.v` + `stopwatch_tb.v`

原则：先冻结接口，再写 RTL，再做独立仿真，不直接堆到 `watch_top.v`。

第三批完成后进入：

- `display_ctrl.v`
- `watch_top.v`
- XDC
- 系统级仿真与上板

## AI 开始工作前必须执行

1. 阅读 `README.md`；
2. 阅读 `docs/REQUIREMENTS.md`；
3. 阅读 `docs/DECISIONS.md`；
4. 阅读 `docs/ARCHITECTURE.md`；
5. 阅读 `docs/INTERFACES.md`；
6. 阅读 `docs/STATUS.md`；
7. 阅读本文件；
8. 阅读本次任务涉及的现有源码；
9. 先总结当前接口和任务边界，再进行修改。

## AI 修改规则

- 不得无理由改变课程要求；
- 不得偷偷改变已确定的模块接口或模式编码；
- 若必须修改接口，先更新 `INTERFACES.md`，涉及全局设计时同步更新 `DECISIONS.md`；
- 新功能优先单独模块化，不把全部逻辑塞进 `watch_top.v`；
- 每次提交应说明“改了什么、为什么、如何验证”；
- 仿真未通过的代码不要当作稳定版本合入 `main`；
- 不修改 Vivado 自动生成文件；
- 代码以易懂、可解释为优先，不无必要使用超出课程范围的复杂写法。

## 每次交接更新模板

```text
日期：
成员/AI：
分支：

本次完成：
- 

修改文件：
- 

验证结果：
- 

关键接口/决策变化：
- 无 / ...

已知问题：
- 无 / ...

下一步：
- 
```
