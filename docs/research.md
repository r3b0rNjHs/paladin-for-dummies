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

Fuentes revisadas: notas oficiales de Blizzard (deep dive de octubre, notas del 2 nov, hotfixes del 9 y 10 nov), Maxroll (4 nov), Conquest Capped (8 nov), classicwowforever.com (8 nov), wowforeverleveling.com (5 nov), Warcraft Tavern (sin fecha, todavía con Twist of Light), LFCarry (11 nov), el simulador de foreverdb.net (build 70888) y el hilo del foro oficial "Unsealed Wrath - Implications and seal effect" (2 nov). Icy Veins (rotación) la pegó Jorge a mano porque daba 403; sin fecha en el texto pegado. Icy Veins (subida de nivel) y Mobalytics (endgame) llegaron en capturas, sin fecha. Ya no queda ninguna fuente bloqueada.

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

### Icy Veins: rotación (la guía más completa; sin fecha, sin números ni pruebas)
- **Unsealed Wrath:** cada golpe con un sello deja un Echo; al golpear con *otro* sello, cada Echo vuelve a aplicar el sello antiguo una vez. IDs: `Echo of Command` **1311703** (coincide con el sondeo 1), `Echo of Righteousness` **1311704**, Unsealed Wrath 1310735.
- **Cambio de sellos:** arma lenta → cambia a Righteousness con 3 Echo of Command y vuelve a Command con 1+ Echo of Righteousness. Arma rápida → al revés. No da un corte en segundos. Recomienda un addon de temporizador de golpes.
- **Prioridad (un objetivo):** Judgement con Crusader si falta el debuff y cambiar a Command al momento; cambio de sellos; Hammer of Wrath por debajo del 20%; **Consecration en cuanto esté lista**; Judgement en cuanto esté listo; Holy Strike en cuanto esté listo; Exorcism contra no muertos y demonios.
- Si otro aturde al objetivo, retrasar Judgement para hacerlo con Command (doble daño): coincide con el texto del cliente.
- **Varios objetivos:** igual, pero Crusader solo en el principal (los demás solo reciben daño Sagrado de Consecration); Holy Wrath contra grupos de no muertos o demonios.
- **Maná:** Reverence mantiene hasta el 30% de la regeneración dentro de la regla de los 5 segundos (**confirma que esa regla existe en Forever**). Sanctified Judgement devuelve maná. Si falta: Seal of Wisdom un rato y aguantar Consecration, lo más caro.
- **Shockadin:** arma rápida con Righteousness (su coeficiente de poder con hechizos es fijo por golpe); con un arma muy lenta, Command da más o menos lo mismo. Mantener Righteousness y renovarlo con menos de 10 s si todo lo demás está en enfriamiento.
- IDs que usa (rangos altos, sacados de su base de datos y sin verificar en nuestro cliente): Command 20920, Righteousness 20293, Crusader 20308, Wisdom 20357, Reverence 1310899, Sanctified Judgement 1311074, Consecrated Ground 1310905, Champion of the Light 1311084.

### Icy Veins: subida de nivel (capturas; sin fecha)
- **Elegir sello depende de la velocidad del arma *y* del poder con hechizos; no hay un corte universal.** Por eso las guías dan números distintos.
  - Command "está diseñado" para unas 7 activaciones por minuto: con arma lenta, mismas activaciones y más daño por golpe. Sigue sin medirse en Forever.
  - Righteousness recibe el 12% del poder con hechizos por golpe (arma de dos manos) y Command el 20,3%, pero solo en algunos golpes. Righteousness gana con mucho poder con hechizos y con armas rápidas. foreverdiff da a Righteousness entre el 8% y el 12,6%: encaja.
