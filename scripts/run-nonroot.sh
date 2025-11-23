#!/usr/bin/env bash
set -euo pipefail

# Script para ejecutar el contenedor con usuario sin privilegios

VERSION="1.0.0"

echo "Iniciando contenedor non-root versión ${VERSION}..."

# Levanta el contenedor en modo detached en puerto 8001
docker run -d \
  --name pc4-app-nonroot \
  -p 8001:8000 \
  pc4-app-nonroot:${VERSION}

echo "Contenedor non-root iniciado!"
echo "Nombre: pc4-app-nonroot"
echo "Puerto: 8001:8000"
echo ""
echo "Endpoints disponibles:"
echo "  - http://localhost:8001/whoami"
echo "  - http://localhost:8001/write-file"
echo ""
echo "Ver logs: docker logs pc4-app-nonroot"
echo "Detener: docker stop pc4-app-nonroot"
echo "Eliminar: docker rm pc4-app-nonroot"