#!/usr/bin/python3

import argparse
import os
import subprocess
import traceback
from functools import cache

from i3ipc import Connection, Event


def run_or_die(cmd: str, msg=""):
    rc = subprocess.run(
        ["/bin/sh", "-c", cmd], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
    ).returncode

    if rc != 0:
        raise Exception(msg)


@cache
def read_file_cached(filepath: str):
    content = ""
    with open(filepath, "r") as file:
        content = file.read()
    return content


def find_sway_ipc_path() -> str:
    for root, _, files in os.walk("/run/user/"):
        for file in files:
            if "sway-ipc" in file:
                return os.path.join(root, file)
    raise Exception("Cannot find sway socket under /run/user/")


def activate_keyd_include(filepaths: list[str], writes: list[str]):
    for filepath in filepaths:
        content = read_file_cached(filepath)
        with open(filepath, "w") as file:
            file.write(content + "\n".join(writes))


def deactivate_keyd_include(filepaths: list[str]):
    for filepath in filepaths:
        with open(filepath, "w") as file:
            # content will be cached at first call, so no need to modify it
            file.write(read_file_cached(filepath))


def subscribe_sway(
    config: list[str], apps: list[str], titles: list[str], writes: list[str]
):
    if len(config) == 0:
        raise Exception("Error: No keyd config specified")
    if len(apps) == 0 and len(titles) == 0:
        raise Exception("Error: No applications or titles specified.")
    if len(writes) == 0:
        raise Exception("Error: No appending config specified")

    def on_window_focus(i3: Connection, _):
        focused = i3.get_tree().find_focused()
        if not focused:  # some applications like bemenu, this check is needed.
            return
        app_name = focused.app_id or focused.window_class  # pyright: ignore
        title = focused.window_title or focused.name  # pyright: ignore
        if args.verbose:
            print(f"Active window: {app_name}|{title}")
        if app_name in apps or title in titles:
            activate_keyd_include(config, writes)
        else:
            deactivate_keyd_include(config)
        rc = subprocess.run(
            ["keyd", "reload"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
        ).returncode
        if rc != 0:
            raise Exception("Failed to reload keyd. Hint: `gpasswd -a $USER keyd`")

    try:
        sway = Connection(find_sway_ipc_path())
        sway.on(Event.WINDOW_FOCUS, on_window_focus)
        sway.main()
    except:
        print(
            "Warning: Couldn't connect to Sway and  fallback to apply all applications. Is sway running?"
        )
        print(traceback.format_exc())


opt = argparse.ArgumentParser()
opt.add_argument(
    "-v",
    "--verbose",
    default=False,
    action="store_true",
    help="Log the active window (useful for discovering window and class names)",
)
opt.add_argument(
    "-a",
    "--apps",
    nargs="+",
    default=[],
    help="Application to apply",
)
opt.add_argument(
    "-t",
    "--titles",
    nargs="+",
    default=[],
    help="Title to apply",
)
opt.add_argument(
    "-c",
    "--config",
    nargs="+",
    default=[],
    help="Keyd config file to modify on window focus change",
)
opt.add_argument(
    "-w",
    "--writes",
    nargs="+",
    default=[],
    help="Keyd config to append on window focus change",
)


args = opt.parse_args()


subscribe_sway(args.config, args.apps, args.titles, args.writes)
