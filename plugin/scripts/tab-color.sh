#!/bin/sh
# Красит вкладку iTerm2 текущей сессии Claude Code.
# Использование: tab-color.sh R G B   (каждый канал 0-255)
#   tab-color.sh reset   — сбросить цвет к дефолту
#
# Хук запускается как подпроцесс Claude Code, у которого stdout перехвачен,
# а /dev/tty отвязан. Поэтому находим устройство сессии, поднимаясь по
# родительским процессам до первого с настоящим tty (это процесс `claude`).

find_tty_dev() {
  pid=$$
  while [ -n "$pid" ] && [ "$pid" != "0" ] && [ "$pid" != "1" ]; do
    cmd=$(ps -o command= -p "$pid" 2>/dev/null)
    # Фоновая/демон-сессия не имеет своей вкладки: если по пути вверх встретили
    # демон Claude Code или bg-pty-host — прерываемся, иначе walk «протечёт» на
    # tty интерактивной сессии-хозяина демона и покрасит ЧУЖУЮ вкладку.
    case "$cmd" in
      *"daemon run"*|*"bg-pty-host"*|*"bg-spare"*|*"--bg-"*) return 1 ;;
    esac
    t=$(ps -o tty= -p "$pid" 2>/dev/null | tr -d ' ')
    case "$t" in
      ttys*) echo "/dev/$t"; return 0 ;;
    esac
    pid=$(ps -o ppid= -p "$pid" 2>/dev/null | tr -d ' ')
  done
  return 1
}

dev=$(find_tty_dev) || exit 0
[ -e "$dev" ] || exit 0

if [ "$1" = "reset" ]; then
  printf '\033]6;1;bg;*;default\a' > "$dev" 2>/dev/null || true
  exit 0
fi

R=${1:-0}; G=${2:-0}; B=${3:-0}
printf '\033]6;1;bg;red;brightness;%s\a\033]6;1;bg;green;brightness;%s\a\033]6;1;bg;blue;brightness;%s\a' \
  "$R" "$G" "$B" > "$dev" 2>/dev/null || true
