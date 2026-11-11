# Protocolo de prueba de PalaProbe

## Instalación
1. Copia la carpeta `addons/PalaProbe` en `World of Warcraft\_forever_\Interface\AddOns\PalaProbe`.
   Para no copiarla en cada cambio, crea un enlace simbólico (en Windows, desde una consola de administrador):
   `mklink /D "C:\...\World of Warcraft\_forever_\Interface\AddOns\PalaProbe" "C:\ruta\al\repo\addons\PalaProbe"`
2. En la pantalla de personajes, botón AddOns: activa PalaProbe. Si sale "desactualizado", haz `/dump select(4, GetBuildInfo())` en el juego y pon ese número en el `.toc`.
3. Entra con el paladín. Debería salir un mensaje de PalaProbe en el chat con la versión del cliente y las APIs que no existen.

## Pruebas (unos 15 minutos)
1. **Grimorio:** `/pp dump`. Si dice que hay hechizos sin descripción, espera 5 s y repítelo.
2. **Objetivo fuera de combate:** marca un enemigo (sin atacarlo) y haz `/pp snap`. Repite con un humanoide, una bestia y un no muerto si puedes.
3. **Combate:** ten un sello activo, marca un enemigo y pelea. El addon guarda instantáneas solo al empezar, a los 1,5 s, al cambiar de objetivo y al terminar. Lanza un par de sellos y una Sentencia durante la pelea.
4. **Pruebas sueltas fuera de combate:**
   - `/pp curve` (¿existe la función de curvas?)
   - `/pp waypoint` (¿aparece el marcador en el mundo? ¿sale "Acción BLOQUEADA"?)
   - `/pp comm` (solo, en grupo fuera de una instancia y, si puedes, en grupo dentro de una mazmorra)
5. **Si entras en una mazmorra con jefe:** pelea contra el jefe y fíjate si sale "ENCOUNTER_START recibido".
6. `/pp report` y copia lo que salga en el chat.
7. `/reload` para que se escriba el archivo.

## Qué traer de vuelta a Claude Code
- La salida de `/pp report`.
- El archivo `WTF\Account\<CUENTA>\SavedVariables\PalaProbe.lua`. Cópialo a `docs/probe-results/` dentro del repo y dile a Claude que lo analice.
- Cualquier error de Lua que aparezca. Recomendado: instalar BugSack + BugGrabber si tienen versión para Forever.
