#!/usr/bin/env python3

from pathlib import Path
import re
import subprocess

PATTERN = re.compile(
    r"^\\documentclass\[?([^\]]*)\]?\{acAssignment\}", re.MULTILINE)

for tex_file in Path(".").iterdir():
    if (
        not tex_file.name.endswith(".tex") or
        tex_file.name.endswith("-solution.tex") or
        tex_file.name == "acAssignment.tex"
    ):
        continue

    tex_file_solution = (
        tex_file.parent / (tex_file.name.replace(".tex", "-solution.tex"))
    )
    
    contents = tex_file.read_text(encoding="UTF-8")
    match = PATTERN.search(contents)
    if not match:
        continue
    
    options = [
        option.strip()
        for option in match.group(1).split(",")
        if option.strip()
    ]
    options.append("solution")
    options_str = ", ".join(options)

    documentclass_str = rf"\\documentclass[{options_str}]{{acAssignment}}"
    contents_solution = PATTERN.sub(documentclass_str, contents)

    if (
        tex_file_solution.exists() and
        tex_file_solution.read_text(encoding="UTF-8") == contents_solution
    ):
        continue

    tex_file_solution.write_text(contents_solution, encoding="UTF-8")

subprocess.call(["latexmk"])
