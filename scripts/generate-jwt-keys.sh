#!/bin/bash
set -e

echo "🟢 Paso 6: Generación de claves RSA para JWT (RS256)"

KEY_DIR="./.files/jwt"
PRIVATE_KEY="private.key"
PUBLIC_KEY="public.key"

mkdir -p "$KEY_DIR"

cd "$KEY_DIR" || {
  echo "❌ No se pudo acceder a $KEY_DIR"
  exit 1
}

# Verifica si ya existen las claves
if [[ -f "$PRIVATE_KEY" && -f "$PUBLIC_KEY" ]]; then
  echo "🔎 Las claves ya existen. ¿Deseas regenerarlas? (esto sobrescribirá las actuales) [s/N]"
  read -r confirm
  if [[ "$confirm" != "s" && "$confirm" != "S" ]]; then
    echo "⏭️  Operación cancelada. Se conservarán las claves existentes."
    exit 0
  fi
fi

# Genera la clave privada (2048 bits recomendados para RS256)
echo "🔐 Generando clave privada RSA..."
openssl genpkey -algorithm RSA -out "$PRIVATE_KEY" -pkeyopt rsa_keygen_bits:2048

# Genera la clave pública a partir de la privada
echo "🔐 Generando clave pública RSA..."
openssl rsa -in "$PRIVATE_KEY" -pubout -out "$PUBLIC_KEY"

# Verificación final
if [[ -f "$PRIVATE_KEY" && -f "$PUBLIC_KEY" ]]; then
  echo "✅ Claves RSA generadas correctamente:"
  ls -l "$PRIVATE_KEY" "$PUBLIC_KEY"
else
  echo "❌ Error: No se generaron correctamente las claves RSA"
  exit 1
fi
