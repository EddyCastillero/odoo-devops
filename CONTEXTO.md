# CONTEXTO.md — Proyecto odoo-devops (handoff de conversación)

> Documento de contexto para retomar el proyecto con cualquier asistente (o humano).
> Última actualización: 2026-07-12

## Quién soy y mi objetivo

- Leonel, dev **junior** en una startup mexicana (empresa de servicios para aduanas / comercio exterior).
- En la chamba todo es "vibe coding" con AI, sin análisis ni reglas de negocio — quiero lo contrario: aprender de verdad.
- Meta profesional: **DevOps/Cloud engineer**, con proficiencia demostrable en **Odoo** (estoy en un proyecto Odoo en la chamba).
- Método acordado: **20% teoría justo-a-tiempo, 80% manos en el teclado.** El asistente NO me da código masticado: me da esqueletos, preguntas guía y pistas; yo armo los comandos. Cuando algo truena: leer logs → diagnosticar → luego preguntar. Errores = aprendizaje.
- Llevo un **NOTES.md** en el repo con formato: síntoma → diagnóstico → causa → fix, por fecha.

## El proyecto

**Repo:** `odoo-devops` en GitHub (cuenta personal EddyCastillero, público, MIT). Local: `~/Desktop/odoo-devops`. Rama de trabajo: `dev`.

**Stack actual (docker compose, 3 servicios):**
- `db`: postgres:18 — volumen `./postgresql`, credenciales odoo/odoo19, POSTGRES_DB=postgres
- `odoo19`: odoo:19 — **sin `user:` (corre como usuario odoo, uid=100 gid=101)**, sin puertos expuestos, config en `./etc/odoo.conf` (config as code), volumen `./odoo-data`
- `web-server`: nginx:alpine — **único punto de entrada**, puerto `8080:80`, config en `./nginx/nginx.conf` (reverse proxy con proxy_pass a odoo19:8069)

**Datos importantes:**
- BD de Odoo: **LeonelProyecto** (Postgres es case-sensitive con esto)
- Master password de Odoo: **admin1** (vive en etc/odoo.conf → admin_passwd; Odoo lo hashea/reescribe solo; para resetear: texto plano + `docker compose restart odoo19`)
- El filestore vive en `odoo-data/.local/share/Odoo/filestore/` (ruta anidada porque el home del usuario odoo cae dentro del volumen; pendiente opcional: fijar `data_dir` en odoo.conf en la próxima recreación de BD)
- `backup.sh` en la raíz del repo: pg_dump + tar del filestore vía docker exec (patrón "tubo": comando adentro escupe, `>` afuera captura), timestamps, rotación con `find -mtime +7 -delete`, `cd "$(dirname "$0")"` para ser a-prueba-de-cron
- **Cron activo**: backup diario 2:30 AM, log en `backups/backup.log` (limitación conocida: solo si la laptop está prendida; se resuelve en la fase de VPS)
- `.gitignore` cubre: .env, backups/, odoo-data/, postgresql/, venvs, __pycache__, .vscode/

## Fases del roadmap

- ✅ **Fase 1 — Dockerización**: Odoo+Postgres, volúmenes, config as code
- ✅ **Fase 2 — Nginx reverse proxy**: single point of entry, Odoo y Postgres sin puertos al host
- ✅ **Fase 3 — Backups**: script + rotación + cron + **restauración probada** (CREATE DATABASE + `psql < dump` + tar -x + mv renombrando la carpeta del filestore al nombre de la BD nueva)
- 🔜 **Fase 4 — Módulo custom Odoo (EN CURSO, etapa de análisis)**
- Fase 5 — CI con GitHub Actions (lint pylint-odoo/flake8 + tests del módulo)
- Fase 6 — Deploy a VPS (créditos DigitalOcean del GitHub Student Pack) + dominio + HTTPS Let's Encrypt
- Fase 7 — CD (push a main → deploy automático)
- Fase 8 — Observabilidad (Uptime Kuma o Prometheus+Grafana)
- Fase 9 (opcional) — Terraform y/o k3s

## Fase 4: módulo custom — estado actual

**Idea elegida:** módulo de **operaciones aduanales** — reemplazar el Excel gigante donde la operadora captura todo (pedimento, BL, PIS, puerto inteligente SAT, contenedores). Alcance v1: captura manual pero estructurada y filtrada por operación. Automatizaciones (n8n, etc.) = backlog futuro.

**Decisiones de diseño ya tomadas:**
- La **operación** es el modelo central (el "número de operación amarra todo")
- Una operación → N contenedores (One2many) y → N documentos (One2many)
- Documentos como modelo propio (`tipo, número, fecha, archivo Binary`) + adjuntos core `ir.attachment` (NO se necesita el módulo Documents de Enterprise)
- Cliente = **Many2one a `res.partner`** (modelo core; nunca duplicar clientes — el "módulo Clientes" de la empresa es solo una vista custom sobre res.partner)
- Todo el proyecto cabe en **Community**; única limitante futura identificada: timbrado CFDI (requiere módulos de terceros + PAC, o Enterprise)

**TAREA PENDIENTE INMEDIATA (mi entregable):** análisis de espionaje en el staging Enterprise de mi empresa (con modo debug activado) sobre su módulo "Operaciones":
1. Lista de campos con nombres técnicos y tipos (¿y se usan? ojo crítico)
2. Desconexiones detectadas ("nada conecta con nada" → lista concreta)
3. Ciclo de vida de una operación (4-5 estados razonados o preguntados)
4. 3-5 "reglas escondidas" (reglas de negocio no documentadas, formato "no se puede ___ si ___")
5. Roles (escritura / lectura / aprueba)
⚠️ Solo estructura, NUNCA datos reales de clientes.

Con ese análisis, el siguiente paso es **dibujar los modelos** (entidades, campos, relaciones, estados) antes de tocar código.

## Aprendizaje en paralelo (acordado)

- OOP y Python los aprendo DENTRO del módulo (regla: no copiar ninguna línea que no pueda explicar; el asistente señala conceptos al aparecer: clases, herencia, decoradores @api, dicts, etc.)
- Exercism (track Python) 2-3 veces/semana para basics puros
- DSA en pausa consciente hasta modo-entrevista
- System design se aprende con el proyecto mismo

## Setup de mi máquina (por si es relevante)

- Ubuntu 24, VS Code/Cursor, Docker Compose v2
- Git: global = identidad de empresa (leonel@cipreholding.com); repo odoo-devops tiene config LOCAL personal (leonelcastillero98@gmail.com, nombre "Leonel Castillero")
- SSH: dos llaves — `id_ed25519` (empresa, host github.com) y `id_ed25519_personal` (alias `github-personal` en ~/.ssh/config). Repos personales se clonan con `git@github-personal:...`
- GitHub personal: EddyCastillero, con Student Developer Pack (correo de la uni como secundario; primario pendiente de cambiar a Gmail 👀)

## Estilo de la conversación

Me dice "bro", tono relajado mexicano, celebra los logros, pero es exigente: no acepta que copie sin entender, me deja tareas, me persigue con los pendientes (ej: me repitió 5 veces lo del `cd dirname` hasta que lo puse 😂), y convierte cada error en clase. Mantener ese formato.
