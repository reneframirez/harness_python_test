#!/usr/bin/env bash
# Gate "sin spec no hay codigo": si cambia algo en src/, tambien debe cambiar algo en
# openspec/changes/ o openspec/specs/ (un change nuevo, editado o archivado).
# Uso: bash scripts/check-spec-gate.sh <ref-base>   (ej. origin/main)
set -euo pipefail

base="${1:-}"
if [[ -z "$base" ]]; then
  echo "uso: bash scripts/check-spec-gate.sh <ref-base>" >&2
  exit 64
fi
if ! git rev-parse --verify --quiet "$base^{commit}" >/dev/null; then
  echo "spec-gate: no existe la referencia base '$base'" >&2
  exit 64
fi

files="$(git diff --name-only "$base"...HEAD)"
code="$(grep -E '^src/' <<<"$files" || true)"
spec="$(grep -E '^openspec/(changes|specs)/' <<<"$files" || true)"

if [[ -z "$code" ]]; then
  echo "spec-gate OK: no hay cambios en src/"
  exit 0
fi
if [[ -n "$spec" ]]; then
  echo "spec-gate OK: cambios en src/ respaldados por openspec/"
  exit 0
fi

echo "spec-gate FALLO: hay cambios en src/ sin ningun cambio en openspec/changes/ ni openspec/specs/." >&2
echo "Archivos de codigo modificados:" >&2
sed 's/^/  /' <<<"$code" >&2
echo "Crea un change de OpenSpec que describa este cambio y vuelve a intentar." >&2
exit 1
