#!/usr/bin/env python

from pathlib import Path
import os

import ska_tango_images as sti
from ska_tango_images import REPO_DIR

def apply_substitutions(subs, line):
    for key, value in subs.items():
        line = line.replace(f'|{key}|', value)
        if '|' not in line:
            break

    return line

def main():
    subs = sti.get_doc_substitutions()

    indir = Path(f'{REPO_DIR}/docs/templates')
    outdir = Path(f'{REPO_DIR}/docs/gen')
    for root, dirs, files in os.walk(indir):
        inroot = Path(root)
        path = inroot.relative_to(indir)
        outroot = outdir / path
        os.makedirs(outroot, exist_ok=True)

        for file in files:
            with open(inroot / file, "r") as i, open(outroot / file, "w") as o:
                for line in i.readlines():
                    if '|' in line:
                        line = apply_substitutions(subs, line)

                    print(line, file=o, end='')


if __name__ == '__main__':
    main()
