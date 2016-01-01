@echo off
setlocal enabledelayedexpansion

set current_path=%~dp0
set preset_path=%current_path%convertVideo.avs

for %%F in (*.avi) do (
  set avi_path=%%~nF
  xcopy "%preset_path%" "%current_path%!avi_path!.avs*"
  ffmpeg -i "!avi_path!.avi" -i "!avi_path!.avs" -c:v libx264 -preset slow -crf 22 -map 1:0 -filter_complex "[0:1][0:2] amerge=inputs=2" -c:a aac "!avi_path!.mp4"
  del "!avi_path!.avs"
)
