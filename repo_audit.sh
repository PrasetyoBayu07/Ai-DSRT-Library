cat > repo_audit.sh <<'BASH'
#!/usr/bin/env bash
set -euo pipefail

ROOT="$(pwd)"
echo "=== Repo audit: $ROOT ==="
echo

# 1. show project top-level
echo "--- top-level files ---"
ls -la | sed -n '1,80p'
echo

# 2. show tree (limited)
echo "--- tree (depth 2) ---"
find . -maxdepth 2 -type d -print | sed 's|^\./|./|' | sed -n '1,200p'
echo

# 3. check vite config & package.json entry
echo "--- vite & package check ---"
[ -f vite.config.js ] && echo "vite.config.js: OK" || echo "vite.config.js: MISSING"
[ -f package.json ] && (jq -r '.name, .scripts.dev?, .scripts.build?' package.json 2>/dev/null || cat package.json) || echo "package.json: MISSING"
echo

# 4. check src/index.js
if [ -f src/index.js ]; then
  echo "src/index.js: exists"
else
  echo "src/index.js: MISSING"
fi
echo

# 5. find TODOs and FIXME
echo "--- TODO / FIXME occurrences ---"
grep -RIn --exclude-dir=node_modules --exclude-dir=.git -e "TODO" -e "FIXME" -n || true
echo

# 6. check examples index.html
[ -f examples/index.html ] && echo "examples/index.html: OK" || echo "examples/index.html: MISSING"
echo

# 7. check vercel / pages config
[ -f vercel.json ] && echo "vercel.json: OK" || echo "vercel.json: MISSING"
[ -d .github/workflows ] && ls -la .github/workflows || echo ".github/workflows: MISSING"
echo

# 8. run vite build dry-run (no fail) - just check entry resolution via rollup with --config if available
echo "--- vite dry-check ---"
if command -v npx >/dev/null 2>&1; then
  if [ -f package.json ]; then
    echo "Running 'npx vite build --dry-run' (if available) ..."
    npx vite build --silent --logLevel=error --emptyOutDir=false || echo "vite dry-run failed (expected if config missing)"
  else
    echo "skip vite dry-run (package.json missing)"
  fi
else
  echo "npx not installed in environment"
fi

echo
echo "=== Audit complete ==="
BASH

chmod +x repo_audit.sh
./repo_audit.sh
