#!/bin/bash

set -e

echo "🔧 Ejecutando setup completo del entorno..."

# --- Git (requerido para clonar repos) ---
echo "🟢 Paso 1: Instalación de Git"
bash ./scripts/install-git.sh

# --- Node.js (necesario para ncu, frontend/backend) ---
echo "🟢 Paso 2: Instalación de Node.js"
bash ./scripts/install-node.sh

# --- npm-check-updates (útil para desarrollo JS/TS) ---
echo "🟢 Paso 3: Instalación de npm-check-updates"
bash ./scripts/install-ncu.sh

# --- mkcert (usado para certs locales) ---
echo "🟢 Paso 4: Instalación de mkcert"
bash ./scripts/install-mkcert.sh

# --- Certificados SSL locales ---
echo "🟢 Paso 5: Generación de certificados SSL locales"
bash ./scripts/generate-certs.sh

# --- Claves RSA para JWT ---
echo "🟢 Paso 6: Generación de claves RSA para JWT (RS256)"
bash ./scripts/generate-jwt-keys.sh

# --- Clonado de repositorios ---
echo "🟢 Paso 7: Clonado de repositorios"

REPOS=(
  "trackplay-backend|https://github.com/abgonzalez93/TrackPlay-Backend"
  "trackplay-core|https://github.com/abgonzalez93/TrackPlay-Core"
  "trackplay-frontend|https://github.com/abgonzalez93/TrackPlay-Frontend"
  "trackplay-igdb|https://github.com/abgonzalez93/TrackPlay-IGDB"
  "trackplay-auth|https://github.com/abgonzalez93/TrackPlay-Auth"
)

for entry in "${REPOS[@]}"; do
  IFS="|" read -r dir url <<< "$entry"

  echo "→ Eliminando y recreando directorio ./$dir"
  rm -rf "$dir"
  mkdir -p "$dir"

  echo "→ Clonando rama develop de $url dentro de $dir..."
  git clone -b develop "$url" "$dir"
done

echo ""
echo "✅ Setup completo. Ya puedes levantar tu entorno con 'docker compose up --build'"

# --- Recordatorio de archivos de entorno ---
echo ""
echo "⚠️  Que no se te olvide copiar de forma manual los archivos de entorno:"
echo "    cp .npmrc-template trackplay-backend/.npmrc"
echo "    cp .npmrc-template trackplay-core/.npmrc"
echo "    cp .npmrc-template trackplay-frontend/.npmrc"
echo "    cp .npmrc-template trackplay-igdb/.npmrc"
echo "    cp .npmrc-template trackplay-auth/.npmrc"
