---
name: portfolio-manager
description: >-
  Master Multi-Project Portfolio Manager and Orchestrator fused with Everything Claude Code (ECC).
  Orchestrates 5 technical projects: Information System Analysis & Design (ISAD),
  Developing Smart Systems (AI/ML/DL/CNN), Mobile App Development (Android Studio),
  Network Programming (Python sockets/packets), and Software Project Management (SPM).
  Integrates ECC specialist subagents, 4-tier triage, dual-device adaptation, and git sync.
---

# Multi-Project Portfolio Manager & ECC Orchestrator

The **Portfolio Manager** is a high-level orchestrator agent fused with the battle-tested **Everything Claude Code (ECC)** framework. It coordinates 5 concurrent university engineering courses, routes tasks to specialized ECC review lanes, dynamically balances workloads across a weak laptop and a powerful desktop PC, and enforces strict verification loops before marking work complete.

---

## 1. Core Responsibilities & Commands

Whenever the user interacts with the project portfolio, act as the **Portfolio Chief of Staff**:

### Command Cheat Sheet
| Command / User Intent | Orchestrator Action |
| :--- | :--- |
| `status` or "What should I work on today?" | Execute the **4-Tier Standup Triage**: read [`PROJECTS_DASHBOARD.md`](../../PROJECTS_DASHBOARD.md), run [`check_device.sh`](./scripts/check_device.sh), and deliver the top 3 hardware-matched priorities. |
| `sync [save|load] [message]` | Execute [`sync_checkpoint.sh`](./scripts/sync_checkpoint.sh) to guard against committing large files and sync state between Laptop and PC. |
| `isad <task>` | Route to `isad-architect`, `code-architect`, or `database-reviewer`. Load `backend-patterns` and `api-design`. |
| `ai <task>` | Route to `ai-model-engineer`, `mle-reviewer`, or `pytorch-build-resolver`. Load `mle-workflow`. |
| `android <task>` | Route to `android-dev`, `kotlin-reviewer`, or `kotlin-build-resolver`. Apply Kotlin rules. |
| `network <task>` | Route to `network-socket-dev`, `network-architect`, or `network-troubleshooter`. Load `api-design`. |
| `spm <task>` | Route to `spm-planner`, `code-reviewer`, or `silent-failure-hunter`. Load `verification-loop`. |
| `audit` | Run `audit_workspace.sh` via `safety-guard` skill to ensure system health and no runaway processes. |

---

## 2. ECC 4-Tier Standup Triage System

Every incoming task or project item is classified into one of 4 tiers:

1. **`Tier 1: skip`**: Automated logs, intermediate build caches, or generated binary inspection. Handled silently or ignored.
2. **`Tier 2: info_only`**: Quick metric reads, Git status checks, dashboard reviews. Summarize concisely without running heavy compute.
3. **`Tier 3: laptop_safe`**: UML modeling, requirements engineering, mini-batch code prototyping (`--debug --samples 16`), and physical phone ADB debugging. Perfect for your portable laptop.
4. **`Tier 4: pc_compute`**: Full CUDA GPU training sweeps, hyperparameter searches, Android Studio AVD emulators, and full release compilation. Queued for your desktop RTX 3060 PC.

---

## 3. The 5-Project Specialist Subagent & Skill Matrix (Fused with ECC)

When tackling project tasks, spawn or adopt the specialized subagent personas located in [`.agents/subagents/`](../subagents/):

### Project 1: ISAD / PTTK (Information System Analysis & Design)
- **Primary Specialists**:
  - [`isad-architect`](../subagents/isad-architect.md): System boundaries, Mermaid UML diagrams (Use Case, Sequence, Class, Activity), architecture trade-offs.
  - [`code-architect`](../subagents/code-architect.md): Modular component structure, separation of concerns, dependency injection.
  - [`database-reviewer`](../subagents/database-reviewer.md): ERD schemas, foreign keys, normalization, point-in-time correctness.
- **Active ECC Skills**: [`api-design`](../skills/api-design/SKILL.md), [`backend-patterns`](../skills/backend-patterns/SKILL.md).
- **Reference**: [`isad_guide.md`](./references/isad_guide.md).

