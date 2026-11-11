# Investigación (11 nov 2026)

## Fuentes fiables
- Blizzard, notas de la API para autores de addons (Forever 1.60.1): https://warcraft.wiki.gg/wiki/Patch_1.60.1/API_changes/notes
  - 15 sep 2026: Forever comparte la arquitectura de UI de Mainline y la mayoría de las APIs de 12.1.5. Forever ("Camelot") y Midnight ("Standard") son dos tipos de juego de la familia Mainline. Las restricciones de Midnight, incluidos los secrets, están activas.
  - 8 oct 2026 (build 70291): `Forever` se acepta como alias de `Camelot` en los sufijos del TOC. `require` pasa a llamarse `import`. Las cuentas de prueba no pueden enviar mensajes de addon.
- Blizzard, Class Deep Dive del paladín en Forever: https://news.blizzard.com/en-us/article/24302099
- Filosofía de la "addon disarmament" en Midnight: https://news.blizzard.com/en-us/article/24246290/combat-philosophy-and-addon-disarmament-in-midnight
- API de curvas y secrets: https://warcraft.wiki.gg/wiki/API:C_CurveUtil.EvaluateColorValueFromBoolean
- Extensión de VS Code: https://github.com/ketho/vscode-wow-api

## Fuentes de la comunidad (sin verificar)
- Chuleta de la API de Forever: https://wowforeverguides.com/addons/api-cheatsheet
- Guías de sellos: ConquestCapped, Icy Veins (guía de Prot en Forever), Mobalytics (guía de Ret en Forever), ForeverChanges (grimorio), wowforever.be. Discrepan en detalles (la duración de la provocación de Fury, el efecto de Crusader).

## Competencia
- ForeCast (coach de rotación para todas las clases; predice los cooldowns a partir de tus propios lanzamientos).
- RotationPilot (siguiente hechizo y su tecla, para Forever y Midnight).
- Ninguno se centra en elegir sello y Sentencia según la situación, en coordinar Sentencias entre paladines ni en el A/B personal.

## Idea de profesiones (aparcada)
- No hay API para detectar objetos del mundo que tengas cerca. Los puntos del minimapa los dibuja el motor y un addon no puede leerlos. Se trabaja con bases de datos de puntos de aparición.
- No se puede dibujar en el espacio 3D del mundo. Opciones: una flecha en pantalla, pines en el mapa o el waypoint nativo.
- Competencia: GatherMate2, Gatherer Reforged (ya compatible con Forever), GatherLite y Waypoint Tracker (flecha).
- Por dónde diferenciarse: rutas óptimas, un planificador para subir la profesión y los datos de las zonas nuevas de Forever.

## Rotación de Retribución (investigación del 11 nov 2026)

Fuentes revisadas: notas oficiales de Blizzard (deep dive de octubre, notas del 2 nov, hotfixes del 9 y 10 nov), Maxroll (4 nov), Conquest Capped (8 nov), classicwowforever.com (8 nov), wowforeverleveling.com (5 nov), Warcraft Tavern (sin fecha, todavía con Twist of Light), LFCarry (11 nov), el simulador de foreverdb.net (build 70888) y el hilo del foro oficial "Unsealed Wrath - Implications and seal effect" (2 nov). Bloqueadas (403): Icy Veins (rotación y subida de nivel) y Mobalytics.

**Ninguna fuente aporta pruebas medidas en el juego.** Las guías son opinión o extrapolación (wowforeverleveling lo dice: la beta acababa en el nivel 30). El simulador de foreverdb marca como especulación lo que el cliente no trae.

### Hechos (Blizzard o tu cliente)
- **Twist of Light ya no existe.** Las notas del 2 nov lo eliminan; el talento de 31 puntos es **Unsealed Wrath**: tus golpes cuerpo a cuerpo guardan una copia del sello activo, hasta 3, y requiere Repentance. El sondeo 1 lo confirma: aura `Echo of Command` (1311703), **15 s, 2-3 acumulaciones**.
- **Vengeance** acumula hasta 5 y **requiere Seal of Command** (2 nov). En el sondeo: 30 s, 1-2 acumulaciones.
- **Judgement no consume el sello** (Blizzard y cliente).
- **La Sentencia de Crusader dura 40 s y la refrescan tus golpes** (texto del cliente): con un solo Judgement se mantiene toda la pelea mientras golpees.
- **Judgement de Command hace el doble contra aturdidos o incapacitados** (cliente). Hammer of Justice + Judgement es una combinación real.
- Sacred Arbiter: Holy Strike refresca todas las Sentencias del objetivo, también las de otros paladines (deep dive).
- Sanctified Judgement: hasta un 60% del coste del sello juzgado se devuelve (deep dive; pasa a la fila 2 el 2 nov).
- Improved Seal of Fury eliminado; Judgement of Fury provoca 3 s (2 nov). Swift Judgement libera el sello al instante y no comparte enfriamiento con Judgement (2 nov).
- Consecration es básica desde el nivel 20 y daña sobre todo a los 4 primeros enemigos (deep dive).
- Para el maná, Blizzard recomienda la Sentencia de Wisdom y Reverence (deep dive).
- **La tasa de activación de Seal of Command no está en el cliente: la decide el servidor** (foreverdb). Las "7 por minuto" de todas las guías son el valor de Classic, sin medir en Forever.
- Seal of Righteousness tiene 8 rangos (niveles 1, 10, 18, 26, 34, 42, 50 y 58) y escala con el poder con hechizos y con la velocidad del arma (foreverdiff, datos del cliente de octubre).

