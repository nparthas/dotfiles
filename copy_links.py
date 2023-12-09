#! /usr/bin/env python3
""" Script to interactively copy over dotfiles kept in this repo"""

import argparse
import filecmp
import os
import readline
import sys


blacklist = [".DS_Store"]


def prefill_response(prompt, prefill):
    """ Adds the last response when prompting to copy files over"""

    def hook():
        readline.insert_text(prefill)
        readline.redisplay()

    readline.set_pre_input_hook(hook)
    result = input(prompt)
    readline.set_pre_input_hook()
    return result.strip().lower()


def do_copy(full_src: str, full_dst: str, force: bool):
    """ logic for copying an individual file"""
    # if we've already linked return early
    if os.path.islink(full_dst) and os.readlink(full_dst) == full_src:
        print(f'{full_dst} already linked, skipping...')
        return

    link = force or not os.path.exists(full_dst)
    should_copy = ""
    if os.path.exists(full_dst) and not force:
        differs = ""
        if filecmp.cmp(full_src, full_dst):
            differs = " (files match)"
        prompt = f"Path {full_dst} exists{differs}, overwrite [y/N\u0332/diff]? "
        opts = ["", "y", "yes", "n", "no"]

        while (should_copy := prefill_response(prompt, should_copy)) not in opts:
            if should_copy == "diff":
                os.system(f"diff -bur {full_src} {full_dst} | less")
                # remove the last line and remove prefill if we do a diff
                sys.stdout.write("\x1b[1A")
                sys.stdout.write("\x1b[2K")
                should_copy = ""

        link = should_copy in ["y", "yes"]

    if link:
        print(f"...linking {full_src} --> {full_dst}")
        if os.path.exists(full_dst):
            print(full_dst)
            os.remove(full_dst)

        os.symlink(full_src, full_dst)


def fetch_submodules():
    """initialize all the submodules so we can copy them over"""
    os.system("git submodule update --init --recursive")

    # also deal with nvchad custom files via hard link
    src = os.path.abspath("home/.config/nvim_custom")
    dst = os.path.abspath("home/.config/nvim/lua/custom")

    os.makedirs(dst, exist_ok=True)
    for file in os.listdir(src):
        s = os.path.join(src, file)
        d = os.path.join(dst, file)
        if os.path.exists(d):
            print(f"rm {d}")
            os.system(f"rm {d}")

        print(f"ln {s} {d}")
        os.system(f"ln {s} {d}")


def copy_dotfiles(force: bool):
    """copy all files from the 'home' directory to  ~/"""
    src = os.path.abspath("home")
    dst = os.path.expanduser("~")

    print("Creating symlinks...")
    # save the last response for enter spamming choices
    for (dirpath, dirnames, filenames) in os.walk(src):
        # creates folders if they're missing since we only symlink files
        for dirname in dirnames:
            dst_dir = os.path.join(dirpath.replace(src, dst), dirname)
            if not os.path.exists(dst_dir):
                os.makedirs(dst_dir)
            elif not os.path.isdir(dst_dir):
                print("Non-dir path at: {dst_dir}, requires manual audit")
                sys.exit(1)

        for filename in filenames:
            if filename in blacklist:
                continue

            full_src = os.path.join(dirpath, filename)
            full_dst = os.path.join(dirpath.replace(src, dst), filename)
            do_copy(full_src, full_dst, force)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Copy dotfile symlinks to ~/. directory")
    parser.add_argument("--force", action="store_true", help="Do not ask when overwriting files")

    args = parser.parse_args()

    fetch_submodules()
    copy_dotfiles(args.force)
