# Sprint Backlog - Sprint 1

## Objetivo del Sprint 1

Implementar la aplicación base en FastAPI con dos versiones de contenedores Docker (root y non-root), junto con scripts de automatización para construir y ejecutar ambas versiones.

## Historias de Usuario

### Historia #1: Crear aplicación Python con endpoints /whoami y /write-file

**ID**: Issue #1

**Descripción**:
Implementar una aplicación FastAPI simple con dos endpoints principales que permitan verificar el usuario que ejecuta el proceso y probar restricciones de escritura en el filesystem.

**Criterios de aceptación**:

- [x] Crear archivo de requerimientos (requirements.txt) con dependencias necesarias
- [x] Endpoint /whoami retorna UID/GID y nombre del usuario actual
- [x] Endpoint /write-file intenta escribir en /restricted/test.txt y maneja errores apropiadamente
- [x] La aplicación corre correctamente en puerto 8000

**Responsable(s)**: Albert Argumedo

**Estado**: Done (Closed)

---

### Historia #2: Crear Dockerfiles root y non-root

**ID**: Issue #2

**Descripción**:
Crear dos versiones de Dockerfiles para demostrar la diferencia entre ejecutar contenedores con privilegios root vs usuario sin privilegios.

**Criterios de aceptación**:

- [x] Crear docker/Dockerfile.root usando `USER root`
- [x] Crear docker/Dockerfile.nonroot con usuario `appuser`
- [x] Dockerfile.nonroot usa `USER appuser`
- [x] Configurar permisos mínimos en contenedor non-root
- [x] Configurar read-only root filesystem al correr contenedor non-root

**Responsable(s)**: Albert Argumedo

**Estado**: Done (Closed)

---

### Historia #3: Crear scripts bash para probar root y non-root

**ID**: Issue #3

**Descripción**:
Implementar scripts de automatización en Bash para construir y ejecutar los contenedores de forma simple y reproducible.

**Criterios de aceptación**:

- [x] Crear script `scripts/run-root.sh` para levantar instancia Docker root
- [x] Crear script `scripts/run-nonroot.sh` para levantar instancia Docker non-root
- [x] Crear script `scripts/build.sh` para construir ambas imágenes Docker
- [x] Scripts tienen permisos de ejecución correctos
- [x] Scripts usan saltos de línea LF para compatibilidad con WSL

**Responsable(s)**: Gabriel Castillejo

**Estado**: Done (Closed)

---

### Historia #4: Crear Makefile

**ID**: Issue #4

**Descripción**:
Crear Makefile para automatizar los comandos más comunes del proyecto y facilitar la ejecución.

**Criterios de aceptación**:

- [x] Target `make build` para construir imágenes
- [x] Target `make run-root` para ejecutar contenedor root
- [x] Target `make run-nonroot` para ejecutar contenedor non-root
- [x] Target `make test` para validaciones
- [x] Makefile documenta cada target con comentarios

**Responsable(s)**: Albert Argumedo

**Estado**: Done (Closed)

---

### Historia #5: Crear documentación inicial

**ID**: Issue #5

**Descripción**:
Crear la documentación mínima requerida para el proyecto según las especificaciones del curso.

**Criterios de aceptación**:

- [x] Crear docs/vision.md con contexto, problema, alcance y objetivos
- [x] Crear docs/sprint-backlog-sprint1.md con historias y tareas
- [x] Crear docs/risk-register.md con mínimo 5 riesgos identificados
- [x] Crear docs/metrics.md con estructura para métricas por sprint
- [x] Crear docs/definition-of-done.md con criterios de completitud

**Responsable(s)**: Gabriel Castillejo

**Estado**: Done (Closed)

---

## Notas del Sprint

- Se priorizó la funcionalidad básica sobre características avanzadas
- Los scripts usan saltos de línea LF para compatibilidad con WSL
- Se decidió usar python:3.12-slim como imagen base por balance entre tamaño y funcionalidad
- La versión de las imágenes se fijó en 1.0.0 para este sprint
