#!/bin/bash
set -e

echo "🟢 Paso 3: Instalación de pnpm"

# Verificar si pnpm ya está instalado
if command -v pnpm &> /dev/null; then
  echo "✔️ pnpm ya está instalado: $(pnpm -v)"
  exit 0
fi

echo "📦 Instalando pnpm..."

# 1. Instalar pnpm globalmente (fallback si no funciona corepack)
npm install -g pnpm

# 2. Habilitar corepack
corepack enable

# 3. Preparar la última versión de pnpm
corepack prepare pnpm@latest --activate

echo "✅ pnpm instalado: $(pnpm -v)"
