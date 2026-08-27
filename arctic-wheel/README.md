# Snowflake Arctic Embed — Standalone Wheels

Self-contained, offline-ready Python packages for the **Snowflake Arctic Embed** models.

This repository packages the model weights, configurations, tokenizer files, and inference wrapper directly into distributable `.whl` files. Once the wheel has been built and transferred to the target environment, the model can be loaded locally without requiring runtime access to Hugging Face.

---

## Models Included

This repository currently supports:

- **Snowflake Arctic Embed L (v1.0)** — large English embedding model
- **Snowflake Arctic Embed M v1.5** — medium English embedding model

Both models are designed for semantic search, retrieval, and cosine-similarity applications.

---

## What's Included

* **Source Code (`src/`)**: A lightweight Python wrapper using `sentence-transformers` to load and run the model locally.

* **Model Weights & Configs (`model/`)**: Model weights (`model.safetensors`), tokenizer files, configuration files, vocabulary, pooling configuration, and other required model assets.

* **Build Automation (`build_arctic_wheel.sh`)**: A reproducible shell script that downloads the selected model from Hugging Face, packages all model assets into a wheel, builds the wheel, creates a clean test environment, installs the wheel, and runs an integration test.

---

## Installation

### Option 1: Install from a Pre-Built Release

Pre-built wheels can be installed directly from the GitHub Releases page without cloning the repository.

### Arctic Embed L

```bash
pip install https://github.com/kcarstons/weights/releases/download/v1.0.0/snowflake_arctic_embed_l-1.0.0-py3-none-any.whl

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
./build_arctic_offline.sh Snowflake/snowflake-arctic-embed-l
./build_arctic_offline.sh Snowflake/snowflake-arctic-embed-m-v1.5
```

This script will fetch model components, bundle them, build the .whl file inside dist/, create a virtual environment, and run an integration test.
