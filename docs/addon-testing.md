# Cómo probar Paladin for Dummies en el juego

## Instalación (una vez)
1. `git pull` en `C:\dev\paladin-for-dummies`.
2. Enlace en AddOns (PowerShell; ajusta la ruta del juego):
   `New-Item -ItemType Junction -Path "D:\World of Warcraft\_forever_\Interface\AddOns\PaladinForDummies" -Target "C:\dev\paladin-for-dummies\addons\PaladinForDummies"`
3. En la pantalla de personajes, botón AddOns: activa **Paladin for Dummies**. PalaProbe puede seguir activo.

Cada vez que haya cambios: `git pull` y `/reload`. **Si la versión añade archivos nuevos** (aparecen como nuevos en el `git pull`), **cierra el juego y vuelve a abrirlo**: WoW solo lee la lista de archivos de un addon al arrancar, y `/reload` no ve los nuevos. Para ver qué versión está cargada: `/dump C_AddOns.GetAddOnMetadata("PaladinForDummies", "Version")`.

## Comandos
- `/pfd macros`: crea o actualiza las macros PFD Apertura, PFD Unsealed y PFD Sello (de personaje), y mantiene PFD Apertura al día con la recomendación. `/pfd macros off` deja de actualizarlas.
- `/pfd test A | B | C | off`: etiqueta las peleas siguientes con una prueba (ver el plan más abajo); `/pfd test` dice cuál está activa.
- `/pfd stats`: estadísticas de tus peleas (por prueba, por sello inicial) por sello inicial y activaciones de Command por minuto. `/pfd last`: la última pelea. `/pfd quiet`: activa o desactiva el resumen tras cada pelea. `/pfd resetstats`: borra las peleas guardadas.
- `/pfd ui`: estado de la ventana (si está visible, dónde y qué iconos tiene).
- `/pfd debug`: lo que ve el addon (spec y de dónde la saca, nivel, contenido, sellos conocidos, objetivo) y la recomendación.
- `/pfd spec ret | prot | holy | auto`: fija la spec a mano si la detección automática no funciona.
- `/pfd show | hide | reset`: mostrar, ocultar o recolocar la ventana. Se mueve arrastrando los iconos.

## Qué mandar a Claude: el archivo
Todo queda en `D:\World of Warcraft\_forever_\WTF\Account\<TU_CUENTA>\SavedVariables\PaladinForDummies.lua`:
- `snapshot`: lo mismo que `/pfd debug` (spec, arma, objetivo, qué era secret, recomendación) y las versiones del addon y del cliente;
- `errors`: los errores que haya capturado el addon, con fecha;
- `fights`: todas las peleas.

El juego solo escribe el archivo al hacer **`/reload` o al salir**. Antes de mandarlo, haz `/reload`. Para comprobar algo concreto (un objetivo, una mazmorra), ponte en esa situación, haz `/reload` allí mismo y manda el archivo. Las capturas del chat siguen valiendo para un vistazo rápido.

## Pruebas de la v0.13.0: aviso antes del pull
**Archivos nuevos y quitados: cierra el juego y vuelve a abrirlo.**
- Selecciona un enemigo **sin sello puesto**: debe salir el icono del sello en rojo con "!" latiendo. Pasa el ratón: qué hacer, pasos y porqué.
- Ponte el sello correcto: el aviso desaparece. Ponte otro sello: sale el correcto con anillo dorado.
- Quítate el aura o la bendición (clic derecho en el buff): sale su aviso.
- Contra un no-muerto o demonio en mundo abierto: consejo de Exorcism.
- En combate no se ve nada. Opciones > Aviso antes del pull > Mover para colocarlo.
- Manda el archivo de SavedVariables: `snapshot.alerts` dice qué avisos calculó.

## Pruebas de la v0.12.0: la guía pensada para quien empieza
**Archivo nuevo (`core/Guide.lua`): cierra el juego y vuelve a abrirlo.**
- Guía → **Tu plan**: pasos según lo que sabes ahora (con tu nivel), con iconos y "Lo próximo".
- Los nombres de hechizo salen como en tu juego (en español si tu cliente está en español).
- **Tus peleas**: "usas Judgement X de cada 10 veces que podrías" y un consejo.

## Pruebas de la v0.11.0: la guía
**Archivo nuevo (`data/Guide.lua`): cierra el juego y vuelve a abrirlo.**
- Opciones → AddOns → Paladin for Dummies → **Guía**: árbol de capítulos a la izquierda, texto con iconos de los sellos a la derecha.
- "Tus números" muestra tus peleas guardadas y Command por minuto.
- Tono Serio (Avanzado) oculta los chistes; Idioma cambia todo tras `/reload`.

