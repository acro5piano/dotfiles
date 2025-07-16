#!/usr/bin/env python


import re

def imgs_to_table(img_lines: str) -> str:
    """
    Convert multiple <img ... /> lines into a single HTML table row,
    and add an empty <tr> above for future insertion.

    Args:
        img_lines (str): Multiline string with <img ... /> tags, one per line.

    Returns:
        str: HTML table with one empty row and one row of images.
    """
    # Only keep lines that look like <img ... />
    img_tag_pattern = re.compile(r'^\s*<img\b[^>]*\/?>\s*$', re.IGNORECASE)
    imgs = [
        line.strip()
        for line in img_lines.strip().splitlines()
        if img_tag_pattern.match(line.strip())
    ]
    empty_tds = ["        <td></td>" for _ in imgs]
    img_tds = ["        <td>{}</td>".format(img) for img in imgs]
    table = (
        "<table>\n"
        "    <tr>\n"
        + "\n".join(empty_tds)
        + "\n    </tr>\n"
        "    <tr>\n"
        + "\n".join(img_tds)
        + "\n    </tr>\n"
        "</table>"
    )
    return table


if __name__ == "__main__":
    import sys

    input_data = sys.stdin.read()
    html_table = imgs_to_table(input_data)
    print(html_table)
