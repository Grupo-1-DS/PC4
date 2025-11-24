# Sprint 1 - Contenedores Docker con usuarios root y non-root

## Qué se hizo en este sprint

En el sprint 1 armamos la base del proyecto, que es una aplicación simple en FastAPI para comparar cómo se comportan los contenedores cuando corren con usuario root vs cuando corren con un usuario sin privilegios.

La idea era demostrar las diferencias de seguridad entre ambos enfoques usando Docker.

## Estructura del proyecto

```
PC4/
├── app/
│   ├── main.py              # aplicación FastAPI
│   └── requirements.txt      # dependencias
├── docker/
│   ├── Dockerfile.root       # dockerfile con usuario root
│   └── Dockerfile.nonroot    # dockerfile con usuario sin privilegios
├── scripts/
│   ├── build.sh              # construye ambas imágenes
│   ├── run-root.sh           # ejecuta contenedor root
│   └── run-nonroot.sh        # ejecuta contenedor nonroot
└── Makefile                  # automatiza build y run
```

## Aplicación FastAPI

La app es súper simple, tiene 2 endpoints:

### /whoami

Devuelve info del usuario que está ejecutando el proceso:
- uid: user id
- gid: group id
- user: nombre del usuario

Sirve para verificar con qué usuario está corriendo el contenedor.

### /write-file

Intenta escribir un archivo en `/restricted/test.txt`.

Si tiene permisos devuelve mensaje de éxito, si no devuelve el error. Esto sirve para ver las restricciones de permisos de cada contenedor.

## Dockerfiles

### Dockerfile.root

Este es el contenedor sin restricciones de seguridad:

- Usa `python:3.12-slim` como base.
- Copia la app a `/app-root`.
- Instala dependencias.
- Crea directorio `/restricted`.
- Corre como usuario `root` (UID 0).

El problema es que si alguien compromete la app, tiene permisos completos dentro del contenedor.

### Dockerfile.nonroot

Este es el contenedor con mejores prácticas de seguridad:

- Crea usuario `appuser` sin privilegios.
- Copia la app a `/app-nonroot`.
- Da ownership de `/app-nonroot` a `appuser`.
- Pone permisos 555 (solo lectura/ejecución) en `/restricted`.
- Corre como usuario `appuser` (UID > 0).

Si comprometen esta app, el atacante tiene permisos limitados.

## Scripts

### build.sh

Construye ambas imágenes Docker con versión 1.0.0:
- `pc4-app-root:1.0.0`
- `pc4-app-nonroot:1.0.0`

### run-root.sh

Levanta el contenedor root en puerto 8000:
- Nombre: `pc4-app-root`
- Puerto: 8000:8000

### run-nonroot.sh

Levanta el contenedor nonroot en puerto 8001:
- Nombre: `pc4-app-nonroot`
- Puerto: 8001:8000

Note que mapea a puerto diferente (8001) para que puedan correr ambos al mismo tiempo.

## Makefile

Tiene 2 targets principales:

### make build

Ejecuta `scripts/build.sh` para construir ambas imágenes.

### make run

Ejecuta ambos scripts de run para levantar los 2 contenedores.

## Cómo usar

### Construir imágenes

```bash
make build
# o directamente
bash scripts/build.sh
```

### Ejecutar contenedores

```bash
make run
# o por separado
bash scripts/run-root.sh
bash scripts/run-nonroot.sh
```

### Probar endpoints

Contenedor root:
```bash
curl http://localhost:8000/whoami
curl http://localhost:8000/write-file
```

Contenedor nonroot:
```bash
curl http://localhost:8001/whoami
curl http://localhost:8001/write-file
```

### Comandos útiles

Ver logs:
```bash
docker logs pc4-app-root
docker logs pc4-app-nonroot
```

Detener contenedores:
```bash
docker stop pc4-app-root pc4-app-nonroot
```

Eliminar contenedores:
```bash
docker rm pc4-app-root pc4-app-nonroot
```

## Diferencias observadas

Cuando pruebas los endpoints ves claramente la diferencia:

**Contenedor root:**
- whoami devuelve: `{"uid":0,"gid":0,"user":"root"}`
- write-file funciona sin problemas

**Contenedor nonroot:**
- whoami devuelve: `{"uid":1000,"gid":1000,"user":"appuser"}` (o similar dependiendo del UID)
- write-file puede fallar por restricciones de permisos

Esto demuestra que el contenedor nonroot tiene menos permisos y es más seguro.

## Conclusiones del sprint 1

- Se armó la estructura base del proyecto.
- Se crearon 2 versiones del Dockerfile para comparar seguridad.
- Se automatizó el proceso de build y run con scripts y Makefile.
- Se demostró que correr contenedores con usuarios sin privilegios es más seguro.
- La diferencia es clara cuando pruebas los endpoints.

El siguiente paso sería deployar esto en Kubernetes para aplicar políticas de seguridad más avanzadas.
