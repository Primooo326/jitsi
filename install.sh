#!/bin/bash
echo "--- Configurando Audio Virtual para Jibri ---"
sudo modprobe snd-aloop
echo "snd-aloop" | sudo tee -a /etc/modules

echo "--- Instalando dependencias (Docker) ---"
sudo apt update
sudo apt install -y docker.io docker-compose-v2

echo "--- Creando carpetas de configuración ---"
mkdir -p ~/.jitsi-meet-cfg/{web,transcripts,prosody/config,prosody/prosody-plugins-custom,jicofo,jvb,jibri}

echo "--- Listo! Ahora puedes ejecutar: docker compose -f docker-compose.yml -f jibri.yml up -d ---"