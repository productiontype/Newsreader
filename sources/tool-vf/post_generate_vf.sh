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

# Fix name table
for i in ${path}/*.ttf
do
    for j in ./tool-vf/name/*.ttx; do
        temp_ttf=`basename $i`
        temp_ttx=`basename $j`

        ttf_file="${temp_ttf%.ttf}"
        ttx_file="${temp_ttx%.ttx}"

        if [ $ttf_file = $ttx_file ]
        then
            echo "Fix name table for $temp_ttf" 
            ttx -d $path -f -m $i $j

        fi
    done
done

# Fix name tables
for i in $path/*.ttf; do
    python ./tool-vf/fixNameTable.py $i
done


