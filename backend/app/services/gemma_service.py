from transformers import pipeline

pipe = None

def get_pipe():
    global pipe
    if pipe is None:
        # Load model lazily
        pipe = pipeline(
            "text-generation",
            model="google/flan-t5-base"
        )
    return pipe

def analyze_symptoms(
    symptoms,
    vision_data
):
    text_generator = get_pipe()

    prompt = f"""
    You are a maternal health triage AI.

    Symptoms:
    {symptoms}

    Visual Findings:
    {vision_data}

    Analyze:
    - possible risk
    - severity
    - suggested action
    """

    result = text_generator(
        prompt,
        max_new_tokens=100
    )

    return result[0]["generated_text"]