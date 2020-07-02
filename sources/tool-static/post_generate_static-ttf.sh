# Post generate static TTFs

path="../fonts/static/ttf"

# Hinting
for i in $path/*.ttf; do
    echo "Hinting $i"
    ttfautohint -i -n -f latn $i ${i}.hinted
done
for i in $path/*.hinted ; do mv $i ${i//.hinted/} ; done

# Add DSIG table
gftools-fix-dsig.py $path/*.ttf -a -f

# Add GASP table
 gftools-fix-gasp.py $path/*.ttf --autofix
rm $path/*.ttf
for i in $path/*.fix ; do mv $i ${i//.fix/} ; done

# Fix fstype table
gftools fix-fstype $path/*.ttf
rm $path/*.ttf
for i in $path/*.fix ; do mv $i ${i//.fix/} ; done

# Fix PPEM rounding
for i in $path/*.ttf; do
    echo "Setting $i PPEM rounding ..."
    gftools-fix-hinting.py $i
done
for i in $path/*.fix ; do mv $i ${i//.fix/} ; done

# Fix OS/2 & head tables
for i in ${path}/*.ttf; do
    echo "Fix OS/2 & head table for" `basename $i`
    python3 ./tool-static/fix-font-info.py $i
done

# Fix name table
for i in ${path}/*.ttf
do
    for j in ./tool-static/name/*.ttx; do
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