### Consenso de guías (sin medir)
- **Antes del pull:** Crusader → Judgement → sello de daño. Maxroll, Warcraft Tavern y wowforever.be.
- **Prioridad en la pelea:** sello de daño siempre puesto, Judgement en cuanto esté listo, Holy Strike en cuanto esté listo. Todas.
- **Consecration solo en grupos de enemigos** (2-3 o más): gasta mucho maná. Todas.
- **Exorcism** contra no muertos y demonios.
- **Arma lenta → Command, rápida → Righteousness.** El corte varía: 3,0 s (Maxroll), 3,2 s (Conquest Capped), y Expcarry dice que no se decida solo por la velocidad. Ninguna explica el número.
- **Maná:** lanzar Judgement y Holy Strike seguidos para pasar más tiempo fuera de la "regla de los 5 segundos" (Maxroll, Conquest Capped). La regla no está confirmada en Forever.
- **Unsealed Wrath:** Command por defecto y cambiar de sello cuando hay 3 copias (classicwowforever). Maxroll propone cambiar en cada golpe (Command ↔ Righteousness), pero lo explica con el "eco" de Twist of Light, así que probablemente está desfasado.

### Contradicciones y dudas abiertas
- **Cómo se gastan las copias de Unsealed Wrath.** Según fansites, al golpear con otro sello cada copia tiene su probabilidad normal: Righteousness siempre se activa y Command tira su probabilidad. No es texto de Blizzard ni está medido. En el foro hay modelos teóricos en los que guardar copias y cambiar en cada golpe dan lo mismo por golpe; lo que cambia es el maná (cada cambio cuesta un sello).
- **Crusader con Unsealed Wrath** parece no aportar nada al liberarse (foro): se juzga una vez y ya.
- **Enfriamiento de Judgement:** 8 s según classicwowforever; nadie más lo da.
- **¿Judgement de Command quita la Sentencia de Crusader del objetivo** ("solo una Sentencia por paladín")? Si la quita, "Judgement en cuanto esté listo" pierde el +daño Sagrado de Crusader. Se puede comprobar mirando los debuffs del objetivo en el juego.
- **Tasa real de Command.** Sondeo 1: 13 activaciones en 143 s de combate con Command puesto al empezar = **5,5 por minuto de combate**. No es concluyente: cuenta tiempo sin golpear, cambios de sello y una muestra pequeña. Lo resolverá el repaso tras el combate con muchas peleas.

### Lo que implica para tu personaje (sondeo 1)
- Seal of Righteousness **solo en rango 1** con nivel 40: faltan los rangos 2-5 (niveles 10-34) y el 6 sale en el 42. Comparar Command con Righteousness así no es justo. También faltan Justice, Wisdom y Fury.
- Tienes Unsealed Wrath (`Echo of Command`, 3 copias) y Vengeance.
- Tu arma va a 2,4 s (lo mostraba otro addon en el tooltip): por debajo de los dos cortes de las guías, que te dirían Righteousness. Por eso la regla `ret-command` es demasiado simple.

### Qué cambia en el addon
- Las reglas Command/Righteousness deben depender de la velocidad del arma (comprobar que `UnitAttackSpeed` es legible) y de que tengas un rango decente de Righteousness.
- Avisar de sellos y rangos sin entrenar para tu nivel: coaching útil y legible fuera de combate.
- Unsealed Wrath es una decisión golpe a golpe: va a la capa didáctica, no al asesor (regla 1).
- El repaso tras el combate puede medir lo que nadie ha medido: activaciones de Command por minuto según la velocidad del arma y el efecto de Unsealed Wrath. Cada activación llega como lanzamiento (20424).
