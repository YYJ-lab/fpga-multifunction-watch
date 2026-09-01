# vivado

本目录用于保存必要的 Vivado 工程说明或可重建工程的配置。

建议：

- 不提交 `.cache`、`.runs`、`.sim`、`.gen`、`.hw` 等自动生成目录；
- 如需要共享 `.xpr`，确保源码仍以仓库根目录的 `src/`、`sim/`、`constraints/` 为唯一真实版本；
- 后期可增加 `create_project.tcl`，用于一键重建 Vivado 工程。
