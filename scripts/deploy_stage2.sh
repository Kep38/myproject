#!/bin/bash
set -e

# Инициализация Terraform
cd ./stages/stage2
terraform init

# Применение Stage 2
terraform apply -auto-approve

# Возврат в корневую папку
cd ../../
