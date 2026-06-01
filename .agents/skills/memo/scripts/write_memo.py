#!/usr/bin/env python3
"""Write a memo Markdown file under $HOME/wiki/raw/memo."""

from __future__ import annotations

import argparse
import datetime as dt
import os
import re
import sys
import unicodedata
from pathlib import Path


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Write a memo Markdown file.")
    parser.add_argument("--title-summary", required=True, help="Short memo title or topic.")
    parser.add_argument("--input", default="", help="Original memo text.")
    parser.add_argument("--input-file", help="Read original memo text from a file.")
    parser.add_argument("--answer", default="", help="Answer text for questions in the memo.")
    parser.add_argument("--enrichment", default="", help="Supplemental business memo content.")
    parser.add_argument("--next-actions", default="", help="Next actions to record.")
    parser.add_argument("--unknowns", default="", help="Unknowns or open questions.")
    parser.add_argument("--tags", default="memo", help="Comma-separated tags.")
    return parser.parse_args()


def read_input(args: argparse.Namespace) -> str:
    if args.input_file:
        return Path(args.input_file).read_text(encoding="utf-8").strip()
    if args.input:
        return args.input.strip()
    if not sys.stdin.isatty():
        return sys.stdin.read().strip()
    return ""


def slugify(value: str) -> str:
    normalized = unicodedata.normalize("NFKD", value)
    ascii_text = normalized.encode("ascii", "ignore").decode("ascii")
    slug = re.sub(r"[^a-zA-Z0-9]+", "-", ascii_text).strip("-").lower()
    return slug[:60].strip("-") or "memo"


def yaml_quote(value: str) -> str:
    escaped = value.replace("\\", "\\\\").replace('"', '\\"')
    return f'"{escaped}"'


def normalize_tags(value: str) -> list[str]:
    tags = []
    for raw_tag in value.split(","):
        tag = raw_tag.strip()
        if tag and tag not in tags:
            tags.append(tag)
    if "memo" not in tags:
        tags.insert(0, "memo")
    return tags


def next_available_path(directory: Path, stem: str) -> Path:
    path = directory / f"{stem}.md"
    if not path.exists():
        return path

    index = 2
    while True:
        candidate = directory / f"{stem}_{index}.md"
        if not candidate.exists():
            return candidate
        index += 1


def section(title: str, body: str) -> str:
    content = body.strip()
    if not content:
        return ""
    return f"## {title}\n\n{content}\n"


def build_markdown(
    *,
    title: str,
    now: dt.datetime,
    tags: list[str],
    original: str,
    answer: str,
    enrichment: str,
    next_actions: str,
    unknowns: str,
) -> str:
    date = now.strftime("%Y-%m-%d")
    created_at = now.isoformat(timespec="minutes")
    tag_lines = "\n".join(f"  - {tag}" for tag in tags)
    frontmatter = "\n".join(
        [
            "---",
            f"title: {yaml_quote(title)}",
            f"date: {yaml_quote(date)}",
            f"created_at: {yaml_quote(created_at)}",
            'source: "memo"',
            "recorded: false",
            "tags:",
            tag_lines,
            "---",
            "",
        ]
    )

    sections = [
        section("原文", original),
        section("回答", answer),
        section("補完メモ", enrichment),
        section("次アクション", next_actions),
        section("未確認事項", unknowns),
    ]
    body = "\n".join(part for part in sections if part).rstrip() + "\n"
    return frontmatter + body


def main() -> int:
    args = parse_args()
    original = read_input(args)
    if not original:
        print("error: memo input is empty", file=sys.stderr)
        return 2

    now = dt.datetime.now().astimezone()
    year = now.strftime("%Y")
    month = now.strftime("%m")
    timestamp = now.strftime("%Y%m%d-%H%M")
    title = args.title_summary.strip() or "memo"
    summary = slugify(title)

    memo_dir = Path(os.environ["HOME"]) / "wiki" / "raw" / "memo" / year / month
    memo_dir.mkdir(parents=True, exist_ok=True)
    path = next_available_path(memo_dir, f"{timestamp}_{summary}")
    markdown = build_markdown(
        title=title,
        now=now,
        tags=normalize_tags(args.tags),
        original=original,
        answer=args.answer,
        enrichment=args.enrichment,
        next_actions=args.next_actions,
        unknowns=args.unknowns,
    )
    path.write_text(markdown, encoding="utf-8")
    print(path)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
