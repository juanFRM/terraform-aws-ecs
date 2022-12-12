all: format init validate documentation

AWS_DEFAULT_REGION ?= us-east-1

validate:
	@export AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION}"; \
		terraform validate

format:
	@terraform fmt

documentation:
	@terraform-docs markdown . > README.md

init:
	@terraform init

lint:
	@tflint -c .tflint.hcl

secure:
	@tfsec
