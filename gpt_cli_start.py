from transformers import pipeline

chat = pipeline("text-generation", model="distilgpt2")
while True:
    prompt = input("👤> ")
    result = chat(prompt, max_length=100, do_sample=True)[0]["generated_text"]
    print("🤖>", result)
