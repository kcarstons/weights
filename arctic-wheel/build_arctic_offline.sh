#!/usr/bin/env bash

set -euo pipefail

PACKAGE="snowflake_arctic_embed_m_v1_5"

SRC_DIR="src/${PACKAGE}"
MODEL_DIR="${SRC_DIR}/model"

rm -rf build dist *.egg-info
rm -rf src/*.egg-info
rm -rf "${SRC_DIR}"

mkdir -p "${MODEL_DIR}/1_Pooling"
mkdir -p "${MODEL_DIR}/2_Normalize"

mkdir -p "${SRC_DIR}"


echo "Creating pyproject.toml"

cat > pyproject.toml <<'EOF'
[build-system]
requires = [
    "setuptools>=68",
    "wheel",
    "build"
]
build-backend = "setuptools.build_meta"


[project]
name = "snowflake-arctic-embed-m-v1-5"
version = "1.0.0"
requires-python = ">=3.12,<3.13"


[tool.setuptools]
package-dir = {"" = "src"}


[tool.setuptools.packages.find]
where = ["src"]


[tool.setuptools.package-data]
snowflake_arctic_embed_m_v1_5 = [
    "model/**/*"
]
EOF



echo "Creating wrapper"

cat > "${SRC_DIR}/__init__.py" <<'EOF'
from pathlib import Path

MODEL_PATH = Path(__file__).resolve().parent / "model"


def load():

    from sentence_transformers import SentenceTransformer

    return SentenceTransformer(
        str(MODEL_PATH),
        local_files_only=True
    )


__all__ = [
    "MODEL_PATH",
    "load"
]
EOF



echo "Downloading model"

BASE_URL="https://huggingface.co/Snowflake/snowflake-arctic-embed-m-v1.5/resolve/main"


FILES=(
"config_sentence_transformers.json"
"modules.json"

"config.json"
"model.safetensors"

"tokenizer.json"
"tokenizer_config.json"
"special_tokens_map.json"
"vocab.txt"

"1_Pooling/config.json"
)


for FILE in "${FILES[@]}"
do
    echo "Downloading ${FILE}"

    curl \
        -L \
        --fail \
        --retry 3 \
        "${BASE_URL}/${FILE}?download=true" \
        -o "${MODEL_DIR}/${FILE}"

done



echo
echo "MODEL CONTENTS"

find "${MODEL_DIR}" -type f



echo
echo "Building wheel"


python3.12 -m pip install --upgrade \
    build \
    setuptools \
    wheel


python3.12 -m build --wheel



echo
echo "Creating test environment"

rm -rf test-env

python3.12 -m venv test-env

source test-env/bin/activate


pip install --upgrade pip


pip install \
    torch==2.5.1 \
    sentence-transformers==3.3.1 \
    transformers==4.57.6



pip install \
    dist/snowflake_arctic_embed_m_v1_5-1.0.0-py3-none-any.whl



cat > test_arctic.py <<'EOF'
import snowflake_arctic_embed_m_v1_5


model = snowflake_arctic_embed_m_v1_5.load()


docs = [
    "Dogs are household pets",
    "The Eiffel Tower is in Paris",
    "Cats sleep a lot"
]


queries = [
    "What animals are common pets?"
]


q = model.encode(
    queries,
    prompt_name="query"
)


d = model.encode(docs)


scores = q @ d.T


print()
print("SUCCESS")
print()


for doc, score in zip(docs, scores[0]):
    print(
        round(float(score), 4),
        doc
    )
EOF



python test_arctic.py


echo
echo "DONE"

ls -lh dist/