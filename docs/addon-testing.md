# Cómo probar Paladin for Dummies en el juego

## Instalación (una vez)
1. `git pull` en `C:\dev\paladin-for-dummies`.
2. Enlace en AddOns (PowerShell; ajusta la ruta del juego):
   `New-Item -ItemType Junction -Path "D:\World of Warcraft\_forever_\Interface\AddOns\PaladinForDummies" -Target "C:\dev\paladin-for-dummies\addons\PaladinForDummies"`
3. En la pantalla de personajes, botón AddOns: activa **Paladin for Dummies**. PalaProbe puede seguir activo.

Cada vez que haya cambios: `git pull` y `/reload`.

## Comandos
- `/pfd stats`: estadísticas de tus peleas por sello inicial y activaciones de Command por minuto. `/pfd last`: la última pelea. `/pfd quiet`: activa o desactiva el resumen tras cada pelea. `/pfd resetstats`: borra las peleas guardadas.
- `/pfd ui`: estado de la ventana (si está visible, dónde y qué iconos tiene).
- `/pfd debug`: lo que ve el addon (spec y de dónde la saca, nivel, contenido, sellos conocidos, objetivo) y la recomendación.
- `/pfd spec ret | prot | holy | auto`: fija la spec a mano si la detección automática no funciona.
- `/pfd show | hide | reset`: mostrar, ocultar o recolocar la ventana. Se mueve arrastrando los iconos.

## Pruebas de la v0.2.0 (repaso tras el combate)
1. `/pfd debug`: nueva línea "Arma: velocidad …, daño …-… | poder con hechizos …". ¿Salen números o `<secret>`?
2. Pelea normal con Seal of Command puesto. Al acabar debe salir en el chat: "Pelea de N s con Seal of Command | Sentencias: … | Holy Strike: … | activaciones de Command: …". ¿Cuadran los números con lo que hiciste?
3. Haz 5-10 peleas, alguna empezando con otro sello, y `/pfd stats`.
4. `/reload` y `/pfd stats` otra vez: las peleas siguen guardadas.
5. Si molesta el mensaje tras cada pelea: `/pfd quiet`.

## Pruebas de la v0.1.3
1. El icono de "Sentencia" debe ser el de Judgement, con el de Seal of the Crusader en pequeño en la esquina inferior derecha.
2. Su tooltip: "Antes del pull" y tres pasos (Ponte Seal of the Crusader, Lanza Judgement sobre el objetivo, Cambia a Seal of Command para la pelea), y debajo el porqué.
3. El tooltip de "Sello" no cambia: el de Seal of Command con su porqué.

## Pruebas de la v0.1.2 (hechas)
1. Al entrar: ¿ves una ventana oscura con el título "Paladin for Dummies" y dos iconos, un poco por debajo del centro de la pantalla?
2. Escribe `/pfd ui` y haz captura (tanto si la ves como si no).
3. Si no la ves: `/pfd reset`, `/pfd show` y otra vez `/pfd ui`.
4. Si la ves: pasa el ratón por cada icono y comprueba que sale el tooltip con el porqué; arrástrala a otro sitio, haz `/reload` y comprueba que se queda donde la dejaste.

## Pruebas de la v0.1.1 (hechas)
1. `/pfd spec auto` (quita la spec fijada a mano) y `/pfd debug`: la spec debe salir `retribution (fuente: specialization)`.
2. En mundo abierto, marca un enemigo y `/pfd debug`: apunta el "tipo".
3. Dentro de una mazmorra, marca un enemigo **fuera de combate** y `/pfd debug`: ¿el tipo sale como número, `nil` o `<secret>`? Repite con dos o tres bichos distintos.

## Pruebas de la v0.1.0 (hechas)
1. Al entrar: ¿aparece una ventana con dos iconos, "Sello" y "Sentencia"?
2. `/pfd debug` sin objetivo. Apunta la línea de "Spec" (sobre todo la **fuente**).
3. Marca un enemigo no muerto o bestia y pasa el ratón por los iconos. Esperado con tu Ret 40: **Seal of Command** y **Seal of the Crusader**, con su porqué en el tooltip.
4. Marca a un aliado: la recomendación no debe depender de él (`/pfd debug` dice "ninguno atacable").
5. Pelea: al entrar en combate sale "en combate" y los iconos no cambian aunque cambies de objetivo. Al salir se recalcula.
6. Si la spec sale `nil`: `/pfd spec ret` y repite el paso 3.

Trae: capturas de `/pfd debug` (pasos 2 y 4), si los iconos son los esperados y cualquier error de Lua.
