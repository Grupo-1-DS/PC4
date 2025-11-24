# Visión del Proyecto - Non-Root Everywhere Lab

## Contexto

Este proyecto surge de la necesidad de demostrar en un entorno práctico cómo la ejecución de contenedores con usuarios privilegiados (root) representa un riesgo de seguridad significativo comparado con la ejecución usando usuarios sin privilegios.

Muchas organizaciones todavía ejecutan sus contenedores como root por default, sin entender las implicaciones de seguridad. Este lab sirve como herramienta educativa y de compliance para mostrar las diferencias.

## Problema que resuelve

El proyecto aborda los siguientes problemas:

1. **Falta de conciencia sobre seguridad en contenedores**: Muchos desarrolladores no entienden por qué correr contenedores como root es peligroso.

2. **Dificultad para demostrar el impacto**: Es difícil mostrar de forma tangible cómo un contenedor comprometido con permisos root puede causar más daño.

3. **Necesidad de compliance**: Los equipos de seguridad necesitan evidencia concreta de que las políticas de "non-root everywhere" funcionan y son aplicables.

## Alcance

### Dentro del alcance

- Aplicación FastAPI simple con endpoints de prueba (/whoami, /write-file)
- Dos versiones de contenedores Docker: una con usuario root y otra con usuario sin privilegios
- Scripts automatizados para construir y ejecutar ambas versiones
- Manifiestos de Kubernetes que demuestran políticas de seguridad (securityContext, readOnlyRootFilesystem)
- Comparación práctica del comportamiento de ambos contenedores
- Documentación de las diferencias observadas

### Fuera del alcance

- Análisis de vulnerabilidades en dependencias
- Escaneo SAST/DAST automatizado
- Integración con sistemas de monitoreo externos
- Deployment en cloud providers

## Objetivos técnicos

1. **Demostrar diferencias de permisos**: Mostrar claramente cómo los permisos del usuario afectan las operaciones dentro del contenedor.

2. **Implementar mejores prácticas de seguridad**: Usar securityContext, readOnlyRootFilesystem, capabilities drop, etc.

3. **Automatización completa**: Todo debe ser ejecutable con comandos simples (make build, make run, kubectl apply).

4. **Reproducibilidad**: Cualquier persona debe poder clonar el repo y ejecutar el lab localmente.

## Objetivos de aprendizaje

1. Entender la diferencia entre ejecutar contenedores como root vs non-root
2. Aprender a configurar securityContext en Kubernetes
3. Comprender el impacto de readOnlyRootFilesystem
4. Practicar con multi-stage builds y Dockerfiles seguros
5. Aplicar principios de DevSecOps en un proyecto real

## Inspiración en caso real

Este lab se inspira en escenarios comunes de la industria donde organizaciones descubren que la mayoría de sus contenedores corren como root sin necesidad. Este es un patrón recurrente en equipos que migran a contenedores sin revisar las implicaciones de seguridad.

Cuando un contenedor ejecutándose como root es comprometido (por ejemplo, a través de una vulnerabilidad en una dependencia), el atacante tiene permisos completos dentro del contenedor para escribir archivos, modificar configuraciones y potencialmente escalar privilegios al host.

Las organizaciones que implementan políticas de "non-root everywhere" reducen significativamente su superficie de ataque. Este lab recrea ese escenario de forma controlada para demostrar el valor de estas políticas.

## Stack tecnológico

- **Lenguaje**: Python 3.12
- **Framework web**: FastAPI
- **Contenedores**: Docker con imágenes python:3.12-slim
- **Orquestación**: Kubernetes (Minikube para local)
- **Automatización**: Bash scripts + Makefile
- **Entorno**: 100% local, sin cloud
