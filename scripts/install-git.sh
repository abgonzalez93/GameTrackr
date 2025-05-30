#!/bin/bash
set -e

echo "🟢 Paso 1.1: Instalación de Git"

if command -v git &> /dev/null; then
  echo "✔️ Git ya está instalado: $(git --version)"
else
  echo "⬇️ Instalando Git con apt..."
  sudo apt update
  sudo apt install -y git
  echo "✅ Git instalado: $(git --version)"
fi
