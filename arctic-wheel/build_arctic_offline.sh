#!/usr/bin/env bash

set -euo pipefail


############################################
# CHANGE THIS ONLY
############################################

MODEL_REPO="${1:-Snowflake/snowflake-arctic-embed-l}"

# Examples:
# ./build_arctic_offline.sh Snowflake/snowflake-arctic-embed-m-v1.5



############################################
# DERIVED NAMES
############################################

MODEL_NAME=$(basename "${MODEL_REPO}")

PACKAGE=$(echo "${MODEL_NAME}" \
    | tr '-' '_' \
    | tr '.' '_')


SRC_DIR="src/${PACKAGE}"
MODEL_DIR="${SRC_DIR}/model"


############################################
# CLEAN
############################################

rm -rf build *.egg-info
mkdir -p dist

rm -rf src/*.egg-info
rm -rf "${SRC_DIR}"


mkdir -p "${MODEL_DIR}"
echo "${MODEL_REPO}" > "${MODEL_DIR}/MODEL_SOURCE.txt"
mkdir -p "${SRC_DIR}"


############################################
# PYPROJECT
############################################

echo "Creating pyproject.toml"


cat > pyproject.toml <<EOF
[build-system]
requires = [
    "setuptools>=68",
    "wheel",
    "build"
]
build-backend = "setuptools.build_meta"


[project]
name = "${PACKAGE}"
version = "1.0.0"
requires-python = ">=3.12,<3.13"


[tool.setuptools]
package-dir = {"" = "src"}


[tool.setuptools.packages.find]
where = ["src"]


[tool.setuptools.package-data]
${PACKAGE} = [
    "model/**/*"
]
EOF



############################################
# WRAPPER
############################################

echo "Creating wrapper"


cat > "${SRC_DIR}/__init__.py" <<EOF
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



############################################
# DOWNLOAD MODEL
############################################

echo "Downloading ${MODEL_REPO}"


python3.12 -m pip install \
    "huggingface_hub==0.27.0" \
    "build==1.2.2.post1" \
    "setuptools==75.6.0" \
    "wheel==0.45.1"


python3.12 - <<EOF

from huggingface_hub import snapshot_download

snapshot_download(
    repo_id="${MODEL_REPO}",
    local_dir="${MODEL_DIR}",
    local_dir_use_symlinks=False
)

EOF



############################################
# SHOW CONTENTS
############################################

echo
echo "MODEL CONTENTS"

find "${MODEL_DIR}" -type f



############################################
# BUILD WHEEL
############################################

echo
echo "Building wheel"


python3.12 -m pip install \
    "huggingface_hub==0.27.0" \
    "build==1.2.2.post1" \
    "setuptools==75.6.0" \
    "wheel==0.45.1"


python3.12 -m build --wheel



############################################
# TEST ENVIRONMENT
############################################

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



############################################
# INSTALL WHEEL
############################################

pip install dist/${PACKAGE}-1.0.0-py3-none-any.whl



############################################
# TEST
############################################

cat > test_arctic.py <<EOF

import ${PACKAGE}


model = ${PACKAGE}.load()


docs = [
    "Dogs are household pets",
    "The Eiffel Tower is in Paris",
    "Cats sleep a lot",
    "Vendor failed to implement adequate access controls"
]


queries = [
    "Animals that are common household pets"
]


try:
    q = model.encode(
        queries,
        normalize_embeddings=True,
        prompt_name="query"
    )
except Exception:
    q = model.encode(
        queries,
        normalize_embeddings=True
    )


d = model.encode(
    docs,
    normalize_embeddings=True
)


scores = q @ d.T


print()
print("SUCCESS")
print("Embedding dimension:", len(q[0]))
print()


for doc, score in zip(docs, scores[0]):
    print(
        round(float(score), 4),
        doc
    )

EOF


python test_arctic.py



############################################
# DONE
############################################

echo
echo "DONE"

ls -lh dist/