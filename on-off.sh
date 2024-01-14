#!/bin/bash

function disable() {
  echo -e "Disabling Gitleaks"
  git config core.hooksPath no-hooks
}

function enable() {
  echo -e "Enabling Gitleaks"
  git config --unset core.hooksPath
}
