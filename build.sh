#!/usr/bin/env bash

set -e

rm -rf dist/
mkdir -p dist

echo 'Building for web ...'
godot --no-window --export "HTML5" dist/index.html
echo 'done.'

echo 'Building for linux ...'
godot --no-window --export 'Linux/X11' dist/hack-to-the-root.x86_64
chmod a+x dist/hack-to-the-root.x86_64
echo 'done.'

echo 'Building for Windows ...'
godot --no-window --export 'Windows Desktop' dist/hack-to-the-root.exe
echo 'done.'