- **Maná al subir de nivel:** el maná también es tu curación (Holy Light), lo que evita parar a comer y beber. No renovar el sello hasta que esté a punto de acabarse, y no gastar Judgement ni Holy Strike si el próximo golpe normal remata.
- **Consecration:** tarda 8 s en hacer todo su daño (el cliente dice "over 8 sec" ✔). Evitarla si los enemigos mueren antes o si hay que moverse. Escala mejor que nada con el poder con hechizos. "Cuesta casi el doble que Judgement + Holy Strike": en el sondeo 1, Consecration rango 3 cuesta 288 frente a 53 + 14, más de 4 veces; con Holy Conduit (-40%) unas 2,6.
- **Prioridad (un objetivo):** bendición siempre puesta (Kings o Might); Crusader → Judgement → Righteousness o Command según arma y poder con hechizos; Judgement y Holy Strike en cuanto estén listos; con Command, Hammer of Justice o Repentance antes de Judgement (el cliente dice "stunned or incapacitated" ✔); Consecration si sobra maná; Exorcism contra no muertos y demonios, también para atraerlos a 30 m (cliente: 30 m ✔); Hammer of Wrath (nivel 44) por debajo del 20%.
- **Varios objetivos:** igual, con Consecration mucho más rentable. Holy Wrath en el nivel 50, solo contra no muertos y demonios.
- Judgement no ocupa el tiempo global de reutilización (coincide con Conquest Capped). Crusader compensa contra enemigos que duran.
- Auras y bendiciones: Devotion por defecto, Retribution contra grupos o para ayudar al tanque; Kings desde el nivel 20 y Might antes.

### Mobalytics: endgame (capturas; sin fecha)
La pestaña se llama "Endgame Twist of Light" pero el contenido ya usa Unsealed Wrath: actualizada a medias.
- **Antes del pull:** empezar con *el sello asignado* (Crusader, Wisdom o Light) y juzgarlo al empezar. En grupo, cada paladín tiene una Sentencia asignada en el jefe (encaja con Sacred Arbiter y con la fase 2 de CLAUDE.md).
- **Unsealed Wrath:** Command puesto hasta 3 copias, cambiar a Righteousness para que se activen y volver a Command.
- **Prioridad:** Judgement → Consecration (3+ enemigos) → Exorcism (no muertos y demonios) → Holy Strike → Consecration (1-2 enemigos).
- **Shockadin:** Righteousness siempre; Consecration siempre puesta (para Consecrated Ground); Judgement → Exorcism → Holy Shock → Holy Strike.

### Consenso de guías (sin medir)
- **Antes del pull:** Crusader → Judgement → sello de daño. Maxroll, Warcraft Tavern y wowforever.be.
- **Prioridad en la pelea:** sello de daño siempre puesto, Judgement en cuanto esté listo, Holy Strike en cuanto esté listo. Todas.
- **Consecration solo en grupos de enemigos** (2-3 o más): gasta mucho maná. Todas las de subir de nivel. **Icy Veins (endgame) dice lo contrario**, "en cuanto esté lista" también contra un solo objetivo; Mobalytics la deja al final de la prioridad con 1-2 enemigos. Depende del perfil (subir de nivel frente a banda).
- **En grupo, Sentencia asignada por paladín** (Crusader, Wisdom o Light): Mobalytics, Warcraft Tavern y Blizzard (Sacred Arbiter).
- **Exorcism** contra no muertos y demonios.
- **Arma lenta → Command, rápida → Righteousness.** El corte varía: 3,0 s (Maxroll), 3,2 s (Conquest Capped), y Expcarry dice que no se decida solo por la velocidad. Icy Veins explica por qué no hay corte: depende también del poder con hechizos.
- **Maná:** lanzar Judgement y Holy Strike seguidos para pasar más tiempo fuera de la "regla de los 5 segundos" (Maxroll, Conquest Capped). Icy Veins confirma que la regla existe (Reverence).
- **Unsealed Wrath (consenso de tres fuentes: classicwowforever, Icy Veins y Mobalytics):** Command por defecto; con 3 copias, cambiar a Righteousness un golpe y volver a Command. Con arma rápida, Icy Veins invierte el patrón. Maxroll propone cambiar en cada golpe (Command ↔ Righteousness), pero lo explica con el "eco" de Twist of Light, así que probablemente está desfasado.

