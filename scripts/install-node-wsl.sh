#!/bin/bash

# Instalación de NVM
echo "🔧 Instalando NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Cargar NVM en esta sesión
export NVM_DIR="$HOME/.nvm"
source "$NVM_DIR/nvm.sh"

# Instalar última versión LTS de Node.js
echo "📦 Instalando Node.js..."
nvm install node

# Establecer como predeterminada
nvm alias default node

# Obtener versión instalada
NODE_VERSION=$(node -v)
echo "✅ Node.js versión instalada: $NODE_VERSION"

# Verificar npm
echo "🔍 Verificando npm..."
npm -v && echo "✅ npm instalado correctamente."

echo "🎉 Instalación completada correctamente."
