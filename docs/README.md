# 项目文档索引

如果是第一次进入仓库，建议按下面顺序阅读：

1. `../README.md` — 项目总体说明与快速开始
2. `REQUIREMENTS.md` — 老师硬性要求和扩展功能
3. `DECISIONS.md` — 已经确定的全局设计
4. `ARCHITECTURE.md` — 系统模块结构与数据流
5. `INTERFACES.md` — 当前模块端口、位宽与信号含义
6. `CODE_STYLE.md` — Verilog 代码规范与课程 PPT 对齐原则
7. `STATUS.md` — 哪些只是“写了”、哪些已经“验证通过”
8. `TESTING.md` — 本地 Vivado 测试方法
9. `TASKS.md` — 阶段任务和两人分工
10. `AI_HANDOFF.md` — 当前交接信息，AI 开始工作前必须阅读

## 使用场景

### 要继续写代码

重点读：

```text
REQUIREMENTS
DECISIONS
ARCHITECTURE
INTERFACES
STATUS
AI_HANDOFF
```

### 要在 Vivado 测试

重点读：

```text
TESTING
STATUS
../vivado/README.md
```

### 要让另一个 AI 接着做

将下面要求作为开头：

> 先阅读 README、REQUIREMENTS、DECISIONS、ARCHITECTURE、INTERFACES、STATUS 和 AI_HANDOFF，再读取本次任务相关源码。不要未经说明改变已有接口。完成后更新 STATUS 与 AI_HANDOFF。