### Contradicciones y dudas abiertas
- **Tooltip real de `Echo of Command` (cliente, 11 nov):** "Empowers your next melee attack without Seal of Command active with N instances of Seal of Command". Confirma que se gastan todas en el siguiente golpe con **cualquier** otro sello (las guías solo hablan de Righteousness). Abre la opción de cambiar a Wisdom para compensar el maná de los cambios (sin medir).
- **Cómo se gastan las copias de Unsealed Wrath.** Según fansites, al golpear con otro sello cada copia tiene su probabilidad normal: Righteousness siempre se activa y Command tira su probabilidad. No es texto de Blizzard ni está medido. En el foro hay modelos teóricos en los que guardar copias y cambiar en cada golpe dan lo mismo por golpe; lo que cambia es el maná (cada cambio cuesta un sello).
- **Crusader con Unsealed Wrath** parece no aportar nada al liberarse (foro): se juzga una vez y ya.
- **Enfriamiento de Judgement:** 8 s según classicwowforever; nadie más lo da.
- **¿Judgement de Command quita la Sentencia de Crusader del objetivo** ("solo una Sentencia por paladín")? Si la quita, "Judgement en cuanto esté listo" pierde el +daño Sagrado de Crusader. Icy Veins pide a la vez "Crusader si falta" y "Judgement en cuanto esté listo", lo que sugiere que no la quita, pero no lo dice. Se comprueba mirando los debuffs del objetivo en el juego.
- **Tasa real de Command.** Sondeo 1: 13 activaciones en 143 s de combate con Command puesto al empezar = **5,5 por minuto de combate**. No es concluyente: cuenta tiempo sin golpear, cambios de sello y una muestra pequeña. Lo resolverá el repaso tras el combate con muchas peleas.

### Lo que implica para tu personaje (sondeo 1)
- Seal of Righteousness **solo en rango 1** con nivel 40: faltan los rangos 2-5 (niveles 10-34) y el 6 sale en el 42. Comparar Command con Righteousness así no es justo. También faltan Justice, Wisdom y Fury.
- Tienes Unsealed Wrath (`Echo of Command`, 3 copias) y Vengeance.
- Tu arma va a **3,0 s** (`UnitAttackSpeed`, v0.2.0, nivel 41; el 2,4 que mostraba otro addon era otra cosa): justo en el corte de Maxroll (3,0 → Command) y por debajo del de Conquest Capped (3,2). Zona dudosa: la regla `ret-command` es demasiado simple. Daño del arma 207-252 y poder con hechizos Sagrado 68.

### Qué cambia en el addon
- Command frente a Righteousness no es un umbral: es una **comparación que se puede calcular** fuera de combate con la velocidad y el daño del arma y el poder con hechizos (comprobar que `UnitAttackSpeed`, `UnitDamage` y `GetSpellBonusDamage` son legibles) y la tasa real de Command (que medirá el repaso tras el combate). Hasta entonces, regla `consensus`. Solo comparar con un rango decente de Righteousness.
- Consejos de maná al subir de nivel (no renovar el sello antes de tiempo, no gastar si el golpe remata) son decisiones en combate: capa didáctica.
- Avisar de sellos y rangos sin entrenar para tu nivel: coaching útil y legible fuera de combate.
- Unsealed Wrath es una decisión golpe a golpe: va a la capa didáctica, no al asesor (regla 1). Lo que sí puede decidir el asesor antes del pull es el *patrón* (arma lenta o rápida) que enseñará la capa didáctica.
- Consecration y Wisdom dependen del perfil (subir de nivel solo frente a banda).
- El repaso tras el combate puede medir lo que nadie ha medido: activaciones de Command por minuto según la velocidad del arma y el efecto de Unsealed Wrath. Cada activación llega como lanzamiento (20424).

## Mostrar auras en combate: Echo of Command (investigación del 12 nov 2026)

Objetivo: ver en grande las copias de Echo of Command (1311703) y Echo of Righteousness (1311704) y que destaque al llegar a 3, para saber cuándo cambiar de sello con Unsealed Wrath.

Fuentes: Warcraft Wiki (Secret Values, notas de API de 12.0.x y 12.1.0, páginas de API) y el **código fuente de la interfaz de Blizzard** (`Gethe/wow-ui-source`, rama live, `Blizzard_AuraContainer`). Blizzard confirmó el 15 sep que los AuraContainer de 12.1.0 también están en Forever.

