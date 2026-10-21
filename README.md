# harness_python_test

Proyecto Python vacío para construir y probar, un MVP a la vez, un harness de desarrollo con
agentes (spec-driven). Aquí no hay lógica de negocio: lo que se construye es el harness.

## Requisitos

- [Git](https://git-scm.com/) y [uv](https://docs.astral.sh/uv/) (instala Python y las dependencias).
- `make`. En Windows, úsalo desde Git Bash o WSL.
- [Node.js](https://nodejs.org/) 20+ (para OpenSpec, que se ejecuta con `npx` en la versión fijada del Makefile).

## Uso

```
make setup    # instala dependencias
make verify   # lint + mypy strict + pytest (cobertura mínima 90%) + validación de specs
make spec     # solo la validación de specs/changes de OpenSpec
make spec-gate BASE=origin/main   # falla si hay cambios en src/ sin spec
make help     # lista los comandos
```

Las instrucciones para agentes están en [`AGENTS.md`](AGENTS.md).

## Hoja de ruta

| MVP | Qué agrega | Estado |
|---|---|---|
| 1 | Esqueleto vacío con `make verify` | hecho |
| 2 | OpenSpec y validación de specs dentro de `verify` | hecho |
| 3 | CI en GitHub Actions y gate "sin spec no hay código" | en curso |
| 4 | Hooks, permisos, skills y subagentes de Claude Code | pendiente |
| 5 | `make doctor` y tareas de referencia para medir el harness | pendiente |
