import asyncio
import websockets
import json
from datetime import datetime

async def send_alerts():
    uri = "ws://192.168.229.133:8000/ws/alerts"  # Mets ici l’IP locale exacte
    async with websockets.connect(uri) as websocket:

        scenario = [
            # CAM 1 - Abandon et récupération
            {
                "title": "Abandon détecté",
                "details": "Personne (1) a quitté la zone sans bagage (1)",
                "camera_id": 1,
                "person_id": 1,
                "baggage_id": 1
            },
            {
                "title": "Bagage abandonné",
                "details": "Bagage (1) détecté seul dans Zone A",
                "camera_id": 1,
                "person_id": 1,
                "baggage_id": 1
            },
            {
                "title": "Récupération confirmée",
                "details": "Personne (1) a récupéré son bagage (1)",
                "camera_id": 1,
                "person_id": 1,
                "baggage_id": 1
            },

            # CAM 2 - Stationnement et abandon
            {
                "title": "Présence inhabituelle",
                "details": "Personne (2) reste immobile depuis 30s dans Zone C",
                "camera_id": 2,
                "person_id": 2,
                "baggage_id": 2
            },
            {
                "title": "Bagage abandonné",
                "details": "Bagage (2) détecté seul dans Zone C",
                "camera_id": 2,
                "person_id": 2,
                "baggage_id": 2
            }
        ]

        i = 0
        while True:
            alert = scenario[i % len(scenario)].copy()
            alert["date"] = datetime.now().strftime("%Y-%m-%d")
            alert["time"] = datetime.now().strftime("%H:%M:%S")

            await websocket.send(json.dumps(alert))
            print(f"✅ Envoyé ({alert['camera_id']}): {alert['title']}")

            await asyncio.sleep(5)
            i += 1

if __name__ == "__main__":
    asyncio.run(send_alerts())