### Lo que el juego no deja hacer (límite técnico, no de normas)
- Desde 12.1.0, en combate **todas** las funciones de auras devuelven datos secret o nada, y `UNIT_AURA` llega con datos secret. El addon no puede saber cuántas copias tienes.
- `C_UnitAuras.GetPlayerAuraBySpellID` requiere que la aura no sea secret: si lo es, devuelve nada (sin error).
- Excepción: las auras que Blizzard marca como **"nunca secret"** se leen siempre. Se comprueba con `C_Secrets.GetSpellAuraSecrecy(1311703)`.

### Lo que sí se puede: AuraContainer (pensado justo para esto)
- El addon crea el contenedor y decide el aspecto (tamaño, posición, texturas, texto); **el juego lo rellena y lo actualiza él mismo**, también en combate. El addon nunca toca los datos.
- `container:AddAuraSlot(clave, "HELPFUL", { candidateFilters = { includeSpellIDs = { [1311703] = true } }, initializeFrame = ... })`: un hueco fijo para una sola aura. Comentario de Blizzard en el código: sirve para *"indicators for specific spells by ID"*.
- **Filtrar por ID está permitido** para buffs del propio jugador (`CanApplyIdentityCandidateFilters`: *"Filtering helpful spells on the active player… is always allowed"*). Solo se restringe filtrar debuffs de jefes (para evitar avisos tipo "¡muévete!").
- El botón admite: icono, **número de acumulaciones** (`SetApplicationCount`), **barra de acumulaciones** (`SetApplicationBar(statusBar, { minApplications, maxApplications })`), duración (texto, barra o espiral), animaciones al aparecer la aura y tooltip.
- **El aviso al llegar a 3:** en `ApplyApplicationBar` el juego hace `statusBar:SetShown(applications >= minApplications)`. Con `minApplications = 3`, la barra (y lo que pongamos dentro: un brillo, un texto "¡CAMBIA!") **solo aparece con 3 copias**. Lo compara el código seguro del juego, no el nuestro.
- **Sonido:** `C_UnitAuras.AddAuraSound(trigger, { unitToken = "player", spellID = 1311703, soundFileID = ... })` con los disparadores `Added`, `ApplicationsIncreased` o `Removed`. No hay disparador "al llegar a N": sonaría en cada copia o al gastarlas.

### Para probar sin pelear
- `/console addonCombatRestrictionsForced 1` simula las restricciones de combate fuera de combate (`0` las quita; no se guarda al reiniciar).
- `/dump C_Secrets.GetSpellAuraSecrecy(1311703)`: si dice "never secret", todo es más fácil.

### Sin confirmar en Forever
- Que el contenedor de la rama live de Midnight (12.1.5) sea igual en Forever: Blizzard fue cambiando la API semana a semana durante las pruebas de 12.1.0.
- Las opciones válidas de la barra de acumulaciones, más allá de `minApplications`, `maxApplications` e `interpolation`, las valida una función interna (`C_AuraContainerUtil.ProcessCustomAuraButtonApplicationBarOptions`).

## Macros de paladín (investigación del 12 nov 2026)

