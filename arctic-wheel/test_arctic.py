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
