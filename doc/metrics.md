# Métricas del Proyecto

Este documento registra las métricas de proceso, calidad técnica y seguridad para cada sprint del proyecto.

---

## Sprint 1

**Duración**: Días 1-5

### Métricas de proceso (Scrum/Kanban)

#### Throughput

- **Historias completadas**: 4 de 5 (80%)
  - Issue #1: Aplicación Python
  - Issue #2: Dockerfiles
  - Issue #3: Scripts Bash
  - Issue #4: Makefile
  - Issue #5: Documentación (En progreso )
- **Tareas técnicas completadas**: 6
  - Aplicación FastAPI
  - Dockerfile root
  - Dockerfile nonroot
  - Script de construcción
  - Scripts de ejecución (2)
  - Makefile

#### Lead Time

- **Promedio de tiempo desde In Progress hasta Done**: 2.75 horas
- **Tarea más rápida**: Issue #1, #2, #4 (2 horas cada una)
- **Tarea más lenta**: Issue #3 (5 horas, de Ready a Done directamente)

**Notas**:

- El tiempo promedio es bajo porque la mayoría de las tareas se completaron el mismo día

#### WIP (Work in Progress)

- **Límite WIP acordado**: 3 issues
- **WIP máximo alcanzado**: 2 issues simultáneas (Issues #1 y #2 )
- **WIP promedio**: 1.5 issues

**Observaciones**:

- Al inicio del sprint  se trabajaron 2 issues en paralelo
- Después se mantuvo 1 issue a la vez
- No hubo bloqueos significativos
- El equipo logró mantener un flujo constante sin acumular WIP excesivo

---

## Sprint 2

**Duración**: Días 6-10

### Métricas de proceso (Scrum/Kanban)

#### Throughput

- **Historias completadas**: 4 de 4 (100%)
  - Issue #6: Manifiestos Kubernetes
  - Issue #7: Scripts de despliegue K8s
  - Issue #8: Script compare-modes
  - Issue #9: Documentación final
- **Tareas técnicas completadas**: 11
  - k8s/deployment-root.yaml
  - k8s/deployment-nonroot.yaml
  - k8s/service.yaml (dos servicios NodePort)
  - scripts/k8s-apply-root.sh
  - scripts/k8s-apply-nonroot.sh
  - scripts/k8s-apply-service.sh
  - scripts/k8s-clean.sh
  - scripts/compare-modes.sh (156 líneas)
  - Actualización de Makefile (targets k8s-apply y k8s-clean)
  - reports/compare.json generado
  - Documentación de manifiestos

#### Lead Time

- **Promedio de tiempo desde In Progress hasta Done**: 8 horas
- **Tarea más rápida**: Issue #8 (57 minutos)
- **Tarea más lenta**: Issue #6 (22 horas)

**Notas**:

- Issue #6 tomó más tiempo por las iteraciones necesarias para configurar volúmenes emptyDir correctamente
- Los issues #7 y #8 se completaron rápidamente al tener los manifiestos ya listos
- El script compare-modes.sh fue muy eficiente en su implementación

#### WIP (Work in Progress)

- **Límite WIP acordado**: 2 issues
- **WIP máximo observado**: 1 issue a la vez
- **WIP promedio**: 1 issue

**Observaciones**:

- Se trabajó de forma más secuencial en este sprint
- Cada issue dependía del anterior (manifiestos -> scripts -> comparación)
- No hubo bloqueos técnicos significativos
- El trabajo se distribuyó entre ambos miembros del equipo
