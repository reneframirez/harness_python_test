# Demo SDD: extraer la sección 1 (a, b, c) de los EAF

Guion para mostrar spec-driven development con OpenSpec y Claude Code. Duración: 45 min o más.

## Antes de empezar (5 min, sin público)

1. `git pull` y entrar a la rama `feat/preparar-demo-eaf` (o a `main` si ya se mezcló).
2. Copiar los PDF de EAF a la carpeta `eaf/` de la raíz (no se suben a git).
3. `make setup` y `make verify` en verde.
4. Abrir Claude Code en la carpeta del proyecto. Deben verse los comandos `/opsx:*`.
5. Crear la rama de trabajo: `git checkout -b feat/extraer-eaf-seccion1`.

## El requerimiento

Está escrito en [`req/REQ-001-extraer-eaf-seccion1.md`](../req/REQ-001-extraer-eaf-seccion1.md).
En Claude Code se le puede indicar al agente que lo lea. Para decirlo en una frase:

> Quiero extraer la sección "1. Descripción pormenorizada de la perturbación", puntos a, b y c,
> de los EAF que están en la carpeta `eaf/`, y dejar un CSV con una fila por EAF.

## Pasos

| # | Min | Qué se hace | Qué se muestra |
|---|---|---|---|
| 1 | 5 | Abrir `AGENTS.md` | El agente lee las reglas del proyecto. Sin spec, el CI no deja pasar código. |
| 2 | 10 | `/opsx:explore` con la frase del requerimiento | El asistente pregunta; el público decide los casos límite (ver abajo). |
| 3 | 10 | `/opsx:propose extraer-eaf-seccion1` | Se generan proposal, specs (WHEN/THEN), design y tasks. Se leen y se corrigen entre todos. |
| 4 | 3 | `make spec` | La spec valida. Opcional: quitar un escenario y ver cómo se rechaza. |
| 5 | 15 | `/opsx:apply` | El agente escribe primero la prueba y luego el código, tarea por tarea. |
| 6 | 5 | `make verify` | Todo en verde: formato, tipos, pruebas, cobertura y specs. |
| 7 | 3 | Ejecutar el programa sobre `eaf/` y abrir el CSV | El resultado sobre los EAF reales. |
| 8 | 5 | Subir la rama, abrir el PR, mirar el CI | El check `verify` en verde. Opcional: mostrar el rojo si se borra la spec. |
| 9 | 3 | `/opsx:archive` | El change pasa a ser la especificación vigente. |

## Decisiones que el público debe tomar (están en los EAF reales)

- **Identificador:** `EAF 410/2026` sale del texto de la primera página, no de los metadatos del PDF
  (el 410 trae en sus metadatos el título `EAF 193/2024`).
- **Fechas** `17/08/2026` y `07-09-2026`: ¿se normalizan a `2026-08-17`?
- **Porcentaje** `0.107%` y `0.060 %`: ¿número o texto?, ¿con o sin símbolo?
- **RUT** `76.102.677-1` y `76000957-1`: ¿se normaliza a un solo formato?
- **Etiquetas equivalentes:** "Nombre del elemento afectado" y "Nombre del elemento fallado".
- **Mayúsculas:** "Transmisión Dedicada" y "Transmisión dedicada".
- **Falta un campo o la sección completa:** ¿error, vacío o advertencia?
- **Un PDF dañado en la carpeta:** ¿se detiene todo o se informa y se sigue con los demás?
- **Dependencia para leer PDF:** `design.md` debe justificarla (regla de `AGENTS.md`).

## Si algo sale mal

- `make verify` falla: se corrige la causa; nunca se baja el umbral ni se agrega `noqa` o `type: ignore`.
- El agente propone leer los PDF reales en las pruebas: se rechaza y se pide texto sintético.
