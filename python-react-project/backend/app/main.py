from fastapi import FastAPI, WebSocket, Request
from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
import os

app = FastAPI()

frontend_static_path = f'{os.getcwd()}/python-react-project/frontend/build'
# exists = os.path.exists(frontend_static_path)
# app.mount("/", StaticFiles(directory=frontend_static_path), name="static")
# templates = Jinja2Templates(directory="/static")

app.mount("/static", StaticFiles(directory=frontend_static_path), name="static")
templates = Jinja2Templates(directory=f'{os.getcwd()}/python-react-project/backend/templates')

@app.get("/", response_class=HTMLResponse)
async def read_root(request: Request):
    return templates.TemplateResponse("index.html", {"request": request})

@app.post("/api/submit")
async def submit_form(data: dict):
    return {"message": f"Received: {data['message']}"}

@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    while True:
        data = await websocket.receive_text()
        await websocket.send_text(f"Message received: {data}")