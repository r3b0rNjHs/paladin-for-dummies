# Cómo probar Paladin for Dummies en el juego

## Instalación (una vez)
1. `git pull` en `C:\dev\paladin-for-dummies`.
2. Enlace en AddOns (PowerShell; ajusta la ruta del juego):
   `New-Item -ItemType Junction -Path "D:\World of Warcraft\_forever_\Interface\AddOns\PaladinForDummies" -Target "C:\dev\paladin-for-dummies\addons\PaladinForDummies"`
3. En la pantalla de personajes, botón AddOns: activa **Paladin for Dummies**. PalaProbe puede seguir activo.

Cada vez que haya cambios: `git pull` y `/reload`.

## Comandos
- `/pfd debug`: lo que ve el addon (spec y de dónde la saca, nivel, contenido, sellos conocidos, objetivo) y la recomendación.
- `/pfd spec ret | prot | holy | auto`: fija la spec a mano si la detección automática no funciona.
- `/pfd show | hide | reset`: mostrar, ocultar o recolocar la ventana. Se mueve arrastrando los iconos.

## Pruebas de la v0.1.1
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
