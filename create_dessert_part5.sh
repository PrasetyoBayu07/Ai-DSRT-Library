#!/usr/bin/env bash
set -euo pipefail

cd DESSERT || { echo "❌ Jalankan Part 1–4 dulu."; exit 1; }

echo "🚀 Menjalankan instalasi dependencies dan setup git..."

# --- Install Dependencies ---
if [ -f package.json ]; then
  echo "📦 Menjalankan npm install..."
  npm install
else
  echo "❌ Tidak menemukan package.json"
  exit 1
fi

# --- Git Init ---
if [ ! -d .git ]; then
  echo "🔧 Menginisialisasi Git repository..."
  git init
  git branch -M main
  git add .
  git commit -m "Initial commit - DESSERT Engine setup"
else
  echo "⚠️ Repo Git sudah ada, skip init."
fi

# --- Remote Setup ---
REMOTE_URL="https://github.com/PrasetyoBayu07/Ai-DSRT-Library.git"
if git remote | grep -q origin; then
  echo "⚠️ Remote origin sudah ada, skip."
else
  git remote add origin "$REMOTE_URL"
  echo "✅ Remote origin ditambahkan: $REMOTE_URL"
fi

# --- Push ke GitHub ---
echo "⬆️  Push ke branch main..."
git push -u origin main || echo "⚠️ Push gagal (cek autentikasi GitHub)."

echo "✅ Semua selesai!"
echo ""
echo "Langkah berikut:"
echo "1️⃣ Jalankan: npm run dev     # untuk preview contoh scene"
echo "2️⃣ Jalankan: npm run build   # untuk hasil library di dist/"
echo ""
echo "🎉 DESSERT Engine siap digunakan! 🚀"
