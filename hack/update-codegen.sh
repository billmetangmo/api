#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

# For all commands, the working directory is the parent directory(repo root).
REPO_ROOT=$(git rev-parse --show-toplevel)
cd "${REPO_ROOT}"

SCRIPT_ROOT=$(dirname "${BASH_SOURCE[0]}")/..
echo $SCRIPT_ROOT

# Clean up any existing generated code to avoid conflicts
rm -rf "${SCRIPT_ROOT}/pkg/generated"

# Generate deepcopy
echo "Generating deepcopy code..."
go run k8s.io/code-generator/cmd/deepcopy-gen \
  --go-header-file "${SCRIPT_ROOT}/hack/boilerplate/boilerplate.go.txt" \
  --bounding-dirs "github.com/gocrane/api" \
  --output-file "zz_generated.deepcopy.go" \
  github.com/gocrane/api/autoscaling/v1alpha1 \
  github.com/gocrane/api/ensurance/v1alpha1 \
  github.com/gocrane/api/prediction/v1alpha1 \
  github.com/gocrane/api/analysis/v1alpha1 \
  github.com/gocrane/api/topology/v1alpha1 \
  github.com/gocrane/api/co2e/v1alpha1

# Generate clientset
echo "Generating clientset code..."
go run k8s.io/code-generator/cmd/client-gen \
  --go-header-file "${SCRIPT_ROOT}/hack/boilerplate/boilerplate.go.txt" \
  --clientset-name "versioned" \
  --input-base "" \
  --input "github.com/gocrane/api/autoscaling/v1alpha1" \
  --input "github.com/gocrane/api/ensurance/v1alpha1" \
  --input "github.com/gocrane/api/prediction/v1alpha1" \
  --input "github.com/gocrane/api/analysis/v1alpha1" \
  --input "github.com/gocrane/api/topology/v1alpha1" \
  --input "github.com/gocrane/api/co2e/v1alpha1" \
  --output-dir "${SCRIPT_ROOT}/pkg/generated/clientset" \
  --output-pkg "github.com/gocrane/api/pkg/generated/clientset" \
  --plural-exceptions "Analytics:Analytics"

# Generate listers
echo "Generating lister code..."
go run k8s.io/code-generator/cmd/lister-gen \
  --go-header-file "${SCRIPT_ROOT}/hack/boilerplate/boilerplate.go.txt" \
  --output-dir "${SCRIPT_ROOT}/pkg/generated/listers" \
  --output-pkg "github.com/gocrane/api/pkg/generated/listers" \
  --plural-exceptions "Analytics:Analytics" \
  github.com/gocrane/api/autoscaling/v1alpha1 \
  github.com/gocrane/api/ensurance/v1alpha1 \
  github.com/gocrane/api/prediction/v1alpha1 \
  github.com/gocrane/api/analysis/v1alpha1 \
  github.com/gocrane/api/topology/v1alpha1 \
  github.com/gocrane/api/co2e/v1alpha1

# Generate informers
echo "Generating informer code..."
go run k8s.io/code-generator/cmd/informer-gen \
  --go-header-file "${SCRIPT_ROOT}/hack/boilerplate/boilerplate.go.txt" \
  --output-dir "${SCRIPT_ROOT}/pkg/generated/informers" \
  --output-pkg "github.com/gocrane/api/pkg/generated/informers" \
  --versioned-clientset-package "github.com/gocrane/api/pkg/generated/clientset/versioned" \
  --listers-package "github.com/gocrane/api/pkg/generated/listers" \
  --plural-exceptions "Analytics:Analytics" \
  github.com/gocrane/api/autoscaling/v1alpha1 \
  github.com/gocrane/api/ensurance/v1alpha1 \
  github.com/gocrane/api/prediction/v1alpha1 \
  github.com/gocrane/api/analysis/v1alpha1 \
  github.com/gocrane/api/topology/v1alpha1 \
  github.com/gocrane/api/co2e/v1alpha1

# Generate OpenAPI specifications
echo "Generating OpenAPI code..."
KUBE_OPENAPI_PKG=`go list -mod=readonly -m -f '{{.Dir}}' k8s.io/kube-openapi`

# Create the output directory if it doesn't exist
mkdir -p "${SCRIPT_ROOT}/pkg/generated/openapi"

# The OpenAPI generation command has different flags in this version
# Let's use the correct flags
go run ${KUBE_OPENAPI_PKG}/cmd/openapi-gen/openapi-gen.go \
      --go-header-file "${SCRIPT_ROOT}/hack/boilerplate/boilerplate.go.txt" \
      --output-dir "${SCRIPT_ROOT}/pkg/generated/openapi" \
      --output-pkg "github.com/gocrane/api/pkg/generated/openapi" \
      --output-file "zz_generated.openapi.go" \
      --report-filename "/dev/null" \
      k8s.io/metrics/pkg/apis/custom_metrics \
      k8s.io/metrics/pkg/apis/custom_metrics/v1beta1 \
      k8s.io/metrics/pkg/apis/custom_metrics/v1beta2 \
      k8s.io/metrics/pkg/apis/external_metrics \
      k8s.io/metrics/pkg/apis/external_metrics/v1beta1 \
      k8s.io/metrics/pkg/apis/metrics \
      k8s.io/metrics/pkg/apis/metrics/v1beta1 \
      k8s.io/apimachinery/pkg/apis/meta/v1 \
      k8s.io/apimachinery/pkg/api/resource \
      k8s.io/apimachinery/pkg/version \
      k8s.io/api/core/v1