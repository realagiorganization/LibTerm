#!/usr/bin/env bash
# Minimal shim to emulate an "oh my opencode" CLI call using the configured LLM endpoint.
set -euo pipefail

api_base="${LLM_API_BASE_URL:-https://api.openai.com/v1}"
if [[ -z "${LLM_API_KEY:-}" ]]; then
  echo "LLM_API_KEY is required" >&2
  exit 2
fi

curl -sS \
  -H "Authorization: Bearer ${LLM_API_KEY}" \
  -H "Content-Type: application/json" \
  "${api_base%/}/models"
