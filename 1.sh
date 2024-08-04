#!/bin/bash

# Direktori backup
BACKUP_DIR="/root/backup"

# Tanggal dan waktu saat ini
DATE=$(date +%Y%m%d%H%M%S)

# Deteksi versi PHP yang terinstal
PHP_VERSION=$(php -r 'echo PHP_VERSION;' | cut -d '.' -f 1,2)
PHP_FPM_INI="/etc/php/${PHP_VERSION}/fpm/php.ini"
PHP_CLI_INI="/etc/php/${PHP_VERSION}/cli/php.ini"

# Lokasi file konfigurasi Nginx
NGINX_CONF_DIR="/etc/nginx/sites-enabled"

# Lokasi script saat ini
SCRIPT_PATH=$(realpath "$0")

# Fungsi untuk melakukan backup
backup_file() {
    local file=$1
    local backup_file="${BACKUP_DIR}/$(basename ${file}).${DATE}.bak"
    if [ -f "$file" ]; then
        cp "$file" "$backup_file"
        echo "Backup $file ke $backup_file selesai."
    else
        echo "File $file tidak ditemukan."
    fi
}

# Fungsi untuk menyembunyikan versi PHP
hide_php_version() {
    local ini_file=$1
    if grep -q "^expose_php" "$ini_file"; then
        sed -i "s/^expose_php.*/expose_php = Off/" "$ini_file"
    else
        echo "expose_php = Off" >> "$ini_file"
    fi
    echo "Versi PHP disembunyikan pada $ini_file."
}

# Fungsi untuk menyembunyikan versi Nginx pada semua file konfigurasi di /etc/nginx/sites-enabled/*.conf
hide_nginx_version() {
    for conf_file in $NGINX_CONF_DIR/*.conf; do
        if grep -q "server_tokens" "$conf_file"; then
            sed -i "s/server_tokens.*/server_tokens off;/" "$conf_file"
        else
            sed -i "/server {/a \\\tserver_tokens off;" "$conf_file"
        fi
        echo "Versi Nginx disembunyikan pada $conf_file."
    done
}

# Membuat direktori backup jika belum ada
mkdir -p "$BACKUP_DIR"

# Melakukan backup file konfigurasi PHP
backup_file "$PHP_FPM_INI"
backup_file "$PHP_CLI_INI"

# Melakukan backup semua file konfigurasi Nginx
for conf_file in $NGINX_CONF_DIR/*.conf; do
    backup_file "$conf_file"
done

# Backup script itu sendiri
backup_file "$SCRIPT_PATH"

# Menyembunyikan versi PHP
hide_php_version "$PHP_FPM_INI"
hide_php_version "$PHP_CLI_INI"

# Menyembunyikan versi Nginx
hide_nginx_version

# Me-restart layanan untuk menerapkan perubahan
sudo systemctl restart php${PHP_VERSION}-fpm
sudo systemctl restart nginx

echo "Proses selesai by Sincan2."
