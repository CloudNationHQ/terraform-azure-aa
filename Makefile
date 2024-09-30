.PHONY: test docs

export EXAMPLE

test:
	cd tests && go test -v -timeout 60m -run TestApplyNoError/$(EXAMPLE) ./aa_test.go

docs:
	@terraform-docs markdown table --output-file README.md --output-mode inject .
