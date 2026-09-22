#!/usr/bin/env bash
# ==============================================================================
# audit_workspace.sh - Workspace Safety & Integrity Auditor
# ==============================================================================

set -eo pipefail
export LC_ALL=C

WORKSPACE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)"
cd "$WORKSPACE_ROOT"

echo "=========================================================="
echo "  Workspace Safety & System Integrity Audit"
echo "  Target: $WORKSPACE_ROOT"
echo "=========================================================="

WARNINGS=0

# 1. Disk Space Check
FREE_KB=$(df "$WORKSPACE_ROOT" | awk 'NR==2 {print $4}')
FREE_GB=$(awk "BEGIN {printf \"%.1f\", $FREE_KB / 1024 / 1024}")
echo "💾 Disk Space Available: ${FREE_GB} GB"
if (( $(echo "$FREE_GB < 3.0" | bc -l 2>/dev/null || [ "$FREE_KB" -lt 3000000 ]) )); then
    echo "  ⚠️ [WARNING] Low disk space! Less than 3GB available."
    WARNINGS=$((WARNINGS + 1))
else
    echo "  ✅ Disk space is healthy."
fi

# 2. Critical Course Folders Check
echo "📁 Critical Project Directories:"
for dir in "PTTK" "Smart system" "Mobile app" ".agents"; do
    if [ -d "$dir" ]; then
        echo "  ✅ Found: $dir/"
    else
        echo "  ⚠️ [WARNING] Expected directory missing: $dir/"
        WARNINGS=$((WARNINGS + 1))
    fi
done

# 3. Orphaned / Runaway Process Check
echo "🔍 Checking for Orphaned Background Processes:"
ORPHAN_PY=$(pgrep -f "run_all.py|train.py|demo.py|demo_cifar10.py" 2>/dev/null || true)
if [ -n "$ORPHAN_PY" ]; then
    echo "  ⚠️ [WARNING] Python training/demo process currently running (PID: $ORPHAN_PY)"
    WARNINGS=$((WARNINGS + 1))
else
    echo "  ✅ No runaway training/demo processes detected."
fi

# 4. Large Files Scan (> 10MB)
echo "📦 Scanning for Uncommitted Heavy Files (>10MB):"
LARGE_COUNT=0
while IFS= read -r -d '' file; do
    SIZE_MB=$(du -m "$file" | cut -f1)
    if [ "$SIZE_MB" -ge 10 ]; then
        LARGE_COUNT=$((LARGE_COUNT + 1))
    fi
done < <(find . -not -path '*/.*' -type f -size +10M -print0 2>/dev/null || true)

if [ "$LARGE_COUNT" -gt 0 ]; then
    echo "  ℹ️ Found $LARGE_COUNT large file(s) (>10MB). Ensure they are in .gitignore."
else
    echo "  ✅ No uncommitted large files detected."
fi

echo "=========================================================="
if [ "$WARNINGS" -eq 0 ]; then
    echo "🛡️  AUDIT RESULT: [PASS] - Workspace is safe & healthy."
else
    echo "⚠️  AUDIT RESULT: [$WARNINGS WARNINGS] - Review warnings above."
fi
echo "=========================================================="
