# **Pour Démarrage de l'Application Mobile Multivisio**

-Les vidéos nécessaires sont déjà présentes dans le dossier du projet.

**Attention** : Le PC et la tablette Android doivent être connectés au même réseau Wi-Fi.

**Configuration réseau**

-Récupérer l'adresse IP du PC : Ouvrir un terminal ou invite de commande sur le PC.
Exécuter la commande :  ipconfig + Repérer l'adresse IPv4 correspondant à votre connexion réseau.

**Configurer l'adresse IP dans le projet :**

Modifier l'IP dans le fichier :

app_multivisio/android/app/src/main/res/xml/network_security_config.xml

Mettre à jour également l'IP dans les fichiers suivants du backend :
  fastapi_app.py
  detector.py
  websocket_service.py
  api_service.py

**Lancement de l'application**

  **Côté Backend (PC)**:
     Dans le dossier app_multivisio/backend, lancer le serveur FastAPI :
     
          uvicorn fastapi_app:app --host 0.0.0.0 --port 8000 --reload
          
          python detector.py
   
  **Côté Frontend (Tablette Android)**:
      Dans le dossier app_multivisio, préparer le projet Flutter :
      
          flutter clean
          
          flutter pub get

  **Détecter l'identifiant de votre tablette :**

         flutter devices (Repérez l'ID de votre tablette, par exemple R92X30BQ11D.)

**Lancer l'application sur la tablette :**

         flutter run -d R92X30BQ11D


Assurez-vous que :

La tablette est bien connectée au même réseau que le PC.

Les autorisations USB sont acceptées.

La tablette est détectée correctement par flutter devices.

**🔧 À installer sur le PC (backend) :**

Python 3.9+

pip (gestionnaire de paquets Python)

FastAPI :pip install fastapi

Uvicorn (serveur ASGI) :pip install uvicorn

WebSockets & HTTP client  :pip install websockets requests


**🔧 À installer pour le Frontend (Flutter) :**

Flutter SDK : https://docs.flutter.dev/get-started/install

Assurez-vous que la tablette Android est bien connectée et que le mode développeur + débogage USB sont activés.




