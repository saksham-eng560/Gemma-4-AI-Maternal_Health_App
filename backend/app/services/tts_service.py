from gtts import gTTS
import uuid

def generate_voice(risk):

    text = ""

    if risk == "HIGH RISK":
        text = "कृपया तुरंत डॉक्टर से संपर्क करें"

    else:
        text = "स्थिति सामान्य प्रतीत होती है"

    import os
    os.makedirs("outputs", exist_ok=True)
    filename = f"outputs/{uuid.uuid4()}.mp3"

    tts = gTTS(
        text=text,
        lang="hi"
    )

    tts.save(filename)

    return filename
