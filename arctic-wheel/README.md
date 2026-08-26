# Snowflake Arctic Embed M v1.5 (Standalone Wheel)

A self-contained, offline-ready Python package for the **Snowflake Arctic Embed M v1.5** model. This package bundles the model weights (`model.safetensors`), configurations, and inference wrappers directly into a single distributable `.whl` file, completely eliminating runtime dependencies on Hugging Face.

---

## What's Included
* **Source Code (`src/`)**: A clean Python wrapper utilizing `sentence-transformers` and `transformers` to run the model locally.
* **Model Weights & Configs (`model/`)**: Bundled tokenizers, vocabulary, pooling configs, and the raw `model.safetensors` weight file (managed via Git LFS).
* **Build Automation (`build_arctic_offline.sh`)**: A reproducible shell script that automates asset fetching, packaging, wheel generation, and local integration testing.

---

## Installation

### Option 1: Install from Pre-Built Release (Recommended)
You can install the wheel directly from the repository's GitHub Releases page without cloning the code:
```
pip install [https://github.com/kcarstons/weights/releases/download/v1.0.0/snowflake_arctic_embed_m_v1_5-1.0.0-py3-none-any.whl](https://github.com/kcarstons/weights/releases/download/v1.0.0/snowflake_arctic_embed_m_v1_5-1.0.0-py3-none-any.whl)
```

### Option 2: Build the Wheel From Source (Using the Shell Script)

If you cloned the repository and want to run the automated build script to generate the wheel yourself (requires Python 3.12):

Navigate into the arctic-wheel directory, make the script executable and run this. 

```
cd arctic-wheel
chmod +x build_arctic_offline.sh
./build_arctic_offline.sh
```

This script will fetch model components, bundle them, build the .whl file inside dist/, create a virtual environment, and run an integration test.

## Developer Guide: Git LFS & Pushing Changes

If you are modifying code or weights in this repository and need to push updates using Git LFS:
```
# Install Git LFS if not already available
sudo apt-get update
sudo apt-get install -y git-lfs

# Initialize and track large file formats
git lfs install
git lfs track "*.safetensors"
git lfs track "*.pt"
git lfs track "*.bin"

# Stage your tracking rules and source files
git add .gitattributes
git add arctic-wheel/pyproject.toml
git add arctic-wheel/README.md
git add arctic-wheel/src/

# Commit and push
git commit -m "add src files with Git LFS model tracking"
git remote add origin [https://github.com/kcarstons/weights.git](https://github.com/kcarstons/weights.git) 2>/dev/null || true
git branch -M main
git push origin main --force
```