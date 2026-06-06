#!/system/bin/sh
# Action script - real-time detection and per-game optimizations

LOG="/sdcard/Android/data/codm_ml_fps/action.log"
mkdir -p "$(dirname "$LOG")" 2>/dev/null

log(){ echo "[$(date '+%H:%M:%S')] $1" >> "$LOG"; }

while true; do
  APP=$(dumpsys window windows 2>/dev/null | grep "mCurrentFocus" | head -n1)
  case "$APP" in
    *com.garena.game.codm*|*codm*)
      log "CODM detected - applying 120FPS settings"
      setprop persist.sys.game_fps_target 120 2>/dev/null
      setprop persist.sys.performance_profile ultra_performance 2>/dev/null
      setprop persist.sys.thermal.profile aggressive_cooling 2>/dev/null
      setprop persist.sys.hwui.drop_shadow_cache_size 1 2>/dev/null
      setprop debug.sf.use_phase_offsets_as_durations 1 2>/dev/null
      ;;
    *com.moonton.slg*|*mobile.legends*|*mlbb*)
      log "Mobile Legends detected - applying 90FPS settings"
      setprop persist.sys.game_fps_target 90 2>/dev/null
      setprop persist.sys.performance_profile high_performance 2>/dev/null
      setprop persist.sys.thermal.profile balanced_gaming 2>/dev/null
      setprop persist.sys.hwui.drop_shadow_cache_size 2 2>/dev/null
      setprop debug.sf.use_phase_offsets_as_durations 1 2>/dev/null
      ;;
  esac
  sleep 1
done &
