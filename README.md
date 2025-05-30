# 🚀 TrackPlay - Setup del Entorno de Desarrollo

Este repositorio contiene todos los scripts necesarios para configurar de forma automática y reproducible el entorno local de desarrollo para TrackPlay, incluyendo frontend, backend, core compartido, certificados locales y configuración de entorno.

---

## 📦 Requisitos Previos

Asegúrate de tener instalado lo siguiente:

### 🔧 Herramientas del sistema

| Herramienta                 | Requerida                  | Instrucciones de instalación                                             |
| --------------------------- | -------------------------- | ------------------------------------------------------------------------ |
| **WSL (Ubuntu)**            | ✅                         | [Instalar WSL en Windows](https://learn.microsoft.com/es-es/windows/wsl/install)    |
| **Docker + Docker Compose** | ✅                         | [Instalar Docker en Windows](https://docs.docker.com/desktop/setup/install/windows-install/) |

---

## 🔄 Configuración Automática

El script principal `scripts/setup.sh` se encarga de:

1. Instalar Node.js y herramientas globales.
2. Instalar `mkcert` y preparar certificados locales.
3. Generar certificados para dominios locales `trackplay.localhost` y `api.trackplay.localhost`.
4. Clonar los tres repositorios necesarios:
   - `trackplay-frontend`
   - `trackplay-backend`
   - `trackplay-core`
5. Copiar archivos `.env` y `.npmrc` desde sus plantillas.

---

## ▶️ Pasos para Ejecutar el Setup

1. **Clona este repositorio raíz** en tu carpeta de trabajo:

```bash
git clone https://github.com/abgonzalez93/TrackPlay.git
cd TrackPlay
chmod +x scripts/*.sh
bash scripts/setup.sh
```

2. **Copia manualmente los archivos de entorno** para cada subproyecto:

```bash
cp .env-template trackplay-backend/.env
cp .npmrc-template trackplay-backend/.npmrc
cp .env-template trackplay-frontend/.env
cp .npmrc-template trackplay-frontend/.npmrc
cp .env-template trackplay-core/.env
cp .npmrc-template trackplay-core/.npmrc
```

3. **Levanta el entorno completo con Docker:**

```bash
docker compose up --build
```
