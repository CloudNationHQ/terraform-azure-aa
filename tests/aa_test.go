package main

import (
	"os"
	"path/filepath"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

type TerraformModuleDeployer interface {
	ConfigureOptions(t *testing.T) *terraform.Options
	Apply(t *testing.T, opts *terraform.Options)
	Destroy(t *testing.T, opts *terraform.Options)
}

type TerraformModule struct {
	Name string
	Path string
}

func NewTerraformModule(name, path string) *TerraformModule {
	return &TerraformModule{
		Name: name,
		Path: path,
	}
}

func (m *TerraformModule) ConfigureOptions(t *testing.T) *terraform.Options {
	return &terraform.Options{
		TerraformDir: m.Path,
		NoColor:      true,
		Parallelism:  2,
	}
}

func (m *TerraformModule) Apply(t *testing.T, opts *terraform.Options) {
	t.Logf("Applying Terraform module: %s", m.Name)
	terraform.WithDefaultRetryableErrors(t, opts)
	terraform.InitAndApply(t, opts)
}

func (m *TerraformModule) Destroy(t *testing.T, opts *terraform.Options) {
	t.Logf("Destroying Terraform module: %s", m.Name)
	terraform.Destroy(t, opts)
	cleanupFiles(t, opts.TerraformDir)
}

func cleanupFiles(t *testing.T, dir string) {
	t.Logf("Cleaning up in: %s", dir)
	filesToCleanup := []string{"*.terraform*", "*tfstate*"}
	for _, pattern := range filesToCleanup {
		matches, err := filepath.Glob(filepath.Join(dir, pattern))
		if err != nil {
			t.Errorf("Error globbing %s: %v", pattern, err)
			continue
		}
		for _, filePath := range matches {
			if err := os.RemoveAll(filePath); err != nil {
				t.Errorf("Failed to remove %s: %v", filePath, err)
			}
		}
	}
}

func TestApplyNoError(t *testing.T) {
	t.Parallel()

	tfPath := os.Getenv("TF_PATH")
	if tfPath == "" {
		t.Fatal("TF_PATH environment variable is not set")
	}

	modulePath := filepath.Join("..", "examples", tfPath)
	module := NewTerraformModule(tfPath, modulePath)

	t.Run(module.Name, func(t *testing.T) {
		opts := module.ConfigureOptions(t)
		defer module.Destroy(t, opts)
		module.Apply(t, opts)
	})
}
