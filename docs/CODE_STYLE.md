# CODE_STYLE

本项目优先保证代码清晰、可解释，并尽量沿用课程 PPT 中已经出现过的 Verilog 写法。

## 1. 基本原则

1. 优先使用课程中已经学过的写法；
2. 不为“代码短”而使用难解释的高级语法；
3. 一个模块只负责一类主要功能；
4. 关键状态、边界判断和接口必须有必要注释；
5. Testbench 可以使用仿真辅助语法，但要明确它不会综合到 FPGA。

## 2. 时序逻辑

优先使用课程常见格式：

```verilog
always @(posedge Clk or negedge Reset_n)
begin
    if(!Reset_n)
        q <= 0;
    else
        q <= d;
end
```

要求：

- 时序寄存器使用非阻塞赋值 `<=`；
- 不把按键当时钟；
- 不人为产生多个逻辑时钟；
- 统一使用 50 MHz `Clk`，通过 `tick_*` 作为时钟使能事件。

## 3. 组合逻辑

优先：

```verilog
always @(*)
begin
    ...
end
```

组合逻辑中使用阻塞赋值 `=`，并保证所有分支对输出有明确赋值，避免无意产生 latch。

## 4. 状态机

状态少时使用课程里熟悉的 `localparam + case`：

```verilog
localparam s0 = 2'b00,
           s1 = 2'b01;

case(state)
    s0: ...
    s1: ...
endcase
```

闹钟提醒、倒计时等后续功能优先使用这种方式，不引入无必要的复杂 SystemVerilog FSM 写法。

## 5. 参数与仿真

真实硬件计数值使用 `parameter`，Testbench 可通过 `defparam` 缩短：

```verilog
parameter MCNT = 50000000;
```

Testbench：

```verilog
defparam uut.MCNT = 10;
```

这样同一份 RTL 可以在真实 FPGA 和快速仿真之间复用。

## 6. `#delay` 的使用

`#10`、`#100` 等延时只允许出现在 Testbench 中，例如产生仿真时钟：

```verilog
always #10 Clk = ~Clk;
```

实际 FPGA RTL 中不能用 `#delay` 实现真实计时。

## 7. `function` / `task`

- `function` 只用于简单、重复的组合计算，例如 `days_in_month`；
- `task` 当前只用于 Testbench 中产生重复测试事件；
- 如果普通 `if/case` 已经足够清楚，就不额外抽象。

## 8. 命名

当前约定：

```text
Clk / Reset_n          主时钟与低有效复位
tick_*                 单周期计时事件
*_mode                  工作模式
key_*                   已消抖按键事件
*_field                 当前选择字段
*_inst                  模块实例名后缀
*_tb                    Testbench 模块/文件后缀
```

## 9. 注释要求

必须解释“为什么”的地方：

- 计数值与真实时间的关系；
- 状态机每个状态的意义；
- 闰年/大小月边界；
- 数码管高低有效极性；
- 与课程 PPT 相同或因实际开发板而调整的地方；
- 任何可能在验收中被老师追问的特殊处理。

不需要给每一条简单赋值都写重复注释。
