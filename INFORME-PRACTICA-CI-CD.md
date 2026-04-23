# Informe de implementación CI/CD actualizado a 2026

## 1. Descripción breve

Esta práctica toma como base un instructivo antiguo de GitHub Actions y lo actualiza a una solución vigente en 2026 para una aplicación simple en Node.js con Express. El repositorio quedó preparado para:

- ejecutar pruebas automáticamente con GitHub Actions
- construir y publicar una imagen Docker con acciones modernas
- desplegar la aplicación en local con Docker Compose
- documentar evidencias del proceso

## 2. Qué estaba desactualizado del instructivo antiguo

- Usaba acciones antiguas como `actions/checkout@v2`, `actions/setup-node@v1` y varias acciones Docker `@v1` o `@v2`.
- El workflow Docker tenía un secreto mal escrito: `GHRC_TOKEN` en vez de `GHCR_TOKEN`.
- La imagen estaba atada al ejemplo original `practica_7.1` y no al repositorio actual.
- No separaba claramente la validación de imagen en pull requests del push real a registries.
- El despliegue propuesto estaba orientado a `docker run` manual y no a `Docker Compose`.

## 3. Paso a paso de lo realizado

### Paso 1. Revisar el proyecto base

Se inspeccionó el repositorio para identificar:

- estructura del proyecto
- dependencias de Node.js
- pruebas existentes
- estado del Dockerfile
- ausencia de workflows en `.github/workflows`

**Espacio para imagen:** insertar captura de la estructura del proyecto o del árbol de archivos.

### Paso 2. Instalar dependencias y validar pruebas locales

Se instalaron los paquetes con Yarn para comprobar que el proyecto pudiera ejecutarse hoy con un entorno moderno.

```bash
yarn install --frozen-lockfile
yarn test
```

**Resultado esperado:** las pruebas terminan correctamente y generan el reporte de cobertura.

**Espacio para imagen:** insertar captura de la terminal con `yarn test`.

### Paso 3. Modificar la aplicación

Se agregó un nuevo animal a la granja, como pedía el instructivo original.

**Código principal usado:**

```js
var animals = {
  "cat": "meow",
  "dog": "bark",
  "eel": "hiss",
  "bear": "growl",
  "frog": "croak",
  "lion": "roar",
  "bird": "tweet",
  "cow": "moo"
}
```

**Espacio para imagen:** insertar captura del cambio en `app.js`.

### Paso 4. Crear el workflow de pruebas

Se creó `.github/workflows/test.yml` para automatizar la integración continua.

Este workflow:

- corre en `push` y `pull_request` sobre `main`
- usa `actions/checkout@v5`
- usa `actions/setup-node@v4`
- instala dependencias con Yarn
- ejecuta `yarn test`

**Código principal usado:**

```yaml
name: Granja Animales Node.js CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
```

**Espacio para imagen:** insertar captura del workflow en la pestaña `Actions`.

### Paso 5. Crear el workflow Docker modernizado

Se creó `.github/workflows/docker.yml` para trabajar con imagen Docker usando versiones actuales de las acciones.

Este workflow:

- valida que la imagen construye en `pull_request`
- publica a Docker Hub y GHCR en `push` a `main`
- usa `docker/setup-qemu-action@v3`
- usa `docker/setup-buildx-action@v3`
- usa `docker/login-action@v3`
- usa `docker/build-push-action@v6`

**Código principal usado:**

```yaml
permissions:
  contents: read
  packages: write
```

```yaml
echo "owner_lc=${GITHUB_REPOSITORY_OWNER,,}" >> "$GITHUB_OUTPUT"
echo "repo_lc=${GITHUB_EVENT_REPOSITORY_NAME,,}" >> "$GITHUB_OUTPUT"
```

**Espacio para imagen:** insertar captura del workflow Docker ejecutándose correctamente.

### Paso 6. Actualizar Docker y añadir Docker Compose

Se modernizó el `Dockerfile` y se añadió `compose.yaml` para despliegue local.

Comandos principales:

```bash
docker build -t local/new-ci-cd-class:latest .
docker compose up --build
```

La aplicación queda accesible en:

- `http://localhost:8080` con ejecución directa
- `http://localhost:9000` con Docker Compose

**Código principal usado:**

```yaml
services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "9000:8080"
```

**Espacio para imagen:** insertar captura de la aplicación funcionando en el navegador con Compose.

### Paso 7. Preparar secretos para GitHub Actions

Para publicar en Docker Hub hay que crear estos secretos en el repositorio:

- `DOCKERHUB_USERNAME`
- `DOCKERHUB_TOKEN`

En este entorno no fue posible automatizarlos por CLI porque `gh` no está instalado. Si se quiere hacer por terminal en otra máquina con GitHub CLI, los comandos serían:

```bash
gh secret set DOCKERHUB_USERNAME --body "TU_USUARIO"
gh secret set DOCKERHUB_TOKEN --body "TU_TOKEN"
```

Ruta alternativa por interfaz web:

`Settings > Secrets and variables > Actions > New repository secret`

**Espacio para imagen:** insertar captura de la sección de secrets del repositorio.

## 4. Archivos más importantes del cambio

- `.github/workflows/test.yml`
- `.github/workflows/docker.yml`
- `Dockerfile`
- `compose.yaml`
- `app.js`

## 5. Validación realizada

Se validó lo siguiente:

- instalación de dependencias con Yarn
- ejecución de pruebas con `yarn test`
- construcción de imagen con `docker build`
- arranque local con `docker compose up --build`
- respuesta correcta de `/` y `/api`

**Espacio para imagen:** insertar captura de la terminal con Docker Compose levantado.

## 6. Conclusión

La práctica quedó modernizada manteniendo la intención del instructivo original, pero adaptada a herramientas, versiones y buenas prácticas vigentes en 2026. La solución ahora permite automatizar pruebas, validar y publicar imágenes Docker, y desplegar el proyecto localmente con una ruta simple y reproducible.
