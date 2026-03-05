#!/bin/bash

# Comprobamos si se ha pasado un nombre de dominio como argumento
if [ -z "$1" ]; then
    echo "Uso: sudo ./EliminarDominios.sh nombre_del_dominio"
    exit 1
fi

DOMINIO=$1

# Comprobamos si somos root
if [ "$EUID" -ne 0 ]; then 
  echo "Por favor, corre el script con sudo."
  exit
fi

echo "--- Iniciando desmantelamiento de: $DOMINIO ---"

# 1. Desactivar el sitio (borrar el enlace simbólico)
if [ -L "/etc/nginx/sites-enabled/$DOMINIO" ]; then
    rm "/etc/nginx/sites-enabled/$DOMINIO"
    echo "[OK] Enlace en sites-enabled eliminado."
fi

# 2. Borrar la configuración
if [ -f "/etc/nginx/sites-available/$DOMINIO" ]; then
    rm "/etc/nginx/sites-available/$DOMINIO"
    echo "[OK] Archivo de configuración en sites-available eliminado."
fi

# 3. Borrar los archivos web (¡CUIDADO AQUÍ!)
if [ -d "/var/www/$DOMINIO" ]; then
    # En Accenture, a veces se hace un backup antes de borrar
    # tar -czf "/root/backups/OLD_$DOMINIO.tar.gz" "/var/www/$DOMINIO"
    rm -rf "/var/www/$DOMINIO"
    echo "[OK] Carpeta /var/www/$DOMINIO eliminada."
fi

# 4. Limpiar los logs
# No queremos que ocupen espacio si la web ya no existe
rm -f /var/log/nginx/${DOMINIO}_access.log
rm -f /var/log/nginx/${DOMINIO}_error.log
echo "[OK] Logs eliminados."

# 5. Quitar del archivo /etc/hosts
sed -i "/$DOMINIO.com/d" /etc/hosts
echo "[OK] Entrada eliminada de /etc/hosts."

# 6. Reiniciar Nginx para aplicar cambios
echo "Reiniciando Nginx..."
nginx -t && systemctl restart nginx

echo "--- Dominio $DOMINIO eliminado correctamente ---"
