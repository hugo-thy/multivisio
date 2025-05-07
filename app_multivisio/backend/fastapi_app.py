from fastapi import FastAPI, WebSocket
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from fastapi.staticfiles import StaticFiles
from pathlib import Path


video_path = Path(__file__).parent / "videos"

app = FastAPI()

app.mount("/videos", StaticFiles(directory="videos"), name="videos")

# Autoriser toutes les origines (comme Flask CORS)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Liste des clients WebSocket connectés
connected_clients = []

# Endpoint WebSocket pour recevoir + diffuser les alertes
@app.websocket("/ws/alerts")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    connected_clients.append(websocket)
    try:
        while True:
            data = await websocket.receive_text()
            for client in connected_clients:
                if client != websocket:
                    await client.send_text(data)
    except:
        connected_clients.remove(websocket)

# Endpoint REST pour flux vidéos
@app.get("/cctv")
def get_cctv_feeds():


    feeds = [
        {"id": 1, "feed_url": "http://192.168.229.133:8000/videos/video1.mp4"},
        {"id": 2, "feed_url": "http://192.168.229.133:8000/videos/video2.mp4"},

    ]
    return JSONResponse(content=feeds)
    # return feeds 

@app.get("/alerts")
def get_alerts():
    return [
        {
            "title": "Test Initial",
            "details": "Détection statique",
            "date": "2025-04-08",
            "time": "12:00:00",
            "person_id": 999,
            "baggage_id": 1234
        }
    ]
