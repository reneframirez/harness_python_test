.DEFAULT_GOAL := help
RUN := uv run --quiet

.PHONY: help setup format lint typecheck test verify

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

verify: lint typecheck test ## Gate completo: lo que debe estar en verde antes de dar algo por terminado
	@echo "verify OK"
