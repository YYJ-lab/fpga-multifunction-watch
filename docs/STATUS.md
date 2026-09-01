# STATUS

本文件只记录“做到哪一步”，避免把“代码已经写好”和“已经验证通过”混为一谈。

状态说明：

```text
✅ 已完成并验证
🟡 代码已写，等待验证或仅完成部分验证
⬜ 尚未开始
```

## 当前分支

开发分支：`feature/base-modules`

对应 PR：`#1 base timing, debounce, display and datetime modules`

前两批 Behavioral Simulation 已全部确认通过，当前分支已达到可评审状态；`main` 尚未合入，等待最终 review/merge 决策。

## 模块状态

| 模块 | RTL | 独立仿真 | 联合仿真 | 综合 | 上板 |
|---|---|---|---|---|---|
| `tick_gen` | ✅ | ✅ `tick_gen_tb` | ✅ `basic_watch_tb` | ⬜ | ⬜ |
| `key_filter` | ✅ | ✅ `key_filter_tb` | ⬜ | ⬜ | ⬜ |
| `LED_disp` | ✅ | ✅ `LED_disp_tb` | ⬜ | ⬜ | ⬜ |
| `datetime_core` | ✅ | ✅ `datetime_core_tb` | ✅ `basic_watch_tb` | ⬜ | ⬜ |
| `alarm_core` | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| `countdown` | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| `stopwatch` | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| `display_ctrl` | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| `watch_top` | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |

## 当前 5 个 Testbench 状态

- [x] `tick_gen_tb`
  - `tick_1s` 周期性单周期脉冲正确；
  - `tick_10ms` 周期性单周期脉冲正确；
  - `blink_1hz` 周期翻转正确。
- [x] `key_filter_tb`
  - 按下抖动只产生一次 `Key_P_Flag`；
  - 松开抖动只产生一次 `Key_R_Flag`；
  - `Key_state` 在稳定按下/松开后正确改变。
- [x] `LED_disp_tb`
  - `SEL=01→02→04→08→10→20→40→80` 循环扫描正确；
  - 数字段码与 `dp_data` 小数点控制符合预期；
  - `digit_en` 从 `8'hFF` 变为 `8'hEB` 后，被禁用扫描位输出 `LUT=8'hFF`，blanking 功能确认正确。
- [x] `datetime_core_tb`
  - 已观察 `2024-02-28 23:59:58 → 23:59:59 → 2024-02-29 00:00:00`；
  - 已观察将年份从 2024 减到 2023 时 `02-29` 自动修正为 `02-28`；
  - 时间/日期字段选择和加减事件波形符合 testbench 设计。
- [x] `basic_watch_tb`
  - 已观察 `2026-12-31 23:59:58 → 23:59:59 → 2027-01-01 00:00:00`；
  - 跨年后秒继续正常递增。

## 前两批完成判定

前两批 Behavioral Simulation 已全部通过。

下一阶段进入：

1. `alarm_core.v`
2. `countdown.v`
3. `stopwatch.v`
4. 对应独立 Testbench

随后再进入 `display_ctrl.v`、`watch_top.v` 和上板联调。
