from fastapi import FastAPI, WebSocket, Request, WebSocketDisconnect
from fastapi.responses import FileResponse, HTMLResponse
from fastapi.staticfiles import StaticFiles
import asyncio


app = FastAPI()

frontend_build_path = f'../frontend/build'

app.mount("/static", StaticFiles(directory=f"{frontend_build_path}/static"), name="static")

@app.get("/", response_class=HTMLResponse)
async def read_root(request: Request):
    return FileResponse(f"{frontend_build_path}/index.html")

@app.post("/api/submit")
async def submit_form(data: dict):
    return {"message": f"Received: {data['data']}"}

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
    i = 0
    try:
        await websocket.accept()
        while i < 10:
            await websocket.send_text(f"Current counter: {i}")
            i += 1
            await asyncio.sleep(5)
        while True:
            data = await websocket.receive_text()
            await websocket.send_text(f"Message received: {data}")
            await websocket.send_text(f"Current counter: {i}")
            i += 1
            await asyncio.sleep(5)
            await websocket.send_text(f"Current counter: {i}")
            i += 1
    except WebSocketDisconnect:
        print("Client disconnected")
    except Exception as e:
        print(f"Error: {e}")