Fuentes: Warcraft Wiki (Macro conditionals, Making a macro, notas de API de 12.x), páginas de macros de Forever ([wowf.io](https://wowf.io/en/macros/paladin), sin fecha, datos de la beta; [classicwowforever.com](https://classicwowforever.com/macros/paladin/), 3 nov, "no probadas en el cliente final"), [wowforevertierlist.com/macros](https://wowforevertierlist.com/macros) (23 oct, cita el soporte de Blizzard "Are Macros Allowed") y guías de Classic y retail (Icy Veins, NoobToBoss, Method).

### Qué permite Forever
- Forever usa **el sistema de macros moderno**, el de retail, no el de Classic. Las notas de API de 12.x no traen restricciones nuevas para macros. Lo único que Midnight limitó en macros es **marcar objetivos** (unas 3 marcas en muy poco tiempo) y **mensajes de chat durante encuentros**. Nada que afecte a lo que usamos.
- Existen: `[@mouseover]`, `[@player]`, `[@targettarget]`, `[@focus]`, `[@cursor]`, `[help]`/`[harm]`, `[dead]`/`[nodead]`, `[exists]`, `[combat]`, `[mod:shift|ctrl|alt]`, `[known]`, `[spec]`, `[channeling]` y las alternativas con `;`. Comandos: `/cast`, `/castsequence`, `/use`, `/cancelaura`, `/stopcasting`, `/startattack`, `/cleartarget`, `/targetenemy`.
- Límites: 255 caracteres por macro y 18 macros por personaje (120 de cuenta).
- Norma de Blizzard: **una pulsación, una acción**. Las macros no pueden mirar buffs ni enfriamientos para decidir.
- `/cast` con el nombre usa el rango más alto. Bajar de rango para ahorrar maná rinde menos en Forever: las notas del 1 oct dicen que los rangos muy por debajo de tu nivel aprovechan menos el poder de sanación.
- Forever trae de serie un **temporizador de golpes** (*swing timer*) y el Cooldown Manager, los dos desactivados por defecto. El temporizador de golpes ayuda con el cambio de sellos.

### El patrón clave: sin cambiar de objetivo
`[@mouseover,help,nodead][help,nodead][@player]` lanza sobre el aliado bajo el ratón (en el mundo o en su marco), si no sobre tu objetivo amistoso y si no sobre ti. **Tu objetivo enemigo no cambia**, así que PFD Unsealed no se reinicia y no pierdes el hilo de la pelea. Para enemigos: `[@mouseover,harm,nodead][harm,nodead]`.

### Macros que recomiendan las fuentes, filtradas a tu kit (grimorio del sondeo 1)
| Macro | Texto (simplificado) | Fuente | ¿La tienes? |
|---|---|---|---|
| Golpe + atacar | `/cast Judgement` `/cast Holy Strike` `/startattack` | wowf.io | ✔ (PFD Golpe, falta `/startattack`) |
| Cura sin cambiar de objetivo | `/cast [mod:shift,…] Holy Light; [@mouseover,help,nodead][help,nodead][@player] Flash of Light` | wowf.io, classicwowforever | ✔ |
| Blessing of Protection, Alt = Divine Protection | `[mod:alt] Divine Protection; [@mouseover,help,nodead][help,nodead][@targettarget,help,nodead] Blessing of Protection` | classicwowforever | ✔ |
| Blessing of Freedom | `[@mouseover,help,nodead][help,nodead][@player]` | wowf.io | ✔ |
| Lay on Hands | `[@mouseover,help,nodead][help,nodead][@player]` | classicwowforever | ✔ |
| Divine Shield que se quita pulsando otra vez | `/cancelaura Divine Shield` (y Divine Protection, BoP) `/cast Divine Shield` | classicwowforever, Icy Veins | ✔ |
| Hammer of Justice que corta tu lanzamiento | `/stopcasting` `/cast [@mouseover,harm,nodead][harm,nodead] Hammer of Justice` | wowf.io | ✔ |
| Repentance sin cambiar de objetivo | `[@mouseover,harm,nodead][harm,nodead]` | wowf.io | ✔ |
| Bendiciones en un botón | Might; Shift = Wisdom; Ctrl = Kings, al ratón o al objetivo | classicwowforever | Might y Kings ✔; Wisdom sin entrenar |
| Purify | `[@mouseover,help,nodead][help,nodead][@player]` | (patrón) | ✔ |
| Exorcism; Shift = Turn Undead | `[mod:shift,harm,nodead] Turn Undead; [harm,nodead] Exorcism` | classicwowforever | Exorcism ✔; Turn Undead no está en el grimorio |
| Redemption sin cambiar de objetivo | `[@mouseover,help,dead][help,dead]` | classicwowforever | ✔ |
| Auras en un botón | Devotion; Shift = Concentration; Ctrl = Retribution | classicwowforever | Devotion y Retribution ✔ |
| Divine Shield + Hearthstone | `/cast Divine Shield` `/use Hearthstone` | wowf.io | ✔ |
| Quitar objetivo muerto y atacar al más cercano | `/cleartarget [dead][help]` `/targetenemy [noexists]` `/startattack` | wowf.io | genérica |
| Tanque y Sagrado | Seal of Fury, Swift Judgement, Templar's Bulwark, Holy Shock, Light's Vigil, Divine Favor | wowf.io | no son de tu spec |

Sin probar en el cliente final de Forever: todas las fuentes lo avisan. Por eso el addon solo genera las de hechizos que tienes (por spellID) y guarda el resultado en `db.macroStatus`.
