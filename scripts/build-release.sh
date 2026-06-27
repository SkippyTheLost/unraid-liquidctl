#!/bin/bash
set -euo pipefail

ROOT=$(cd "$(dirname "$0")/.." && pwd)
VERSION=${VERSION:-2026.06.28.1}
PYTHON=${PYTHON:-python3}
STAGE="$ROOT/.build/liquidctl"
DIST="$ROOT/dist"

rm -rf "$STAGE"
mkdir -p "$STAGE/bin" "$DIST"

"$PYTHON" -m pip install -r "$ROOT/build/requirements.txt"
"$PYTHON" -m PyInstaller --clean --noconfirm --onefile \
  --name liquidctl \
  --collect-all liquidctl \
  --collect-all usb \
  --hidden-import hid \
  --add-binary "/usr/lib/x86_64-linux-gnu/libusb-1.0.so.0:." \
  "$ROOT/build/liquidctl_entry.py"

cp "$ROOT/dist/liquidctl" "$STAGE/bin/liquidctl"
cp -a "$ROOT/source/usr/local/emhttp/plugins/liquidctl/." "$STAGE/"
chmod 755 "$STAGE/bin/liquidctl" "$STAGE/scripts/liquidctlctl" "$STAGE/event/started"
printf '%s\n' "$VERSION" > "$STAGE/VERSION"

tar -C "$ROOT/.build" -czf "$DIST/liquidctl-$VERSION.tgz" liquidctl
md5sum "$DIST/liquidctl-$VERSION.tgz"
