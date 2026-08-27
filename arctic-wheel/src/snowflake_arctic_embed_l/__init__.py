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
