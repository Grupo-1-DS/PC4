# Registro de Riesgos

Este documento identifica y rastrea los riesgos técnicos y de seguridad del proyecto, junto con sus planes de mitigación.

---

## Riesgo #1: Incompatibilidad entre Docker Desktop y WSL

**Tipo**: Técnico

**Descripción**:
Docker Desktop puede no integrarse correctamente con WSL, causando problemas al construir o ejecutar contenedores desde el entorno Linux.

**Probabilidad**: Media

**Impacto**: Alto

**Plan de mitigación**:

1. Verificar que Docker Desktop tiene habilitada la integración WSL2
2. Confirmar que la distribución Ubuntu está seleccionada en la configuración
3. Probar `docker ps` desde WSL antes de comenzar el desarrollo
4. Documentar los pasos de configuración en el README
5. Como alternativa, usar Docker nativo en Linux si WSL falla

**Estado**: Mitigado

**Notas**:

- Integración WSL2 funcionando correctamente
- Docker responde desde WSL sin problemas

---

## Riesgo #2: Permisos insuficientes en contenedor nonroot

**Tipo**: Técnico

**Descripción**:
El contenedor nonroot podría tener restricciones de permisos tan estrictas que impidan el funcionamiento normal de la aplicación, no solo las operaciones de prueba.

**Probabilidad**: Media

**Impacto**: Medio

**Plan de mitigación**:

1. Asegurar que el directorio de trabajo `/app-nonroot` tiene ownership correcto (appuser:appuser)
2. Crear volúmenes emptyDir en Kubernetes para directorios de escritura temporal (/tmp, /app-nonroot/tmp)
3. Probar la aplicación exhaustivamente en modo nonroot antes de añadir más restricciones
4. Documentar qué directorios necesitan permisos de escritura y por qué
5. Usar logs detallados para identificar problemas de permisos rápidamente

**Estado**: Mitigado

**Notas**:

- Volúmenes emptyDir agregados para /tmp y /app-nonroot/tmp
- La aplicación funciona correctamente con readOnlyRootFilesystem
- Endpoint /write-file falla como se esperaba en modo non-root

---

## Riesgo #3: Imágenes Docker con vulnerabilidades conocidas

**Tipo**: Seguridad

**Descripción**:
La imagen base python:3.12-slim o las dependencias en requirements.txt pueden contener vulnerabilidades de seguridad conocidas (CVEs).

**Probabilidad**: Alta

**Impacto**: Medio

**Plan de mitigación**:

1. Usar imágenes base oficiales y actualizadas (python:3.12-slim)
2. Fijar versiones específicas de dependencias en requirements.txt
3. Considerar usar pip-audit o trivy para escaneo de vulnerabilidades (Sprint 2)
4. Mantener un registro de dependencias conocidas vulnerables y justificación de su uso
5. Actualizar dependencias cuando sea crítico

**Estado**: Mitigado

**Notas**:

- Imagen base oficial python:3.12-slim actualizada regularmente
- Dependencias fijadas en requirements.txt
- Considerado de baja prioridad para el alcance del proyecto

---

## Riesgo #4: Pods no arrancan en Kubernetes por políticas muy restrictivas

**Tipo**: Técnico

**Descripción**:
Al aplicar readOnlyRootFilesystem y capabilities.drop: ALL, los pods pueden fallar al iniciar si la aplicación necesita escribir en ciertos directorios o requiere capabilities específicas.

**Probabilidad**: Media

**Impacto**: Alto

**Plan de mitigación**:

1. Configurar securityContext en pod: `runAsUser: 1000`, `runAsNonRoot: true`, `fsGroup: 1000`
2. Configurar securityContext en container: `readOnlyRootFilesystem: true`, `allowPrivilegeEscalation: false`, `capabilities.drop: [ALL]`
3. Crear volúmenes emptyDir montados en `/tmp` y `/app-nonroot/tmp`
4. Configurar resources.requests y resources.limits
5. Validar con `kubectl logs` y `kubectl describe pod` que no hay errores de permisos

**Estado**: Mitigado

**Notas**:

- Políticas de seguridad aplicadas correctamente en Sprint 2
- Volúmenes emptyDir solucionaron los problemas de escritura
- Los pods arrancan exitosamente con todas las restricciones

---

## Riesgo #5: Diferencias de comportamiento entre Docker y Kubernetes

**Tipo**: Técnico

**Descripción**:
Los contenedores pueden comportarse diferente en Docker local vs cuando se despliegan en Kubernetes (Minikube), especialmente en temas de networking y permisos.

**Probabilidad**: Media

**Impacto**: Medio

**Plan de mitigación**:

1. Probar ambos escenarios (Docker y K8s) para cada cambio importante
2. Usar la misma imagen Docker en ambos entornos (construcción con eval $(minikube docker-env))
3. Documentar diferencias observadas claramente
4. Configurar networking de forma similar en docker-compose.yml y K8s Services
5. Validar que los endpoints responden igual en ambos entornos

**Estado**: Mitigado

**Notas**:

- Script compare-modes.sh validó el comportamiento consistente
- Evidencia documentada en reports/compare.json
- Port-forward implementado para compatibilidad WSL

---

## Riesgo #6: Scripts incompatibles entre Windows y Linux

**Tipo**: Técnico

**Descripción**:
Los scripts Bash pueden tener problemas de saltos de línea (CRLF vs LF) o rutas incompatibles entre Windows y WSL/Linux.

**Probabilidad**: Baja

**Impacto**: Medio

**Plan de mitigación**:

1. Configurar todos los scripts con saltos de línea LF
2. Usar rutas relativas en scripts cuando sea posible
3. Probar scripts tanto en WSL como en Linux nativo si está disponible
4. Usar `set -euo pipefail` para detectar errores rápidamente
5. Documentar requisitos del entorno en README

**Estado**: Mitigado

**Notas**:

- Scripts configurados con saltos de línea LF
- Todos los scripts funcionan correctamente en WSL

---
