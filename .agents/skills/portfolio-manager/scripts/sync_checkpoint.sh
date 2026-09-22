#!/usr/bin/env bash
# ==============================================================================
# sync_checkpoint.sh - Git Handoff & Large-File Guard for Dual-Device Workflow
# ==============================================================================
# Usage:
#   ./sync_checkpoint.sh save "optional commit message"
#   ./sync_checkpoint.sh load
#   ./sync_checkpoint.sh check-large-files
#   ./sync_checkpoint.sh status
# ==============================================================================

set -eo pipefail

ACTION="${1:-status}"
MESSAGE="${2:-}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"

cd "$WORKSPACE_ROOT"

# Detect device profile for commit attribution
HOSTNAME=$(hostname 2>/dev/null || echo "device")
DEVICE_PROFILE="LAPTOP"
if command -v nvidia-smi &> /dev/null && nvidia-smi &> /dev/null; then
    DEVICE_PROFILE="PC"
fi

check_large_files() {
    echo "🔍 Scanning for uncommitted large files (>10MB) to prevent Git bloat..."
    FOUND_LARGE=0
    while IFS= read -r -d '' file; do
        SIZE_MB=$(du -m "$file" | cut -f1)
        if [ "$SIZE_MB" -ge 10 ]; then
            echo "  ⚠️ [WARNING] Large file detected: $file (${SIZE_MB}MB)"
            FOUND_LARGE=$((FOUND_LARGE + 1))
        fi
    done < <(find . -not -path '*/.*' -type f -size +10M -print0 2>/dev/null || true)

    if [ "$FOUND_LARGE" -gt 0 ]; then
        echo "------------------------------------------------------------------"
        echo "🚨 Found $FOUND_LARGE file(s) exceeding 10MB!"
        echo "   Please ensure datasets (.csv, .zip), model weights (.pth, .h5),"
        echo "   and Android build outputs (.apk) are in .gitignore before pushing."
        echo "------------------------------------------------------------------"
        return 1
    else
        echo "✅ No uncommitted files > 10MB found. Safe to sync."
        return 0
    fi
}

case "$ACTION" in
    check-large-files)
        check_large_files
        ;;

    status)
        echo "=========================================================="
        echo "  Portfolio Workspace Status: $WORKSPACE_ROOT"
        echo "  Current Host: $HOSTNAME ($DEVICE_PROFILE)"
        echo "=========================================================="
        if [ -d ".git" ]; then
            git status -s
        else
            echo "ℹ️  Root is not a git repo. Checking subdirectories..."
            for d in */; do
                if [ -d "$d/.git" ]; then
                    echo "📁 Submodule/Repo: $d"
                    git -C "$d" status -s
                fi
            done
        fi
        ;;

    save|push)
        echo "=========================================================="
        echo "  Saving & Pushing Checkpoint ($DEVICE_PROFILE)"
        echo "=========================================================="
        check_large_files || {
            read -p "Do you want to continue despite large files? (y/N) " confirm
            if [[ "$confirm" != [yY] ]]; then
                echo "Aborting sync."
                exit 1
            fi
        }

        TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
        if [ -z "$MESSAGE" ]; then
            COMMIT_MSG="[Checkpoint] Handoff from $DEVICE_PROFILE at $TIMESTAMP"
        else
            COMMIT_MSG="[$DEVICE_PROFILE] $MESSAGE ($TIMESTAMP)"
        fi

        if [ -d ".git" ]; then
            git add -A
            if git diff-index --quiet HEAD --; then
                echo "ℹ️  No changes to commit."
            else
                git commit -m "$COMMIT_MSG"
                echo "✅ Changes committed: $COMMIT_MSG"
            fi
            
            # Check if remote exists
            if git remote | grep -q 'origin'; then
                CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
                echo "🚀 Pushing to origin/$CURRENT_BRANCH..."
                git push origin "$CURRENT_BRANCH"
                echo "🎉 Handoff push completed! You can now pull on your other device."
            else
                echo "ℹ️  No git remote 'origin' configured. Changes committed locally."
            fi
        else
            echo "⚠️  Root directory is not a git repository."
            echo "   To initialize: git init && git remote add origin <url>"
        fi
        ;;

    load|pull)
        echo "=========================================================="
        echo "  Pulling Latest Checkpoint ($DEVICE_PROFILE)"
        echo "=========================================================="
        if [ -d ".git" ]; then
            if git remote | grep -q 'origin'; then
                CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
                echo "📥 Pulling from origin/$CURRENT_BRANCH..."
                git pull origin "$CURRENT_BRANCH"
                echo "✅ Workspace updated to latest remote state."
            else
                echo "ℹ️  No git remote 'origin' configured."
            fi
        else
            echo "⚠️  Root directory is not a git repository."
        fi
        ;;

    *)
        echo "Usage: $0 {status|save|load|check-large-files} [message]"
        exit 1
        ;;
esac
