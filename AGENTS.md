# AGENTS.md

Instrucciones para cualquier agente de código en este repo. Es la fuente única de verdad:
`CLAUDE.md` solo la importa. Mantenerla corta; el detalle irá a `docs/` cuando haga falta.

## Qué es esto

Proyecto Python vacío para construir y probar un harness de desarrollo con agentes, un MVP a la vez.
Python 3.11+, sin dependencias de runtime. Gestor: `uv`. Calidad: `ruff`, `mypy --strict`, `pytest`.

Estado: MVP 2 (OpenSpec). Todavía no hay CI ni hooks; llegan en los MVP siguientes.

## Specs (OpenSpec)

Todo desarrollo es un change de OpenSpec en `openspec/changes/<nombre>/` (proposal, specs, tasks).
Las specs vigentes están en `openspec/specs/`. Las reglas para redactarlas están en `openspec/config.yaml`.
Cada requirement lleva al menos un escenario WHEN/THEN. `make spec` las valida en modo estricto.

## Comandos (punto de entrada único: `make`)

| Comando | Para qué |
|---|---|
| `make setup` | Instala dependencias |
| `make format` | Formatea y autocorrige lint |
| `make spec` | Valida specs y changes de OpenSpec (strict); requiere Node.js |
| `make verify` | **Gate completo**: lint + mypy strict + pytest con cobertura mínima del 90% + `make spec` |

La prueba final de cualquier cambio es `make verify` en verde, no un `ruff` o `pytest` suelto.

Sin `make` (por ejemplo en Windows sin Git Bash ni WSL), el equivalente de `make verify` es:

```
uv run ruff format --check src tests
uv run ruff check src tests
uv run mypy
uv run pytest
npx --yes @fission-ai/openspec@1.14.3 validate --all --strict
```

## Convenciones

- Código en `src/app/`, pruebas en `tests/` (un archivo de prueba por módulo).
- Identificadores y comentarios de código en inglés; documentación en español.
- Tipado completo (mypy strict); nada de `Any` sin una justificación escrita en un comentario.
- Sin dependencias de runtime nuevas sin dejarlo dicho y justificado.

## No tocar

- `.env*` y cualquier secreto.
- `uv.lock` a mano: lo gestiona `uv`.

## Cuando algo falla

Si `make verify` falla, corrige la causa. No desactives reglas, no bajes el umbral de cobertura
ni agregues `# type: ignore` o `# noqa` para hacerlo pasar. Si crees que una regla está mal,
dilo en la respuesta y propón el cambio por separado.
