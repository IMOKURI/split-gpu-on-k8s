.DEFAULT_GOAL := help

export
NOW = $(shell date '+%Y%m%d-%H%M%S')


.PHONY: config-map
config-map: ## config-map
	kubectl apply -f ./mps-config.yaml
	kubectl apply -f ./time-slicing-config.yaml

.PHONY: mps
mps: ## mps
	kubectl patch clusterpolicies.nvidia.com/cluster-policy --type merge \
		-p '{"spec": {"devicePlugin": {"config": {"name": "mps-config", "default": "any"}}}}'

.PHONY: time-slicing
time-slicing: ## time-slicing
	kubectl patch clusterpolicies.nvidia.com/cluster-policy --type merge \
		-p '{"spec": {"devicePlugin": {"config": {"name": "time-slicing-config", "default": "any"}}}}'

.PHONY: event
event: ## event
	kubectl get event --sort-by='.lastTimestamp'

.PHONY: help
help: ## Show this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / \
		{printf "\033[38;2;98;209;150m%-15s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
