# Non-Root Everywhere Lab

Proyecto de DevSecOps que demuestra la implementación de contenedores Docker con usuarios no privilegiados (non-root) y su despliegue en Kubernetes con políticas de seguridad estrictas.

## Integrantes

- Gabriel Castillejo
- Albert Argumedo

## Videos de Evidencia

- [Videos Sprints](https://drive.google.com/drive/folders/10V9HbKCMk-8vFK8k9YFh1NgdjUAnfxL0?usp=sharing)

## Objetivo del Proyecto

Implementar y comparar el comportamiento de aplicaciones contenedorizadas ejecutándose como root vs non-root, tanto en Docker como en Kubernetes (Minikube). El proyecto incluye:

- Aplicación FastAPI con endpoints de prueba
- Contenedores Docker con dos configuraciones: root y non-root
- Manifiestos Kubernetes con políticas de seguridad
- Script automatizado de comparación y generación de reportes

## Tecnologías Utilizadas

- **Python 3.12**: Aplicación FastAPI
- **Docker**: Contenedorización
- **Kubernetes (Minikube)**: Orquestación de contenedores
- **Bash**: Scripts de automatización
- **WSL2**: Entorno de desarrollo

## Estructura del Proyecto

```
.
├── app/
│   ├── main.py              # Aplicación FastAPI
│   └── requirements.txt     # Dependencias Python
├── docker/
│   ├── Dockerfile.root      # Dockerfile ejecutando como root
│   └── Dockerfile.nonroot   # Dockerfile con usuario no privilegiado
├── k8s/
│   ├── deployment-root.yaml     # Deployment sin restricciones
│   ├── deployment-nonroot.yaml  # Deployment con políticas de seguridad
│   └── service.yaml             # Servicios k8s
├── scripts/
│   ├── build.sh                 # Construye ambas imágenes Docker
│   ├── run-root.sh              # Ejecuta contenedor root
│   ├── run-nonroot.sh           # Ejecuta contenedor non-root
│   ├── k8s-apply-*.sh           # Scripts de despliegue K8s
│   ├── k8s-clean.sh             # Limpia recursos de K8s
│   └── compare-modes.sh         # Script de comparación automatizada
├── doc/
│   ├── sprint-backlog-sprint1.md
│   ├── sprint-backlog-sprint2.md
│   ├── metrics.md
|   ├── vision.md
│   ├── risk-register.md
|   └── definition-of-done.md
├── reports/
│   └── compare.json         # Reporte de comparación
└── Makefile                 # Comandos make para build y ejecución
```

## Configuraciones de Seguridad

### Modo Non-Root (deployment-nonroot.yaml)

El deployment non-root implementa las siguientes políticas de seguridad:

- **runAsUser: 1000**: Ejecuta como usuario sin privilegios
- **runAsNonRoot: true**: Previene ejecución como root
- **readOnlyRootFilesystem: true**: Sistema de archivos raíz de solo lectura
- **allowPrivilegeEscalation: false**: Impide escalación de privilegios
- **capabilities.drop: [ALL]**: Elimina todas las capabilities de Linux
- **Volúmenes emptyDir**: Montados en /tmp y /app-nonroot/tmp para escritura temporal

## Uso

### Inicializar Minikube

```bash
# Comando de inicialización
minikube start
```


### Construcción de Imágenes Docker

```bash
# Construir ambas imágenes
make build

# O manualmente
bash scripts/build.sh
```

### Ejecución en Docker

```bash
# Ejecutar modo root
make run-root

# Ejecutar modo non-root
make run-nonroot

# Limpiar contenedores
make clean
```

### Despliegue en Kubernetes

```bash
# Configurar entorno Docker de Minikube
eval $(minikube docker-env)

# Construir imágenes
make build

# Aplicar manifiestos
make k8s-apply

# Verificar estado
kubectl get pods
kubectl get services

# Desplegar servicios 
make k8s-deploy

# Limpiar recursos
make k8s-clean
```

### Script de Comparación Automatizada

El script `compare-modes.sh` automatiza todo el proceso de comparación:

```bash
# Ejecutar comparación completa
bash scripts/compare-modes.sh

# Ver reporte generado
cat reports/compare.json
```

**Qué hace el script:**

1. Construye ambas imágenes Docker
2. Despliega ambos deployments en Kubernetes
3. Espera a que los pods estén listos
4. Ejecuta pruebas contra los endpoints /whoami y /write-file
5. Recolecta logs y resultados
6. Genera reporte JSON con la comparación completa

## Endpoints de la Aplicación

- `GET /`: Mensaje de bienvenida
- `GET /whoami`: Retorna información del usuario (UID, GID, username)
- `POST /write-file`: Intenta escribir un archivo en /restricted/test.txt

## Resultados

### Modo Root

- **UID**: 0 (root)
- **Escritura de archivos**: ✓ Exitosa
- **Permisos**: Sin restricciones

### Modo Non-Root

- **UID**: 1000 (appuser)
- **Escritura de archivos**: ✗ Bloqueada
- **Error**: "[Errno 30] Read-only file system"
- **Permisos**: Restringidos según políticas de seguridad

## Conclusiones

Este proyecto demuestra la importancia de ejecutar contenedores con usuarios no privilegiados y aplicar políticas de seguridad estrictas en Kubernetes. Las configuraciones implementadas:

- Reducen la superficie de ataque
- Previenen escalación de privilegios
- Limitan el impacto de posibles vulnerabilidades
- Mantienen la funcionalidad de la aplicación

El script de comparación automatizada proporciona evidencia concreta del comportamiento de ambos modos, facilitando la validación de las políticas de seguridad aplicadas.
