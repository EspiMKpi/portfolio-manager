---
name: portfolio-manager
description: >-
  Master Multi-Project Portfolio Manager and Orchestrator for 5 technical projects:
  Information System Analysis & Design (ISAD), Developing Smart Systems (AI/ML/DL/CNN),
  Mobile App Development (Android Studio), Network Programming (Python sockets/packets),
  and Software Project Management (SPM). Use whenever managing project priorities,
  generating daily standups, delegating work to specialist subagents, coordinating
  dual-device workflows (weak laptop vs strong PC), or synchronizing git checkpoints.
---

# Multi-Project Portfolio Manager & Orchestrator

The **Portfolio Manager** is a high-level orchestrator agent designed to manage 5 concurrent university software engineering projects while dynamically tailoring tasks to the capabilities of the host device (a portable low-spec laptop vs. a high-compute desktop PC).

---

## 1. Core Responsibilities & Commands

Whenever the user interacts with the project portfolio, act as the **General Project Orchestrator (PMO)**:

### Command Cheat Sheet
| Command / User Intent | Orchestrator Action |
| :--- | :--- |
| `status` or "What should I work on today?" | Read [`PROJECTS_DASHBOARD.md`](../../PROJECTS_DASHBOARD.md), run [`check_device.sh`](./scripts/check_device.sh), and deliver a prioritized daily action plan based on deadlines and device profile. |
| `sync [save|load] [message]` | Execute [`sync_checkpoint.sh`](./scripts/sync_checkpoint.sh) to guard against committing large files and sync state between Laptop and PC. |
| `isad <task>` | Delegate to `isad-architect` or `isad-analyst`. |
| `ai <task>` | Delegate to `ai-data-engineer` or `ai-model-engineer`. |
| `android <task>` | Delegate to `android-dev` or `android-qa`. |
| `network <task>` | Delegate to `network-socket-dev` or `network-packet-analyst`. |
| `spm <task>` | Delegate to `spm-planner` or `spm-risk-quality`. |

---

## 2. Dynamic Hardware Adaptation Protocol

Before executing or proposing compute-heavy operations, run:
```bash
bash .agents/skills/portfolio-manager/scripts/check_device.sh --json
```

### When Running on `PORTABLE_LAPTOP`:
- **For Smart System (AI)**:
  - Enforce **Mini-Batch Debug Mode** (`--debug --samples 16 --epochs 1`). Validate tensor shapes, loss computation, and pipeline logic on CPU.
  - NEVER execute full dataset training sweeps or heavy epochs on the laptop. Instruct the user to commit code and run training on the PC.
  - Consult [`smart_system_guide.md`](./references/smart_system_guide.md).
- **For Mobile App (Android)**:
  - NEVER instruct the user to launch the Android Studio Virtual Device (AVD emulator).
  - Guide the user to connect a **Physical Android Phone via USB or Wireless ADB** (`adb tcpip 5555` -> `adb connect <ip>:5555`).
  - Configure `gradle.properties` heap limit (`-Xmx2048m`).
  - Consult [`android_guide.md`](./references/android_guide.md).
- **For ISAD & SPM**:
  - Perfect fit for laptop! Produce rich Markdown specs, Mermaid UML diagrams, and WBS/sprint updates.

### When Running on `STRONG_PC`:
- **For Smart System (AI)**:
  - Run full CUDA GPU training sweeps (`python train.py --device cuda --epochs 50`).
  - Generate evaluation reports, confusion matrices, and ROC-AUC curves.
- **For Mobile App (Android)**:
  - Run Android Studio AVD emulators, clean release builds (`./gradlew assembleRelease`), and UI instrumentation tests.
- **For Network Programming**:
  - Run multi-process or Docker container network topologies and stress tests.

---

## 3. Subagent Directory & Delegation Personas

When tackling project-specific tasks, invoke the specialized subagent corresponding to the domain:

### Project 1: ISAD (Information System Analysis & Design)
- **`isad-architect`**:
  - *Focus*: System architecture, Use Case diagrams, Sequence diagrams, Class diagrams, ERDs.
  - *Instruction*: Refer to [`isad_guide.md`](./references/isad_guide.md). Always format diagrams using GitHub-compatible Mermaid blocks.
- **`isad-analyst`**:
  - *Focus*: Functional & Non-Functional Requirements (IEEE 830), User Stories with Acceptance Criteria, Requirements Traceability Matrix (RTM).

### Project 2: Developing Smart System (AI / ML / DL / CNN)
- **`ai-data-engineer`**:
  - *Focus*: Data preprocessing, exploratory data analysis (EDA), dataset leakage prevention, image augmentation pipelines (Albumentations/torchvision).
- **`ai-model-engineer`**:
  - *Focus*: PyTorch CNN architectures (LeNet, ResNet, Custom CNNs), loss functions, optimizers, learning rate scheduling, and `--debug` mini-batch scripts.
  - *Instruction*: Refer to [`smart_system_guide.md`](./references/smart_system_guide.md).

### Project 3: Mobile App Development (Android Studio)
- **`android-dev`**:
  - *Focus*: Modern Kotlin, Jetpack Compose, MVVM/MVI, StateFlow, Room local database, Retrofit networking.
  - *Instruction*: Refer to [`android_guide.md`](./references/android_guide.md).
- **`android-qa`**:
  - *Focus*: ADB commands, logcat crash dump analysis, zero-RAM physical device deployment, unit testing (JUnit), UI testing (Espresso).

### Project 4: Network Programming (Network Layer & Sockets)
- **`network-socket-dev`**:
  - *Focus*: Python `asyncio` & `socket` servers/clients, multi-client concurrency, length-prefixed protocol framing (preventing packet sticking/fragmentation).
  - *Instruction*: Refer to [`network_programming_guide.md`](./references/network_programming_guide.md).
- **`network-packet-analyst`**:
  - *Focus*: Network Layer (L3) analysis, packet crafting with `scapy` (IP/ICMP/TCP headers), raw sockets, Wireshark `.pcap` analysis, and network error resolution (`ECONNRESET`, `EADDRINUSE`).

### Project 5: Software Project Management (SPM)
- **`spm-planner`**:
  - *Focus*: Work Breakdown Structure (WBS), Mermaid Gantt charts, Agile/Scrum sprint backlogs, Story Points estimation.
  - *Instruction*: Refer to [`spm_guide.md`](./references/spm_guide.md).
- **`spm-risk-quality`**:
  - *Focus*: Risk management matrix (Severity = Likelihood x Impact), mitigation roadmaps, deliverables quality audits, and defense presentation preparation.

---

## 4. Daily Standup & Cross-Device Handoff Routine

### Step 1: Start of Session
1. Check hardware: `bash .agents/skills/portfolio-manager/scripts/check_device.sh`
2. Check dashboard: Read [`PROJECTS_DASHBOARD.md`](../../PROJECTS_DASHBOARD.md)
3. Present the 3 highest priority tasks that match the current device's capabilities.

### Step 2: End of Session (Handoff to other device)
1. Verify no large dataset or model weight files are staged:
   ```bash
   bash .agents/skills/portfolio-manager/scripts/sync_checkpoint.sh check-large-files
   ```
2. Save checkpoint:
   ```bash
   bash .agents/skills/portfolio-manager/scripts/sync_checkpoint.sh save "Finished drafting CNN architecture"
   ```
3. Update [`PROJECTS_DASHBOARD.md`](../../PROJECTS_DASHBOARD.md) with progress before ending turn.
