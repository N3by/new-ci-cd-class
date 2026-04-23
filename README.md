# Práctica CI/CD actualizada a 2026

Aplicación Node.js/Express usada para practicar CI/CD con GitHub Actions, Docker y despliegue local con Docker Compose.

## Ejecución local

```bash
yarn install
yarn test
yarn start
```

La aplicación queda disponible en `http://localhost:8080`.

## Despliegue local con Docker Compose

```bash
docker compose up --build
```

La aplicación queda disponible en `http://localhost:9000`.

## Workflows incluidos

- `test.yml`: ejecuta instalación y pruebas en `push` y `pull_request` sobre `main`.
- `docker.yml`: valida la construcción de la imagen en `pull_request` y publica a Docker Hub y GHCR en `push` a `main`.

## Secrets necesarios para publicación

- `DOCKERHUB_USERNAME`
- `DOCKERHUB_TOKEN`

Para `GHCR` se usa `GITHUB_TOKEN` con permisos de `packages: write`.
