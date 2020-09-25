# #!/bin/bash
# set -e

path="../fonts/variable/ttf"


echo "Adding STAT table to Newsreader-VF.ttf ..."
statmake --designspace NewsreaderVF-upright.designspace "$path/Newsreader[opsz,wght].ttf"

echo "Adding STAT table to Newsreader-italics-VF.ttf ..."
statmake --designspace NewsreaderVF-italics.designspace "$path/Newsreader-Italic[opsz,wght].ttf"


# Add DSIG table
gftools-fix-dsig.py $path/*.ttf -a -f

# Add GASP table
gftools-fix-gasp.py $path/*.ttf --autofix
rm $path/*.ttf
for i in $path/*.fix ; do mv $i $path/$(basename -s .fix $i) ; done

# Fix fstype table
gftools-fix-fstype.py $path/*.ttf
# rm *.ttf
for i in $path/*.fix ; do mv $i $path/$(basename -s .fix $i) ; done

# Fix PPEM rounding
for i in $path/*.ttf; do
    echo "Setting $i PPEM rounding ..."
    gftools fix-nonhinting $i $i.fix
done
for i in $path/*.fix ; do mv $i $path/$(basename -s .fix $i) ; done

# Remove unwanted tables
for i in $path/*.ttf; do
    echo "Setting $i PPEM rounding ..."
    gftools-fix-unwanted-tables.py $i
done
rm $path/*backup*.ttf

# Fix name tables
for i in $path/*.ttf; do
    python3 ./tool-vf/fixNameTable.py $i
done

# Add stat table
python3 ./tool-vf/gen_stat.py

