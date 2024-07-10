.PHONY: test

export TF_PATH

test:
	cd tests && go test -v -timeout 60m -run TestApplyNoError/$(TF_PATH) ./aa_test.go

#test_extended:
	#cd tests && env go test -v -timeout 60m -run TestVault ./aa_extended_test.go

