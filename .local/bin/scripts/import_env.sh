#!/usr/bin/env bash
systemctl --user import-environment
systemctl --user start user-graphical-login.target
