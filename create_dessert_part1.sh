#!/usr/bin/env bash
set -euo pipefail

echo "🚀 Membuat struktur dasar proyek DESSERT..."

# --- 1. Siapkan folder utama ---
rm -rf DESSERT
mkdir -p DESSERT
cd DESSERT

# --- 2. package.json ---
cat > package.json <<'EOF'
{
  "name": "dessert",
  "version": "0.1.0",
  "description": "DESSERT - AI-Driven WebGL Library by PrasetyoBayu07",
  "type": "module",
  "main": "src/index.js",
  "types": "types/index.d.ts",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview",
    "lint": "eslint src --ext .js"
  },
  "keywords": ["webgl", "3d", "engine", "graphics", "dessert", "gzjs"],
  "author": "PrasetyoBayu07",
  "license": "Unlicense",
  "devDependencies": {
    "vite": "^5.0.0",
    "eslint": "^9.0.0",
    "typescript": "^5.5.0"
  }
}
EOF

# --- 3. vite.config.js ---
cat > vite.config.js <<'EOF'
import { defineConfig } from "vite";
export default defineConfig({
  root: ".",
  publicDir: "assets",
  build: {
    outDir: "dist",
    lib: {
      entry: "src/index.js",
      name: "DESSERT",
      fileName: (format) => `dessert.${format}.js`
    },
    rollupOptions: { external: [] }
  },
  server: { port: 5173, open: "examples/index.html" }
});
EOF

# --- 4. tsconfig.json untuk d.ts generation ---
cat > tsconfig.json <<'EOF'
{
  "compilerOptions": {
    "allowJs": true,
    "declaration": true,
    "emitDeclarationOnly": true,
    "outDir": "types",
    "target": "ES2020",
    "module": "ESNext",
    "moduleResolution": "Bundler",
    "strict": false
  },
  "include": ["src/**/*"]
}
EOF

# --- 5. README.md ---
cat > README.md <<'EOF'
# 🍨 DESSERT – AI-Driven WebGL Library

DESSERT (AI-DSRT-Library) is an open-source 3D/WebGL engine framework.  
Designed for creativity, performance, and simplicity.

## Commands
```bash
npm install
npm run dev      # Run examples via Vite
npm run build    # Build library to dist/
