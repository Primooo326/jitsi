# Jitsi Meet Deployment (Docker)

Este proyecto contiene los archivos necesarios para desplegar una instancia de **Jitsi Meet** utilizando Docker, con soporte integrado para **Jibri** (grabación y retransmisión).

## 📁 Estructura del Proyecto

- `docker-compose.yml`: Define los servicios de Jitsi (Web, Prosody, Jicofo, JVB, Jibri).
- `.env`: Variables de entorno para la configuración de red, dominio, certificados de Let's Encrypt y claves de comunicación interna.
- `install.sh`: Script de instalación para preparar el entorno (Docker, dependencias y carpetas de configuración).
- `restart.sh`: Script para reiniciar los servicios y depurar/regenerar archivos de configuración de manera limpia.

## 📋 Requisitos Previos

- Sistema operativo Linux (preferiblemente Ubuntu/Debian).
- Privilegios de superusuario (`sudo/root`) para instalar dependencias y crear configuraciones.
- Los puertos `8181` (o el que se configure en `.env`), `8443` y `10000/udp` deberán estar accesibles.

## 🚀 Instalación y Despliegue

### 1. Configurar Entorno
Revisa y ajusta el archivo `.env` según tus necesidades antes de comenzar.
Asegúrate de cambiar los dominios (`PUBLIC_URL`, `LETSENCRYPT_DOMAIN`, etc.), correos, contraseñas e IPs correctas.

### 2. Ejecutar Script de Instalación
Este paso instalará el módulo de loopback de audio `snd-aloop` (requerido por Jibri), instalará Docker/Docker Compose y creará los directorios de configuración en `~/.jitsi-meet-cfg/`.

```bash
chmod +x install.sh
./install.sh
```

### 3. Levantar los Servicios
Después de que se complete la preparación, puedes inicializar Jitsi levantando los contenedores:

```bash
docker compose up -d
```
> *Nota: Según indica el script de instalación, si se requiere instanciar configuraciones extra para Jibri, se usaría un comando combinado, pero por defecto el archivo docker-compose suministrado incluye a Jibri.*

## 🔄 Mantenimiento y Reinicio

Si cambias la configuración en el `.env` o necesitas regenerar de forma limpia las carpetas de componentes (como Web, Prosody o Jicofo), utiliza el script de reinicio:

```bash
chmod +x restart.sh
./restart.sh
```

Esto bajará los contenedores temporalmente, limpiará configuraciones específicas en `~/.jitsi-meet-cfg` y los volverá a levantar en segundo plano.

## 📹 Notas sobre Jibri (Grabación/Streaming)

Este entorno ya tiene configurado un contenedor `jibri` en `docker-compose.yml`. Las credenciales y variables de su comportamiento se definen en el archivo `.env` bajo la sección *"Configuración de Jibri (Streaming)"*. Para que funcione correctamente, debe permanecer cargado el módulo `snd-aloop` implementado durante el `install.sh`.
