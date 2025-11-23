#!/usr/bin/env bash
set -euo pipefail

# Script para construir las imágenes docker del proyecto

echo "Construyendo imágenes Docker..."

# Construye la imagen con usuario root
echo "Construyendo imagen root..."
docker build -t pc4-app-root:latest -f docker/Dockerfile.root .

# Construye la imagen con usuario sin privilegios
echo "Construyendo imagen non-root..."
docker build -t pc4-app-nonroot:latest -f docker/Dockerfile.nonroot .

echo "Construcción completada!"
echo "Imágenes creadas:"
echo "  - pc4-app-root:latest"
echo "  - pc4-app-nonroot:latest"