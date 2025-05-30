#!/bin/bash
set -e

echo "🟢 Paso 1.2: Instalación de npm-check-updates (ncu)"

if command -v ncu &> /dev/null; then
  echo "✔️ ncu ya está instalado: $(ncu --version)"
else
  echo "⬇️ Instalando ncu globalmente..."
  npm install -g npm-check-updates
  echo "✅ ncu instalado: $(ncu --version)"
fi
