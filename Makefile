include .env
export

prereqs:
	@echo "Checking prerequisites"
	@sudo flux check --pre

bootstrap: prereqs
	@echo "Bootstrapping Flux"
	@sudo flux bootstrap github \
		--owner=$(GITHUB_USER) \
		--repository=flux-infra \
		--branch=main \
		--path=./clusters/dev \
		--personal \
		--log-level=debug \
		--network-policy=false
	@sudo flux check

create-github-source:
	@echo "Creating GitHub source"
	@sudo flux create source git instavote --url="https://github.com/squerez/instavote.git" --branch=main --interval=30s

create-kustomization:
	@echo "Creating Kustomization"
	@sudo flux create kustomization vote-dev --source=instavote --path="./deploy/vote" --target-namespace=instavote --validation=client

