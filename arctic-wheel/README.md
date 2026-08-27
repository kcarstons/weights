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
