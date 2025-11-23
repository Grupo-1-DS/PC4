#!/usr/bin/env bash
set -euo pipefail

# Script para ejecutar el contenedor con usuario root

VERSION="1.0.0"

echo "Iniciando contenedor root versión ${VERSION}..."

# Levanta el contenedor en modo detached en puerto 8000
docker run -d \
  --name pc4-app-root \
  -p 8000:8000 \
  pc4-app-root:${VERSION}

echo "Contenedor root iniciado!"
echo "Nombre: pc4-app-root"
echo "Puerto: 8000:8000"
echo ""
echo "Endpoints disponibles:"
echo "  - http://localhost:8000/whoami"
echo "  - http://localhost:8000/write-file"
echo ""
echo "Ver logs: docker logs pc4-app-root"
echo "Detener: docker stop pc4-app-root"
echo "Eliminar: docker rm pc4-app-root"