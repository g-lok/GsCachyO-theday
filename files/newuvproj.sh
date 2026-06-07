#!/usr/bin/env bash
set -e

PROJECT_NAME="$1"

if [ -z "$PROJECT_NAME" ]; then
    echo "Usage: $0 <project-name>"
    exit 1
fi

# Use mise shim for uv
UV=~/.local/share/mise/shims/uv

# Create project with uv
$UV init "$PROJECT_NAME"
cd "$PROJECT_NAME"

# Create mise.toml with uv and python - use uv_venv_auto for uv projects
cat <<'EOF' > mise.toml
[tools]
uv = "latest"
python = "3.14.3"

[env]
_.python.venv = { path = ".venv", create = true }

[settings]
python.uv_venv_auto = "create|source"
EOF

# Trust the config
mise trust mise.toml

# Create .venv and install dev dependencies
$UV venv --clear
source .venv/bin/activate

# Add dev dependencies
$UV add --dev pytest pytest-cov pytest-bdd graphifyy

# Deactivate (mise will handle activation)
deactivate 2>/dev/null || true

echo "Project $PROJECT_NAME created with uv + mise .venv auto-activation"
echo "Run: cd $PROJECT_NAME"
