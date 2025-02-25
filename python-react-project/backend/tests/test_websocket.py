import pytest
from fastapi.testclient import TestClient
from fastapi.websockets import WebSocket
from backend.app.main import app
import asyncio
from typing import Generator

@pytest.fixture
def client() -> Generator:
    with TestClient(app) as c:
        yield c

@pytest.mark.asyncio
async def test_websocket_connection():
    client = TestClient(app)
    with client.websocket_connect("/ws") as websocket:
        # Test initial connection
        assert websocket.connected

@pytest.mark.asyncio
async def test_websocket_message_echo():
    client = TestClient(app)
    with client.websocket_connect("/ws") as websocket:
        # Send a test message
        test_message = "Hello WebSocket"
        websocket.send_text(test_message)
        
        # Check the echo response
        response = websocket.receive_text()
        assert response == f"Message received: {test_message}"
        
        # Check counter message
        counter_msg = websocket.receive_text()
        assert "Current counter:" in counter_msg

@pytest.mark.asyncio
async def test_websocket_counter_increment():
    client = TestClient(app)
    with client.websocket_connect("/ws") as websocket:
        # Get first counter message
        websocket.send_text("test")
        _ = websocket.receive_text()  # Skip echo message
        counter1 = websocket.receive_text()
        
        # Wait for next counter update
        counter2 = websocket.receive_text()
        
        # Extract counter values
        value1 = int(counter1.split(": ")[1])
        value2 = int(counter2.split(": ")[1])
        
        # Verify counter incremented
        assert value2 == value1 + 1

@pytest.mark.asyncio
async def test_websocket_disconnect():
    client = TestClient(app)
    with pytest.raises(Exception):  # Should raise when connection is closed
        with client.websocket_connect("/ws") as websocket:
            websocket.close()
            # Try to send after close
            websocket.send_text("Should fail") 