¡Qué buena captura! Ver ese **"En vivo"** en YouTube después de tanto pelear con los archivos de configuración es la mejor sensación. Para que no tengas que repetir todo el proceso de memoria y puedas clonar esto en cualquier VPS en segundos, aquí tienes el `README.md` definitivo.

He incluido los "hacks" que descubrimos (el modo Kiosko para el zoom y el fix del VirtualHost de Prosody) para que el repositorio sea nivel profesional.

---

# 🎥 Jitsi Meet + Jibri: One-Click Deployment

Este proyecto permite desplegar una instancia completa de **Jitsi Meet** con capacidades de **Streaming (YouTube/Facebook/RTMP)** y **Grabación**, optimizada para servidores VPS. 

A diferencia de la instalación estándar, este repositorio incluye:
* **Modo Kiosko:** Jibri transmite solo la reunión, sin barras de direcciones ni menús de Chrome.
* **Auto-Fix de Prosody:** Configuración automática del dominio de grabación (`recorder`).
* **Aislamiento Docker:** Todo se ejecuta en contenedores, manteniendo tu sistema limpio.

---

## 🚀 Requisitos del Sistema

| Recurso | Recomendado | Mínimo |
| :--- | :--- | :--- |
| **CPU** | 4 Cores | 2 Cores |
| **RAM** | 8 GB | 4 GB (con SWAP) |
| **SO** | Ubuntu 22.04 / 24.04 | Debian 11+ |
| **Red** | Puertos 80, 443, 10000/udp abiertos | - |

---

## 📁 Estructura del Proyecto

* `docker-compose.yml`: Orquestación de los 5 microservicios (Web, Prosody, Jicofo, JVB, Jibri).
* `.env`: Configuración de dominios, SSL y credenciales.
* `setup.sh`: Script inteligente que prepara carpetas, permisos y módulos de audio.
* `config/`: Carpeta (generada) que contiene la persistencia de datos.

---

## 🛠️ Instalación Paso a Paso

### 1. Clonar y Preparar
```bash
git clone <tu-repositorio>
cd jitsi-streaming-server
cp .env.example .env
```

### 2. Configurar el `.env`
Edita el archivo `.env` y asegúrate de cambiar:
* `PUBLIC_URL`: Tu dominio (ej. `https://jitsi.midominio.com`).
* `JIBRI_RECORDER_PASSWORD`: Una clave segura.
* **TIP (Zoom en Transmisión):** Asegúrate de que `JIBRI_CHROMIUM_FLAGS` incluya `--kiosk` para que la transmisión se vea a pantalla completa.

### 3. Ejecutar el Instalador
El script `setup.sh` hará el trabajo sucio (instalar Docker, cargar el módulo de audio virtual `snd-aloop` y configurar Prosody):
```bash
chmod +x setup.sh
./setup.sh
```

---

## 📹 Cómo Iniciar una Transmisión

1.  Accede a tu dominio y crea una sala.
2.  Ve a **Más acciones (los tres puntos)** > **Iniciar transmisión en vivo**.
3.  Pega tu **Clave de transmisión** de YouTube/Twitch.
4.  Jibri entrará a la sala como un usuario invisible llamado `recorder` y empezará a enviar el video.

---

## 🔍 Solución de Problemas (Debug)

### El botón de "Grabar/Transmitir" no aparece
Esto suele ser un error de comunicación interna. Verifica que el usuario recorder exista:
```bash
docker exec jitsi-streaming-server-prosody-1 prosodyctl --config /config/prosody.cfg.lua register recorder recorder.meet.jitsi <tu_password>
```

### La transmisión se ve con bordes negros
Jibri captura a **1280x720** por defecto. Si quieres cambiar la calidad, ajusta las variables de resolución en el contenedor de Jibri dentro del `docker-compose.yml`.

### Ver logs en tiempo real
* **General:** `docker compose logs -f`
* **Solo Jibri (Captura de video):** `docker logs -f jitsi-streaming-server-jibri-1`

---

## 🛡️ Seguridad
* El tráfico está cifrado vía **Let's Encrypt** (auto-renovable).
* Se recomienda configurar `AUTH_TYPE=internal` en el `.env` si no quieres que cualquier persona pueda crear salas en tu servidor.

---

> **Nota:** Este despliegue utiliza el modo "Host Gateway" para que Jibri pueda resolver dominios locales, evitando problemas comunes de red en VPS como AWS o Google Cloud.

---