from fastapi import APIRouter
from app.models.chat_models import ChatRequest, ChatResponse
from app.services.llm_service import generate_reply

router = APIRouter()

<<<<<<< HEAD
@router.post("/", response_model=ChatResponse)
=======
@router.post("/chat", response_model=ChatResponse)
>>>>>>> ff9a281da14fd2211d5e027c78a4e6daf4f6262e
def chat_endpoint(request: ChatRequest):
    reply = generate_reply(
        user_id=request.user_id,
        user_message=request.message
    )

    return ChatResponse(
        reply=reply,
        confidence=0.87
    )
