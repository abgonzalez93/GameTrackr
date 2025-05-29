#!/bin/bash

# scripts/generate-local-cert.sh

# Ruta al directorio de certificados
CERT_DIR="./nginx/certs"

# Nombres de los archivos finales
CERT_NAME="cert.crt"
KEY_NAME="cert.key"

# Dominios locales
DOMAINS="trackplay.localhost api.trackplay.localhost"

# Crear carpeta si no existe
mkdir -p "$CERT_DIR"

# Ir al directorio de certificados
cd "$CERT_DIR" || exit 1

echo "→ Generando certificados con mkcert para: $DOMAINS"
mkcert $DOMAINS

# Obtener el archivo recién generado (.pem y -key.pem)
NEW_CERT=$(ls -t trackplay*.pem | grep -v '\-key.pem' | head -n 1)
NEW_KEY=$(ls -t trackplay*-key.pem | head -n 1)

# Verifica que ambos existen
if [[ ! -f "$NEW_CERT" || ! -f "$NEW_KEY" ]]; then
  echo "❌ Error: No se encontraron los archivos generados por mkcert"
  exit 1
fi

# Renombrar
echo "→ Renombrando $NEW_CERT → $CERT_NAME"
mv -f "$NEW_CERT" "$CERT_NAME"

echo "→ Renombrando $NEW_KEY → $KEY_NAME"
mv -f "$NEW_KEY" "$KEY_NAME"

echo "✅ Certificados generados correctamente:"
ls -l
