#!/usr/bin/env bash
# ==============================================================================
# check_device.sh - Hardware Profiler for Dual-Device (Laptop vs PC) Workflow
# ==============================================================================
# Usage:
#   ./check_device.sh         # Human-readable summary
#   ./check_device.sh --json  # Machine-readable JSON output
# ==============================================================================

set -eo pipefail
export LC_ALL=C

JSON_MODE=false
if [[ "${1:-}" == "--json" ]]; then
    JSON_MODE=true
fi

# 1. RAM Information
TOTAL_MEM_KB=$(grep MemTotal /proc/meminfo | awk '{print $2}')
AVAIL_MEM_KB=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
TOTAL_MEM_GB=$(awk "BEGIN {printf \"%.1f\", $TOTAL_MEM_KB / 1024 / 1024}")
AVAIL_MEM_GB=$(awk "BEGIN {printf \"%.1f\", $AVAIL_MEM_KB / 1024 / 1024}")

# 2. CPU Information
CPU_MODEL=$(grep -m1 "model name" /proc/cpuinfo | cut -d: -f2 | sed -e 's/^[ \t]*//')
CPU_CORES=$(nproc)

# 3. GPU / CUDA Check
HAS_NVIDIA_GPU=false
GPU_NAME="None (Integrated/No CUDA)"
GPU_VRAM_MB="0"

if command -v nvidia-smi &> /dev/null; then
    NVIDIA_OUT=$(nvidia-smi --query-gpu=name,memory.total --format=csv,noheader,nounits 2>/dev/null | head -n 1 || true)
    if [[ -n "$NVIDIA_OUT" ]]; then
        HAS_NVIDIA_GPU=true
        GPU_NAME=$(echo "$NVIDIA_OUT" | cut -d, -f1 | sed -e 's/^[ \t]*//')
        GPU_VRAM_MB=$(echo "$NVIDIA_OUT" | cut -d, -f2 | sed -e 's/^[ \t]*//')
    fi
fi

# 4. Android ADB Check
HAS_ADB=false
CONNECTED_ADB_DEVICES=0
if command -v adb &> /dev/null; then
    HAS_ADB=true
    # Count lines with "device" status, excluding header
    CONNECTED_ADB_DEVICES=$(adb devices 2>/dev/null | grep -v "List of devices" | grep "device$" | wc -l || echo 0)
fi

# 5. Device Profile Classification
DEVICE_PROFILE="PORTABLE_LAPTOP"
RECOMMENDATION="Run documentation, UML diagrams, specs, and lightweight code. Use --debug/mini-batch for AI. Use physical phone for Android debugging."

if [[ "$HAS_NVIDIA_GPU" == "true" ]] && (( $(echo "$TOTAL_MEM_GB >= 15.0" | bc -l 2>/dev/null || [ ${TOTAL_MEM_KB} -ge 15000000 ]) )); then
    DEVICE_PROFILE="STRONG_PC"
    RECOMMENDATION="Ready for heavy workloads: GPU CNN training, Android Studio AVD emulators, and full test sweeps."
fi

# Output
if [[ "$JSON_MODE" == "true" ]]; then
    cat <<EOF
{
  "device_profile": "$DEVICE_PROFILE",
  "cpu_model": "$CPU_MODEL",
  "cpu_cores": $CPU_CORES,
  "ram_total_gb": $TOTAL_MEM_GB,
  "ram_available_gb": $AVAIL_MEM_GB,
  "has_nvidia_gpu": $HAS_NVIDIA_GPU,
  "gpu_name": "$GPU_NAME",
  "gpu_vram_mb": $GPU_VRAM_MB,
  "has_adb": $HAS_ADB,
  "connected_adb_devices": $CONNECTED_ADB_DEVICES,
  "recommendation": "$RECOMMENDATION"
}
EOF
else
    echo "=========================================================="
    echo "  Antigravity Dual-Device Hardware Profiler"
    echo "=========================================================="
    echo " Detected Profile:   [$DEVICE_PROFILE]"
    echo " CPU:                $CPU_MODEL ($CPU_CORES cores)"
    echo " RAM:                Total ${TOTAL_MEM_GB} GB (Available: ${AVAIL_MEM_GB} GB)"
    if [[ "$HAS_NVIDIA_GPU" == "true" ]]; then
        echo " GPU (CUDA):         $GPU_NAME (${GPU_VRAM_MB} MB VRAM)"
    else
        echo " GPU (CUDA):         No NVIDIA GPU detected"
    fi
    if [[ "$HAS_ADB" == "true" ]]; then
        echo " ADB Installed:      Yes ($CONNECTED_ADB_DEVICES physical/virtual device(s) connected)"
    else
        echo " ADB Installed:      No (Install adb for Android debugging)"
    fi
    echo "----------------------------------------------------------"
    echo " Recommendation: $RECOMMENDATION"
    echo "=========================================================="
fi
