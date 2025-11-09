#!/usr/bin/env bash

brew info --json=v2 --installed |
  jq -r '.formulae[] | [.name, .installed[0].time] | @tsv' |
  while IFS=$'\t' read -r name epoch; do
    if [ "$epoch" != "null" ]; then
      date_str=$(date -r "$epoch" "+%Y-%m-%d %H:%M:%S")
    else
      date_str="unknown"
    fi
    printf "%-30s %s\n" "$name" "$date_str"
  done | sort -k2
