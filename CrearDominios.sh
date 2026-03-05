#!/bin/bash

# --- VARIABLES ---
DOMINIOS_FILE="dominios.csv"
IP_FILE="IP.csv"
WEB_TEMPLATE="web.html"  # Usaremos este como base
IP_SERVIDOR=$(cat $IP_FILE) # Lee la IP del archivo

# Comprobamos si somos root (necesario para tocar /etc y /var/www)
if [ "$EUID" -ne 0 ]; then 
  echo "Por favor, corre el script con sudo."
  exit
fi

echo "--- Iniciando creación masiva de dominios ---"

# --- BUCLE DE CREACIÓN ---
# Leemos el archivo de dominios línea por línea
while IFS= read -r DOMINIO || [ -n "$DOMINIO" ]; do
    echo "Configurando: $DOMINIO..."

    # 1. Crear carpeta de la web
    mkdir -p "/var/www/$DOMINIO"

    # 2. Crear el HTML (usamos el template y personalizamos el nombre)
    # Aquí 'sed' cambia la palabra 'REEMPLAZO' por el nombre del dominio
    sed "s/REEMPLAZO/$DOMINIO/g" "$WEB_TEMPLATE" > "/var/www/$DOMINIO/index.html"
    chown -R www-data:www-data "/var/www/$DOMINIO"

    # 3. Crear el Virtual Host (aquí el truco de cat <<EOF sustituye a nano)
    cat <<EOF > "/etc/nginx/sites-available/$DOMINIO"
server {
    listen 80;
    server_name $DOMINIO.com www.$DOMINIO.com;

    root /var/www/$DOMINIO;
    index index.html;

    access_log /var/log/nginx/${DOMINIO}_access.log;
    error_log /var/log/nginx/${DOMINIO}_error.log;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

    # 4. Activar el sitio (crear link simbólico)
    ln -sf "/etc/nginx/sites-available/$DOMINIO" "/etc/nginx/sites-enabled/"

    # 5. Añadir al archivo /etc/hosts local para que funcione en tu PC
    # Primero borramos si ya existía para no duplicar, luego añadimos
    sed -i "/$DOMINIO.com/d" /etc/hosts
    echo "$IP_SERVIDOR $DOMINIO.com" >> /etc/hosts

done < "$DOMINIOS_FILE"

# --- FINALIZAR ---
echo "Reiniciando Nginx..."
nginx -t && systemctl restart nginx

echo "--- ¡Proceso completado! ---"
echo "Prueba a entrar en tu navegador a los dominios creados."
