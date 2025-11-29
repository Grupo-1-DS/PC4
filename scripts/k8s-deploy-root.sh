#!/usr/bin/env bash
set -euo pipefail

kubectl port-forward service/pc4-app-root-service 8080:8000 > /dev/null 2>&1 &

