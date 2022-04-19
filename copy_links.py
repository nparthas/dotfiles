#! /usr/bin/env python3

import argparse
import filecmp
import os
import readline
import sys

blacklist = [".DS_Store"]


def prefill_response(prompt, prefill):

    def hook():
        readline.insert_text(prefill)
        readline.redisplay()

    readline.set_pre_input_hook(hook)
    result = input(prompt)
    readline.set_pre_input_hook()
    return result.strip().lower()


def copy_dotfiles(force: bool):
    src = os.path.abspath("home")
    dst = os.path.expanduser("~")

    print("Creating symlinks...")
    # save the last response for enter spamming choices
    should_copy = ""
    for (dirpath, dirnames, filenames) in os.walk(src):
        # creates folders if they're missing since we only symlink files
        for dirname in dirnames:
            # TODO:: handle there being a file instead of a folder
            dst_dir = os.path.join(dirpath.replace(src, dst), dirname)
            if not os.path.exists(dst_dir):
                os.makedirs(dst_dir)

        for filename in filenames:
            if filename in blacklist:
                continue

            full_src = os.path.join(dirpath, filename)
            full_dst = os.path.join(dirpath.replace(src, dst), filename)
            link = force or not os.path.exists(full_dst)
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


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Copy dotfile symlinks to ~/. directory")
    parser.add_argument("--force", action="store_true", help="Do not ask when overwriting files")

    args = parser.parse_args()

    copy_dotfiles(args.force)
