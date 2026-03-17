#!/usr/bin/env bash
set -euo pipefail

# Quarto Installer for numerical-geophysics
# Reads .quarto-version and installs the required version to ~/.local/bin/

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
QUARTO_VERSION_FILE="${SCRIPT_DIR}/.quarto-version"
QUARTO_INSTALL_DIR="${HOME}/.local"
QUARTO_BIN="${QUARTO_INSTALL_DIR}/bin/quarto"

# Detect OS and architecture
detect_os() {
    case "$(uname -s)" in
        Linux*)
            if [[ "$(uname -m)" == "aarch64" ]]; then
                echo "linux-arm64"
            else
                echo "linux-amd64"
            fi
            ;;
        Darwin*)
            if [[ "$(uname -m)" == "arm64" ]]; then
                echo "macos-arm64"
            else
                echo "macos-amd64"
            fi
            ;;
        MINGW*|MSYS*|CYGWIN*)
            echo "windows-x64"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# Check if required version file exists
if [[ ! -f "${QUARTO_VERSION_FILE}" ]]; then
    echo "Error: .quarto-version file not found"
    exit 1
fi

REQUIRED_VERSION=$(cat "${QUARTO_VERSION_FILE}" | tr -d '[:space:]')
echo "Required Quarto version: ${REQUIRED_VERSION}"

# Check current installation
if [[ -x "${QUARTO_BIN}" ]]; then
    CURRENT_VERSION=$("${QUARTO_BIN}" --version 2>/dev/null || echo "unknown")
    echo "Current installation: ${QUARTO_BIN} (version ${CURRENT_VERSION})"
    
    if [[ "${CURRENT_VERSION}" == "${REQUIRED_VERSION}" ]]; then
        echo "✓ Quarto version matches. No installation needed."
        exit 0
    else
        echo "✗ Version mismatch. Installing required version..."
    fi
else
    echo "Quarto not found at ${QUARTO_BIN}. Installing..."
fi

# Detect OS
OS=$(detect_os)
if [[ "${OS}" == "unknown" ]]; then
    echo "Error: Unable to detect OS"
    exit 1
fi
echo "Detected OS: ${OS}"

# Create temporary directory
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "${TEMP_DIR}"' EXIT

# Download and install Quarto
case "${OS}" in
    linux-amd64)
        URL="https://github.com/quarto-dev/quarto-cli/releases/download/v${REQUIRED_VERSION}/quarto-${REQUIRED_VERSION}-linux-amd64.tar.gz"
        echo "Downloading from: ${URL}"
        curl -fsSL -o "${TEMP_DIR}/quarto.tar.gz" "${URL}"
        echo "Extracting..."
        tar -xzf "${TEMP_DIR}/quarto.tar.gz" -C "${TEMP_DIR}"
        ;;
    linux-arm64)
        URL="https://github.com/quarto-dev/quarto-cli/releases/download/v${REQUIRED_VERSION}/quarto-${REQUIRED_VERSION}-linux-arm64.tar.gz"
        echo "Downloading from: ${URL}"
        curl -fsSL -o "${TEMP_DIR}/quarto.tar.gz" "${URL}"
        echo "Extracting..."
        tar -xzf "${TEMP_DIR}/quarto.tar.gz" -C "${TEMP_DIR}"
        ;;
    macos-amd64)
        URL="https://github.com/quarto-dev/quarto-cli/releases/download/v${REQUIRED_VERSION}/quarto-${REQUIRED_VERSION}-macos-x64.tar.gz"
        echo "Downloading from: ${URL}"
        curl -fsSL -o "${TEMP_DIR}/quarto.tar.gz" "${URL}"
        echo "Extracting..."
        tar -xzf "${TEMP_DIR}/quarto.tar.gz" -C "${TEMP_DIR}"
        ;;
    macos-arm64)
        URL="https://github.com/quarto-dev/quarto-cli/releases/download/v${REQUIRED_VERSION}/quarto-${REQUIRED_VERSION}-macos-arm64.tar.gz"
        echo "Downloading from: ${URL}"
        curl -fsSL -o "${TEMP_DIR}/quarto.tar.gz" "${URL}"
        echo "Extracting..."
        tar -xzf "${TEMP_DIR}/quarto.tar.gz" -C "${TEMP_DIR}"
        ;;
    windows-x64)
        URL="https://github.com/quarto-dev/quarto-cli/releases/download/v${REQUIRED_VERSION}/quarto-${REQUIRED_VERSION}-win-x64.zip"
        echo "Downloading from: ${URL}"
        curl -fsSL -o "${TEMP_DIR}/quarto.zip" "${URL}"
        echo "Extracting..."
        
        # Check if unzip is available, otherwise use PowerShell
        if command -v unzip &> /dev/null; then
            unzip -q "${TEMP_DIR}/quarto.zip" -d "${TEMP_DIR}"
        elif command -v powershell.exe &> /dev/null; then
            powershell.exe -Command "Expand-Archive -Path '${TEMP_DIR}/quarto.zip' -DestinationPath '${TEMP_DIR}' -Force"
        else
            echo "Error: Neither unzip nor PowerShell available for extraction"
            echo "Please install unzip or manually extract: ${URL}"
            exit 1
        fi
        ;;
esac

# Create bin directory if it doesn't exist
mkdir -p "${QUARTO_INSTALL_DIR}/bin"

# Find and copy quarto binary
if [[ "${OS}" == "windows-x64" ]]; then
    QUARTO_EXTRACTED=$(find "${TEMP_DIR}" -name "quarto.exe" -type f | head -1)
    if [[ -z "${QUARTO_EXTRACTED}" ]]; then
        echo "Error: Could not find quarto.exe binary in extracted archive"
        exit 1
    fi
    cp "${QUARTO_EXTRACTED}" "${QUARTO_BIN}.exe"
    chmod +x "${QUARTO_BIN}.exe"
else
    QUARTO_EXTRACTED=$(find "${TEMP_DIR}" -name "quarto" -type f | head -1)
    if [[ -z "${QUARTO_EXTRACTED}" ]]; then
        echo "Error: Could not find quarto binary in extracted archive"
        exit 1
    fi
    cp "${QUARTO_EXTRACTED}" "${QUARTO_BIN}"
    chmod +x "${QUARTO_BIN}"
fi

# Verify installation
if [[ "${OS}" == "windows-x64" ]]; then
    INSTALLED_VERSION=$("${QUARTO_BIN}.exe" --version)
else
    INSTALLED_VERSION=$("${QUARTO_BIN}" --version)
fi
echo "Installed Quarto version: ${INSTALLED_VERSION}"

if [[ "${INSTALLED_VERSION}" != "${REQUIRED_VERSION}" ]]; then
    echo "Warning: Installed version (${INSTALLED_VERSION}) does not match required version (${REQUIRED_VERSION})"
else
    echo "✓ Quarto ${REQUIRED_VERSION} installed successfully"
fi

# Check if ~/.local/bin is in PATH
if [[ ":${PATH}:" != *":${HOME}/.local/bin:"* ]]; then
    echo ""
    echo "Note: ${HOME}/.local/bin is not in your PATH."
    echo "Add the following to your shell configuration file (~/.bashrc, ~/.zshrc, etc.):"
    echo "  export PATH=\"${HOME}/.local/bin:\$PATH\""
    echo ""
    echo "Or run: export PATH=\"${HOME}/.local/bin:\$PATH\" (for current session only)"
fi
