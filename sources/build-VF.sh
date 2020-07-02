# Build variable fonts

fontpath="../fonts/variable/ttf"

mkdir -p $fontpath
rm -r $fontpath/*.ttf

# Fail fast
set -e

fontmake -m NewsreaderVF-upright.designspace -o variable --output-path "$fontpath/Newsreader[opsz,wght].ttf"
fontmake -m NewsreaderVF-italics.designspace -o variable --output-path "$fontpath/Newsreader-Italic[opsz,wght].ttf"

echo "Post generate vf"
echo $PWD
sh tool-vf/post_generate_vf.sh

echo "Export webfonts"
sh tool-vf/export-webfont.sh
