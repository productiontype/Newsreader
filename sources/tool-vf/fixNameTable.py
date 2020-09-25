import sys
import re
import unicodedata
import os
import fontTools.ttLib
from fontbakery.parse import style_parse

file = sys.argv[1]
ttFont = fontTools.ttLib.TTFont(file)


# Variable Font
if 'fvar' in ttFont:

    # Sub family name
    for name in ttFont['name'].names:
        if name.nameID == 2:
            name.string = style_parse(ttFont).win_style_name
        if name.nameID == 17:
            name.string = style_parse(ttFont).win_style_name

    # macStyle & fsSelection
    if '-Italic' in file:
        ttFont['head'].macStyle |= 1 << 1  # Set  bit 1
        ttFont['OS/2'].fsSelection |= 1 << 0  # Set bit 0 (Italic)
        # Unset bit 5 (Bold)
        ttFont['OS/2'].fsSelection = ttFont['OS/2'].fsSelection & ~(1 << 5)
        # Unset bit 6 (Regular)
        ttFont['OS/2'].fsSelection = ttFont['OS/2'].fsSelection & ~(1 << 6)



ttFont.save(file)
