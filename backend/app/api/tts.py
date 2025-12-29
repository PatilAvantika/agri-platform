from fastapi import APIRouter, HTTPException, Request
from pydantic import BaseModel

from app.services.tts_service import text_to_speech as tts_service

router = APIRouter()


class TTSRequest(BaseModel):
    text: str


@router.post("/tts", summary="Text to Speech")
async def text_to_speech(request: Request, tts_request: TTSRequest):
    """
    Converts text to speech using ElevenLabs API and returns the audio URL.
    """
    try:
        # The service returns a dict: {"id": ..., "text": ..., "file_path": ...}
        audio_data = await tts_service(tts_request.text)

        # The mobile app now expects a 'file_path' to construct the URL itself.
        return {"file_path": audio_data["file_path"]}

    except HTTPException as e:
        raise e
    except Exception as e:
        # Log the exception for debugging
        print(f"TTS endpoint error: {e}")
        raise HTTPException(
            status_code=500,
            detail="An unexpected error occurred during text-to-speech processing.",
        )