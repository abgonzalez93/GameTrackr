#!/bin/bash
set -e

echo "🟢 Paso 4: Instalación de mkcert"

if command -v mkcert &> /dev/null; then
  echo "✔️ mkcert ya está instalado: $(mkcert --version)"
  exit 0
fi

echo "🛠 Instalando dependencias..."
sudo apt update
sudo apt install -y libnss3-tools ca-certificates curl

echo "⬇️ Descargando mkcert..."
curl -JLO https://dl.filippo.io/mkcert/latest?for=linux/amd64

echo "📦 Instalando mkcert en /usr/local/bin..."
chmod +x mkcert-v*-linux-amd64
sudo mv mkcert-v*-linux-amd64 /usr/local/bin/mkcert

echo "✅ mkcert instalado: $(mkcert --version)"
echo "🔐 Instalando CA local..."
mkcert -install
echo "🎉 mkcert listo para usar."
