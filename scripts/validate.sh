#!/usr/bin/env bash
set -euo pipefail

terraform fmt -check -recursive

for directory in modules/network modules/eks environments/dev; do
  terraform -chdir="$directory" init -backend=false -input=false
  terraform -chdir="$directory" validate
done

kubectl kustomize kubernetes >/dev/null
