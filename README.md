# Non-root everywhere lab

## Manifiestos de Kubernetes

Este proyecto incluye manifiestos de Kubernetes en la carpeta `k8s/` para demostrar la ejecución de contenedores en un entorno orquestado. Los manifiestos permiten comparar el comportamiento de contenedores ejecutándose como root vs non-root directamente en Kubernetes.

### Archivos incluidos

#### deployment-root.yaml

Deployment básico que ejecuta el contenedor `pc4-app-root` como usuario root (comportamiento por defecto de Kubernetes).

**Características**:

- Ejecuta como usuario root sin restricciones
- Configura límites de recursos (CPU y memoria)
- Expone el puerto 8000

#### deployment-nonroot.yaml

Deployment con configuraciones de seguridad reforzadas que ejecuta el contenedor `pc4-app-nonroot` con un usuario sin privilegios.

**Características de seguridad implementadas**:

- `runAsUser: 1000` y `runAsNonRoot: true`: Ejecuta el contenedor como usuario ID 1000 (no root)
- `readOnlyRootFilesystem: true`: El filesystem root es read-only, previene escrituras maliciosas
- `allowPrivilegeEscalation: false`: Impide que el proceso obtenga más privilegios
- `capabilities.drop: [ALL]`: Elimina todas las capabilities de Linux del contenedor
- Volúmenes emptyDir para `/tmp` y `/app-nonroot/tmp`: Provee directorios escribibles necesarios para la aplicación

#### service.yaml

Define dos servicios de tipo NodePort para exponer las aplicaciones fuera del cluster.

**Servicios incluidos**:

- `pc4-app-root-service`: Expone el deployment root en el puerto 30080
- `pc4-app-nonroot-service`: Expone el deployment non-root en el puerto 30081

### Uso

Para deployar los manifiestos en un cluster de Kubernetes (como Minikube):

```bash
# Definir el entorno de instalacion de las imagenes
eval $(minikube docker-env)

# Construir Imagenes
make build

# Deployar ambas aplicaciones
kubectl apply -f k8s/deployment-root.yaml
kubectl apply -f k8s/deployment-nonroot.yaml
kubectl apply -f k8s/service.yaml

# Verificar los deployments
kubectl get deployments
kubectl get pods
kubectl get services
```

### Script de comparación automatizada

#### compare-modes.sh

Script automatizado que compara el comportamiento de contenedores ejecutándose como root vs non-root en Kubernetes.

**Funcionalidad**:

El script ejecuta los siguientes pasos de forma automatizada:

1. **Construcción de imágenes**: Construye ambas imágenes Docker (root y non-root) usando el script `build.sh`
2. **Despliegue de manifiestos**: Aplica los manifiestos de Kubernetes para ambos deployments y sus servicios
3. **Verificación de pods**: Espera a que ambos pods estén en estado `ready` antes de continuar
4. **Port-forwarding**: Inicia `kubectl port-forward` en background para exponer los servicios en puertos locales (8080 para root, 8081 para non-root)
5. **Pruebas de endpoints**: Ejecuta `curl` contra los endpoints `/whoami` y `/write-file` de ambos servicios
6. **Recolección de datos**: Obtiene los logs de ambos pods y extrae información relevante (UID, capacidad de escritura)
7. **Generación de reporte**: Crea un archivo JSON en `reports/compare.json` con toda la información recolectada
8. **Limpieza automática**: Mata los procesos de port-forward al finalizar (incluso si ocurre un error)

**Uso**:

```bash
# Configurar el entorno Docker de minikube
eval $(minikube docker-env)

# Ejecutar el script de comparación
bash scripts/compare-modes-portforward.sh

# Ver el reporte generado
cat reports/compare.json
```

**Ventajas de usar port-forward**:

- No requiere `minikube tunnel` corriendo en otra terminal
- Funciona perfectamente en WSL sin bloquear la consola
- Limpieza automática de recursos al finalizar
- Acceso a servicios mediante `localhost` en lugar de IP de minikube

**Estructura del reporte JSON**:

El archivo `reports/compare.json` contiene:

- Timestamp de ejecución
- Información completa de ambos modos (root y non-root)
- UID del usuario en cada contenedor
- Resultado de intentar escribir archivos
- Logs completos de cada pod
- Resumen comparativo de las diferencias
