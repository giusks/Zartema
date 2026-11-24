#!/usr/bin/env bash
set -e

BASEDIR="$(pwd -P)"

changelog() {
    local base
    base="$(git ls-tree HEAD "$1" | cut -d' ' -f3 | cut -f1)"
    cd "$1" && git log --oneline "${base}...HEAD"
}

waterfall="$(changelog Waterfall)"

updated=""
logsuffix=""
if [ -n "$waterfall" ]; then
    logsuffix="\n\nWaterfall Changes:\n$waterfall"
    if [ -z "$updated" ]; then
        updated="Waterfall"
    else
        updated="$updated/Waterfall"
    fi
fi

disclaimer="Upstream has released updates that appears to apply and compile correctly."
if [ -n "$1" ]; then
    disclaimer="$@"
fi

log="${UP_LOG_PREFIX}Updated Upstream ($updated)\n\n${disclaimer}${logsuffix}"
echo -e "$log" | git commit -F -
