#!/usr/bin/env bash
poetry new "$1"
cat <<EOF >"$1/mise.toml"
[tools]
python = "3.14.3"
poetry = "latest"

[env]
_.python.venv = "{{ config_root }}/.venv"

[hooks]
enter = """
if [ -f "{{ config_root }}/poetry.lock" ] && [ ! -d "{{ config_root }}/.venv" ]; then
  echo "mise: No .venv found. Bootstrapping with poetry install..."
  mise exec poetry -- poetry install
fi
"""
EOF
mise trust "$1/mise.toml"
cd "$1" || exit
poetry add --group=dev pytest pytest-bdd pytest-cov graphifyy
rm -rf .venv
cd ..
mise cache clear
cd "$1" || exit
