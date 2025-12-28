from fastapi import APIRouter, HTTPException, Depends
from fastapi.responses import FileResponse
from app.database import get_db_connection
import os

router = APIRouter()

BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
STATIC_DIR = os.path.join(BASE_DIR, "static")
AUDIO_DIR = os.path.join(STATIC_DIR, "audio")


@router.get("/play/{audio_id}", summary="Play audio file")
async def play_audio(audio_id: int):
    """
    Retrieves and plays an audio file from the database.
    """
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT file_path FROM audio_recordings WHERE id = ?", (audio_id,))
        audio_data = cursor.fetchone()
        conn.close()

        if not audio_data:
            raise HTTPException(status_code=404, detail="Audio file not found.")

        # Construct the full file path
        # db_filepath is like /static/audio/tts_....mp3
        # we need to convert it to a full path
        relative_path = audio_data[0]
        if relative_path.startswith('/'):
            relative_path = relative_path[1:] # remove leading /

        file_path = os.path.join(BASE_DIR, relative_path)
        print(f"Attempting to play audio file for audio_id: {audio_id}")
        print(f"Constructed file path: {file_path}")
        print(f"File exists: {os.path.exists(file_path)}")


        if not os.path.exists(file_path):
            print(f"Audio file not found on disk for audio_id: {audio_id}")
            raise HTTPException(status_code=404, detail="Audio file not found on disk.")

        return FileResponse(file_path, media_type="audio/mpeg")

    except HTTPException as e:
        raise e
    except Exception as e:
        print(f"Play audio endpoint error: {e}")
        raise HTTPException(status_code=500, detail="An unexpected error occurred while playing the audio file.")

