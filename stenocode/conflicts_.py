#!/usr/bin/python
"""Find conflicts in your Plover dictionaries

Supports JSON-JSON and JSON-Python comparisons.

Adapted from:
https://discord.com/channels/136953735426473984/136953735426473984/835164920437538848


Usage:
    `python conflicts.py [-h] [--all] [ignore ...]`

    positional arguments:
    ignore      paths of dictionaries to ignore

    optional arguments:
    -h, --help  show this help message and exit
    --all       compare all registered dictionaries, not just enabled
"""

from collections import defaultdict
import functools, json, glob, runpy, configparser, os, argparse
from plover.oslayer.config import CONFIG_FILE, CONFIG_DIR


def prepare(enabled_only=True, ignore=[]):
    config = configparser.ConfigParser()
    config.read(CONFIG_FILE)

    dictionaries = set(
        [
            os.path.join(CONFIG_DIR, d["path"])
            for d in json.loads(config["System: English Stenotype"]["dictionaries"])
            if not (enabled_only and not d["enabled"])
        ]
    )
    dictionaries = dictionaries - set(ignore)

    json_dictionaries = [d for d in dictionaries if os.path.splitext(d)[1] == ".json"]
    python_dictionaries = [d for d in dictionaries if os.path.splitext(d)[1] == ".py"]

    ds = list(
        map(
            lambda f: {k: (v, f) for k, v in json.load(open(f)).items()},
            json_dictionaries,
        )
    )
    first = defaultdict(list)
    first.update({k: [v] for k, v in ds[0].items()})

    def _join(a, b):
        for k, v in b.items():
            a[k].append(v)
        return a

    json_merged = functools.reduce(_join, ds[1:], first)
    python_lookups = [
        (runpy.run_path(path)["lookup"], path) for path in python_dictionaries
    ]

    return json_merged, python_lookups


def print_conflicts(stroke, conflicts):
    if conflicts:
        #print(f"'{stroke}':{conficts[1][0]}")
        for c in conflicts:
            print(f"@+{stroke}@: @{c[0]}@,")


def check_strokes_conflicts(json_merged, python_lookups, strokes):
    for stroke in strokes:
        conflicts = json_merged.get(stroke, [])
        for lookup, name in python_lookups:
            try:
                result = (lookup(tuple(stroke.split("/"))), name)
                conflicts.append(result)
            except Exception:
                pass

        print_conflicts(stroke, conflicts)


def check_lookup_conflicts(json_merged, python_lookups, lookup):
    for stroke, v in json_merged.items():
        conflicts = v

        try:
            result = (lookup(tuple(stroke.split("/"))), __file__)
            conflicts.append(result)

            # other python dictionaries
            for p_lookup, name in python_lookups:
                try:
                    result = (p_lookup(tuple(stroke.split("/"))), name)
                    conflicts.append(result)
                except Exception:
                    pass

            print_conflicts(stroke, conflicts)
        except Exception:
            pass


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Find conflicts in your Plover dictionaries"
    )
    parser.add_argument(
        "--all",
        help="compare all registered dictionaries, not just enabled",
        action="store_true",
    )
    parser.add_argument("ignore", help="paths of dictionaries to ignore", nargs="*")
    args = parser.parse_args()

    print(args)
    print([os.path.abspath(path) for path in args.ignore])

    json_merged, python_lookups = prepare(
        enabled_only=(not args.all),
        ignore=[os.path.abspath(path) for path in args.ignore],
    )

    for stroke, v in json_merged.items():
        conflicts = v
        for lookup, name in python_lookups:
            try:
                result = (lookup(tuple(stroke.split("/"))), name)
                conflicts.append(result)
            except Exception:
                pass

        if len(conflicts) > 1:
            print_conflicts(stroke, conflicts)