## Pruebas de la v0.10.0: estilo nuevo y humor
**Archivos nuevos (`ui/Style.lua`, `core/HudState.lua`): cierra el juego y vuelve a abrirlo** tras el `git pull`.
- **Asesor:** ya sin fondo ni título; dos iconos con "Sello" y "Sentencia" debajo, anillo de oro en el sello. Sin objetivo se ve atenuado; con un enemigo seleccionado, entero; en combate desaparece. Opción "Cuándo se ve" en Asesor.
- **Tooltips:** "Por qué" y la confianza con un punto de color (azul = mecánica, ámbar = guías, verde = medido).
- **Unsealed Wrath:** borde fino, anillo de oro y halo que late al llegar a 3 copias (o a 1 para volver). "Reducir animaciones" en Avanzado (tras `/reload`).
- **Humor:** la bienvenida, los mensajes vacíos y algunos avisos llevan chiste. Opción Tono en Avanzado (Con humor / Serio).
- Idioma en Avanzado: los textos nuevos ya salen en inglés o español.

## Pruebas de la v0.9.0: base pública
**Archivos y librerías nuevos: cierra el juego y vuelve a abrirlo** tras el `git pull`.
- Tus datos se migran solos (ajustes al perfil, peleas al personaje). No verás la bienvenida porque ya eras usuario.
- `/pfd`: opciones (pestañas Asesor, Unsealed Wrath, Macros, Repaso, Avanzado) y el subapartado Perfiles. **Idioma**: en Avanzado; se aplica tras `/reload`.
- `/pfd help`, `/pfd stats`, `/pfd report` (informe para copiar). Los comandos de diagnóstico (`debug`, `ui`, `echodebug`, `last`, `test`, `spec`) necesitan el **modo desarrollador** (Avanzado).
- El resumen en el chat tras cada pelea está **apagado por defecto** (Repaso).
- Los errores ya no salen en el chat: van al gestor de errores (BugSack si lo tienes) y al informe. **Las acciones bloqueadas por el juego se guardan con el nombre de la función.**
- Con otra clase, el addon no hace nada.

## Pruebas de la v0.8.0: panel de opciones (fase 1)
**Archivo nuevo (`ui/Options.lua`): cierra el juego y vuelve a abrirlo** tras el `git pull`.
1. `/pfd` a secas abre el panel. También desde *Opciones → AddOns → Paladin for Dummies* y desde el menú de addons del minimapa.
2. En la lista de addons (pantalla de personajes) debe salir con su icono, en la categoría *Combate*.
3. Prueba cada opción: mostrar/ocultar y tamaño del asesor y del widget, bloquear el asesor, mover y restablecer el widget, activar o desactivar macros concretas, el resumen tras cada pelea, ver y borrar estadísticas (pide confirmación).
4. `/reload`: las opciones se mantienen.

## Pruebas de la v0.7.0: macros de utilidad
`git pull`, `/reload` y `/pfd macros`: el chat dice cuáles crea y, si alguna no, por qué (por ejemplo, un hechizo sin entrenar o que no queda hueco: máximo 18 macros de personaje).

| Macro | Qué hace | Modificador |
|---|---|---|
| PFD Cura | Flash of Light al aliado bajo el ratón, si no a tu objetivo, si no a ti | Shift: Holy Light |
| PFD Proteccion | Blessing of Protection al aliado bajo el ratón o a tu objetivo | Alt: Divine Protection |
| PFD Libertad / Manos / Purificar | Blessing of Freedom / Lay on Hands / Purify, igual que la cura | |
| PFD Martillo | Corta tu lanzamiento y aturde al enemigo bajo el ratón o a tu objetivo | |
| PFD Arrepentir | Repentance al enemigo bajo el ratón o a tu objetivo | |
| PFD Escudo | Divine Shield; pulsar otra vez te lo quita | |
| PFD Bendicion | Blessing of Might al ratón o al objetivo | Ctrl: Kings |
| PFD Auras | Devotion Aura | Ctrl: Retribution Aura |
| PFD Resucitar | Redemption al aliado muerto bajo el ratón | |
| PFD Exorcismo | Exorcism y empezar a atacar | |

Comprueba sobre todo que **las curas y bendiciones con el ratón encima de un compañero no cambian tu objetivo** (PFD Unsealed no se reinicia).

## Pruebas de la v0.6.0: sin macro de apertura
`git pull` y `/reload`. El addon ya no crea PFD Apertura: **bórrala tú** desde `/macro` (el addon no borra macros). PFD Unsealed se reescribe sola.

**Con cada enemigo:** Crusader (tu botón normal) → PFD Golpe (Judgement) → **PFD Unsealed (Command)**.
**Durante la pelea:** PFD Golpe a menudo; PFD Unsealed con "¡CAMBIA!" (Righteousness) y "¡VUELVE!" (Command).
**Enemigo nuevo:** al marcarlo, PFD Unsealed vuelve a empezar por Command.

Pega: si cambias de objetivo llevando ya Command, la primera pulsación vuelve a ponerte Command (pulsa otra vez).

