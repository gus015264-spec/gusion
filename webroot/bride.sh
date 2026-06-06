#!/system/bin/sh
# Bridge script - frame pacing bridge

LOG="/sdcard/Android/data/codm_ml_fps/bride.log"
mkdir -p "$(dirname "$LOG")" 2>/dev/null

log(){ echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG"; }

log "Starting frame pacing bridge"
setprop debug.sf.use_phase_offsets_as_durations 1 2>/dev/null
setprop ro.surface_flinger.max_frame_buffer_acquired_buffers 3 2>/dev/null

while true; do
  APP=$(dumpsys window windows 2>/dev/null | grep "mCurrentFocus" | head -n1)
  case "$APP" in
    *com.garena.game.codm*|*codm*)
      setprop debug.sf.late.app.duration 3000000 2>/dev/null
      setprop persist.sys.fps_lock 120 2>/dev/null
      log "Applied 120FPS bridge for CODM"
      ;;
    *com.moonton.slg*|*mobile.legends*|*mlbb*)
      setprop debug.sf.late.app.duration 4000000 2>/dev/null
      setprop persist.sys.fps_lock 90 2>/dev/null
      log "Applied 90FPS bridge for ML"
      ;;
  esac
  sleep 5
done &
