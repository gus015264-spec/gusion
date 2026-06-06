#!/sbin/sh
# Installation script for CODM GARENA AND ML OPTIMIZATION

MODDIR=${0%/*}
MODPATH=$MODDIR
LOG="$MODPATH/install.log"
DATA_DIR="/sdcard/Android/data/codm_ml_fps"

mkdir -p "$DATA_DIR" 2>/dev/null

echo "Installing CODM GARENA AND ML OPTIMIZATION..." | tee -a "$LOG"

DEVICE=$(getprop ro.product.model 2>/dev/null)
CHIPSET=$(getprop ro.board.platform 2>/dev/null || getprop ro.hardware 2>/dev/null)

case "$CHIPSET" in
  *sdm*|*msm*|*sm*|*exynos*)
    SUPPORTED="60 90 120"
    DEFAULT="120"
    ;;
  *)
    SUPPORTED="60"
    DEFAULT="60"
    ;;
esac

echo "Device: $DEVICE" >> "$LOG"
echo "Chipset: $CHIPSET" >> "$LOG"
echo "Supported: $SUPPORTED | Default: $DEFAULT" >> "$LOG"

chmod +x "$MODPATH"/*.sh
chmod +x "$MODPATH/webroot"/*.sh 2>/dev/null || true

echo "Installation complete" | tee -a "$LOG"
