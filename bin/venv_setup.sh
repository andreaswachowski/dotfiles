#!/usr/bin/env bash

# Source this file to setup FZF completion for some Python tools
# Use "complete | grep _fzf" to check enabled executables

type _fzf_setup_completion >/dev/null 2>&1 \
    || echo "FZF not found"  \
    && {
        for executable in pytest mypy pylint isort black
        do
            command -v $executable >/dev/null && {
              _fzf_setup_completion path $executable
            }
        done
    }
