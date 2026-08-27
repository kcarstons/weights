
import snowflake_arctic_embed_m_v1_5


model = snowflake_arctic_embed_m_v1_5.load()


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

