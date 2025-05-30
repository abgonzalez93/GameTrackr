#!/bin/bash
set -e

echo "🟢 Paso 3: Generación de certificados SSL locales"

CERT_DIR="./files/caddy/certs"
CERT_NAME="cert.crt"
KEY_NAME="cert.key"
DOMAINS="trackplay.localhost api.trackplay.localhost"

mkdir -p "$CERT_DIR"
cd "$CERT_DIR" || exit 1

if [[ -f "$CERT_NAME" && -f "$KEY_NAME" ]]; then
  echo "🔎 Verificando validez del certificado existente..."
  if openssl x509 -checkend 604800 -noout -in "$CERT_NAME" &> /dev/null; then
    echo "✔️ Certificados existentes válidos por al menos 7 días."
    exit 0
  else
    echo "⚠️ Certificados existentes caducados o próximos a caducar. Regenerando..."
    rm -f "$CERT_NAME" "$KEY_NAME"
  fi
fi

echo "🔐 Generando nuevos certificados con mkcert para: $DOMAINS"
mkcert $DOMAINS

NEW_CERT=$(ls -t trackplay*.pem | grep -v '\-key.pem' | head -n 1)
NEW_KEY=$(ls -t trackplay*-key.pem | head -n 1)

if [[ ! -f "$NEW_CERT" || ! -f "$NEW_KEY" ]]; then
  echo "❌ Error: No se generaron correctamente los certificados"
  exit 1
fi

mv -f "$NEW_CERT" "$CERT_NAME"
mv -f "$NEW_KEY" "$KEY_NAME"

echo "✅ Certificados generados correctamente:"
ls -l "$CERT_NAME" "$KEY_NAME"
