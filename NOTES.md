-- En este proyecto he ido aprendiendo varias cosas que voy a documentar, si me es posible incluso voy a hacerlo
por dia con la fecha y si es posible la hora

hoy 6 julio 2026 aprendi a hacer un repo desde 0 ademas de poder crear llaves SSH y diferenciarlas por perfil en mi local. Hice un repo con buenas practicas, como declarar la licencia, hacer primeros pushes

-- aprendi como hacer el .gitignore
-- hice un docker compose y aprendi lo que son los volumenes y declarar imagenes y como dependen unas con otras

8 julio 2026 -- NGINX
-como realizar un reverse proxy para solo exponer el puerto del servidor web como unico, utilice nginx y agregue la imagen y los volumenes a el .yml
-vi que en el .yml no puedes dejar llaves sueltas, quise comentar los puertos de odoo19 para que desaparezcan los puertos y todo se fuera a nginx en el reverse proxy, pero me dio error y es porque la llave ports: estaba vacia al comentar los puertos, pero se soluciono comentando tambien esa llave

##NOTA
-seguir investigando sobre proxys, puertos y docker compose

9 julio 2026 -- Creacion de backups y aprendiendo docker compose
-aprendi como ejecutar comandos de docker compose, para leer procesos dentro de la imagen, para poder ejecutar comandos propios de la imagen, etc.
# pude hacer un backup de odoo con la imagen usando docker compose exec <nombre de el servicio> <comando>

11 jul 2026 
-BASH aprendi como funcionan principalmente los comandos, es siempre (programa) - (argumento)
-Importante leer logs de errores 'tar': can't open 'tar' SI corrio pero no encontro el comando 'sudo': command not found sudo NO corrio aqui, por eso no se encontro el argumento

13 julio 2026
-Analizar antes de copiar una parte de codigo de otro repo si es que algo no entiendo por completo
-Aprendi a instalar temas en odoo y modificar el mismo
-Entender como estan echos los gitignore sin ./ porque no es una carpeta raiz, sino una carpeta dentro del repo 