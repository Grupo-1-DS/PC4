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
