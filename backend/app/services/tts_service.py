import os
import uuid
import httpx
from fastapi import HTTPException

from app.core.config import ELEVENLABS_API_KEY
from app.database import get_db_connection

BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
STATIC_DIR = os.path.join(BASE_DIR, "static")
AUDIO_DIR = os.path.join(STATIC_DIR, "audio")

os.makedirs(AUDIO_DIR, exist_ok=True)


async def text_to_speech(text: str):
    if not ELEVENLABS_API_KEY:
        print("❌ ERROR: ELEVENLABS_API_KEY is not set in the environment.")
        raise HTTPException(status_code=500, detail="ElevenLabs API key not configured on server.")
        
    if not text.strip():
        raise HTTPException(status_code=400, detail="Text is required")

    voice_id = "21m00Tcm4TlvDq8ikWAM"
    url = f"https://api.elevenlabs.io/v1/text-to-speech/{voice_id}"

    headers = {
        "xi-api-key": ELEVENLABS_API_KEY,
        "Content-Type": "application/json",
        "accept": "audio/mpeg",
    }

    payload = {
        "text": text,
        "model_id": "eleven_multilingual_v2",
    }

    async with httpx.AsyncClient() as client:
        try:
            response = await client.post(url, json=payload, headers=headers)
            response.raise_for_status()
        except Exception as e:
            print("❌ ElevenLabs TTS Error:", str(e))
            raise HTTPException(status_code=500, detail="TTS failed")

    filename = f"tts_{uuid.uuid4()}.mp3"
    filepath = os.path.join(AUDIO_DIR, filename)
    db_filepath = f"/static/audio/{filename}"

    with open(filepath, "wb") as f:
        f.write(response.content)

    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute(
        "INSERT INTO audio_recordings (text, file_path) VALUES (?, ?)",
        (text, db_filepath),
    )
    conn.commit()
    new_audio_id = cursor.lastrowid
    conn.close()

    return {"id": new_audio_id, "text": text, "file_path": db_filepath}
