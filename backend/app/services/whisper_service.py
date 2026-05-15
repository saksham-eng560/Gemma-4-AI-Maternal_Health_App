from faster_whisper import WhisperModel
import tempfile

model = None

def get_model():
    global model
    if model is None:
        try:
            # Using int8 for faster CPU inference with base model for better accuracy
            model = WhisperModel("base", device="cpu", compute_type="int8")
        except Exception as e:
            print(f"Error loading Whisper: {e}")
            return None
    return model

def transcribe_audio(audio):
    whisper_model = get_model()
    if whisper_model is None:
        return "Transcription error: Whisper model not loaded or FFmpeg missing."

    with tempfile.NamedTemporaryFile(
        delete=False,
        suffix=".wav"
    ) as temp:
        temp.write(audio.file.read())
        temp_path = temp.name

    try:
        segments, _ = whisper_model.transcribe(temp_path, beam_size=5, vad_filter=False, condition_on_previous_text=False)
        text = " ".join([segment.text.strip() for segment in segments])
        return text
    except Exception as e:
        return f"Transcription error: {str(e)}. Please ensure FFmpeg is installed."