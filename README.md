# 🚀 Script de Automatización de Dominios en Nginx

A menudo, el Administrador de Sistemas recibe solicitudes para desplegar webs temporales, para ello es necesaria la creación de dominios en Nginx y su configuración. Sin embargo, un Administrador de Sistemas debe ser capaz de automatizar este proceso para no perder el tiempo. 

En este script se automatiza la creación de estructuras de directorios, así como la generación del contenido web, la configuracion del Virtual Hosts, su activación y borrado completo del dominio cuando ya no es necesario.

Es importante tener en cuenta que este script está diseñado principalmente para un HomeLab, simulando como lo haría en un lugar de trabajo real, pero no es adecuado para usar en un entorno profesional real. Esto debido a diferencias en los puertos, directorios y en la seguridad.

---

## Requisitos Previos

Antes de ejecutar los scripts, asegúrate de cumplir con los siguientes requisitos:

1. Se deben tener las herramientas de `sed` y `tar` instaladas en nuestro equipo.
```bash
sudo apt update && sudo apt install build-essential curl -y
```
2. Ambos scripts requieren permisos de superusuario `sudo` para modificar archivos en los directorios `/etc/nginx/` y `/var/www`.

3. En el mismo directorio donde se ubiquen los scripts, deben estar los archivos `dominios.csv`, `IP.csv` y `web.html` para su correcto funcionamiento.

---

## 📖 Instrucciones

### 1. Crear los archivos de configuración
Primero, necesitaremos crear tres archivos clave que van a ser usados como variables para los scripts:

* **`dominios.csv`**: Debe contener el nombre que queremos poner a los dominios.

* **`web.html`**: Debe tener el contenido que queremos que se vea al abrir la web. Dentro del HTML escribiremos la palabra REEMPLAZO donde queramos que aparezca el nombre del dominio. El comando `sed` cambiará esa palabra por el nombre real de cada dominio automáticamente.

* **`IP.csv`**: Debe contener la IP de nuestro equipo local para que sea archivada en el directorio `/etc/hosts`. Así, al buscar el nombre de nuestro dominio, nos redirigirá correctamente hacia él.

### 2. Asignar permisos de ejecución
Hay que darle permisos a los scripts con el comando `chmod +x` para que estos puedan ser ejecutados por el sistema. 

Ejemplo de cómo aplicar los permisos a ambos scripts:
```bash
chmod +x CrearDominios.sh EliminarDominios.sh
```

Para ejecutarlos será necesario el permiso de superusuario `sudo`.
```bash
sudo ./CrearDominios.sh
```

```bash
sudo ./EliminarDominios.sh
```

¡Y todo listo! Ahora serás capaz de automatizar la creación de servidores en Nginx en tu laboratorio para tus prácticas personales.

Los scripts están diseñados para que, si se ejecutan dos veces, no creen conflictos ni dupliquen líneas en el archivo `/etc/hosts`.

-----

**Este proyecto ha sido desarrollado por un estudiante de 1ºASIR que está introduciéndose en el mundo del scripting, gracias por leer :)**

