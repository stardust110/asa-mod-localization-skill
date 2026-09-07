# ASA Mod Localization Skill

[English](#english) | [简体中文](#简体中文)

## 简体中文

一个遵循开放 Agent Skills 格式的《方舟：生存飞升》（ARK: Survival Ascended，ASA）模组汉化 skill。它将模组文本清点、ASA 术语核对、普通版和双语版底包适配、打包校验与问题回归整理为可复用流程，供支持 `SKILL.md` 的 Agent 工具使用。

### 功能

- 从模组压缩包或已解包目录清点玩家可见文本，并与更新包比较。
- 根据项目提供的 ASA 术语表与上下文翻译生物、物品、印痕、描述、Buff、HUD 和书籍文本。
- 修复截图中发现的漏译、中文英文混排、间距不一致、句子被拆分翻译等问题，并检查同类文本。
- 分别构建普通汉化与双语汉化：普通版使用官方普通底包，双语版使用官方双语底包，避免原版内容缺少双语。
- 校验 ZIP CRC、官方底包哈希、覆盖层、安装说明和 `SHA256SUMS.txt`。

### 适用范围与限制

- 不依赖 GitHub、账号、固定盘符、游戏安装路径或特定模组作者。
- 不会把压缩包结构校验当作游戏内显示完全正确的证明。
- 不会将未经确认的专有名词直接固化为 ASA 标准译名。
- 没有官方双语底包时，只会制作普通版，不会伪造原版双语文本。

### 安装

这是一个标准 skill 文件夹。将整个仓库克隆或复制到所用 Agent 的 skill 目录，并保持文件夹名为 `asa-mod-localization-release`。常见位置示例：

| 工具 | 个人级目录 | 项目级目录 |
| --- | --- | --- |
| Codex | `~/.codex/skills/` | 工具支持时使用项目配置目录 |
| Claude Code | `~/.claude/skills/` | `.claude/skills/` |
| Cursor | 由 Cursor 的 Skills 设置指定 | `.cursor/skills/` |
| DeepSeek Harness / DSH Desktop | DSH 配置的 user skills 根目录 | `.dsh/skills/` 或 `.agents/skills/` |

例如：

```powershell
git clone https://github.com/stardust110/asa-mod-localization-skill `
  "$env:USERPROFILE\.codex\skills\asa-mod-localization-release"
```

安装后重启 Agent 或开始新任务，再描述 ASA 模组汉化需求；支持显式调用的客户端可使用 skill 名称 `asa-mod-localization-release`。

#### DeepSeek Harness / DSH Desktop

DeepSeek Harness 原生识别 `SKILL.md`。在任一 DSH 项目根目录执行：

```powershell
git clone https://github.com/stardust110/asa-mod-localization-skill `
  .dsh/skills/asa-mod-localization-release
```

也可放入 `.agents/skills/asa-mod-localization-release`。DSH 会把项目级 skills 加入目录；不需要转换为 DSH 插件。

### 使用

按需求提供以下内容：

1. 模组压缩包或已解包目录。
2. 普通版所需的官方普通底包三件套：`.pak`、`.ucas`、`.utoc`。
3. 双语版所需的官方双语底包三件套。
4. 可选：术语表、既有补丁、截图、历史翻译映射。

skill 会在用户选择的工作区中隔离 `source`、`inventory`、`translations`、`build` 和 `output`，输出安装包、校验文件、安装说明与审计摘要。普通版和双语版必须二选一安装。

### 没有解包工具时

不需要预先安装全部工具。skill 会先检测 ZIP 校验、Unreal IoStore 解包、locres 转换、封包和 SHA-256 哈希能力；缺少时会说明缺失的具体能力与兼容工具类别。下载、安装、更新工具或修改 PATH 前必须征得用户同意，并优先使用工作区内的便携式工具。

没有解包器时，仍可整理截图、术语与翻译映射；但不会声称已完成覆盖审计或生成可安装补丁。没有封包器时，可完成翻译映射并标记构建受阻，待工具就绪后复用。

仓库不上传从个人电脑复制来的二进制工具。Windows 用户可在确认后运行 `scripts/bootstrap-retoc.ps1 -InstallRetoc`，从 `retoc` 官方 v0.1.5 发布页下载到工作区；脚本默认只检测。UnrealPak、Oodle DLL 与授权不明的工具必须由用户从合法来源自行提供。

### 新电脑一键预检

在开始翻译前运行以下命令：

```powershell
.\scripts\preflight.ps1 `
  -ModSource 'D:\Mods\example-windows.zip' `
  -NormalBaseline 'D:\ASA\official-normal' `
  -BilingualBaseline 'D:\ASA\official-bilingual' `
  -UnrealPak 'D:\UE\Engine\Binaries\Win64\UnrealPak.exe'
```

它会输出 JSON，分别标出“能否清点文本”“能否出普通版”“能否出双语版”，并列出唯一缺少的文件或工具。只提供模组包时也能得到准确的下一步，而不是模糊报错。

## English

An open Agent Skills-format skill for ARK: Survival Ascended (ASA) mod localization. It packages mod text inventory, ASA terminology review, normal/bilingual baseline selection, package validation, and regression repair into a reusable workflow for any agent that supports `SKILL.md` folders.

### Features

- Inventories player-facing strings from archives or unpacked mods and compares updates.
- Translates creatures, items, engrams, descriptions, buffs, HUD, and books using project-provided ASA terminology and context rules.
- Repairs untranslated screenshots, mixed Chinese/English strings, inconsistent whitespace, and fragmented tooltip translations, then audits related text families.
- Builds normal and bilingual variants independently from their matching official baseline triplets so base-game bilingual text is retained.
- Validates ZIP CRCs, baseline hashes, localization overlays, install notes, and `SHA256SUMS.txt`.

### Scope and limits

- Does not require GitHub, accounts, fixed paths, a game installation location, or a particular mod author.
- Does not treat archive validation as proof of complete in-game rendering.
- Does not turn unverified proper names into ASA standard terminology.
- Does not fabricate bilingual base-game text without an official bilingual baseline.

### Install

This repository is a standard skill folder. Clone or copy it into your agent's skills directory, retaining the directory name `asa-mod-localization-release`. Common examples:

| Client | User-level directory | Project-level directory |
| --- | --- | --- |
| Codex | `~/.codex/skills/` | Client-specific project configuration |
| Claude Code | `~/.claude/skills/` | `.claude/skills/` |
| Cursor | Configured in Cursor Skills settings | `.cursor/skills/` |
| DeepSeek Harness / DSH Desktop | DSH-configured user skills root | `.dsh/skills/` or `.agents/skills/` |

For example:

```powershell
git clone https://github.com/stardust110/asa-mod-localization-skill `
  "$env:USERPROFILE\.codex\skills\asa-mod-localization-release"
```

Restart the client or begin a new task, then describe the ASA localization work. Clients that support explicit skill invocation can use `asa-mod-localization-release`.

#### DeepSeek Harness / DSH Desktop

DeepSeek Harness natively discovers `SKILL.md`. From any DSH project root:

```powershell
git clone https://github.com/stardust110/asa-mod-localization-skill `
  .dsh/skills/asa-mod-localization-release
```

`.agents/skills/asa-mod-localization-release` is also supported. DSH adds project skills to its catalog, so no DSH-specific plugin conversion is needed.

### Inputs and outputs

Provide the mod archive or unpacked directory, the official normal baseline triplet, the bilingual baseline triplet when bilingual output is required, plus optional terminology, previous patches, screenshots, or translation maps. The skill keeps source, inventory, translation, build, and output areas separate and produces requested installable archives, checksums, an installation note, and an audit summary.

Normal and bilingual packages are mutually exclusive installs.

### When tools are missing

The skill first probes for ZIP validation, Unreal IoStore extraction, locres
conversion, package building, and SHA-256 hashing. When a capability is missing, it
reports the exact gap and a compatible tool category. Downloads, installations,
updates, and PATH changes always require user approval; approved tools should
prefer a portable workspace-local location.

Without an extractor, the agent can still organize screenshots, terminology, and
translation maps, but it must not claim source coverage or an installable patch.
Without a packer, it can complete the map and report a blocked build for later reuse.

This repository does not redistribute binaries copied from a personal machine. After
approval, Windows users may run `scripts/bootstrap-retoc.ps1 -InstallRetoc` to fetch
retoc v0.1.5 from its official release into the workspace; the default script mode
only detects tools. Users must provide UnrealPak, Oodle DLLs, and tools with unknown
licenses from legitimate sources.

### New-machine preflight

Run this before translation:

```powershell
.\scripts\preflight.ps1 `
  -ModSource 'D:\Mods\example-windows.zip' `
  -NormalBaseline 'D:\ASA\official-normal' `
  -BilingualBaseline 'D:\ASA\official-bilingual' `
  -UnrealPak 'D:\UE\Engine\Binaries\Win64\UnrealPak.exe'
```

It emits JSON with separate inventory, normal-build, and bilingual-build readiness,
plus an exact missing-input list. Supplying only a mod package still produces a clear
next step instead of an ambiguous failure.

## Repository layout

- `SKILL.md`: portable entry-point workflow and quality rules.
- `references/portable-input-output.md`: input, output, workspace, and automation contract.
- `references/release-checklist.md`: source, translation, package, and runtime follow-up checks.
- `references/tool-bootstrap.md`: clean-machine capability checks and permission-aware tool setup.
- `references/tool-sources.md`: official sources and redistribution boundaries.
- `references/new-machine-quickstart.md`: minimum inputs and readiness outcomes for clean computers.
- `scripts/bootstrap-retoc.ps1`: optional, user-approved official retoc bootstrap for Windows.
- `scripts/preflight.ps1`: deterministic new-machine readiness report.
- `agents/openai.yaml`: optional OpenAI/Codex UI metadata; not required by other clients.

## License

[MIT](LICENSE)
