# Sprint Backlog - Sprint 2

## Objetivo del Sprint 2

Desplegar la aplicación en Kubernetes (Minikube) con dos configuraciones distintas: una ejecutándose como root y otra con usuario no privilegiado, implementando políticas de seguridad estrictas. Además, crear un script automatizado que compare el comportamiento de ambos modos y genere un reporte detallado en formato JSON.

## Historias de Usuario

### Historia #6: Crear manifiestos Kubernetes

**ID**: Issue #6

**Descripción**:
Desarrollar los manifiestos YAML necesarios para desplegar la aplicación en Kubernetes con dos configuraciones diferentes: root y non-root. Los manifiestos deben incluir deployments con sus respectivas configuraciones de seguridad y services para exponer las aplicaciones.

**Criterios de aceptación**:

- [x] Crear k8s/deployment-root.yaml con configuración básica
- [x] Crear k8s/deployment-nonroot.yaml con securityContext configurado
- [x] Configurar runAsUser: 1000, runAsNonRoot: true en pod securityContext
- [x] Aplicar readOnlyRootFilesystem, allowPrivilegeEscalation: false en container
- [x] Eliminar todas las capabilities con drop: ALL
- [x] Crear k8s/service.yaml con dos servicios NodePort (30080 y 30081)
- [x] Configurar resources limits y requests en ambos deployments
- [x] Añadir volúmenes emptyDir para /tmp y /app-nonroot/tmp

**Responsable(s)**: Gabriel Castillejo

**Estado**: Done (Closed)

---

### Historia #7: Crear scripts bash para aplicar K8s

**ID**: Issue #7

**Descripción**:
Implementar scripts Bash que automaticen el despliegue de los manifiestos en Kubernetes mediante kubectl. Los scripts deben ser simples y enfocados, aplicando un manifiesto específico cada uno para facilitar el debugging.

**Criterios de aceptación**:

- [x] Crear scripts/k8s-apply-root.sh para desplegar deployment root
- [x] Crear scripts/k8s-apply-nonroot.sh para desplegar deployment non-root
- [x] Crear scripts/k8s-apply-service.sh para desplegar los servicios
- [x] Crear scripts/k8s-clean.sh para eliminar recursos de K8s
- [x] Scripts usan set -euo pipefail para manejo de errores
- [x] Actualizar Makefile con targets k8s-apply y k8s-clean

**Responsable(s)**: Albert Argumedo

**Estado**: Done (Closed)

---

### Historia #8: Crear script bash compare-modes.sh

**ID**: Issue #8

**Descripción**:
Desarrollar un script Bash completo que automatice la comparación entre los modos root y non-root. El script debe construir imágenes, desplegar en K8s, ejecutar pruebas contra los endpoints, recolectar información y generar un reporte JSON estructurado con los resultados.

**Criterios de aceptación**:

- [x] Script construye ambas imágenes Docker
- [x] Despliega ambos deployments y services en Kubernetes
- [x] Espera a que los pods estén listos con kubectl wait
- [x] Usa port-forward para acceder a los servicios (compatibilidad WSL)
- [x] Ejecuta curl contra endpoints /whoami y /write-file
- [x] Colecta UID, resultados de escritura y logs de ambos pods
- [x] Genera reporte estructurado en reports/compare.json
- [x] Incluye función cleanup para limpiar port-forwards al salir
- [x] Muestra resumen en consola al finalizar

**Responsable(s)**: Gabriel Castillejo

**Estado**: Done (Closed)

---

### Historia #9: Crear documentación final

**ID**: Issue #9

**Descripción**:
Completar la documentación del proyecto actualizando los archivos necesarios para el Sprint 2, incluyendo el sprint backlog, métricas del sprint y mejoras al README con instrucciones de Kubernetes.

**Criterios de aceptación**:

- [x] Crear doc/sprint-backlog-sprint2.md con las historias del sprint
- [x] Actualizar doc/metrics.md con métricas reales del Sprint 2
- [x] Actualizar doc/risk-register.md marcando riesgos mitigados
- [x] Mejorar README.md con instrucciones de Kubernetes
- [x] Documentar el script compare-modes.sh

**Responsable(s)**: Albert Argumedo

**Estado**: Done

---

## Notas del Sprint

- Se implementó port-forward en lugar de acceso directo a NodePort para mejor compatibilidad con WSL
- Los volúmenes emptyDir fueron necesarios para que la aplicación funcione con readOnlyRootFilesystem
- El script compare-modes.sh generó evidencia concreta del comportamiento en reports/compare.json
- Se validó que readOnlyRootFilesystem bloquea correctamente la escritura en modo non-root
- La configuración capabilities.drop: ALL elimina todos los privilegios del contenedor
- Ambos pods arrancan exitosamente en Minikube sin problemas de compatibilidad
- El trabajo se distribuyó equilibradamente entre ambos miembros del equipo
