#!/system/bin/sh
# CODM GARENA AND ML OPTIMIZATION - ULTIMATE Service Script
# ULTIMATE ULTRA-STABLE FPS OPTIMIZER for AxManager (Non-Root)

MODDIR=${0%/*}
MODPATH=$MODDIR
LOG_FILE="/sdcard/Android/data/codm_ml_fps/service.log"
STATS_FILE="/sdcard/Android/data/codm_ml_fps/stats.log"

mkdir -p "$(dirname "$LOG_FILE")" 2>/dev/null
mkdir -p "$(dirname "$STATS_FILE")" 2>/dev/null

log_msg() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

log_stats() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$STATS_FILE"
}

detect_refresh_rate() {
    CHIPSET=$(getprop ro.board.platform 2>/dev/null || getprop ro.hardware 2>/dev/null || echo "unknown")
    DEVICE=$(getprop ro.product.model 2>/dev/null)

    case "$CHIPSET" in
        *msm8998*|*sdm660*|*sdm636*|*exynos9810*|*exynos9820*)
            MAX_REFRESH="90"
            ;;
        *sdm845*|*sdm855*|*sdm865*|*sm8150*|*sm8250*|*sm8350*|*sm8450*|*sm8475*|*kona*|*lahaina*|*taro*)
            MAX_REFRESH="120"
            ;;
        *)
            MAX_REFRESH="60"
            ;;
    esac

    log_msg "Device: $DEVICE | Chipset: $CHIPSET | Max Refresh: ${MAX_REFRESH}Hz"
    log_stats "Device: $DEVICE | Chipset: $CHIPSET | Max Refresh: ${MAX_REFRESH}Hz"
    echo "$MAX_REFRESH"
}

optimize_cpu_gpu() {
    local TARGET=$1
    log_msg "Applying CPU/GPU optimizations for ${TARGET}Hz"

    setprop persist.sys.performance_profile ultra_performance 2>/dev/null
    setprop persist.sys.thermal.profile performance_gaming 2>/dev/null
    setprop persist.sys.usb.config mtp,adb 2>/dev/null
    setprop ro.opengles.version 196610 2>/dev/null
    setprop debug.atrace.tags.enableflags 0 2>/dev/null
    setprop ro.max.fling_velocity 12000 2>/dev/null
}

thermal_management() {
    log_msg "Applying thermal management"
    setprop persist.sys.thermal.profile high_performance_gaming 2>/dev/null
    setprop ro.thermal_active true 2>/dev/null
}

reduce_latency() {
    log_msg "Applying latency reductions"
    setprop persist.sys.input_latency_value 100 2>/dev/null
    setprop ro.audio.low_latency true 2>/dev/null
    setprop persist.touch.latency 0 2>/dev/null
}

pixelated_graphics() {
    log_msg "Enabling pixelated blocky graphics"
    setprop persist.sys.hwui.drop_shadow_cache_size 2 2>/dev/null
    setprop persist.sys.hwui.path_cache_size 8 2>/dev/null
    setprop persist.sys.antialiasing disabled 2>/dev/null
}

frame_pacing() {
    log_msg "Enabling frame pacing optimizations"
    setprop debug.sf.use_phase_offsets_as_durations 1 2>/dev/null
    setprop ro.surface_flinger.max_frame_buffer_acquired_buffers 3 2>/dev/null
    setprop persist.sys.frame_pacing_smooth true 2>/dev/null
}

monitor_games() {
    log_msg "Starting game monitor"
    while true; do
        APP=$(dumpsys window windows 2>/dev/null | grep "mCurrentFocus" | head -n1)
        case "$APP" in
            *com.garena.game.codm*|*codm*)
                log_msg "CODM detected - set 120FPS"
                setprop persist.sys.game_fps_target 120 2>/dev/null
                setprop persist.sys.performance_profile ultra_performance 2>/dev/null
                setprop persist.sys.thermal.profile aggressive_cooling 2>/dev/null
                ;;
            *com.moonton.slg*|*mobile.legends*|*mlbb*)
                log_msg "Mobile Legends detected - set 90FPS"
                setprop persist.sys.game_fps_target 90 2>/dev/null
                setprop persist.sys.performance_profile high_performance 2>/dev/null
                setprop persist.sys.thermal.profile balanced_gaming 2>/dev/null
                ;;
        esac
        sleep 2
    done
}

main() {
    log_msg "Starting CODM & ML Optimization Service"
    TARGET=$(detect_refresh_rate)
    optimize_cpu_gpu "$TARGET"
    thermal_management
    reduce_latency
    pixelated_graphics
    frame_pacing
    monitor_games
}

main &
