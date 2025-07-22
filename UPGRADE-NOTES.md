# Kubernetes v1.30.2 Upgrade Notes

## Breaking Changes

1. **Code Generation Tools**: The `generate-groups.sh` script has been removed in the newer versions of code-generator. The new approach is to use the `kube_codegen.sh` script or the individual code generator tools directly.

2. **Controller-Gen Version**: Updated controller-gen from v0.7.0 to v0.18.0 for CRD generation.

## Dependency Changes

The following dependencies were updated to v0.30.2:

- k8s.io/api: v0.30.2
- k8s.io/apimachinery: v0.30.2 (downgraded from v0.32.2)
- k8s.io/client-go: v0.30.2 (downgraded from v0.32.2)
- k8s.io/code-generator: v0.30.2 (downgraded from v0.32.0)
- k8s.io/metrics: v0.30.2 (downgraded from v0.30.14)
- k8s.io/kube-openapi: v0.0.0-20240228011516-70dd3763d340

## Required Go Version

Go 1.22 or higher is required for Kubernetes v1.30.2. The project is currently using Go 1.24.0, which is compatible.

## Code Generation

The code generation scripts have been updated to work with the new versions of the code-generator tools. The following code generation steps were performed:

1. Regenerated clientsets
2. Regenerated informers
3. Regenerated listers
4. Regenerated deepcopy methods
5. Regenerated OpenAPI specifications
6. Regenerated CRD manifests

## CRD Compatibility

All CRD manifests have been regenerated and are compatible with Kubernetes v1.30.2. No deprecated fields were found in the generated CRD files.

## Build and Test

The project builds successfully with the updated dependencies, and all unit tests pass.