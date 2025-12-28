from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.responses import JSONResponse

from app.api.chat import router as chat_router
from app.api.user import router as user_router
from app.api.carbon_routes import router as carbon_router
from app.api.tts import router as tts_router
from app.api.play_audio import router as play_audio_router

import os
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = FastAPI(title="TechFiesta AI Backend")

# Logging middleware
@app.middleware("http")
async def log_requests(request: Request, call_next):
    logger.info(f"Incoming request: {request.method} {request.url}")
    logger.info(f"Headers: {request.headers}")
    response = await call_next(request)
    return response

# ✅ CORS — THIS WAS MISSING (CRITICAL)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],      # allow all for dev
    allow_credentials=True,
    allow_methods=["*"],      # allows OPTIONS, POST, GET
    allow_headers=["*"],
)

# Generic exception handler
@app.exception_handler(Exception)
async def generic_exception_handler(request: Request, exc: Exception):
    logger.error(f"Unhandled exception: {exc}", exc_info=True)
    return JSONResponse(
        status_code=500,
        content={"message": f"Something went wrong on the server: {exc}"},
    )

# Static audio
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
AUDIO_DIR = os.path.join(BASE_DIR, "../static/audio")
os.makedirs(AUDIO_DIR, exist_ok=True)

app.mount("/static/audio", StaticFiles(directory=AUDIO_DIR), name="static_audio")

# Routers
app.include_router(chat_router, prefix="/api/chat", tags=["Chat"])
app.include_router(user_router, prefix="/api/user", tags=["User"])
app.include_router(carbon_router, prefix="/api/carbon", tags=["Carbon Credits"])
app.include_router(tts_router, prefix="/api/tts", tags=["TTS"])
app.include_router(play_audio_router, prefix="/api", tags=["Play Audio"])


@app.get("/health")
def health():
    return {"status": "TechFiesta backend running"}
