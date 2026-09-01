# STATUS

本文件只记录“做到哪一步”，避免把“代码已经写好”和“已经验证通过”混为一谈。

状态说明：

```text
✅ 已完成并验证
🟡 代码已写，等待本地验证
⬜ 尚未开始
```

## 当前分支

开发分支：`feature/base-modules`

对应 Draft PR：`#1 WIP: base timing and datetime modules`

`main` 暂不合入这些 RTL，直到两名成员至少完成前两批 Behavioral Simulation。

## 模块状态

| 模块 | RTL | 独立仿真 | 联合仿真 | 综合 | 上板 |
|---|---|---|---|---|---|
| `tick_gen` | 🟡 | 🟡 `tick_gen_tb` | 🟡 `basic_watch_tb` | ⬜ | ⬜ |
| `key_filter` | 🟡 | 🟡 `key_filter_tb` | ⬜ | ⬜ | ⬜ |
| `LED_disp` | 🟡 | 🟡 `LED_disp_tb` | ⬜ | ⬜ | ⬜ |
| `datetime_core` | 🟡 | 🟡 `datetime_core_tb` | 🟡 `basic_watch_tb` | ⬜ | ⬜ |
| `alarm_core` | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| `countdown` | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| `stopwatch` | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| `display_ctrl` | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| `watch_top` | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |

> 表中的 🟡 代表代码/Testbench 已提交，但还不能声称 Vivado 已通过。成员本地验证后再改成 ✅。

## 当前必须验证的 5 个 Testbench

- [ ] `tick_gen_tb`
- [ ] `key_filter_tb`
- [ ] `LED_disp_tb`
- [ ] `datetime_core_tb`
- [ ] `basic_watch_tb`

## 前两批完成判定

只有五个测试都通过后，才把 Phase 1~3 标记为完成，并考虑将 Draft PR 转为 Ready for Review。
