import os
from fontTools.ttLib import TTFont
import sys
from ntpath import basename

STYLES = [
    "Thin",
    "ExtraLight",
    "Extralight",
    "SemiLight",
    "Light",
    "Regular",
    "Medium",
    "SemiBold",
    "Semibold",
    "Bold",
    "ExtraBold",
    "Extrabold",
    "Black",
    "VF Beta",
]

WEIGHTS = {
    "Thin": 250,
    "ExtraLight": 275,
    "Extralight": 275,
    "SemiLight": 275,
    "Light": 300,
    "Regular": 400,
    "Italic": 400,
    "Medium": 500,
    "SemiBold": 600,
    "Semibold": 600,
    "Bold": 700,
    "ExtraBold": 800,
    "Extrabold": 800,
    "Black": 900,
    "VF Beta": 400,
}

FSTYPE = 0




def get_macstyle(filename):
    """Infer the macstyle from a font's filename"""
    bold, italic = parse_metadata(filename)
    mac_style = (italic << 1) | bold
    return mac_style


def get_fsselection(ttfont, filename):
    """Infer the fsSelection bit from a font and its filename"""
    bold, italic = parse_metadata(filename)

    fsselection = ((bold << 5) | italic) or (1 << 6)
    if italic:
        fsselection |= 1
    # check use_typo_metrics is enabled
    if 0b10000000 & ttfont['OS/2'].fsSelection:
        fsselection |= 128
    return fsselection


def get_weightclass(filename):
    """Infer the OS/2 usweightClass from filename"""
    font_style = filename[:-4].split('-')[-1]
    if font_style == 'Italic':
        return 400
    font_weight = font_style.replace('Italic', '')
    for weight in STYLES:
        if weight == font_weight:
            return WEIGHTS[weight]
    return None


def parse_metadata(filename):
        """Parse font name to infer weight and slope."""
        font_name = filename[:-4]
        style_name = font_name.split('-')[-1]

        italic = 'Italic' in style_name
        bold = 'Bold' == style_name or 'BoldItalic' == style_name
        return bold, italic

def fix_font(font_path, dest):
    """Fix fonts attribs to match GF Spec"""
    font = TTFont(font_path)
    font_filename = basename(font_path)
    dest_path = os.path.join(dest, font_filename)

    font['OS/2'].fsSelection = get_fsselection(font, font_path)
    font['head'].macStyle = get_macstyle(font_path)
    font['OS/2'].usWeightClass = get_weightclass(font_path)
    font['OS/2'].fsType = FSTYPE
    font.save(font_path)

font_path = sys.argv[1]
fix_font(font_path, font_path)
