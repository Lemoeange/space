import glob
import sys
from fontTools.subset import main as subset_main

# 字体：站酷庆科黄油体（ZCOOL QingKe HuangYou），即「黄油体」
# 文件名沿用原始字体命名，此处仅做子集化拆分
SRC = "assets/fonts/ZCOOLQingKeHuangYou-Regular.ttf"

def charset():
    chars = set()
    for name in glob.glob("*.html"):
        try:
            html = open(name, encoding="utf-8").read()
            chars.update(c for c in html if not c.isspace() and ord(c) < 0xFFFF)
        except OSError:
            pass
    return "".join(sorted(chars))

def run(output, flavor):
    args = [
        SRC,
        "--text=" + charset(),
        "--layout-features=*",
        "--glyph-names",
        "--symbol-cmap",
        "--legacy-cmap",
        "--notdef-glyph",
        "--name-IDs=*",
        "--name-legacy",
        "--name-languages=*",
        "--output-file=" + output,
    ]
    if flavor:
        args.append("--flavor=" + flavor)
    subset_main(args)

run("assets/fonts/ZCOOLQingKeHuangYou-subset.woff2", "woff2")
run("assets/fonts/ZCOOLQingKeHuangYou-subset.woff", "woff")
run("assets/fonts/ZCOOLQingKeHuangYou-subset.ttf", None)
print("done")
