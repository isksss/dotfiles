#!/usr/bin/env python3
"""Print a Markdown relative link between two wiki files."""

from __future__ import annotations

import argparse
import os
from pathlib import Path


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Create a relative Markdown link.")
    parser.add_argument("--from", dest="from_path", required=True, help="Source note file path.")
    parser.add_argument("--to", dest="to_path", required=True, help="Target file path.")
    parser.add_argument("--text", help="Optional Markdown link text.")
    return parser.parse_args()


def expand(path: str) -> Path:
    return Path(os.path.expandvars(os.path.expanduser(path))).resolve()


def main() -> int:
    args = parse_args()
    source = expand(args.from_path)
    target = expand(args.to_path)
    base_dir = source.parent if source.suffix else source
    relative = os.path.relpath(target, base_dir)
    text = args.text or target.stem
    print(f"[{text}]({relative})")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
