#!/bin/bash

# 1. Cargar variables de entorno
if [ ! -f .env ]; then
    echo "❌ Error: Archivo .env no encontrado."
    exit 1
fi
source .env

echo "🔍 Verificando estado de los contenedores..."

# 2. Si hay algo corriendo, le hacemos down para limpiar el estado
if [ "$(docker compose ps --quiet)" ]; then
    echo "🛑 Detectados contenedores activos. Realizando apagado limpio..."
    docker compose down --remove-orphans
fi

# 3. Limpieza de archivos temporales/sensibles para regeneración
echo "🧹 Limpiando archivos de configuración específicos..."
# Usamos rutas relativas ./config para que el repo sea portátil
sudo rm -f ./config/web/config.js
sudo rm -rf ./config/prosody/conf.d/*
sudo rm -f ./config/jicofo/*.conf
sudo rm -rf ./config/jibri/*

# 4. Re-inyectar configuración del Recorder (Asegura que Prosody siempre cargue el host)
echo "📝 Configurando VirtualHost del Recorder..."
mkdir -p ./config/prosody/conf.d
cat <<EOF | sudo tee ./config/prosody/conf.d/recorder.meet.jitsi.cfg.lua > /dev/null
VirtualHost "recorder.meet.jitsi"
    modules_enabled = { "ping"; }
    authentication = "internal_plain"
EOF

# 5. Ajustar permisos
sudo chown -R 1000:1000 ./config/

# 6. Levantar servicios
echo "🚀 Levantando contenedores en segundo plano..."
docker compose up -d

# 7. Verificación de salud y registro del Recorder
echo "⏳ Esperando a que Prosody esté listo (20s)..."
sleep 20

# Intentamos el registro (si ya existe, Prosody simplemente ignorará el comando)
echo "👤 Verificando registro del usuario recorder..."
PROSODY_CONTAINER=$(docker ps -qf "name=prosody")

if [ -z "$PROSODY_CONTAINER" ]; then
    echo "❌ Error: El contenedor de Prosody no arrancó correctamente."
    docker compose logs prosody
    exit 1
fi

docker exec $PROSODY_CONTAINER prosodyctl --config /config/prosody.cfg.lua register $JIBRI_RECORDER_USER $XMPP_RECORDER_DOMAIN $JIBRI_RECORDER_PASSWORD

echo "✅ Jitsi Meet está arriba. Transmisión configurada en $PUBLIC_URL"