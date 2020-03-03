# Build variable fonts

path="../fonts/variable/ttf"

mkdir -p $path

fontmake -m NewsreaderVF-upright.designspace -o variable --output-path "$path/Newsreader[opsz,wght].ttf"
fontmake -m NewsreaderVF-italics.designspace -o variable --output-path "$path/Newsreader-Italic[opsz,wght].ttf"

echo "Post generate vf"
echo $PWD
sh tool-vf/post_generate_vf.sh

echo "Export webfonts"
sh tool-vf/export-webfont.sh