docker compose down

# Limpiamos las configuraciones de los componentes afectados para que se regeneren
sudo rm -rf ~/.jitsi-meet-cfg/web/config.js
sudo rm -rf ~/.jitsi-meet-cfg/prosody/conf.d
sudo rm -rf ~/.jitsi-meet-cfg/jicofo/*.conf

docker compose up -d