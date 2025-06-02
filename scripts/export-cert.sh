#!/bin/bash
set -e

echo "🟢 Exportador de certificado raíz de mkcert para Windows"

# 1. Verifica mkcert
if ! command -v mkcert &>/dev/null; then
  echo "❌ mkcert no está instalado. Instálalo primero con 'brew install mkcert' o desde https://mkcert.dev"
  exit 1
fi

# 2. Solicita nombre de usuario Windows
read -rp "🧑‍💻 Introduce tu nombre de usuario de Windows: " WINDOWS_USER

# 3. Ruta del certificado raíz
CAROOT=$(mkcert -CAROOT)
PEM="$CAROOT/rootCA.pem"
DEST="/mnt/c/Users/$WINDOWS_USER/Desktop"
CRT="$DEST/rootCA.crt"

# 4. Verifica existencia del .pem
if [[ ! -f "$PEM" ]]; then
  echo "❌ No se encontró el archivo raíz en $PEM"
  exit 1
fi

# 5. Convierte a .crt
cp "$PEM" "$CRT"
echo "✅ Convertido rootCA.pem ➜ rootCA.crt"

# 6. Copia al escritorio
mkdir -p "$DEST"
cp "$PEM" "$CRT"
echo "📂 Copiado en: $DEST/rootCA.crt"

echo "✅ Listo. Instala el certificado en 'Entidades de certificación raíz de confianza' desde el asistente de Windows."
