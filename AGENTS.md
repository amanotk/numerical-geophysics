# Build Environment Guide

This document describes the reproducible build environment for the numerical-geophysics repository.

## Quick Start

```bash
# One-time setup
make setup

# Build documentation
make render

# Preview in browser
make preview
```

## Environment Versions

The following versions are pinned for reproducibility:

| Component | Version | Managed By |
|-----------|---------|------------|
| Quarto | 1.3.450 | `.quarto-version` + `install-quarto.sh` |
| Python | 3.11 | `.python-version` + uv |
| numpy | >=1.24.0 | `pyproject.toml` + `uv.lock` |
| matplotlib | >=3.7.0 | `pyproject.toml` + `uv.lock` |
| jupyter | >=1.0.0 | `pyproject.toml` + `uv.lock` |

## File Structure

```
numerical-geophysics/
├── .quarto-version      # Quarto version (single line)
├── .python-version      # Python version (single line)
├── pyproject.toml       # Python dependencies
├── uv.lock             # Locked Python dependencies (auto-generated)
├── install-quarto.sh   # Quarto installer script
├── Makefile            # Build commands
├── _quarto.yaml        # Quarto project config
├── .github/
│   └── workflows/
│       └── publish.yml # GitHub Actions workflow
└── AGENTS.md           # This file
```

## Makefile Commands

| Command | Description |
|---------|-------------|
| `make setup` | Install Quarto and Python dependencies |
| `make render` | Build all documentation |
| `make preview` | Start preview server on port 4200 |
| `make clean` | Remove generated HTML files |
| `make check` | Verify environment setup |
| `make help` | Show available commands |

## Installation Details

### Quarto Installation

The `install-quarto.sh` script:
1. Reads the required version from `.quarto-version`
2. Detects the OS (Linux/macOS/Windows-WSL)
3. Downloads Quarto from GitHub releases
4. Installs to `~/.local/bin/quarto`
5. Skips installation if the correct version is already installed

**Manual PATH setup** (if needed):
```bash
export PATH="$HOME/.local/bin:$PATH"
```

Add this to your `~.bashrc` or `~/.zshrc` for persistence.

### Python Environment

Managed by [uv](https://docs.astral.sh/uv/):
- `uv sync` - Install Python and all dependencies
- `uv sync --check` - Verify dependencies are up to date
- `uv add <package>` - Add a new dependency
- `uv remove <package>` - Remove a dependency

## Updating Versions

### Update Quarto Version

1. Edit `.quarto-version`:
   ```bash
   echo "1.4.0" > .quarto-version
   ```

2. Run setup to install new version:
   ```bash
   make setup
   ```

3. Update GitHub Actions workflow if needed:
   ```yaml
   # .github/workflows/publish.yml
   with:
     version: 1.4.0
   ```

### Update Python Packages

1. Add or modify dependencies in `pyproject.toml`

2. Update lock file:
   ```bash
   uv sync
   ```

3. Commit the updated `uv.lock` file

### Update Python Version

1. Edit `.python-version`:
   ```bash
   echo "3.12" > .python-version
   ```

2. Reinstall environment:
   ```bash
   uv sync
   ```

## Troubleshooting

### "quarto: command not found"

Run `make setup` or manually run `./install-quarto.sh`. Ensure `~/.local/bin` is in your PATH.

### Python package errors

Run `uv sync` to ensure all dependencies are installed correctly.

### Version mismatch warnings

Run `make check` to verify your environment. If Quarto version doesn't match, run `make setup` again.

### Windows Users

**WSL (Windows Subsystem for Linux):**
The `install-quarto.sh` script works automatically on WSL - it detects WSL as Linux.

**Native Windows:**
The `install-quarto.sh` script supports native Windows:
1. Requires `unzip` or PowerShell for extraction
2. Installs `quarto.exe` to `~/.local/bin/`
3. Add to PATH: `setx PATH "%USERPROFILE%\.local\bin;%PATH%"`

Alternatively, install uv for Windows to manage Python packages.

## For Collaborators

1. Clone the repository
2. Run `make setup` (one-time)
3. Run `make render` to build
4. Submit changes via pull request

No need to worry about version compatibility - the environment is fully reproducible!

## GitHub Actions (Automatic Deployment)

This repository uses GitHub Actions to automatically build and deploy to GitHub Pages.

### How it works

- On every push to the `main` branch, GitHub Actions:
  1. Sets up Quarto 1.3.450
  2. Sets up Python 3.11 with uv
  3. Installs dependencies from `uv.lock`
  4. Renders all QMD files
  5. Deploys to GitHub Pages (`gh-pages` branch)

### Configuration

The workflow is defined in `.github/workflows/publish.yml`.

### Freeze computations

Code execution uses `freeze: auto` (configured in `_quarto.yaml`):
- Code runs locally when you render
- Results are stored in `_freeze/` directory
- GitHub Actions uses frozen results (no code execution on CI)
- Ensures reproducible builds without re-running expensive computations

To re-run code, delete the `_freeze/` directory and render locally.

### Manual trigger

You can manually trigger a build:
1. Go to **Actions** tab in GitHub
2. Select "Quarto Publish" workflow
3. Click "Run workflow"

### Initial setup

Before GitHub Actions can deploy:
1. Run `quarto publish gh-pages` locally once (creates `_publish.yml`)
2. Ensure repository has **Read and write permissions** for Actions
3. GitHub Pages source should be set to `gh-pages` branch

