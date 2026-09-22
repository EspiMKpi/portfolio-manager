# Master Project Portfolio Dashboard

> **Last Updated**: 2026-09-22  
> **Active Host**: `dung-HP-Notebook` (PORTABLE_LAPTOP)  
> **Master Orchestrator**: Active via [`.agents/skills/portfolio-manager/SKILL.md`](file:///home/dung/Documents/.agents/skills/portfolio-manager/SKILL.md)

---

## 1. Executive Summary & Projects Overview

| # | Project / Course | Milestone / Focus | Status | Assigned Agents | Next Deadline | Hardware Req |
| :-: | :--- | :--- | :---: | :--- | :---: | :---: |
| **1** | **ISAD / PTTK** (Information Systems Analysis & Design) | UML System Architecture & Sequence Diagrams | 🟡 `IN_PROGRESS` | `isad-architect`<br/>`isad-analyst` | TBD | 💻 Laptop-Friendly |
| **2** | **Smart System** (AI / ML / DL / CNN) | Assignment 4 / LeNet & CNN Image Classification | 🟡 `IN_PROGRESS` | `ai-data-engineer`<br/>`ai-model-engineer` | TBD | 🖥️ PC (GPU Training) / 💻 Laptop (Mini-batch) |
| **3** | **Mobile App Development** (Android Studio) | Modern Kotlin / Compose UI & Room Setup | ⚪ `NOT_STARTED` | `android-dev`<br/>`android-qa` | TBD | 💻 Laptop (Code & Phone ADB) / 🖥️ PC (AVD) |
| **4** | **Network Programming** (L3/L4 Protocols & Sockets) | Asyncio TCP Server & Length-Prefixed Framing | ⚪ `NOT_STARTED` | `network-socket-dev`<br/>`network-packet-analyst` | TBD | 💻 Laptop-Friendly |
| **5** | **Software Project Management** (SPM) | Project Charter, WBS & Sprint Schedule | 🟡 `IN_PROGRESS` | `spm-planner`<br/>`spm-risk-quality` | TBD | 💻 Laptop-Friendly |

*Status Legend: 🟢 `COMPLETED` | 🟡 `IN_PROGRESS` | 🔴 `BLOCKED` | ⚪ `NOT_STARTED`*

---

## 2. Immediate Next Actions (Ranked by Device Fit)

### 💻 Laptop-Friendly Tasks (Execute Today on Laptop)
1. **[ISAD / PTTK]**: Review Use Case specifications and convert design diagrams into standard [Mermaid UML format](file:///home/dung/Documents/.agents/skills/portfolio-manager/references/isad_guide.md).
2. **[SPM]**: Formulate project WBS breakdown and risk matrix in the SPM project directory using [SPM Reference Guide](file:///home/dung/Documents/.agents/skills/portfolio-manager/references/spm_guide.md).
3. **[Smart System]**: Verify model pipeline code locally using `--debug --samples 16` before pushing to PC.
4. **[Network]**: Initialize Python asyncio TCP client/server boilerplate using [Network Reference Guide](file:///home/dung/Documents/.agents/skills/portfolio-manager/references/network_programming_guide.md).
5. **[Mobile App]**: Set up `gradle.properties` low-memory limits and connect physical phone via `adb connect`.

### 🖥️ High-Compute Tasks (Queue for Desktop PC)
1. **[Smart System]**: Pull git branch on PC and run full CUDA GPU training:
   ```bash
   python train.py --device cuda --epochs 50 --batch-size 64
   ```
2. **[Mobile App]**: Run full Gradle build and launch Android Studio AVD emulator for screen recording if physical phone is unavailable.

---

## 3. Active Sprint Goals

### Project 1: Information System Analysis & Design (ISAD)
- **Goal**: Complete detailed Sequence Diagrams and Class Diagrams for primary subsystems.
- **Artifacts**: SRS Document, Mermaid UML Diagrams.

### Project 2: Developing Smart System (AI)
- **Goal**: Finalize Assignment 4 evaluations (LeNet on MNIST/CIFAR-10, comparison metrics).
- **Artifacts**: Classification reports, loss/accuracy curves, final master PDF report.

### Project 3: Mobile App Development
- **Goal**: Initialize project architecture (MVVM), setup Jetpack Compose navigation, and connect local Room database.
- **Artifacts**: Clean codebase, debug APK build.

### Project 4: Network Programming
- **Goal**: Implement multi-client TCP chat/data server with length-prefixed protocol framing to prevent message fragmentation.
- **Artifacts**: `server.py`, `client.py`, protocol documentation.

### Project 5: Software Project Management (SPM)
- **Goal**: Produce complete WBS, Sprint Backlog with story points, and Mermaid Gantt timeline.
- **Artifacts**: Project Charter, Risk Assessment Matrix, Sprint Roadmap.

---

## 4. Cross-Device Handoff Log
- **2026-09-22** (`PORTABLE_LAPTOP`): Initialized Portfolio Management Skill and Central Dashboard. All 5 project structures mapped.
