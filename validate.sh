#!/bin/bash

echo -e "Generate README"
terraform-docs markdown table --output-file README.md .

echo -e "fmt"
terraform fmt -recursive -check

echo -e "tfsec"
tfsec