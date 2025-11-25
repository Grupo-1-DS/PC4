.PHONY: help build run k8s-apply k8s-clean

SHELL := /usr/bin/bash

help: ## Muestra los targets disponibles
	@grep -E '^[a-zA-Z0-9_-]+:.*?## ' $(MAKEFILE_LIST) | awk -F':|##' '{printf "  %-12s %s\n", $$1, $$3}'

build: ## Construye las imágenes Docker para usuario root y non-root
	@bash scripts/build.sh

run: ## Ejecuta los contenedores Docker con imágenes Docker configuradas para usuario root y non-root
	@bash scripts/run-root.sh
	@bash scripts/run-nonroot.sh

k8s-apply: build ## Aplica las configuraciones de Kubernetes para despliegues y servicios root y non-root
	@bash scripts/k8s-apply-root.sh
	@bash scripts/k8s-apply-nonroot.sh
	@bash scripts/k8s-apply-service.sh

k8s-clean:
	@bash scripts/k8s-clean.sh