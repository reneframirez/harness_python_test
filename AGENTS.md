# AGENTS.md

Instrucciones para cualquier agente de código en este repo. Es la fuente única de verdad:
`CLAUDE.md` solo la importa. Mantenerla corta; el detalle irá a `docs/` cuando haga falta.

## Qué es esto

Herramientas en Python para el **proyecto de Norma Técnica de Indisponibilidad de Suministro y
Compensaciones** (Coordinador Eléctrico Nacional, Chile). La norma se alimenta de los
"Estudio para análisis de falla" (EAF): primero se convierten a datos, después se calcula sobre ellos.

Primer requerimiento: extraer la sección 1 (a, b, c) de los EAF a un CSV ([`req/`](req/)).
Los siguientes consumirán esos datos (por ejemplo, el cálculo de compensaciones).

El repo es también el banco de pruebas de un harness de desarrollo con agentes (spec-driven).
Por eso las reglas de abajo son estrictas aunque el código sea pequeño.

Python 3.11+. Gestor: `uv`. Calidad: `ruff`, `mypy --strict`, `pytest`. Specs: OpenSpec.
Dependencias de runtime: ninguna por defecto; cada una nueva se justifica en el `design.md` del change.

## Flujo de trabajo

1. Un requerimiento llega a `req/REQ-NNN-nombre.md`. No es la spec: la spec se deriva de él.
2. `/opsx:explore` para aclarar casos límite; `/opsx:propose` para generar proposal, specs, design y tasks.
3. Se revisa la spec con las personas **antes** de escribir código. Si la spec calla sobre algo, se pregunta;
   no se inventan reglas del dominio.
4. `/opsx:apply` implementa las tareas en orden. `make verify` en verde al final de cada tarea.
5. Una rama por requerimiento (`feat/<nombre>`) y un pull request. `main` está protegida: nadie hace
   push directo y el CI (`verify`) debe pasar para mezclar.
6. `/opsx:archive` al terminar: el change pasa a ser la especificación vigente.

**Sin spec no hay código:** un cambio en `src/` debe ir con cambios en `openspec/changes/` o
`openspec/specs/`. Lo comprueba `make spec-gate` y el CI lo exige en cada pull request.
Cada requirement lleva al menos un escenario WHEN/THEN; `make spec` las valida en modo estricto.

## Comandos (punto de entrada único: `make`)

| Comando | Para qué |
|---|---|
| `make setup` | Instala dependencias |
| `make format` | Formatea y autocorrige lint |
| `make spec` | Valida specs y changes de OpenSpec (strict); requiere Node.js |
| `make spec-gate` | Falla si hay cambios en `src/` sin spec (compara contra `BASE`, por defecto `origin/main`) |
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

## Estructura

| Ruta | Contenido |
|---|---|
| `req/` | Requerimientos tal como llegan |
| `openspec/` | Specs vigentes y changes en curso |
| `src/app/` | Código |
| `tests/` | Pruebas (un archivo por módulo) |
| `eaf/` | PDF de EAF reales (entrada; ignorados por git) |
| `salida/` | Resultados generados, como el CSV (ignorada por git) |
| `docs/` | Documentación y guiones |

## Buenas prácticas de desarrollo

**Pruebas**
- Cada escenario WHEN/THEN de la spec se convierte en al menos una prueba, con nombre que diga el
  comportamiento (`test_rejects_pdf_without_section_1`), no la implementación.
- Primero la prueba, luego el código. Si una prueba nueva pasa sin código nuevo, está mal escrita.
- Las pruebas usan texto sintético con el formato de los EAF. Nunca leen `eaf/` ni dependen de archivos
  que no estén en el repo.
- Para el tiempo, el azar y el sistema de archivos se inyectan dependencias o se usan temporales de `pytest`;
  nada de `sleep` reales ni rutas absolutas.

**Diseño**
- Separar la lógica de la entrada/salida: la lógica pura (parsear, normalizar, validar) va en funciones
  sin efectos secundarios; leer PDF y escribir CSV va en una capa fina.
- Funciones chicas, con un solo propósito, y nombres del dominio (`outage`, `failure_event`), no genéricos.
- Representar datos con tipos explícitos (`dataclass(frozen=True)`, `Enum`) en vez de diccionarios sueltos.
- El mismo insumo debe dar siempre el mismo resultado (determinismo) y ejecutar dos veces no debe duplicar nada.

**Errores y datos**
- Los errores se dicen claro y con contexto (qué archivo, qué campo). Prohibido `except:` desnudo o tragarse
  una excepción en silencio.
- Un archivo malo no detiene el procesamiento de los demás: se informa y se continúa, salvo que la spec diga otra cosa.
- No se registran en logs ni en mensajes de error datos de personas (RUT, direcciones, representantes legales).
- Nunca se versionan los EAF reales ni salidas con datos de personas.

**Git y revisión**
- Cambios pequeños y commits atómicos con mensaje convencional (`feat:`, `fix:`, `test:`, `docs:`, `chore:`).
- Un pull request por requerimiento, con la spec, las pruebas y el código juntos.
- No mezclar refactorizaciones con cambios de comportamiento en el mismo commit.

## Convenciones

- Código en `src/app/`, pruebas en `tests/` (un archivo de prueba por módulo).
- Identificadores y comentarios de código en inglés; documentación, specs y mensajes para personas en español.
- Tipado completo (mypy strict); nada de `Any` sin una justificación escrita en un comentario.
- Comentarios solo para explicar el porqué, no el qué.

## No tocar

- `.env*` y cualquier secreto.
- `uv.lock` a mano: lo gestiona `uv`.
- `openspec/specs/` a mano: se actualiza con `/opsx:archive` o `/opsx:sync`.

## Cuando algo falla

Si `make verify` falla, corrige la causa. No desactives reglas, no bajes el umbral de cobertura
ni agregues `# type: ignore` o `# noqa` para hacerlo pasar. Si crees que una regla está mal,
dilo en la respuesta y propón el cambio por separado.
