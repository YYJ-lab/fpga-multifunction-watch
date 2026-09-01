# FPGA 多功能电子表

《数字系统课程设计》课程项目：基于 HX7A75C FPGA 开发板实现一个多功能数字电子表。

## 项目目标

完成课程规定的时间、日期、时间/日期设置、3 个闹钟和倒计时功能，并在此基础上加入适量扩展功能。项目强调：

- 代码可综合、可仿真、可上板验证；
- 模块职责清晰，便于两人协作；
- 关键逻辑能够在验收时自行解释；
- GitHub 作为代码、设计决策和 AI 交接的统一来源；
- Verilog 写法优先参考课程 PPT，不无必要引入复杂语法。

## 计划功能

### 课程必做

- 时间显示：00:00 ~ 23:59；
- 日期显示：年 / 月 / 日；
- 时间设置；
- 日期设置，支持大小月和闰年；
- 3 个闹钟；
- 闹钟到时 LED 闪烁 5 秒，可手动解除；未解除时暂停 10 秒后再提醒一次；
- 倒计时，可开始、暂停、继续/重新开始，到 00:00 后 LED 闪烁 5 秒；
- 只使用 4 个按键和 4 个开关完成全部操作。

### 计划扩展

- 秒表；
- 12 / 24 小时制切换；
- 3 个闹钟独立启用 / 禁用；
- 设置字段闪烁；
- 时间分隔符闪烁。

## 当前开发状态

当前正在 `feature/base-modules` 完成前两批基础 RTL：

```text
tick_gen
key_filter
LED_disp
datetime_core
```

以及 5 个 Testbench：

```text
tick_gen_tb
key_filter_tb
LED_disp_tb
datetime_core_tb
basic_watch_tb
```

代码已经写入开发分支，但仍需成员在本地 Vivado 完成 Behavioral Simulation。未验证代码暂不合入 `main`。

详细状态见：`docs/STATUS.md`。

## 仓库结构

```text
fpga-multifunction-watch/
├── src/                    # 可综合 Verilog 设计源码
├── sim/                    # Testbench
├── constraints/            # XDC 引脚与时钟约束
├── vivado/                 # Vivado 工程说明/必要配置
├── docs/
│   ├── REQUIREMENTS.md     # 课程要求与扩展范围
│   ├── ARCHITECTURE.md     # 模块结构
│   ├── INTERFACES.md       # 已冻结/当前接口
│   ├── DECISIONS.md        # 已确认设计决策
│   ├── CODE_STYLE.md       # 课程对齐的代码规范
│   ├── TESTING.md          # 本地 Vivado 测试步骤
│   ├── STATUS.md           # 模块验证状态
│   ├── TASKS.md            # 两人任务与进度
│   └── AI_HANDOFF.md       # AI/成员交接状态
├── .github/
│   └── pull_request_template.md
├── CONTRIBUTING.md
├── .gitignore
└── README.md
```

## 本地快速开始

仓库里的源码不是一个 `.xpr` Vivado 工程，不能直接用 `Open Project` 打开 `README.md`。

第一次在本地使用：

```text
Vivado
-> Create Project
-> RTL Project
-> Part: xc7a75tfgg484-2
```

然后：

**Design Sources** 加入：

```text
src/tick_gen.v
src/key_filter.v
src/LED_disp.v
src/datetime_core.v
```

**Simulation Sources** 加入：

```text
sim/tick_gen_tb.v
sim/key_filter_tb.v
sim/LED_disp_tb.v
sim/datetime_core_tb.v
sim/basic_watch_tb.v
```

完整测试顺序见 `docs/TESTING.md`。

## 协作规则

1. `main` 只保留已经验证过的版本；
2. 每项功能使用独立 `feature/*` 分支开发；
3. 修改接口或全局设计前先同步 `docs/INTERFACES.md` / `docs/DECISIONS.md`；
4. 每次完成一个可验证阶段后更新 `docs/STATUS.md` 与 `docs/AI_HANDOFF.md`；
5. 合并前至少完成对应仿真，重要阶段还需上板验证；
6. 不提交 Vivado 自动生成的缓存、运行结果和临时文件。

## AI 使用约定

每个 AI 在开始修改前，应先阅读：

```text
README.md
-> docs/REQUIREMENTS.md
-> docs/DECISIONS.md
-> docs/ARCHITECTURE.md
-> docs/INTERFACES.md
-> docs/STATUS.md
-> docs/AI_HANDOFF.md
```

然后只修改本次任务涉及的文件。若发现现有设计需要改变，应先说明原因并更新决策记录，避免两个 AI 各自重构一套方案。
