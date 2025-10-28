# 1 = yt video id
# 2 = start (second)
# 3 = end (second) 
# 4 = output gif name

out="$HOME/Videos/gifs"

echo "downloading file from youtube..."
yt-dlp \
    --download-sections "*$2-$3" \
    $1 -o "$out/temp.mp4" \
    -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best" \

echo "converting to gif..."
ffmpeg \
    -i "$out/temp.mp4" \
    -vf "fps=15,scale=360:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" \
    "$out/$4.gif"

echo "removing temp file: $out/temp.mp4..."
rm "$out/temp.mp4"

