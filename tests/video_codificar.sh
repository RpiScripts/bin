#!/bin/bash

# Videoencoding failed
#
#ffmpeg -i /var/media/Cine/torrent/fin/El\ resplandor\ \[4K\ UHDrip\]\[2160p\]\[HDR\]\[AC3\ 5.1-Castellano\ AC3\ 5.1-Ingles+Subs\]\[ES-EN\]/El\ resplandor\ 4Krip2160.www.pctnew.org.mkv -vf scale=1920x1080 -c:v libx264 -crf 35 nuevo1080.mp4
#ffmpeg -i /var/media/Cine/torrent/fin/El\ resplandor\ \[4K\ UHDrip\]\[2160p\]\[HDR\]\[AC3\ 5.1-Castellano\ AC3\ 5.1-Ingles+Subs\]\[ES-EN\]/El\ resplandor\ 4Krip2160.www.pctnew.org.mkv -vf scale=1920x1080 resplandor1080.mkv
ffmpeg -i /var/media/Cine/torrent/fin/El\ resplandor\ \[4K\ UHDrip\]\[2160p\]\[HDR\]\[AC3\ 5.1-Castellano\ AC3\ 5.1-Ingles+Subs\]\[ES-EN\]/El\ resplandor\ 4Krip2160.www.pctnew.org.mkv -s 1920x1080 -c:a copy resplandor1080p.mkv

