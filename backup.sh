#!/bin/bash
set -e

cd "$(dirname "$0")"

FECHA=$(date +%Y-%m-%d_%H%M)

docker compose exec -T db pg_dump -U odoo LeonelProyecto > backups/dump_$FECHA.sql
docker compose exec -T odoo19 tar -czf - -C /var/lib/odoo/.local/share/Odoo filestore > backups/filestore_$FECHA.tar.gz

echo "✅ Backup completado: $FECHA"