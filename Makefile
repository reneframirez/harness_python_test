.DEFAULT_GOAL := help
RUN := uv run --quiet
OPENSPEC := npx --yes @fission-ai/openspec@1.14.3
BASE ?= origin/main

.PHONY: help setup format lint typecheck test spec spec-gate verify

help: ## Muestra esta ayuda
	@grep -E '^[a-z-]+:.*?## ' $(MAKEFILE_LIST) | awk -F':.*?## ' '{printf "  %-12s %s\n", $$1, $$2}'

setup: ## Instala dependencias (uv)
	uv sync

format: ## Formatea y corrige lint automaticamente
	$(RUN) ruff format src tests
	$(RUN) ruff check --fix src tests

lint: ## Verifica formato y lint (no modifica)
	$(RUN) ruff format --check src tests
	$(RUN) ruff check src tests

typecheck: ## mypy en modo strict
	$(RUN) mypy

test: ## pytest con cobertura minima del 90%
	$(RUN) pytest

spec: ## Valida specs y changes de OpenSpec (strict)
	$(OPENSPEC) validate --all --strict

spec-gate: ## Falla si hay cambios en src/ sin spec (BASE=origin/main)
	bash scripts/check-spec-gate.sh $(BASE)

verify: lint typecheck test spec ## Gate completo: lo que debe estar en verde antes de dar algo por terminado
	@echo "verify OK"
