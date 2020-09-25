# Newsreader statics builder

# ----------------------------------------------------------------- #
# Dependencies:
# - python3
# - fontmake: https://github.com/googlefonts/fontmake
# - fonttools: https://github.com/fonttools/fonttools
# - ttfautohint: https://www.freetype.org/ttfautohint
# - gftools: https://github.com/googlefonts/gftools
# - sfnt2woff: https://github.com/kseo/sfnt2woff
# - woff2_compress: https://github.com/google/woff2
# ----------------------------------------------------------------- #


# Fail fast
set -e

echo "Building static TTFs"
rm -rf ../fonts/static/ttf/*.ttf
fontmake -m NewsreaderStatic-upright.designspace -o ttf -i -a --output-dir ../fonts/static/ttf --expand-features-to-instances
fontmake -m NewsreaderStatic-italics.designspace -o ttf -i -a --output-dir ../fonts/static/ttf --expand-features-to-instances


# Post generate static TTFs
echo "Post generate TTFs"
sh ./tool-static/post_generate_static-ttf.sh


# # Build web fonts
echo "Export webfonts"
sh ./tool-static/export-webfont.sh


# Delete instances, we don't need them. If you need to look at instances, comment-out this line and repeat
rm -r instances
