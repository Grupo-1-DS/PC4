#!/usr/bin/env bash
set -euo pipefail

# Script para construir las imágenes docker del proyecto

VERSION="1.0.0"

echo "Construyendo imágenes Docker versión ${VERSION}..."

# Construye la imagen con usuario root
echo "Construyendo imagen root..."
docker build -t pc4-app-root:${VERSION} -f docker/Dockerfile.root .

# Construye la imagen con usuario sin privilegios
echo "Construyendo imagen non-root..."
docker build -t pc4-app-nonroot:${VERSION} -f docker/Dockerfile.nonroot .

echo "Construcción completada!"
echo "Imágenes creadas:"
echo "  - pc4-app-root:${VERSION}"
echo "  - pc4-app-nonroot:${VERSION}"