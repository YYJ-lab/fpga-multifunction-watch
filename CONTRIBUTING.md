# CONTRIBUTING

本仓库用于两人课程项目协作，流程尽量简单，但要保证代码不会互相覆盖、AI 不会各自重构一套方案。

## 1. 分支

```text
main
  只放已经通过对应验证的版本

feature/*
  功能开发分支
```

当前示例：

```text
feature/base-modules
feature/datetime
feature/alarm-countdown
```

开始新任务前先从最新稳定基线创建分支。

## 2. 每次开始工作

1. `git pull` 获取最新代码；
2. 阅读 `README.md`；
3. 阅读 `docs/REQUIREMENTS.md`；
4. 阅读 `docs/DECISIONS.md`；
5. 阅读 `docs/INTERFACES.md`；
6. 阅读 `docs/STATUS.md` 和 `docs/AI_HANDOFF.md`；
7. 确认自己本次修改范围后再开始。

## 3. 每次完成工作

1. 先运行最小相关 Testbench；
2. 再运行必要的联合 Testbench；
3. 更新 `docs/STATUS.md`；
4. 更新 `docs/AI_HANDOFF.md`；
5. 提交到自己的 feature 分支；
6. 用 Pull Request 合并，不直接覆盖 `main`。

## 4. Commit 建议

```text
feat: add datetime core
fix: correct leap-year rollover
test: add alarm state simulation
docs: update module interfaces
```

避免：

```text
update
final
final2
test123
```

## 5. AI 协作

给任何 AI 的第一条项目指令建议包含：

> 先阅读 README、REQUIREMENTS、DECISIONS、ARCHITECTURE、INTERFACES、STATUS 和 AI_HANDOFF，再阅读本次任务相关源码。不要在未说明原因的情况下改变已有接口或模式编码。完成后更新 STATUS 与 AI_HANDOFF。

AI 生成代码后也必须经过成员本地 Vivado 验证，不能因为“代码看起来正确”就直接标记为完成。

## 6. Vivado 文件

仓库中的 `src/`、`sim/`、`constraints/` 是源码真实来源。

不要提交：

```text
.cache
.runs
.sim
.gen
.hw
.Xil
```

Vivado 自动生成结果不要作为两人协作的主要文件。
