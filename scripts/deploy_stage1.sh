#!/bin/bash
set -e

# Инициализация Terraform
cd ./stages/stage1
terraform init

# Применение Stage 1
terraform apply -auto-approve

# Возврат в корневую папку
cd ../../
