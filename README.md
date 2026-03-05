# 🚀 Nginx VirtualHost Automator: Provisioning & De-provisioning

A menudo, el administrador de sistemas recibe solicitudes para desplegar "Landing Pages" o webs temporales, para ello es necesaria la creación de dominios en Nginx y su configuración. Sin embargo, un Administrador de sistemas debe ser capaz de automatizar este proceso para no perder el tiempo. 

En este script se automatiza la creación de estructuras de directorios. Así como la generación del contenido web, la configuracion del Virtual Hosts, su activación y borrado completo del dominio cuando ya no es necesario.



Es importante tener en cuenta que este script está diseñado principalmente para un entorno de laboratorio, simulando como lo haría en un entorno de trabajo real, pero no es adecuado para usar en un entorno profesional real. Esto debido a diferencias en los puertos, directorios y en la seguridad.

---

## Requisitos Previos

Antes de ejecutar los scripts, asegúrate de cumplir con los siguientes requisitos:

1. Se deben las herramientas de `sed` y `tar` instaladas en nuestro equipo.
```bash
sudo apt update && sudo apt install build-essential curl -y
```
2. Ambos scripts requieren permisos de superusuario `sudo` para modificar archivos en los directorios `/etc/nginx/` y `/var/www`.
3. 
4. En el mismo directorio donde se ubiquen los scripts, deben estar los archivos `dominios.csv`, `IP.csv` y `web.html` para su correcto funcionamiento.

---

## Instrucciones

### 1. Crear los archivos de configuración
Primero, necesitaremos crear tres archivos clave que van a ser usados como variables para los scripts:

* **`dominios.csv`**: Debe contener el nombre que queremos poner a los dominios.
* **`web.html`**: Debe tener el contenido que queremos que se vea al abrir la web (para separarlos hay que..... no sé cómo hacerlo jajajajajjaja).
* **`IP.csv`**: Debe contener la IP de nuestro equipo local para que sea archivada en el directorio `/etc/hosts`. Así, al buscar el nombre de nuestro dominio, nos redirigirá correctamente hacia él.

### 2. Asignar permisos de ejecución
Hay que darle permisos a los scripts con el comando `chmod +x` para que estos puedan ser ejecutados por el sistema. 

Ejemplo de cómo aplicar los permisos a ambos scripts:
```bash
chmod +x CrearDominios.sh EliminarDominios.sh
```

