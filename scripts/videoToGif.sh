# 1 = yt video id
# 2 = start (second)
# 3 = end (second) 
# 4 = output gif name

out="$HOME/Videos/gifs"

echo "[videoToGif.sh] Downloading file from youtube..."
yt-dlp \
    --download-sections "*$2-$3" \
    $1 -o "$out/temp.mp4" \
    -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best" \

crop=$(ffmpeg -i $out/temp.mp4 -vf cropdetect -f null - 2>&1 | grep "crop=" | tail -n 1 | sed -E 's/.*crop=([0-9:]+).*/\1/')
echo "Crop detected: $crop"

echo "[videoToGif.sh] Converting to gif..."
ffmpeg \
    -i "$out/temp.mp4" \
    -aspect 4:3 \
    -vf "fps=15,crop=$crop,scale=480:-1:flags=lanczos,split[s0][s1];[s0]palettegen=max_colors=128:stats_mode=diff[p];[s1][p]paletteuse=dither=bayer:bayer_scale=5:diff_mode=rectangle" \
    "$out/$4.gif"

echo "removing temp file: $out/temp.mp4..."
rm "$out/temp.mp4"

echo "[videoToGif.sh] $out/$4.gif created sucessfully"
FILESIZE=$(( $(stat -c%s "$out/$4.gif") / 1000000))
echo "[videoToGif.sh] Size: $FILESIZE MB / Aspect Ratio: 4:3 / fps: 15"

# Requisites: ffmpeg, yt-dlp
# Usage: ./videoToGif.sh [YT_VIDEO_ID] [START_SECONDS] [END_SECONDS] [OUTPUT_GIF_NAME]