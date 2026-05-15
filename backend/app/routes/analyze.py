from fastapi import APIRouter, UploadFile, File, HTTPException
from app.services.whisper_service import transcribe_audio
from app.services.gemma_service import analyze_symptoms
from app.services.vision_service import analyze_image
from app.rules.risk_rules import evaluate_risk
from app.services.tts_service import generate_voice
from app.services.pdf_service import generate_referral_pdf

router = APIRouter()

@router.post("/analyze")
def analyze(
    audio: UploadFile = File(...),
    image: UploadFile = File(...)
):

    text = transcribe_audio(audio)
    
    # Validation: Check if the audio actually contained speech
    cleaned_text = text.strip().lower() if text else ""
    # Common Whisper noise transcriptions
    noise_phrases = ["thank you.", "thanks.", "you", "subscribe", "thanks for watching"]
    if len(cleaned_text) < 5 or any(phrase in cleaned_text for phrase in noise_phrases):
        raise HTTPException(
            status_code=400,
            detail="We couldn't hear your symptoms clearly. Please record your voice again and describe how you are feeling."
        )

    vision_result = analyze_image(image)

    gemma_result = analyze_symptoms(
        text,
        vision_result
    )

    risk = evaluate_risk(gemma_result)

    voice_file = generate_voice(risk)

    pdf_file = generate_referral_pdf(
        gemma_result,
        risk
    )

    return {
        "speech_text": text,
        "vision_analysis": vision_result,
        "ai_analysis": gemma_result,
        "risk": risk,
        "voice_output": voice_file,
        "referral_pdf": pdf_file
    }