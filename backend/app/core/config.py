import os
from dotenv import load_dotenv

load_dotenv()

GROQ_API_KEY = os.getenv("GROQ_API_KEY")
DEFAULT_LANGUAGE = "en"
ELEVENLABS_API_KEY = os.getenv("ELEVENLABS_API_KEY")
