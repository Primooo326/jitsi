#!/bin/bash

echo "🏗️  Iniciando preparación del entorno Jitsi..."

# 1. Verificar dependencias del sistema (Modulo de audio para Jibri)
if ! lsmod | grep -q "snd_aloop"; then
    echo "🔊 Cargando módulo de audio virtual (snd-aloop)..."
    sudo modprobe snd-aloop
    echo "snd-aloop" | sudo tee -a /etc/modules
fi

# 2. Crear estructura de carpetas local
echo "📁 Creando carpetas de persistencia..."
mkdir -p ./config/web ./config/prosody/conf.d ./config/jicofo ./config/jvb ./config/jibri

# Crear config de MediaMTX si no existe
if [ ! -f ./config/mediamtx.yml ]; then
    cat > ./config/mediamtx.yml << 'EOF'
rtmp:
  servers:
    - address: :1935

hls:
  serverAddress: :8888
  muxSegments: 2

paths:
  live:
    source: publisher
EOF
fi

# 3. Verificar existencia de .env
if [ ! -f .env ]; then
    echo "⚠️  Archivo .env no encontrado. Copiando desde .env.example..."
    if [ -f .env.example ]; then
        cp .env.example .env
        echo "✅ .env creado. ¡POR FAVOR EDÍTALO ANTES DE CONTINUAR!"
        exit 0
    else
        echo "❌ Error: No existe .env ni .env.example"
        exit 1
    fi
fi

# 4. Delegar el arranque al script de start
echo "➡️  Pasando al proceso de arranque..."
chmod +x start.sh
./start.sh