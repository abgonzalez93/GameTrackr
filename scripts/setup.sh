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

# --- Clonado de repositorios ---
echo "🟢 Paso 6: Clonado de repositorios"

REPOS=(
  "trackplay-frontend|https://github.com/abgonzalez93/TrackPlay-Frontend"
  "trackplay-backend|https://github.com/abgonzalez93/TrackPlay-Backend"
  "trackplay-core|https://github.com/abgonzalez93/TrackPlay-Core"
)

for entry in "${REPOS[@]}"; do
  IFS="|" read -r dir url <<< "$entry"

  echo "→ Preparando directorio ./$dir"
  mkdir -p "$dir"
  rm -rf "$dir/"* "$dir/".* 2>/dev/null || true

  echo "→ Clonando rama develop de $url dentro de $dir..."
  git clone -b develop "$url" "$dir"

  if [[ -f "$dir/package.json" ]]; then
    echo "📦 Instalando dependencias en $dir..."
    cd "$dir"
    npm install --silent
    echo "   ✔️ node: $(node -v) | npm: $(npm -v) | Paquetes: $(ls node_modules | wc -l)"
    cd ..
  else
    echo "ℹ️ No se encontró package.json en $dir, omitiendo npm install"
  fi
done

echo ""
echo "✅ Setup completo. Ya puedes levantar tu entorno con 'docker compose up --build'"

# --- Recordatorio de archivos de entorno ---
echo ""
echo "⚠️  Que no se te olvide copiar de forma manual los archivos de entorno:"
echo "    cp .env-template trackplay-backend/.env"
echo "    cp .npmrc-template trackplay-backend/.npmrc"
echo "    cp .env-template trackplay-frontend/.env"
echo "    cp .npmrc-template trackplay-frontend/.npmrc"
echo "    cp .env-template trackplay-core/.env"
echo "    cp .npmrc-template trackplay-core/.npmrc"
