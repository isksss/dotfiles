#!/bin/bash
if ! command -v mise >/dev/null; then
    curl https://mise.run | sh
fi
