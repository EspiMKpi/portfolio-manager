---
name: safety-guard
description: >-
  System Integrity & Catastrophic Error Prevention Guard. Use whenever deleting files,
  cleaning caches, executing shell commands with destructive potential, auditing disk space,
  or ensuring hardware limits are respected on low-spec devices.
---

# System Integrity & Safety Guard

The **Safety Guard** enforces operational ground limits to protect the developer's computer, operating system, and academic project work from accidental destruction, runaway processes, and Git bloat.

---

## 1. Ground Limits & Inviolable Rules

1. **Absolute Protection of User Data**:
   - Never remove or overwrite `.py`, `.kt`, `.java`, `.pdf`, `.docx`, `.md`, `.ipynb`, or `.vpp` files without explicit user review.
   - Never run unbounded recursive deletion commands (`rm -rf *`, `rm -rf ~`, `rm -rf /`).
2. **Safe Cleanup Only**:
   - Permissible cleanup is strictly confined to:
     - `__pycache__/`
     - `.pytest_cache/`
     - `.gradle/caches/`
     - Temporary scratch scripts inside designated temporary directories.
3. **Hardware Overload Prevention**:
   - Respect host profile from `check_device.sh`: On `PORTABLE_LAPTOP`, never trigger full CUDA training or AVD emulators.
4. **Git Safety**:
   - Never execute `git push --force` or `git reset --hard` across public/shared branches.
   - Always run pre-flight large-file check before committing.

---

## 2. Safety Audit Runbook

Whenever the user asks to "audit safety", "check system integrity", or before performing complex refactors or deletions:

1. Execute the workspace auditor:
   ```bash
   bash .agents/skills/safety-guard/scripts/audit_workspace.sh
   ```
2. Report disk space, running background jobs, and health status.
3. If warnings are present, resolve them before proceeding.
