"""Conversation service for managing LLM interactions and logging."""

import json
import logging
from datetime import datetime
from typing import Dict, List, Optional, Any
from uuid import uuid4

import httpx

from app.config import settings
from app.services.openai_service import OpenAIService


logger = logging.getLogger(__name__)


class ConversationService:
    """Service for managing conversations with LLM including logging and context."""

    def __init__(self) -> None:
        """Initialize conversation service."""
        self.openai_service = OpenAIService()
        self.conversations: Dict[str, List[Dict[str, Any]]] = {}

    async def start_conversation(self, user_id: str, document_id: Optional[str] = None,
                               document_type: Optional[str] = None) -> str:
        """Start a new conversation session."""
        conversation_id = str(uuid4())

        # Initialize conversation with system context
        system_prompt = self._build_system_prompt(document_type)

        self.conversations[conversation_id] = [{
            "id": str(uuid4()),
            "timestamp": datetime.utcnow().isoformat(),
            "role": "system",
            "content": system_prompt,
            "user_id": user_id,
            "document_id": document_id,
            "document_type": document_type
        }]

        logger.info(f"Started conversation {conversation_id} for user {user_id}")
        return conversation_id

    async def send_message(self, conversation_id: str, user_id: str, message: str,
                          context: Optional[Dict[str, Any]] = None) -> Dict[str, Any]:
        """Send a message in a conversation and get AI response."""
        if conversation_id not in self.conversations:
            raise ValueError(f"Conversation {conversation_id} not found")

        # Log user message
        user_message = {
            "id": str(uuid4()),
            "timestamp": datetime.utcnow().isoformat(),
            "role": "user",
            "content": message,
            "user_id": user_id,
            "context": context or {}
        }

        self.conversations[conversation_id].append(user_message)
        logger.info(f"User message logged for conversation {conversation_id}")

        try:
            # Prepare conversation context for LLM
            conversation_context = self._prepare_conversation_context(conversation_id, context)

            # Get AI response
            ai_response = await self.openai_service.generate_completion(
                prompt=message,
                model="gpt-3.5-turbo",
                context=conversation_context
            )

            # Log AI response
            ai_message = {
                "id": str(uuid4()),
                "timestamp": datetime.utcnow().isoformat(),
                "role": "assistant",
                "content": ai_response,
                "user_id": user_id,
                "model": "gpt-3.5-turbo"
            }

            self.conversations[conversation_id].append(ai_message)
            logger.info(f"AI response logged for conversation {conversation_id}")

            return {
                "conversation_id": conversation_id,
                "message_id": ai_message["id"],
                "response": ai_response,
                "timestamp": ai_message["timestamp"]
            }

        except Exception as e:
            # Log error
            error_message = {
                "id": str(uuid4()),
                "timestamp": datetime.utcnow().isoformat(),
                "role": "system",
                "content": f"Error: {str(e)}",
                "user_id": user_id,
                "error": True
            }

            self.conversations[conversation_id].append(error_message)
            logger.error(f"Error in conversation {conversation_id}: {str(e)}")

            raise

    def get_conversation_history(self, conversation_id: str,
                               include_system: bool = False) -> List[Dict[str, Any]]:
        """Get conversation history for a conversation."""
        if conversation_id not in self.conversations:
            raise ValueError(f"Conversation {conversation_id} not found")

        messages = self.conversations[conversation_id]

        if not include_system:
            messages = [msg for msg in messages if msg["role"] != "system"]

        return messages

    def get_conversation_summary(self, conversation_id: str) -> Dict[str, Any]:
        """Get summary information about a conversation."""
        if conversation_id not in self.conversations:
            raise ValueError(f"Conversation {conversation_id} not found")

        messages = self.conversations[conversation_id]
        user_messages = [msg for msg in messages if msg["role"] == "user"]
        ai_messages = [msg for msg in messages if msg["role"] == "assistant"]

        return {
            "conversation_id": conversation_id,
            "total_messages": len(messages),
            "user_messages": len(user_messages),
            "ai_messages": len(ai_messages),
            "started_at": messages[0]["timestamp"] if messages else None,
            "last_activity": messages[-1]["timestamp"] if messages else None,
            "document_id": messages[0].get("document_id") if messages else None,
            "document_type": messages[0].get("document_type") if messages else None
        }

    def _build_system_prompt(self, document_type: Optional[str] = None) -> str:
        """Build system prompt based on document type and context."""
        base_prompt = """You are an AI assistant helping users create and improve project documentation.
        You should provide helpful, accurate, and contextual suggestions while maintaining a collaborative tone.
        Always ask clarifying questions when user requests are ambiguous."""

        if document_type == "vision":
            return base_prompt + """

            You are specifically helping with a vision document. Focus on:
            - Clear problem statements and solutions
            - Target audience and user needs
            - Business goals and success criteria
            - Strategic direction and market context
            Ask questions about stakeholders, market fit, and business objectives."""

        elif document_type == "requirements":
            return base_prompt + """

            You are specifically helping with technical requirements. Focus on:
            - Complete and unambiguous specifications
            - Acceptance criteria and edge cases
            - Technical constraints and dependencies
            - Implementation considerations
            Ask questions about completeness, testability, and technical feasibility."""

        elif document_type == "user_story":
            return base_prompt + """

            You are specifically helping with user stories. Focus on:
            - User motivation and value proposition
            - Clear acceptance criteria
            - User journey and workflow
            - Testable scenarios
            Ask questions about user needs, workflows, and success measures."""

        return base_prompt

    def _prepare_conversation_context(self, conversation_id: str,
                                    additional_context: Optional[Dict[str, Any]] = None) -> str:
        """Prepare conversation context for LLM."""
        messages = self.conversations[conversation_id]

        # Build conversation history (last 10 messages to stay within token limits)
        recent_messages = messages[-10:]
        context_parts = []

        for msg in recent_messages:
            if msg["role"] in ["user", "assistant"]:
                context_parts.append(f"{msg['role']}: {msg['content']}")

        context = "\n".join(context_parts)

        # Add additional context if provided
        if additional_context:
            if "document_content" in additional_context:
                context += f"\n\nCurrent document content:\n{additional_context['document_content']}"

            if "project_context" in additional_context:
                context += f"\n\nProject context:\n{additional_context['project_context']}"

        return context

    async def log_conversation_to_console(self, conversation_id: str) -> None:
        """Log conversation details to console for debugging."""
        if conversation_id not in self.conversations:
            logger.warning(f"Conversation {conversation_id} not found for logging")
            return

        messages = self.conversations[conversation_id]

        print(f"\n=== Conversation Log: {conversation_id} ===")
        for msg in messages:
            timestamp = msg["timestamp"]
            role = msg["role"].upper()
            content = msg["content"][:100] + "..." if len(msg["content"]) > 100 else msg["content"]

            print(f"[{timestamp}] {role}: {content}")

        print("=== End Conversation Log ===\n")