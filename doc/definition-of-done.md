# Definition of Done

Este documento define los criterios mínimos que deben cumplirse para considerar una tarea o historia de usuario como "Done" (completada) en este proyecto.

## Criterios generales

Para que una tarea se considere completada, debe cumplir TODOS los siguientes criterios:

### 1. Cumple con especificaciones de la issue

- [ ] El código implementado funciona según las especificaciones definidas en la issue
- [ ] No hay errores críticos que impidan la ejecución

### 2. Documentación de cambios

- [ ] Los cambios en el código están documentados con comentarios explicando la intención
- [ ] README.md está actualizado si se añadieron nuevos comandos o funcionalidades

### 3. Reproducibilidad

- [ ] Cualquier miembro del equipo puede ejecutar el código siguiendo la documentación
- [ ] No depende de configuraciones específicas del entorno local
- [ ] Las dependencias están claramente especificadas

### 4. Control de versiones

- [ ] Los cambios están commiteados en Git con mensajes descriptivos
- [ ] No se subieron archivos que deberían estar en .gitignore (.env, __pycache__, etc.)
- [ ] El historial de commits refleja el progreso de la tarea

## Criterios específicos por tipo de tarea

### Para tareas de Docker

- [ ] La imagen construye sin errores
- [ ] La imagen usa tags explícitos (no :latest)
- [ ] El .dockerignore excluye archivos innecesarios
- [ ] Se probó que el contenedor arranca correctamente

### Para tareas de Kubernetes

- [ ] Los manifiestos son válidos (se pueden aplicar sin errores de sintaxis)
- [ ] Los recursos incluyen labels apropiados
- [ ] Se configuraron resources.requests y resources.limits
- [ ] Los pods arrancan correctamente

### Para tareas de scripts

- [ ] Primera línea es `#!/usr/bin/env bash`
- [ ] Se usa `set -euo pipefail` para manejo de errores
- [ ] Tienen comentarios en español explicando pasos clave
- [ ] Se probó la ejecución en el entorno target (WSL/Linux)

## Proceso de validación

Antes de mover una tarea a "Done":

1. __Auto-revisión__: El responsable verifica todos los criterios de esta lista
2. __Ejecución limpia__: Se ejecuta desde cero en un entorno limpio si es posible
3. __Documentación verificada__: Se confirma que la documentación está actualizada
4. __Commit realizado__: Los cambios están en el repositorio

## Excepciones

Si por alguna razón no se puede cumplir algún criterio, debe:

- Documentarse explícitamente en la historia/tarea
- Incluir la justificación técnica
- Crear una tarea de seguimiento si es necesaria para resolverla después