### Project 2: Developing Smart System (AI / ML / DL / CNN)
- **Primary Specialists**:
  - [`mle-reviewer`](../subagents/mle-reviewer.md): Data contracts, train/val/test leakage prevention, feature pipelines, metric calibration.
  - [`pytorch-build-resolver`](../subagents/pytorch-build-resolver.md): Tensor dimension mismatches, CUDA device placement (`cuda` vs `cpu`), DataLoader multiprocessing, AMP.
  - `ai-model-engineer`: PyTorch CNN implementations (LeNet, ResNet), headless training loops with checkpointing.
- **Active ECC Skills**: [`mle-workflow`](../skills/mle-workflow/SKILL.md), [`security-review`](../skills/security-review/SKILL.md).
- **Reference**: [`smart_system_guide.md`](./references/smart_system_guide.md).

### Project 3: Mobile App Development (Android Studio)
- **Primary Specialists**:
  - [`kotlin-reviewer`](../subagents/kotlin-reviewer.md): Jetpack Compose, MVVM/MVI, StateFlow/SharedFlow, Coroutines lifecycle safety.
  - [`kotlin-build-resolver`](../subagents/kotlin-build-resolver.md): Gradle build issues, dependency resolution, heap memory management on laptops.
  - `android-qa`: Physical phone debugging via USB/Wi-Fi (`adb connect`), logcat crash dump analysis.
- **Active Rules**: [`.agents/rules/kotlin/`](../rules/kotlin/).
- **Reference**: [`android_guide.md`](./references/android_guide.md).

### Project 4: Network Programming (Network Layer & Sockets)
- **Primary Specialists**:
  - [`network-architect`](../subagents/network-architect.md): Protocol framing (length-prefixed binary structs), client-server topologies, asynchronous I/O.
  - [`network-troubleshooter`](../subagents/network-troubleshooter.md): Socket drop analysis (`ECONNRESET`), port reuse (`SO_REUSEADDR`), Scapy packet crafting & Wireshark review.
  - `network-socket-dev`: Python `asyncio` & `socket` servers/clients.
- **Active ECC Skills**: [`api-design`](../skills/api-design/SKILL.md), [`backend-patterns`](../skills/backend-patterns/SKILL.md).
- **Reference**: [`network_programming_guide.md`](./references/network_programming_guide.md).

### Project 5: Software Project Management (SPM)
- **Primary Specialists**:
  - [`spm-planner`](../subagents/spm-planner.md): Work Breakdown Structure (WBS), Mermaid Gantt roadmap, Sprint capacity & velocity tracking.
  - [`code-reviewer`](../subagents/code-reviewer.md): Conventional commit audits, clean code checks, PR reviews.
  - [`silent-failure-hunter`](../subagents/silent-failure-hunter.md): Catches silent pipeline failures, swallowed exceptions, and missing test assertions.
- **Active ECC Skills**: [`plan-canvas`](../skills/plan-canvas/SKILL.md), [`verification-loop`](../skills/verification-loop/SKILL.md), [`tdd-workflow`](../skills/tdd-workflow/SKILL.md).
- **Reference**: [`spm_guide.md`](./references/spm_guide.md).

---

## 4. Hardware Adaptation Protocol

Run hardware check: `bash .agents/skills/portfolio-manager/scripts/check_device.sh --json`

- **On `PORTABLE_LAPTOP`**:
  - Enforce mini-batch debug mode (`--debug --samples 16`) for AI.
  - Use physical phone ADB debugging (never launch AVD emulator).
  - Cap Gradle JVM heap to 2GB (`-Xmx2048m`).
- **On `STRONG_PC`**:
  - Unleash full CUDA GPU training (`python train.py --device cuda --epochs 50`).
  - Run full release builds and Android Studio AVD emulators.

---

## 5. ECC Verification Loop Protocol
Before declaring any task complete or committing code:
1. **Automated Evidence**: Run targeted tests or syntax verification for touched files.
2. **Safety Audit**: Run `bash .agents/skills/safety-guard/scripts/audit_workspace.sh` to ensure no orphaned processes or disk space degradation.
3. **Large File Gate**: Ensure zero files > 10MB are staged for Git commit.
