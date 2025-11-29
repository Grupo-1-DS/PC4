#!/usr/bin/env bash
set -euo pipefail

kubectl port-forward service/pc4-app-nonroot-service 8081:8000 > /dev/null 2>&1 &
