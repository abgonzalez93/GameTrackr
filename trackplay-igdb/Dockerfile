# Imagen base ligera
FROM node:24.0-slim

# Crea carpeta de trabajo
WORKDIR /app

# Copia sólo lo necesario para instalar dependencias
COPY package.json package-lock.json .npmrc* ./

# Instala dependencias del sistema (incluye OpenSSL)
RUN apt-get update -y && \
    apt-get install -y openssl && \
    npm ci --silent && \
    npm cache clean --force && \
    rm -f .npmrc && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copia configuraciones necesarias
COPY tsconfig.json ./

# Copia sólo el código fuente y prisma
COPY prisma ./prisma
COPY src ./src

# Genera Prisma
RUN npm run prisma:generate

# Comando de arranque en desarrollo
CMD ["npm", "run", "dev"]
