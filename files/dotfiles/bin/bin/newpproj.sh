#!/usr/bin/env bash
poetry new "$1"
cat <<EOF >"$1/mise.toml"
[tools]
poetry = { version = "latest", pyproject = "{{ config_root }}/pyproject.toml" }
python = "3.12"
EOF
mise trust "$1/mise.toml"
cd "$1" || exit
poetry add --group=dev pytest pytest-bdd pytest-cov graphifyy
rm -rf .venv
cd ..
mise cache clear
cd "$1" || exit
