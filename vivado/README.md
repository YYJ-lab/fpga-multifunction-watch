# vivado

本目录用于保存必要的 Vivado 工程说明或后续可重建工程的配置。

## 1. 仓库源码不是 `.xpr` 工程

第一次在本地使用时，不要在 Vivado 中用 `Open Project` 打开：

```text
README.md
*.v
*.md
```

这些都不是 Vivado Project File。

正确做法：

```text
Vivado
-> Create Project
-> RTL Project
-> Part: xc7a75tfgg484-2
```

创建完成后 Vivado 会生成真正的：

```text
*.xpr
```

以后才可以通过 `Open Project` 打开该 `.xpr`。

## 2. 当前需要加入的源码

Design Sources：

```text
../src/tick_gen.v
../src/key_filter.v
../src/LED_disp.v
../src/datetime_core.v
```

Simulation Sources：

```text
../sim/tick_gen_tb.v
../sim/key_filter_tb.v
../sim/LED_disp_tb.v
../sim/datetime_core_tb.v
../sim/basic_watch_tb.v
```

详细测试顺序见 `../docs/TESTING.md`。

## 3. 仓库中的真实源码

无论每个人本地 Vivado 工程放在哪里，都规定：

```text
src/
sim/
constraints/
```

是 GitHub 中的源码真实来源。

不要让 Vivado 工程目录里的自动复制文件变成第二套不同版本。

## 4. 不提交的文件

不要提交：

```text
.cache
.runs
.sim
.gen
.hw
.Xil
*.jou
*.log
```

这些是 Vivado 自动生成结果或临时文件。

## 5. 后续计划

等最终顶层和 XDC 稳定后，可以增加：

```text
create_project.tcl
```

让两名成员能够一键从 `src/ + sim/ + constraints/` 重建 Vivado 工程，进一步减少本地路径差异。
