#!/bin/bash
set -e

echo "🟢 Paso 3: Instalación de npm-check-updates"

if command -v ncu &> /dev/null; then
  echo "✔️ ncu ya está instalado: $(ncu --version)"
else
  echo "⬇️ Instalando ncu globalmente..."
  pnpm install -g npm-check-updates
  echo "✅ ncu instalado: $(ncu --version)"
fi
