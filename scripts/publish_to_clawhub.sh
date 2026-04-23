#!/usr/bin/env bash
# Publish the installable skill folder to ClawHub (OpenClaw registry).
#
# Prerequisites:
#   - Node/npm (for npx clawhub)
#   - CLAWHUB_TOKEN set in the environment, or run:
#       npx clawhub@latest login --no-browser --token "<token>"
#
# Usage (from repo root):
#   export CLAWHUB_TOKEN=...
#   ./scripts/publish_to_clawhub.sh 1.2.0 "Mp4 CLI fix, Roboto default, verification rubric"
#
# The skill path is always ./recursive-maths-animator/ (contains SKILL.md).

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_DIR="${ROOT}/recursive-maths-animator"
VERSION="${1:-}"
CHANGELOG="${2:-}"

if [[ ! -f "${SKILL_DIR}/SKILL.md" ]]; then
  echo "error: expected SKILL.md at ${SKILL_DIR}/SKILL.md" >&2
  exit 1
fi

if [[ -z "${VERSION}" ]]; then
  echo "usage: $0 <semver> [changelog]" >&2
  exit 1
fi

if [[ -z "${CHANGELOG}" ]]; then
  CHANGELOG="See repository commit history for this release."
fi

if [[ -z "${CLAWHUB_TOKEN:-}" ]]; then
  echo "error: set CLAWHUB_TOKEN (see clawhub login --no-browser --token)" >&2
  exit 1
fi

npx --yes clawhub@latest login --no-browser --token "${CLAWHUB_TOKEN}"
npx --yes clawhub@latest publish "${SKILL_DIR}" \
  --slug recursive-maths-animator \
  --name "Recursive maths animator" \
  --version "${VERSION}" \
  --changelog "${CHANGELOG}" \
  --tags latest

echo "Published recursive-maths-animator ${VERSION} to ClawHub."
