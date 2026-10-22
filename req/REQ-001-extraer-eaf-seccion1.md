# REQ-001: Extraer la sección 1 (a, b, c) de los EAF

| | |
|---|---|
| Solicita | Equipo del proyecto de Norma Técnica de Indisponibilidad de Suministro y Compensaciones |
| Prioridad | Alta (es el insumo principal del proyecto) |
| Estado | Por especificar |

## Contexto

El Coordinador Eléctrico Nacional publica un "Estudio para análisis de falla" (EAF) por cada falla
relevante del sistema, por ejemplo `EAF 410/2026`. Hoy los datos de cada falla se copian a mano desde
el PDF a una planilla. Es lento, y dos personas distintas anotan el mismo dato de formas distintas.

Los EAF son el insumo de todo el proyecto de norma técnica: las compensaciones se calculan a partir
de lo que dicen. Antes de calcular nada necesitamos tenerlos como datos, no como PDF.

## Lo que se pide

Un programa que lea los EAF que estén en la carpeta `eaf/` (raíz del proyecto) y, de cada uno,
extraiga la sección **"1. Descripción pormenorizada de la perturbación"**, puntos **a, b y c**:

- **a. Fecha y hora de la falla:** fecha, hora, consumos desconectados (MW), demanda previa del
  sistema (MW), porcentaje de desconexión y calificación de apagón.
- **b. Identificación de la instalación afectada:** nombre, tipo, tensión nominal, segmento,
  propietario, RUT, representante legal y dirección.
- **c. Identificación del elemento fallado:** nombre, propietario, RUT, representante legal y dirección.

Además, de cada EAF se necesita su identificador (por ejemplo `EAF 410/2026`), su título y su
fecha de emisión.

El resultado debe ser un **CSV con una fila por EAF**, que se pueda abrir directamente en Excel.

## Para qué se usará

- Armar la base histórica de fallas para el análisis de compensaciones.
- Comparar fallas entre instalaciones y propietarios.
- Que cualquier persona del equipo pueda repetir el proceso y obtener el mismo resultado.

## Fuera de alcance (por ahora)

- Los puntos d en adelante de la sección 1 (origen, fenómeno, reiteración, etc.) y las secciones 2 a 11.
- Calcular compensaciones.
- Descargar los EAF desde el sitio del Coordinador.
- Una interfaz gráfica.

## Material disponible

- PDF reales de ejemplo en `eaf/` (no se versionan; traen datos de personas). Se parte con dos:
  `EAF 410/2026` y `EAF 411/2026`.
- Estructura de los puntos a, b y c vista en esos dos PDF:

```
1. Descripción pormenorizada de la perturbación
  a. Fecha y Hora de la falla
       Fecha / Hora / Consumos desconectados (MW) / Demanda previa del sistema (MW)
       Porcentaje de desconexión / Calificación Apagón
  b. Identificación instalación afectada
       Nombre de la instalación / Tipo / Tensión nominal / Segmento
       Propietario / RUT / Representante Legal / Dirección
  c. Identificación del elemento fallado
       Nombre del elemento / Propietario / RUT / Representante Legal / Dirección
```

## Criterio de aceptación general

Al ejecutar el programa sobre una carpeta con varios EAF se obtiene el CSV completo, y las
personas del equipo reconocen en él los datos que habrían copiado a mano.

> Las reglas finas (formatos, campos faltantes, errores) se definen al especificar, no aquí.
