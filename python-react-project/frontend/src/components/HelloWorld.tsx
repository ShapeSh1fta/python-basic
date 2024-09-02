import React, { useState, useEffect, FormEvent } from 'react';

function HelloWorld() {
  const [message, setMessage] = useState<string>('');
  const [buttonMessage, setButtonMessage] = useState<string>('');
  const [wsMessage, setWsMessage] = useState<string>('');
  const [ws, setWs] = useState<WebSocket | null>(null);

  useEffect(() => {
    const websocket = new WebSocket('ws://localhost:8000/ws');
    setWs(websocket);

    websocket.onmessage = (event: MessageEvent) => {
      setWsMessage(event.data);
    };

    return () => {
      websocket.close();
    };
  }, []);

  const handleSubmit = async (e: FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    const response = await fetch('/api/submit', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ message }),
    });
    const data = await response.json();
    alert(data.message);
  };

  const sendButtonMessage = () => {
    setButtonMessage(message);
  };

  const sendWebSocketMessage = () => {
    if (ws) {
      ws.send(message);
    }
  };

  return (
    <div>
      <h1>Hello, World!</h1>
      <form onSubmit={handleSubmit}>
        <input
          type="text"
          value={message}
          onChange={(e) => setMessage(e.target.value)}
          placeholder="Enter a message"
        />
        <button type="submit">Submit</button>
      </form>
      <button onClick={sendButtonMessage}>Send Button Message</button>
      <p>Button Message: {buttonMessage}</p>
      <button onClick={sendWebSocketMessage}>Send WebSocket Message</button>
      <p>WebSocket Message: {wsMessage}</p>
    </div>
  );
}

export default HelloWorld;
