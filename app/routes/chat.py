"""Chat routes for LLM interaction."""

import logging
from typing import Dict, Any, Optional

from fastapi import APIRouter, HTTPException, Form, Request, Depends
from fastapi.responses import HTMLResponse, JSONResponse
from fastapi.templating import Jinja2Templates

from app.services.conversation_service import ConversationService


logger = logging.getLogger(__name__)
router = APIRouter()
templates = Jinja2Templates(directory="app/templates")


# Dependency to get conversation service
def get_conversation_service() -> ConversationService:
    """Get conversation service instance."""
    return ConversationService()


@router.get("/chat", response_class=HTMLResponse, name="chat_interface")
async def chat_interface(request: Request) -> HTMLResponse:
    """Basic chat interface for testing LLM connectivity."""
    return templates.TemplateResponse(
        request, "chat/basic_chat.html", {
            "title": "AI Chat - Reckie",
            "page_title": "AI Chat Interface"
        }
    )


@router.post("/chat/start", name="start_conversation")
async def start_conversation(
    user_id: str = Form(default="test_user"),
    document_type: Optional[str] = Form(default=None),
    conversation_service: ConversationService = Depends(get_conversation_service)
) -> JSONResponse:
    """Start a new conversation with the AI."""
    try:
        conversation_id = await conversation_service.start_conversation(
            user_id=user_id,
            document_type=document_type
        )

        return JSONResponse({
            "success": True,
            "conversation_id": conversation_id,
            "message": "Conversation started successfully"
        })

    except Exception as e:
        logger.error(f"Error starting conversation: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Failed to start conversation: {str(e)}")


@router.post("/chat/send", name="send_message")
async def send_message(
    conversation_id: str = Form(...),
    message: str = Form(...),
    user_id: str = Form(default="test_user"),
    conversation_service: ConversationService = Depends(get_conversation_service)
) -> JSONResponse:
    """Send a message to the AI and get response."""
    try:
        if not message.strip():
            raise HTTPException(status_code=400, detail="Message cannot be empty")

        if len(message) > 2000:
            raise HTTPException(status_code=400, detail="Message too long (max 2000 characters)")

        response = await conversation_service.send_message(
            conversation_id=conversation_id,
            user_id=user_id,
            message=message.strip()
        )

        # Log conversation to console for debugging
        await conversation_service.log_conversation_to_console(conversation_id)

        return JSONResponse({
            "success": True,
            "response": response["response"],
            "message_id": response["message_id"],
            "timestamp": response["timestamp"]
        })

    except ValueError as e:
        logger.error(f"Validation error: {str(e)}")
        raise HTTPException(status_code=400, detail=str(e))

    except Exception as e:
        logger.error(f"Error sending message: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Failed to send message: {str(e)}")


@router.get("/chat/history/{conversation_id}", name="conversation_history")
async def get_conversation_history(
    conversation_id: str,
    include_system: bool = False,
    conversation_service: ConversationService = Depends(get_conversation_service)
) -> JSONResponse:
    """Get conversation history."""
    try:
        history = conversation_service.get_conversation_history(
            conversation_id=conversation_id,
            include_system=include_system
        )

        summary = conversation_service.get_conversation_summary(conversation_id)

        return JSONResponse({
            "success": True,
            "conversation_id": conversation_id,
            "messages": history,
            "summary": summary
        })

    except ValueError as e:
        logger.error(f"Validation error: {str(e)}")
        raise HTTPException(status_code=404, detail=str(e))

    except Exception as e:
        logger.error(f"Error getting conversation history: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Failed to get conversation history: {str(e)}")


@router.get("/chat/test", response_class=HTMLResponse, name="chat_test")
async def chat_test(request: Request) -> HTMLResponse:
    """Simple test page for basic AI connectivity."""
    return templates.TemplateResponse(
        request, "chat/test_chat.html", {
            "title": "AI Test - Reckie",
            "page_title": "AI Connectivity Test"
        }
    )


@router.post("/chat/test/echo", name="test_echo")
async def test_echo(
    message: str = Form(...),
    conversation_service: ConversationService = Depends(get_conversation_service)
) -> JSONResponse:
    """Test endpoint that echoes back the message (for testing without AI)."""
    try:
        if not message.strip():
            raise HTTPException(status_code=400, detail="Message cannot be empty")

        # Simple echo response for testing
        response = f"Echo: {message.strip()}"

        return JSONResponse({
            "success": True,
            "response": response,
            "timestamp": "test",
            "mode": "echo"
        })

    except Exception as e:
        logger.error(f"Error in test echo: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Test failed: {str(e)}")


@router.get("/chat/status", name="chat_status")
async def chat_status() -> JSONResponse:
    """Check the status of chat services."""
    try:
        # Test conversation service initialization
        conversation_service = ConversationService()

        return JSONResponse({
            "success": True,
            "services": {
                "conversation_service": "operational",
                "openai_service": "configured" if conversation_service.openai_service.api_key else "not_configured"
            },
            "message": "Chat services are operational"
        })

    except Exception as e:
        logger.error(f"Error checking chat status: {str(e)}")
        return JSONResponse({
            "success": False,
            "error": str(e),
            "message": "Chat services are not fully operational"
        }, status_code=500)