## Pruebas de la v0.5.0: apertura sin secuencia y PFD Golpe
`git pull` y `/reload`: el addon reescribe las macros solo (fuera de combate). Arrastra **PFD Golpe** a tu barra.

**Antes de cada pelea:** PFD Apertura (fuera de combate: Crusader) → PFD Golpe (Judgement: atrae al enemigo) → PFD Apertura (ya en combate: Command).
**Durante la pelea:** PFD Golpe a menudo (Judgement o Holy Strike, lo que esté listo); PFD Unsealed con "¡CAMBIA!" y "¡VUELVE!".

Comprueba: que PFD Apertura no se queda nunca a medias; que PFD Golpe no deja el aviso rojo de "no está listo"; que al encadenar enemigos en combate PFD Apertura da Command.

## Pruebas de la v0.4.0: macros
1. `git pull`, `/reload` y escribe `/pfd macros`. Debe decir qué macros ha creado.
2. Abre `/macro`, pestaña de tu personaje: deben estar **PFD Apertura**, **PFD Unsealed** y **PFD Sello**. Arrástralas a tu barra.
3. **PFD Apertura:** antes de atacar, púlsala tres veces: Crusader → Judgement → Command.
4. **PFD Unsealed:** con Command puesto, púlsala cuando el widget diga "¡CAMBIA!" (Righteousness) y cuando diga "¡VUELVE!" (Command).
5. **PFD Sello:** Command; con Shift, Righteousness.
6. Marca otro tipo de enemigo: si cambia la recomendación, PFD Apertura se actualiza sola (fuera de combate).

Pega de `/castsequence`: si lanzas un sello a mano entre medias, la secuencia se desincroniza. PFD Apertura vuelve al primer paso al cambiar de objetivo, al salir de combate o tras 6 s sin pulsarla (v0.4.3); PFD Unsealed, al salir de combate.

## Pruebas de la v0.3.0: widget de Unsealed Wrath (experimental)
1. `git pull`, `/reload` y escribe `/pfd echo`. Debe decir "Widget de Unsealed Wrath activado". Si sale un error, también queda en el archivo.
2. Pelea con Seal of Command. Debajo del centro de la pantalla debe aparecer el icono de **Echo of Command** con su número de copias.
3. Con **3 copias**: ¿se enciende un brillo y aparece "¡CAMBIA!"?
4. Cambia a Righteousness y da un golpe: debe aparecer **Echo of Righteousness** con "¡VUELVE!".
5. Lo importante es que funcione **en combate**: si solo se ve fuera de combate, dímelo.
6. Haz capturas del widget en plena pelea, `/reload` y manda el archivo.

`/pfd echo` otra vez lo oculta. `/pfd echo move` lo desbloquea para arrastrarlo (y lo vuelve a fijar); `/pfd echo reset` lo devuelve a su sitio. La posición se guarda.

## Plan de pruebas de rotación (v0.2.3)
Qué queremos saber: (1) cuántas veces por minuto se activa Command en Forever, (2) Command o Righteousness con tu arma de 3,0 s, (3) si el cambio de sellos con Unsealed Wrath compensa.

**No hace falta etiquetar nada: juega normal.** Cada pelea guarda la secuencia de lo que lanzaste y el addon deduce el estilo (solo Command, solo Righteousness, Crusader y luego un sello, cambio de sellos, mezcla). `/pfd stats` agrupa por estilo y Claude analiza el archivo con la secuencia completa. Para que salgan comparaciones útiles, conviene que haya rachas de peleas con cada estilo de abajo, a ser posible contra el mismo tipo de enemigo. `/pfd test X` sigue existiendo si algún día quieres etiquetar a mano.

**Estilo A: solo Command**
- Seal of Command puesto **antes** de atacar, sin cambiarlo en toda la pelea. Sin Crusader.
- Judgement y Holy Strike en cuanto estén listos.
- Entrar a pegar enseguida: sin abrir con Exorcism a distancia y sin correr detrás.

**Estilo B: solo Righteousness**
- Igual que la A con Seal of Righteousness. **Antes entrena su rango más alto** (el 5; el 6 en el nivel 42): con el rango 1 la comparación no vale.

**Estilo C: Unsealed Wrath**
- Empieza con Command. Con 3 "Echo of Command" en tus buffs, cambia a Righteousness, da **un** golpe y vuelve a Command. Repite.
- Judgement y Holy Strike en cuanto estén listos. Si te quedas sin maná, apúntalo.

**Cuando quieras:** `/reload` y manda `PaladinForDummies.lua`.

**Comprobaciones a ojo (una vez):**
- Juzga Crusader y luego juzga con Command: ¿desaparece el icono de Crusader de los debuffs del enemigo?
- Pasa el ratón por Judgement en tu barra: ¿qué enfriamiento pone?

## Pruebas de la v0.2.1
1. Juega con normalidad (varias peleas, alguna con otro sello) y haz `/reload`.
2. Manda `PaladinForDummies.lua`.

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
