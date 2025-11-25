#!/usr/bin/env bash
set -euo pipefail

# Script para comparar el comportamiento de contenedores root vs non-root
# Versión con port-forward (para wsl )

REPORTS_DIR="reports"
OUTPUT_FILE="${REPORTS_DIR}/compare.json"

# Puertos locales para port-forward
ROOT_LOCAL_PORT=8080
NONROOT_LOCAL_PORT=8081

echo "=== Iniciando comparación de modos root vs non-root (port-forward) ==="

# Función para limpiar port-forwards al salir
cleanup() {
    echo ""
    echo "Limpiando procesos de port-forward..."
    if [ ! -z "${ROOT_PF_PID:-}" ]; then
        kill ${ROOT_PF_PID} 2>/dev/null || true
    fi
    if [ ! -z "${NONROOT_PF_PID:-}" ]; then
        kill ${NONROOT_PF_PID} 2>/dev/null || true
    fi
}

# Registrar función de limpieza para ejecutar al salir
trap cleanup EXIT

# 1. Construir ambas imágenes
echo ""
echo "Paso 1: Construyendo imágenes Docker..."
bash scripts/build.sh

# 2. Desplegar manifiestos en Kubernetes
echo ""
echo "Paso 2: Desplegando manifiestos en Kubernetes..."
bash scripts/k8s-apply-nonroot.sh
bash scripts/k8s-apply-root.sh
bash scripts/k8s-apply-service.sh


# 3. Esperar a que los pods estén listos
echo ""
echo "Paso 3: Esperando a que los pods estén listos..."
echo "Esperando pod root..."
kubectl wait --for=condition=ready pod -l app=pc4-app-root --timeout=120s
echo "Esperando pod non-root..."
kubectl wait --for=condition=ready pod -l app=pc4-app-nonroot --timeout=120s

# Esperar unos segundos adicionales para que los servicios estén completamente listos
sleep 5

# 4. Iniciar port-forward para ambos servicios
echo ""
echo "Paso 4: Iniciando port-forward..."
echo "Port-forward root: localhost:${ROOT_LOCAL_PORT} -> service/pc4-app-root-service:8000"
kubectl port-forward service/pc4-app-root-service ${ROOT_LOCAL_PORT}:8000 > /dev/null 2>&1 &
ROOT_PF_PID=$!

echo "Port-forward non-root: localhost:${NONROOT_LOCAL_PORT} -> service/pc4-app-nonroot-service:8000"
kubectl port-forward service/pc4-app-nonroot-service ${NONROOT_LOCAL_PORT}:8000 > /dev/null 2>&1 &
NONROOT_PF_PID=$!

# Esperar a que los port-forwards estén listos
sleep 3

# 5. Ejecutar curl contra los endpoints
echo ""
echo "Paso 5: Probando endpoints..."

# Endpoints para modo root
ROOT_ENDPOINT="http://localhost:${ROOT_LOCAL_PORT}"
echo "Probando endpoint root: ${ROOT_ENDPOINT}"
ROOT_WHOAMI=$(curl -s "${ROOT_ENDPOINT}/whoami")
ROOT_WRITE=$(curl -s "${ROOT_ENDPOINT}/write-file")

# Endpoints para modo non-root
NONROOT_ENDPOINT="http://localhost:${NONROOT_LOCAL_PORT}"
echo "Probando endpoint non-root: ${NONROOT_ENDPOINT}"
NONROOT_WHOAMI=$(curl -s "${NONROOT_ENDPOINT}/whoami")
NONROOT_WRITE=$(curl -s "${NONROOT_ENDPOINT}/write-file")

# 6. Obtener logs de los pods
echo ""
echo "Paso 6: Recolectando logs de los pods..."
ROOT_POD=$(kubectl get pod -l app=pc4-app-root -o jsonpath='{.items[0].metadata.name}')
NONROOT_POD=$(kubectl get pod -l app=pc4-app-nonroot -o jsonpath='{.items[0].metadata.name}')

ROOT_LOGS=$(kubectl logs ${ROOT_POD} 2>&1 | sed 's/"/\\"/g' | awk '{printf "%s\\n", $0}')
NONROOT_LOGS=$(kubectl logs ${NONROOT_POD} 2>&1 | sed 's/"/\\"/g' | awk '{printf "%s\\n", $0}')

# 7. Extraer información relevante
echo ""
echo "Paso 7: Procesando datos recolectados..."

# Extraer UID de las respuestas whoami
ROOT_UID=$(echo "${ROOT_WHOAMI}" | grep -o '"uid":[0-9]*' | cut -d':' -f2)
NONROOT_UID=$(echo "${NONROOT_WHOAMI}" | grep -o '"uid":[0-9]*' | cut -d':' -f2)

# Determinar si pudieron escribir el archivo
ROOT_CAN_WRITE=$(echo "${ROOT_WRITE}" | grep -q '"message"' && echo "true" || echo "false")
NONROOT_CAN_WRITE=$(echo "${NONROOT_WRITE}" | grep -q '"message"' && echo "true" || echo "false")

# 8. Generar JSON final
echo ""
echo "Paso 8: Generando reporte JSON..."
mkdir -p "${REPORTS_DIR}"

cat > "${OUTPUT_FILE}" << EOF
{
  "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "method": "port-forward",
  "comparison": {
    "root": {
      "uid": ${ROOT_UID},
      "user_info": ${ROOT_WHOAMI},
      "can_write_file": ${ROOT_CAN_WRITE},
      "write_result": ${ROOT_WRITE},
      "pod_name": "${ROOT_POD}",
      "logs": "${ROOT_LOGS}",
      "endpoint": "${ROOT_ENDPOINT}",
      "local_port": ${ROOT_LOCAL_PORT}
    },
    "nonroot": {
      "uid": ${NONROOT_UID},
      "user_info": ${NONROOT_WHOAMI},
      "can_write_file": ${NONROOT_CAN_WRITE},
      "write_result": ${NONROOT_WRITE},
      "pod_name": "${NONROOT_POD}",
      "logs": "${NONROOT_LOGS}",
      "endpoint": "${NONROOT_ENDPOINT}",
      "local_port": ${NONROOT_LOCAL_PORT}
    }
  },
  "summary": {
    "root_uid": ${ROOT_UID},
    "nonroot_uid": ${NONROOT_UID},
    "root_can_write": ${ROOT_CAN_WRITE},
    "nonroot_can_write": ${NONROOT_CAN_WRITE}
  }
}
EOF

echo ""
echo "=== Comparación completada ==="
echo "Resultados guardados en: ${OUTPUT_FILE}"
echo ""
echo "Resumen:"
echo "  Root UID: ${ROOT_UID}, Puede escribir: ${ROOT_CAN_WRITE}"
echo "  Non-root UID: ${NONROOT_UID}, Puede escribir: ${NONROOT_CAN_WRITE}"
echo ""
echo "Para ver el reporte completo:"
echo "  cat ${OUTPUT_FILE}"
