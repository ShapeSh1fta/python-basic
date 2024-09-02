from fastapi import FastAPI, WebSocket, Request
from fastapi.responses import FileResponse, HTMLResponse
from fastapi.staticfiles import StaticFiles
import os

app = FastAPI()

frontend_build_path = f'../frontend/build'

app.mount("/static", StaticFiles(directory=f"{frontend_build_path}/static"), name="static")

@app.get("/", response_class=HTMLResponse)
async def read_root(request: Request):
    return FileResponse(f"{frontend_build_path}/index.html")

@app.post("/api/submit")
async def submit_form(data: dict):
    return {"message": f"Received: {data['message']}"}

# sets up a health check route. This is used later to show how you can hit
# the API and the React App url's
@app.get('/api/health')
async def health():
    return { 'status': 'healthy' }


# Defines a route handler for `/*` essentially.
# NOTE: this needs to be the last route defined b/c it's a catch all route
@app.get("/{rest_of_path:path}")
async def react_app(req: Request, rest_of_path: str):
    return FileResponse(f"{frontend_build_path}/index.html")

@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    while True:
        data = await websocket.receive_text()
        await websocket.send_text(f"Message received: {data}")