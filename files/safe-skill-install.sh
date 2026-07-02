#!/usr/bin/env bash
# safe-skill-install.sh - Vet and install skills with security checks
# Usage: safe-skill-install <repo> [skills-options]
#
# Examples:
#   safe-skill-install vercel-labs/agent-skills
#   safe-skill-install https://github.com/user/repo
#   safe-skill-install vercel-labs/agent-skills -g
#
# This script performs security checks before installing skills:
# 1. Lists available skills in the repo
# 2. Downloads and scans skill files for red flags
# 3. Prompts for confirmation before installation

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Check arguments
if [[ $# -lt 1 ]]; then
    echo -e "${RED}Error: Repository required${NC}"
    echo ""
    echo "Usage: $0 <repo> [skills-options]"
    echo ""
    echo "Examples:"
    echo "  $0 vercel-labs/agent-skills"
    echo "  $0 vercel-labs/agent-skills -g"
    echo "  $0 https://github.com/user/repo --skill my-skill"
    echo ""
    echo "Browse skills at: https://skills.sh/"
    exit 1
fi

REPO="$1"
shift
EXTRA_ARGS="$*"

echo -e "${BLUE}╔═══════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║       Safe Skill Installer                ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════╝${NC}"
echo ""
echo -e "Repository: ${CYAN}${REPO}${NC}"
echo ""

# Check if skills CLI is available
if ! command -v skills &> /dev/null; then
    echo -e "${RED}Error: 'skills' CLI not found${NC}"
    echo "Install it with: mise use -g npm:skills@latest"
    exit 1
fi

# Step 1: List available skills
echo -e "${BLUE}[1/3] Listing available skills...${NC}"
SKILL_LIST=$(skills add "$REPO" --list 2>&1) || {
    echo -e "${RED}Error: Could not list skills from repository${NC}"
    echo "$SKILL_LIST"
    exit 1
}

echo "$SKILL_LIST"
echo ""

# Step 2: Security scan
echo -e "${BLUE}[2/3] Scanning for security concerns...${NC}"
WARNINGS=0
TMPDIR=$(mktemp -d)
trap "rm -rf $TMPDIR" EXIT

# Determine the GitHub URL
if [[ "$REPO" == http* ]]; then
    GITHUB_URL="$REPO"
else
    GITHUB_URL="https://github.com/${REPO}"
fi

# Try to fetch raw skill files for scanning
# Convert github.com URL to raw.githubusercontent.com
RAW_URL=$(echo "$GITHUB_URL" | sed 's|github.com|raw.githubusercontent.com|' | sed 's|$|/HEAD|')

# Scan for red flags in common skill file locations
for skill_file in "SKILL.md" "skill.md" "README.md"; do
    CONTENT=$(curl -sL "${RAW_URL}/${skill_file}" 2>/dev/null) || continue
    
    if [[ -z "$CONTENT" ]]; then
        continue
    fi
    
    echo -e "  Scanning ${skill_file}..."
    
    # Check for suspicious patterns
    if echo "$CONTENT" | grep -qiE "(curl.*\|.*sh|wget.*\|.*sh|eval\s|exec\s)"; then
        echo -e "    ${RED}⚠ Found command execution patterns${NC}"
        WARNINGS=$((WARNINGS + 1))
    fi
    
    if echo "$CONTENT" | grep -qiE "(base64.*decode|/etc/passwd|/etc/shadow|\.ssh/|\.aws/)"; then
        echo -e "    ${RED}⚠ Found sensitive file/path access patterns${NC}"
        WARNINGS=$((WARNINGS + 1))
    fi
    
    if echo "$CONTENT" | grep -qiE "(API_KEY|SECRET_KEY|PASSWORD|PRIVATE_KEY)" | grep -viE "(example|placeholder|your_|<|\\\$)"; then
        echo -e "    ${YELLOW}⚠ References credentials/secrets${NC}"
        WARNINGS=$((WARNINGS + 1))
    fi
    
    if echo "$CONTENT" | grep -qiE "(sudo |chmod.*777|chown.*root)"; then
        echo -e "    ${RED}⚠ Requests elevated privileges${NC}"
        WARNINGS=$((WARNINGS + 1))
    fi
    
    if echo "$CONTENT" | grep -qiE "(rm -rf /|mkfs|dd if=|format)"; then
        echo -e "    ${RED}⚠ Found destructive command patterns${NC}"
        WARNINGS=$((WARNINGS + 1))
    fi
    
    # Check for suspicious URLs
    SUSPICIOUS_URLS=$(echo "$CONTENT" | grep -oE "https?://[^ \"'>]+" | grep -viE "(github\.com|gitlab\.com|bitbucket\.org|skills\.sh|npmjs\.com|pypi\.org|docs\.|api\.|raw\.|cdn\.)" || true)
    if [[ -n "$SUSPICIOUS_URLS" ]]; then
        echo -e "    ${YELLOW}⚠ Found external URLs:${NC}"
        echo "$SUSPICIOUS_URLS" | head -3 | sed 's/^/      /'
    fi
done

echo ""

# Step 3: Assessment
echo -e "${BLUE}[3/3] Security assessment${NC}"
if [[ $WARNINGS -eq 0 ]]; then
    echo -e "  Risk Level: ${GREEN}LOW${NC}"
    echo -e "  ${GREEN}No security concerns detected${NC}"
elif [[ $WARNINGS -le 2 ]]; then
    echo -e "  Risk Level: ${YELLOW}MEDIUM${NC}"
    echo -e "  ${YELLOW}${WARNINGS} concern(s) found - review before proceeding${NC}"
else
    echo -e "  Risk Level: ${RED}HIGH${NC}"
    echo -e "  ${RED}${WARNINGS} concerns detected - proceed with caution${NC}"
fi
echo ""

# Confirmation
if [[ $WARNINGS -gt 2 ]]; then
    read -p "Install anyway? [y/N] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Installation cancelled${NC}"
        exit 0
    fi
elif [[ $WARNINGS -gt 0 ]]; then
    read -p "Proceed with installation? [Y/n] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        echo -e "${YELLOW}Installation cancelled${NC}"
        exit 0
    fi
else
    read -p "Install skill(s)? [Y/n] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        echo -e "${YELLOW}Installation cancelled${NC}"
        exit 0
    fi
fi

echo ""
echo -e "${BLUE}Installing from ${REPO}...${NC}"
echo ""

# Install the skill(s)
# shellcheck disable=SC2086
if skills add "$REPO" $EXTRA_ARGS; then
    echo ""
    echo -e "${GREEN}╔═══════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║  ✓ Skill(s) installed successfully        ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════╝${NC}"
else
    echo ""
    echo -e "${RED}✗ Installation failed${NC}"
    exit 1
fi
