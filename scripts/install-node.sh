#!/bin/bash
set -e

echo "🟢 Paso 1: Instalación de Node.js"

export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
  source "$NVM_DIR/nvm.sh"
fi

if command -v node &> /dev/null; then
  echo "✔️ Node.js ya está instalado: $(node -v)"
  echo "🔍 npm: $(npm -v)"
  exit 0
fi

if [ ! -s "$NVM_DIR/nvm.sh" ]; then
  echo "⬇️ Descargando e instalando NVM..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
  source "$NVM_DIR/nvm.sh"
fi

echo "📦 Instalando Node.js (última versión disponible)..."
nvm install node
nvm alias default node

echo "✅ Node.js instalado: $(node -v)"
echo "🔍 npm: $(npm -v)"
