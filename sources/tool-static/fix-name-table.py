import sys
import re
import unicodedata
import os
import fontTools.ttLib
from fontbakery.parse import style_parse

file = sys.argv[1]
ttFont = fontTools.ttLib.TTFont(file)


RIBBI_style = [
    "Regular",
    "Italic",
    "Bold",
    "BoldItalic"
]







if file.split("-")[-1].split(".")[0] not in RIBBI_style:

    if "Italic" in file.split("-")[-1].split(".")[0]:
        newNameID1 = ttFont["name"].getDebugName(1).replace(" Italic", "")

        ttFont["name"].setName(string=newNameID1,  nameID=1,
                               platformID=3, platEncID=1, langID=0x409)

        ttFont["name"].setName(string="Italic",  nameID=2,
                               platformID=3, platEncID=1, langID=0x409)


ttFont.save(file)