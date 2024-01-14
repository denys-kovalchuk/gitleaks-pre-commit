#!/bin/bash

ENABLE=$(git config --bool hooks.gitleaks-enable)

echo -e "Running gitleaks..."
gitleaksOutput=$(gitleaks detect --redact --verbose --report-format json --report-path gitleaks-report.json --config .gitleaks.toml)
gitleaksExitCode=$?

if [[ $gitleaksExitCode -eq 1 ]]; then
    echo -e "Found the following secrets:"
    echo "$gitleaksOutput"
    echo -e "Committing with existing secrets is not allowed."
    exit 1
else
    echo -e "No secrets found"
fi

chmod +x on-off.sh
