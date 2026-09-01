# TASKS

## 当前原则

`[x]` 只表示该具体任务已经完成；“代码已写”和“Vivado 已验证”分开记录。当前前两批 RTL 已写入 `feature/base-modules`，但本地 Behavioral Simulation 仍待完成。

## 总体阶段

### Phase 0 — 仓库与接口
- [x] 建立 GitHub 仓库
- [x] 建立需求、架构、决策与 AI 交接文档
- [x] 增加接口文档、代码规范、测试规范和状态矩阵
- [ ] 确认两名成员的 GitHub 协作者权限
- [ ] 最终确认完整按键/开关交互方案

### Phase 1 — 基础时钟
- [x] `tick_gen.v`
- [x] `tick_gen_tb.v`
- [ ] Vivado 验证 `tick_1s` 单周期事件
- [ ] Vivado 验证 `tick_10ms`
- [ ] Vivado 验证 `blink_1hz`

### Phase 2 — 时间核心
- [x] `datetime_core.v`：时/分/秒
- [x] `datetime_core_tb.v`
- [ ] 验证 59 秒进位
- [ ] 验证 59 分进位
- [ ] 验证 23:59:59 → 00:00:00

### Phase 3 — 日期核心
- [x] 年/月/日逻辑
- [x] 大小月判断
- [x] 闰年判断
- [x] 日期设置时非法日期自动修正逻辑
- [x] `basic_watch_tb.v` 联合测试代码
- [ ] 验证 2024-02-28 → 2024-02-29
- [ ] 验证平年 2 月
- [ ] 验证 30/31 天月份
- [ ] 验证 12 月 31 日跨年
- [ ] 验证 `tick_gen -> datetime_core` 联合仿真

### Phase 4 — 人机操作与显示
- [x] `key_filter.v` 基础消抖模块
- [x] `key_filter_tb.v`
- [x] `LED_disp.v` 基础动态扫描模块
- [x] `LED_disp_tb.v`
- [ ] Vivado 验证按键消抖波形
- [ ] Vivado 验证数码管扫描/段码/位选
- [ ] 4 个按键实例化接入
- [ ] 4-bit 模式选择
- [x] `datetime_core` 已预留时间设置事件接口
- [x] `datetime_core` 已预留日期设置事件接口
- [ ] `display_ctrl.v`
- [ ] `watch_top.v`
- [ ] FPGA 上板显示时间

### Phase 5 — 三个闹钟
- [ ] 冻结 `alarm_core` 接口
- [ ] 三组闹钟寄存器
- [ ] 独立启用状态
- [ ] 第一次提醒 5 s
- [ ] 10 s 等待
- [ ] 第二次提醒 5 s
- [ ] 手动解除
- [ ] LED 展示
- [ ] 独立 Testbench

### Phase 6 — 倒计时
- [ ] 冻结 `countdown` 接口
- [ ] 设置起始时间
- [ ] 开始 / 暂停 / 继续或重启
- [ ] 00:00 结束
- [ ] LED 闪烁 5 s
- [ ] 独立 Testbench

### Phase 7 — 扩展功能
- [ ] 秒表
- [ ] 12 / 24 小时制
- [ ] 三个闹钟独立启停
- [ ] 设置字段闪烁
- [ ] 时间分隔符闪烁
- [ ] 若时间允许：星期计算

### Phase 8 — 总体验收
- [ ] 系统级 `watch_top_tb.v`
- [ ] 综合通过
- [ ] Implementation 通过
- [ ] Bitstream 生成
- [ ] 全功能上板演示
- [ ] 两名成员互相讲解核心代码
- [ ] 整理验收演示顺序

## 当前最近任务

按照 `docs/TESTING.md` 在本地 Vivado 依次运行：

1. `tick_gen_tb`
2. `key_filter_tb`
3. `LED_disp_tb`
4. `datetime_core_tb`
5. `basic_watch_tb`

全部通过后，再进入闹钟/倒计时/显示控制的下一批开发。

## 两人分工建议

在两名成员确认后，把“成员A / 成员B”替换成真实 GitHub 用户名。

### 成员 A
- `tick_gen`
- `datetime_core`
- 日期 / 闰年
- 对应 Testbench

### 成员 B
- `alarm_core`
- `countdown`
- `stopwatch`
- 对应 Testbench

### 共同完成
- 顶层 `watch_top`
- `display_ctrl`
- 开关/按键操作规则
- XDC
- 系统级仿真
- FPGA 上板联调

> 分工不是知识隔离。最终两名成员都应能解释各核心模块。
