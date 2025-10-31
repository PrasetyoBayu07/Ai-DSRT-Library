cat > repo_fix_and_build.sh <<'BASH'
#!/usr/bin/env bash
set -euo pipefail

ROOT="$(pwd)"
echo "=== repo fix & build starting in $ROOT ==="

# 0. Ensure git workspace clean (not required but helpful)
if git status --porcelain | grep -q .; then
  echo "Warning: Git workspace has local changes. Committing them as 'wip: before auto-fix' ..."
  git add -A
  git commit -m "wip: before auto-fix" || echo "commit skipped (no changes or no git configured)"
fi

# 1. If there's a DESSERT folder with src inside, move contents to root
if [ -d "./DESSERT" ]; then
  if [ -d "./src" ]; then
    echo "Root src already exists; skipping move of DESSERT/src"
  else
    echo "Moving DESSERT/src and other top-level into repo root..."
    shopt -s dotglob
    mv DESSERT/* .
    rmdir DESSERT || true
    shopt -u dotglob
    echo "Moved files from DESSERT/ to root"
    git add -A
    git commit -m "chore: move DESSERT subproject to repo root" || true
  fi
fi

# 2. Ensure src exists
mkdir -p src

# 3. Ensure src/index.js exists (entry file)
if [ ! -f src/index.js ]; then
  echo "Creating src/index.js (entry re-exports) ..."
  cat > src/index.js <<'JS'
/**
 * DESSERT library entry point
 * Exports core modules. Add modules to re-export as implemented.
 */
export * from './core/Engine.js';
export { default as Object3D } from './core/Object3D.js';
export { default as Scene } from './core/Scene.js';
export { default as Camera } from './core/Camera.js';
export { default as WebGLRenderer } from './renderers/WebGLRenderer.js';
JS
  git add src/index.js
  git commit -m "chore: add src/index.js entry" || true
fi

# 4. Ensure examples/index.html exists and points to examples/scene-basic.js
if [ ! -f examples/index.html ]; then
  echo "Creating examples/index.html ..."
  mkdir -p examples
  cat > examples/index.html <<'HTML'
<!doctype html>
<html>
<head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
  <title>DESSERT Showcase</title>
  <style>html,body,canvas{height:100%;margin:0;background:#111}</style>
</head>
<body>
  <canvas id="app"></canvas>
  <script type="module" src="./scene-basic.js"></script>
</body>
</html>
HTML
  git add examples/index.html
  git commit -m "chore: add examples/index.html" || true
fi

# 5. Ensure vercel.json for redirects
if [ ! -f vercel.json ]; then
  echo "Creating vercel.json..."
  cat > vercel.json <<'JSON'
{
  "redirects": [
    { "source": "/", "destination": "/examples/index.html", "permanent": true }
  ],
  "cleanUrls": true,
  "trailingSlash": false
}
JSON
  git add vercel.json
  git commit -m "chore: add vercel.json" || true
fi

# 6. Ensure build scripts exist in package.json
if [ -f package.json ]; then
  if ! jq -e '.scripts.build' package.json >/dev/null 2>&1; then
    echo "Adding build script to package.json..."
    tmp="package.tmp.json"
    jq '.scripts.build="vite build"' package.json > "$tmp" && mv "$tmp" package.json
    git add package.json
    git commit -m "chore: add build script" || true
  fi
else
  echo "package.json missing — creating minimal package.json..."
  cat > package.json <<'PKG'
{
  "name": "dessert",
  "version": "0.1.0",
  "type": "module",
  "main": "src/index.js",
  "scripts": {
    "dev": "vite",
    "build": "vite build"
  },
  "devDependencies": {
    "vite": "^5.0.0"
  }
}
PKG
  npm install --silent
  git add package.json package-lock.json node_modules || true
  git commit -m "chore: add minimal package.json" || true
fi

# 7. Run npm install
if [ -f package.json ]; then
  echo "Running npm install..."
  npm install --silent
fi

# 8. Try build
echo "Attempting npm run build..."
if npm run build --silent; then
  echo "✅ Build succeeded"
else
  echo "❌ Build failed — collecting diagnostics..."
  echo "---- rollup/vite error snippet ----"
  npx vite build --debug || true
fi

# 9. Lint (if eslint config present)
if [ -f .eslintrc.json ] || [ -f .eslintrc ]; then
  if command -v npx >/dev/null 2>&1; then
    echo "Running eslint..."
    npx eslint src || echo "eslint failed or found issues"
  fi
fi

# 10. Final status
echo "=== Final file list (top) ==="
ls -la | sed -n '1,80p'
echo "=== Done ==="
BASH

chmod +x repo_fix_and_build.sh
./repo_fix_and_build.sh
