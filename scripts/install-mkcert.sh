#!/bin/bash

# scripts/install-mkcert.sh
# Instala mkcert en Linux/WSL desde fuente oficial

set -e

echo "🛠 Instalando dependencias necesarias..."
sudo apt update
sudo apt install -y libnss3-tools ca-certificates curl

echo "⬇️ Descargando mkcert..."
curl -JLO https://dl.filippo.io/mkcert/latest?for=linux/amd64

echo "📦 Instalando mkcert en /usr/local/bin..."
chmod +x mkcert-v*-linux-amd64
sudo mv mkcert-v*-linux-amd64 /usr/local/bin/mkcert

echo "✅ Verificando instalación..."
mkcert --version

echo "🔐 Instalando CA local (solo la primera vez)..."
mkcert -install

echo "🎉 mkcert instalado correctamente y listo para generar certificados."
