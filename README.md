# Multi-Project Portfolio Manager & Dual-Device Agent System

An autonomous, multi-agent portfolio management framework built with Google Antigravity. It orchestrates 5 concurrent software engineering university courses while intelligently adapting compute workloads between a **portable, low-spec laptop** and a **high-performance desktop PC**.

---

## 🚀 Quick Start: How to Use Everyday

### 1. Daily Standup (Every Morning / Start of Session)
Just type in the chat:
> **"What should I work on today?"** *(or `/portfolio status`)*

The Master Orchestrator will:
1. Scan your hardware using `check_device.sh` to see whether you are on your laptop or PC.
2. Read [`PROJECTS_DASHBOARD.md`](./PROJECTS_DASHBOARD.md) to check milestones and deadlines.
3. Recommend the 3 best tasks tailored specifically for your current device.

---

### 2. Working on a Specific Subject
You can directly command the specialized subagents in plain English:

| If you want to... | Type this prompt: | Responsible Agent |
| :--- | :--- | :--- |
| **Design UML / Architecture** | *"Draft a Sequence Diagram for the checkout flow in ISAD"* | `isad-architect` |
| **Write Requirements / SRS** | *"Create use case specifications and user stories for PTTK"* | `isad-analyst` |
| **Train AI / Deep Learning** | *"Build a PyTorch CNN model for CIFAR-10 with mini-batch debug mode"* | `ai-model-engineer` |
| **Preprocess Dataset** | *"Clean and augment the image dataset for Smart Systems"* | `ai-data-engineer` |
| **Develop Android App** | *"Build a Jetpack Compose screen with ViewModel & StateFlow"* | `android-dev` |
| **Debug Android App** | *"Analyze this logcat crash dump without using an emulator"* | `android-qa` |
| **Build Sockets / Server** | *"Write a multi-client async TCP server with length-prefixed framing"* | `network-socket-dev` |
| **Analyze Network Packets** | *"Craft an ICMP ping packet and sniff TCP handshakes using Scapy"* | `network-packet-analyst`|
| **Plan Sprints & WBS** | *"Generate a WBS and Mermaid Gantt chart for Project Management"* | `spm-planner` |
| **Assess Risks & Quality** | *"Calculate the risk matrix score and prepare defense checklist"* | `spm-risk-quality` |

---

### 3. Switching Between Laptop & Desktop PC (Handoff)

#### When Leaving Your Laptop (e.g., leaving university/cafe):
Run in your terminal:
```bash
bash .agents/skills/portfolio-manager/scripts/sync_checkpoint.sh save "Done drafting model and UML on laptop"
```
*(This automatically scans for accidental large files > 10MB, commits your code, and pushes to GitHub).*

#### When Sitting at Your Strong PC (e.g., at home):
Run in your terminal:
```bash
bash .agents/skills/portfolio-manager/scripts/sync_checkpoint.sh load
```
*(This pulls your latest work. The agent on your PC will automatically detect your NVIDIA GPU and take over heavy CUDA training, Android emulators, and full builds).*

---

## 🛡️ Built-in Safety Guardrails & Ground Limits

The workspace is protected by an **always-on safety contract** ([`AGENTS.md`](./AGENTS.md)) and the **`safety-guard` skill**:

1. **No Catastrophic File Deletion**:
   - The agent is **strictly forbidden** from running destructive commands (`rm -rf /`, `rm -rf ~`, `rm -rf *`).
   - Source code (`.py`, `.kt`, `.java`), notebooks (`.ipynb`), reports (`.pdf`, `.docx`), and project directories will **never** be deleted without your explicit confirmation.
2. **Git History Protection**:
   - Forced pushes (`git push --force`) and destructive hard resets (`git reset --hard`) are blocked.
   - Files > 10MB (model weights, raw datasets) are intercepted before committing to protect your GitHub repository.
3. **Hardware Meltdown Protection**:
   - When on your weak laptop, the agent will **never** launch heavy CUDA training loops or Android Virtual Device (AVD) emulators that could freeze or crash your machine.
4. **Safety Audit Command**:
   - Ask the agent: *"Audit workspace safety"* to check disk space, runaway processes, and folder integrity at any time.

---

## 💻 Hardware Workload Matrix

| Task Category | Weak Laptop (`dung-HP-Notebook`) | Strong PC (`Desktop RTX 3060`) |
| :--- | :--- | :--- |
| **AI / Deep Learning** | Write code, verify mini-batch (`--debug --samples 16`) | Full GPU training (`--device cuda --epochs 50`), generate plots |
| **Android Studio** | Kotlin coding, test on **Physical Phone via USB/Wi-Fi ADB** | Android Studio AVD Emulators, clean release builds |
| **Network Sockets** | Localhost TCP/UDP testing, protocol framing | Docker network topologies, traffic load testing |
| **ISAD & SPM** | Write specs, render Mermaid UML diagrams, WBS | Review documents, export final presentation slide decks |

---

## 📂 Repository Layout

```text
/home/dung/Documents/
├── README.md                                     # This guide
├── AGENTS.md                                     # Always-on Safety Guardrails & Ground Limits
├── PROJECTS_DASHBOARD.md                         # Master 5-course tracking board
├── .gitignore                                    # Excludes datasets & weights from Git
├── .agents/
│   ├── rules/
│   │   └── safety_guardrails.md                  # Safety rules
│   └── skills/
│       ├── portfolio-manager/                    # Master Orchestration Skill
│       │   ├── SKILL.md                          # Core instruction & subagent personas
│       │   ├── scripts/
│       │   │   ├── check_device.sh               # Hardware detector (Laptop vs PC)
│       │   │   └── sync_checkpoint.sh            # Git handoff helper (>10MB scanner)
│       │   └── references/
│       │       ├── isad_guide.md                 # UML & SRS templates
│       │       ├── smart_system_guide.md         # PyTorch CNN & mini-batch templates
│       │       ├── android_guide.md              # Android Compose & ADB runbooks
│       │       ├── network_programming_guide.md  # Python asyncio sockets & Scapy
│       │       └── spm_guide.md                  # WBS, Gantt & Risk matrices
│       └── safety-guard/                         # System Integrity & Safety Skill
│           ├── SKILL.md                          # Safety audit skill
│           └── scripts/
│               └── audit_workspace.sh            # Health & runaway process checker
├── PTTK/                                         # Project 1: ISAD / PTTK
├── Smart system/                                 # Project 2: AI / Smart Systems
├── Mobile app/                                   # Project 3: Android Studio
├── Network Programming/                          # Project 4: Socket Programming
└── SPM/                                          # Project 5: Software Project Management
```

---

## 🔗 One-Time Setup on Your Strong PC

Once you push from this laptop to your GitHub repository ([`EspiMKpi/portfolio-manager`](https://github.com/EspiMKpi/portfolio-manager)), setup on your desktop PC is instant:

```bash
cd ~/Documents
git clone https://github.com/EspiMKpi/portfolio-manager.git .
```

*Antigravity will automatically load all skills, subagents, and safety guardrails the second you open the folder.*
