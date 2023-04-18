#! /usr/bin/env python3
""" Script to interactively install packages used"""

import subprocess
import argparse
import readline


ITEMS = [
    ('brew',
     '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'),
    ('tmux', 'brew install tmux'),
    ('nvim', 'brew install nvim'),
]


def prefill_response(prompt, prefill):
    """ Adds the last response when prompting to copy files over"""

    def hook():
        readline.insert_text(prefill)
        readline.redisplay()

    readline.set_pre_input_hook(hook)
    result = input(prompt)
    readline.set_pre_input_hook()
    return result.strip().lower()


def prompt_for_install(name: str, cmd: str, force: bool):
    """ logic for installing a resource"""

    exists = subprocess.run(['command', '-v', '{name}']).returncode == 0
    link = force or not exists
    should_copy = ""
    if link:
        prompt = f"install {name} [y/N\u0332]? "
        opts = ["", "y", "yes", "n", "no"]

        while (should_copy := prefill_response(prompt, should_copy)) not in opts:
            pass

        link = should_copy in ["y", "yes"]

    if link:
        print(f"...installing {name}")
        print(cmd)
        subprocess.run(cmd, shell=True, check=True)


def do_installs(force: bool):
    """copy all files from the 'home' directory to  ~/"""
    for (name, cmd) in ITEMS:
        prompt_for_install(name, cmd, force)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Copy dotfile symlinks to ~/. directory")
    parser.add_argument("--force", action="store_true", help="Do not ask when overwriting files")

    args = parser.parse_args()

    do_installs(args.force)
