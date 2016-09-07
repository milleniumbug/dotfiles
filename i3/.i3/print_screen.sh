#!/bin/sh
NAME="`mktemp`.png"
import "$@" "$NAME"
cp -f "$NAME" ~/screens/latest.png
mv "$NAME" ~/screens/
