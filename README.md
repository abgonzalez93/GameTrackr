# 🚀 TrackPlay - Setup del Entorno de Desarrollo

Este repositorio contiene todos los scripts necesarios para configurar de forma automática y reproducible el entorno local de desarrollo para TrackPlay, incluyendo frontend, backend, core compartido, certificados locales y configuración de entorno.

---

## 📦 Requisitos Previos

Asegúrate de tener instalado lo siguiente:

### 🔧 Herramientas del sistema

| Herramienta                 | Requerida | Instrucciones de instalación                                                                 |
| --------------------------- | --------- | -------------------------------------------------------------------------------------------- |
| **WSL (Ubuntu)**            | ✅        | [Instalar WSL en Windows](https://learn.microsoft.com/es-es/windows/wsl/install)             |
| **Docker + Docker Compose** | ✅        | [Instalar Docker en Windows](https://docs.docker.com/desktop/setup/install/windows-install/) |

---

## 🔄 Configuración Automática

El script principal `scripts/setup.sh` se encarga de:

1. Instalar Git, Node.js y pnpm como gestor de paquetes.
2. Instalar herramientas globales como npm-check-updates.
3. Instalar mkcert y preparar certificados locales.
4. Generar certificados para los dominios locales trackplay.internal y api.trackplay.internal.
5. Generar claves RSA para la firma de JWT.
6. Clonar los cuatro repositorios necesarios:
   - [trackplay-auth](https://github.com/abgonzalez93/TrackPlay-Auth)
   - [trackplay-backend](https://github.com/abgonzalez93/TrackPlay-Backend)
   - [trackplay-core](https://github.com/abgonzalez93/TrackPlay-Core)
   - [trackplay-frontend](https://github.com/abgonzalez93/TrackPlay-Frontend)
   - [trackplay-igdb](https://github.com/abgonzalez93/TrackPlay-IGDB)
   - [trackplay-notifications](https://github.com/abgonzalez93/TrackPlay-Notifications)
7. Copiar archivo `.npmrc` desde sus plantillas.

---

## ▶️ Pasos para Ejecutar el Setup

1. **Clona este repositorio raíz** en tu carpeta de trabajo:

```bash
git clone https://github.com/abgonzalez93/TrackPlay.git
cd TrackPlay
bash scripts/setup.sh
```

2. **Copia manualmente los archivos de entorno** para cada subproyecto:

```bash
cp .npmrc-template trackplay-backend/.npmrc
cp .npmrc-template trackplay-core/.npmrc
cp .npmrc-template trackplay-frontend/.npmrc
cp .npmrc-template trackplay-igdb/.npmrc
cp .npmrc-template trackplay-auth/.npmrc
```

3. **Levanta el entorno completo con Docker:**

```bash
docker compose up --build
```
