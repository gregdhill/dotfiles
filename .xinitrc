#!/bin/bash
exec i3
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
