# Export webfonts

path="../fonts/static/ttf"
webfont_metadata="./webfont_metadata.xml"


for i in $path/*.ttf; do
    file_name=`basename $i`
    file_name="${file_name%.ttf}"
    echo "Export "$file_name.woff

    sfnt2woff -m $webfont_metadata $i
    woff2_compress $i
done


mkdir -p ../fonts/static/woff
mkdir -p ../fonts/static/woff2

for i in ../fonts/static/ttf/*.woff ; do mv $i ../fonts/static/woff/`basename $i` ; done
for i in ../fonts/static/ttf/*.woff2 ; do mv $i ../fonts/static/woff2/`basename $i` ; done
