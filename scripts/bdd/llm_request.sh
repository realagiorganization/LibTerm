#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${LLM_API_KEY:-}" ]]; then
  echo "LLM_API_KEY is not set" >&2
  exit 2
fi

api_base="${LLM_API_BASE_URL:-https://api.openai.com/v1}"
response_path="${LLM_RESPONSE_PATH:-/tmp/llm_response.json}"
request_command="${LLM_REQUEST_COMMAND:-}"

script_file="$(mktemp)"
cat >"$script_file" <<'SCRIPT'
#!/usr/bin/env bash
set -euo pipefail

api_base="${LLM_API_BASE_URL:-https://api.openai.com/v1}"
response_path="${LLM_RESPONSE_PATH:-/tmp/llm_response.json}"
request_command="${LLM_REQUEST_COMMAND:-}"

if [[ -n "${request_command}" ]]; then
  bash -lc "${request_command}" > "${response_path}"
else
  curl -sS \
    -H "Authorization: Bearer ${LLM_API_KEY}" \
    -H "Content-Type: application/json" \
    "${api_base%/}/models" \
    -o "${response_path}"
fi
SCRIPT
chmod +x "$script_file"

if command -v tmux >/dev/null 2>&1; then
  session_name="llm_request"
  tmux new-session -d -s "$session_name" "$script_file"
  while tmux has-session -t "$session_name" 2>/dev/null; do
    sleep 0.2
  done
else
  "$script_file"
fi

python3 - <<'PY'
import json
import os

response_path = os.environ.get("LLM_RESPONSE_PATH", "/tmp/llm_response.json")
with open(response_path, "r", encoding="utf-8") as handle:
    payload = json.load(handle)
if "data" not in payload:
    raise SystemExit("Expected 'data' in response payload")
print(f"LLM response items: {len(payload['data'])}")
PY

rm -f "$script_file"
