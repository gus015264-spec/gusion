#!/system/bin/sh
# Uninstall script - resets properties and removes files

MODDIR=${0%/*}
LOG="$MODDIR/uninstall.log"
DATA_DIR="/sdcard/Android/data/codm_ml_fps"

echo "Uninstalling CODM & ML Optimization..." | tee -a "$LOG"

# Reset props
setprop persist.sys.performance_profile balanced 2>/dev/null
setprop persist.sys.thermal.profile default 2>/dev/null
setprop persist.sys.game_fps_target 0 2>/dev/null
setprop persist.sys.input_latency_value 0 2>/dev/null
setprop debug.sf.use_phase_offsets_as_durations 0 2>/dev/null

# Remove logs
rm -rf "$DATA_DIR" 2>/dev/null

# Remove webroot
rm -rf "$MODDIR/webroot" 2>/dev/null

echo "Uninstalled and cleaned up." | tee -a "$LOG"
