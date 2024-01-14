#!/bin/bash

create_gitleaks_config() {
    echo '[[rules]]
regex = "API[_-]?KEY"
tags = ["api-key", "token" ]' > .gitleaks.toml

    additional_config=$(curl -s https://raw.githubusercontent.com/gitleaks/gitleaks/master/config/gitleaks.toml)

    echo "$additional_config" >> .gitleaks.toml
}

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="darwin"
else
    echo -e "Unsupported operating system."
    exit 1
fi

echo -e "Operating System: $OS"

ARCH=$(uname -m)
if [[ "$ARCH" == "x86_64" ]]; then
    ARCH="amd64"
elif [[ "$ARCH" == "aarch64" ]]; then
    ARCH="arm64"
else
    echo -e "Unsupported architecture."
    exit 1
fi

echo -e "Architecture: $ARCH"

echo -e "Downloading and installing gitleaks..."

RELEASE_VERSION="v8.18.1"
RELEASE_URL=""
if [[ "$OS" == "darwin" ]]; then
    RELEASE_URL="https://github.com/gitleaks/gitleaks/releases/download/$RELEASE_VERSION/gitleaks_8.18.1_darwin_x64.tar.gz"
elif [[ "$OS" == "linux" ]]; then
    if [[ "$ARCH" == "amd64" ]]; then
        RELEASE_URL="https://github.com/gitleaks/gitleaks/releases/download/$RELEASE_VERSION/gitleaks_8.18.1_linux_x64.tar.gz"
    elif [[ "$ARCH" == "arm64" ]]; then
        RELEASE_URL="https://github.com/gitleaks/gitleaks/releases/download/$RELEASE_VERSION/gitleaks_8.18.1_linux_arm64.tar.gz"
    fi
fi

if [[ -z "$RELEASE_URL" ]]; then
    echo -e "Unable to find a compatible version of gitleaks for this operating system and architecture"
    exit 1
fi

curl -sSL "$RELEASE_URL" -o gitleaks.tar.gz
tar -xf gitleaks.tar.gz
chmod +x gitleaks

echo -e "Gitleaks installed"

echo -e "Creating .gitleaks.toml file..."
create_gitleaks_config

rm gitleaks.tar.gz gitleaks

GITLEAKS_VERSION=$(gitleaks version)
echo -e "Gitleaks version: ${GITLEAKS_VERSION}"

REPO_URL="https://raw.githubusercontent.com/denys-kovalchuk/gitleaks-pre-commit/main/pre-commit.sh"

HOOKS_DIR=".git/hooks"

mkdir -p "$HOOKS_DIR"

echo -e "Downloading pre-commit hook..."
curl -sSfL "$REPO_URL" -o "$HOOKS_DIR/pre-commit"
chmod +x "$HOOKS_DIR/pre-commit"

if [ -f "$HOOKS_DIR/pre-commit" ]; then
    echo -e "Pre-commit hook script installed successfully!"
else
    echo -e "An error occurred while installing the pre-commit hook script."
fi

download-onoffscript() {
    curl -sSfL "https://raw.githubusercontent.com/denys-kovalchuk/gitleaks-pre-commit/main/on-off.sh" -o on-off.sh
    chmod +x on-off.sh
}

download-onoffscript
