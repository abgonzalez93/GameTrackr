#!/bin/bash
set -e

echo "🟢 Paso 3: Generación de certificados SSL locales"

CERT_DIR="./.files/caddy/certs"
CERT_NAME="cert.crt"
KEY_NAME="cert.key"
DOMAINS="trackplay.localhost api.trackplay.localhost igdb.trackplay.localhost"

mkdir -p "$CERT_DIR"

cd "$CERT_DIR" || {
  echo "❌ No se pudo acceder a $CERT_DIR"
  exit 1
}

# Si ya existen, verifica si caducan en menos de 7 días (604800 segundos)
if [[ -f "$CERT_NAME" && -f "$KEY_NAME" ]]; then
  echo "🔎 Verificando validez del certificado existente..."
  if openssl x509 -checkend 604800 -noout -in "$CERT_NAME" &> /dev/null; then
    echo "✔️ Certificados existentes válidos por al menos 7 días."
    exit 0
  else
    echo "⚠️ Certificados caducados o próximos a caducar. Regenerando..."
    rm -f "$CERT_NAME" "$KEY_NAME"
  fi
fi

# ✅ Generación explícita de nombres de salida
echo "🔐 Generando nuevos certificados con mkcert para: $DOMAINS"
mkcert -cert-file "$CERT_NAME" -key-file "$KEY_NAME" $DOMAINS

# Verifica que fueron generados correctamente
if [[ ! -f "$CERT_NAME" || ! -f "$KEY_NAME" ]]; then
  echo "❌ Error: No se generaron correctamente los certificados"
  exit 1
fi

echo "✅ Certificados generados correctamente:"
ls -l "$CERT_NAME" "$KEY_NAME"
