# Pala Helper (nombre provisional) — addon de paladín para WoW: Forever

## Qué es
Addon para **World of Warcraft: Forever** (Classic+, salió el 4 nov 2026) que ayuda al paladín a elegir **qué sello y qué Sentencia** usar según la situación. No es un asistente de rotación: es un **planificador y coach** que decide antes del pull, enseña en combate y analiza después.

Dueño: Jorge (arquitecto de software, experto en TypeScript, practica TDD y Clean Architecture). Nuevo en el desarrollo de addons de WoW. Juega a Forever y tiene el cliente instalado: **todo lo que dependa del juego lo prueba él**. Claude escribe el código y le dice exactamente qué probar.

## Fase actual
**Fase 1: primer addon jugable** (`addons/PaladinForDummies`, v0.9.4). Asesor antes del pull (probado en el juego) y, desde la v0.2.0, **repaso tras el combate** (`Recorder.lua`, `core/Fight.lua`, `core/FightStats.lua`, `/pfd stats`), pendiente de probar en el juego. Cómo probarlo: `docs/addon-testing.md`.

**Fase 0: sondeo.** El addon `addons/PalaProbe` comprueba en el cliente real qué es secret, qué está protegido y vuelca el grimorio. El protocolo está en `docs/probe-protocol.md`. **Primer sondeo hecho el 11 nov 2026**: resultados en `docs/probe-results/2026-11-11-sondeo-1.md`. Quedan pruebas pendientes (ver Preguntas abiertas).

## Hechos técnicos de Forever (verificados en fuentes oficiales o en la Warcraft Wiki)
- Usa la familia de código **Mainline** (la API moderna de 12.1.5), no la de Classic Era. Los tutoriales de Classic no sirven; la referencia es la API de retail/Midnight.
- TOC: `## Interface: 16001`. Sufijos: `_Forever.toc` o `_Camelot.toc` (Camelot es el nombre interno). Para comprobarlo: `/dump select(4, GetBuildInfo())`.
- Lua 5.1.
- `WOW_PROJECT_ID` = 18 (`WOW_PROJECT_CAMELOT`), confirmado en el sondeo 1 (cliente 1.60.1, build 70888, toc 16001). **No** detectar Forever con `WOW_PROJECT_CLASSIC`.
- Carpeta de addons: `World of Warcraft\_forever_\Interface\AddOns`.
- SavedVariables en: `World of Warcraft\_forever_\WTF\Account\<CUENTA>\SavedVariables\<Addon>.lua`. Se escriben en disco al hacer `/reload` o al salir.
- **Las restricciones de addons de Midnight están activas** (comunicado de Blizzard del 15 sep 2026):
  - En combate muchos valores son **secret**: se pueden mostrar (pasarlos a widgets), pero no comparar, operar con ellos, indexar, usarlos como clave ni medir su longitud. Guarda: `issecretvalue(v)`.
  - El registro de combate no está disponible para addons (`COMBAT_LOG_EVENT_UNFILTERED`).
  - Dentro de instancias los addons no pueden enviarse mensajes.
  - Principio de Blizzard: los addons no deben dar ventaja competitiva en combate.
- APIs cambiadas: `C_Spell.GetSpellInfo`, `C_Item.GetItemInfo`, `C_SpellBook.*`, `C_AddOns.GetAddOnMetadata`, la Settings API para las opciones (no `InterfaceOptions_AddCategory`).
- `C_CurveUtil.EvaluateColorValueFromBoolean(bool, siTrue, siFalse)` existe y funciona en Forever (sondeo 1). Deja al motor del juego aplicar una condición secret a un valor visual. No se pueden combinar dos secrets.

### Confirmado en el sondeo 1 (11 nov 2026)
- **Vida y maná son secret siempre**, también fuera de combate: `UnitHealth`, `UnitHealthMax(target)`, `UnitPower(player, mana)`. `UnitPowerMax` sí es legible. Las reglas basadas en el maná o la vida no pueden leerlos directamente.
- **Legibles en todo momento:** tipo de criatura (usar el ID numérico, 2.º retorno de `UnitCreatureType`, no el nombre), clasificación, nivel y nombre del objetivo, posición, orientación y datos del grupo y la instancia.
- **Auras propias:** legibles fuera de combate. En combate `C_UnitAuras.GetAuraDataByIndex` da error ("Auras cannot be accessed when secret while tainted"). En `PLAYER_REGEN_DISABLED` todavía se leen (`InCombatLockdown()` es `false`): es la ventana para registrar el sello al empezar la pelea.
- **`UNIT_SPELLCAST_SUCCEEDED` (player) no es secret en combate.** También llegan los procs (activación de Seal of Command = 20424).
- `C_SuperTrack.SetSuperTrackedUserWaypoint` **no está protegido**: el marcador se ve en el mundo.
- Mensajes de addon por PARTY fuera de instancia: funcionan.

### Confirmado con la v0.1.0 (11 nov 2026)
- **La spec se lee con `C_SpecializationInfo`**, pero Forever tiene sus propios IDs: **1486 = Retribución**. Faltan los de Holy y Protección; mientras tanto se deduce del rol (5.º retorno de `GetSpecializationInfo`: `HEALER`, `TANK`, `DAMAGER`).
- `GetNumTalentTabs` / `GetTalentTabInfo` no dan la spec en Forever.
- La detección automática funciona: `retribution (fuente: specialization)` (v0.1.1).
- **Dentro de las mazmorras el tipo de criatura del objetivo es secret** (3 élites de nivel 37 a 39, v0.1.1). La clasificación y el nivel sí se leen. Las reglas por tipo de criatura solo funcionan en mundo abierto.
- **El arma y el poder con hechizos se leen fuera de combate** (v0.2.0, nivel 41): `UnitAttackSpeed` 3.0, `UnitDamage` 207-252, `GetSpellBonusDamage(2)` 68. Ninguno secret. Vienen como floats (3.0000001907349): redondear al mostrar.
- `C_Secrets.GetSpellAuraSecrecy(1311703)` = **2 (ContextuallySecret)**: Echo of Command es secret en combate, no está en la lista de "nunca secret". Para mostrarlo en combate hay que usar AuraContainer.
### Medido con las peleas (12 nov 2026, `docs/probe-results/2026-11-12-peleas-1.md`)
- **Enfriamiento de Judgement: 8 s. Enfriamiento de Holy Strike: 10 s** (intervalos mínimos entre lanzamientos).
- **Seal of Command: unas 3,7 activaciones por minuto con el sello puesto** (102 en 1669 s; 3 por minuto en peleas largas). Muy por debajo de las 7 que asumen las guías, aunque el tiempo incluye ratos sin golpear y golpes fallados.
- `UnitAttackSpeed` incluye el +40% de Crusader si está puesto: desde la v0.7.1 se guarda `weaponBaseSpeed`.
- **Cada rango de un hechizo tiene su propio spellID.** Hasta la v0.7.1 solo se conocía el rango 1 de Righteousness (21084), así que los lanzamientos del rango 5 no se registraban: las peleas de antes no tienen datos del cambio de sellos. Desde la v0.7.2 el adaptador **descubre los rangos en el grimorio** por el nombre del ID conocido (nombre del cliente, vale en cualquier idioma) y `Data.LearnRanks` los añade y rehace el catálogo. Los IDs descubiertos quedan en `snapshot.diagnostics.discoveredRanks`.

- **La ventana funciona (v0.1.2):** se ve con fondo, los tooltips muestran el hechizo, el porqué y la confianza, y la posición se guarda entre `/reload`. Sin fondo (v0.1.0/0.1.1) no se distinguía.

Fuentes no verificadas (guías de la comunidad, muchas generadas con IA): tratar como hipótesis hasta que el sondeo lo confirme.

## Reglas de diseño (no negociables)
1. **En combate se prueba todo lo que el juego permita** (decisión de Jorge, 12 nov 2026): mostrar auras y acumulaciones con las herramientas de Blizzard (AuraContainer, Cooldown Manager, curvas, duraciones), avisos, etc. La recomendación antes del pull sigue congelándose al entrar en combate. Lo que no se hace es **sortear** las restricciones técnicas (leer datos secret por vías no previstas, exploits).
2. Nunca comparar, operar ni indexar un valor sin comprobar antes `issecretvalue`. Usar `pcall` en el límite con la API de WoW.
3. **Nunca identificar hechizos por su nombre**: el cliente puede estar en español (esES). Siempre por `spellID`.
4. Nunca guardar valores secret en SavedVariables.
5. Política de addons: gratis, código legible, sin publicidad ni donaciones dentro del juego.
6. **Ante la duda de si algo está permitido, se pregunta antes de descartarlo.** Distinguir siempre entre límite técnico (el juego no lo deja: no hay nada que preguntar) y duda de normas (se pregunta). Dónde: WoWUIDev Discord, canal #author-wishlist (lo leen los desarrolladores de Blizzard), o un ticket de soporte para dudas de normas.

## Arquitectura
Todo vive en `addons/PaladinForDummies/` (WoW solo carga lo que está dentro de la carpeta del addon). Orden de carga en el `.toc`.
Tests: `busted` desde la raíz del repo (Lua 5.1; en Ubuntu, `apt install lua5.1 lua-busted`). `spec/support/addon.lua` carga los archivos como WoW, pasando `(addonName, ns)`; `spec/smoke/` carga el `.toc` entero con un WoW simulado.

- **Widget de Unsealed Wrath** (`ui/EchoTracker.lua`, `/pfd echo`, experimental desde la v0.3.0): AuraContainer de Blizzard con un hueco por copia (Echo of Command 1311703, Echo of Righteousness 1311704) filtrado por ID, los dos en el mismo sitio (nunca hay copias de los dos a la vez; v0.9.3); el juego pinta el número de copias y una barra con `minApplications` que solo se muestra al llegar a 3 (o a 1 para volver). Resultado de la creación en `db.echoStatus`. **Funciona en Forever (12 nov): el número de copias se actualiza en combate y los avisos "¡CAMBIA!" (3 copias de Command) y "¡VUELVE!" (1 de Righteousness) se encienden.** `/pfd echo debug` muestra qué partes se construyeron. El contenedor va sujeto a un ancla propia movible (`/pfd echo move`, posición en `db.echoPosition`): al contenedor no se le ponen scripts. La posición se guarda siempre por el centro (`EchoTracker.toCenter`, v0.9.4): al cambiar el tamaño del recuadro en la v0.9.3, la esquina guardada lo desplazaba. Detalle en `docs/research.md`.

- **Macros** (capa 2 del MVP, v0.4.0; v0.6.0): `core/Macros.lua` construye el texto. **No hay macro de apertura** (decisión de Jorge, 12 nov): Crusader se lanza desde su botón normal; antes hubo un `/castsequence` que se quedaba a medias y una versión con `[nocombat]` que no servía con varios enemigos. PFD Unsealed hace de apertura: `/castsequence reset=combat Command, Righteousness`: la primera pulsación de cada pelea pone Command. Sin `reset=target` (Jorge, 12 nov): el sello es un buff propio, no algo del enemigo, así que al cambiar de objetivo la secuencia sigue donde iba. PFD Golpe: `/cast Judgement` + `/cast Holy Strike` + borrar el aviso rojo, porque Judgement no ocupa el tiempo global; PFD Sello con `[mod:shift]`), con nombres del cliente sacados por spellID. **Macros de utilidad (v0.7.0):** curas, protección, libertad, Lay on Hands, Purify, Hammer of Justice, Repentance, Divine Shield con cancelación, bendiciones, auras, Redemption y Exorcism, todas con `[@mouseover,help,nodead][help,nodead][@player]` (o `harm`) para no cambiar de objetivo; hechizos en `data/MacroSpells.lua` (IDs del sondeo 1 y rangos de Classic sin verificar). Investigación en `docs/research.md` ("Macros de paladín"). **Probadas en el juego (12 nov): se crean y funcionan.** `adapters/MacroWriter.lua` las crea como macros de personaje o edita solo el cuerpo si cambió; nunca en combate (`CreateMacro`/`EditMacro` son `nocombat`): queda pendiente hasta salir. `/pfd macros [off]`. **Probado en el juego (12 nov): las macros se crean en la pestaña del personaje.** Las macros no tienen condiciones de auras: el botón no puede decidir según las copias (límite técnico).

- La Sentencia (Judgement, 20271) es **un solo hechizo** que libera el sello puesto. La recomendación de "Sentencia" es el sello que hay que llevar al juzgar; `core/Plan.lua` la convierte en pasos (ponte X, lanza Judgement, cambia a Y) y la interfaz muestra el icono de Judgement con el sello en la esquina.

- **Repaso tras el combate:** en `PLAYER_REGEN_DISABLED` se lee el sello y las copias de Unsealed Wrath (último momento con auras legibles); durante la pelea solo se anotan tus lanzamientos; `core/Fight.lua` reconstruye cuánto tiempo llevaste cada sello (cada sello dura 30 s) y cuenta Sentencias, Holy Strike y activaciones de Command (20424). Se guarda en `PaladinForDummiesDB.fights` (máximo 1000). Cada pelea guarda `timeline` (cada sello, Sentencia, Holy Strike y activación de Command con su segundo, hasta 300) y `core/FightStyle.lua` deduce el estilo (solo un sello, Crusader y luego un sello, cambio de sellos, mezcla): **Jorge juega normal y no etiqueta nada**. `/pfd test X` existe como opción (`context.test`). Plan de pruebas en `docs/addon-testing.md`.

- `core/`: Lua puro, **sin dependencias de WoW**: motor de reglas, dominio (Situación → Recomendación) y estadísticas de peleas. Se prueba con **busted** fuera del juego (TDD).
- `adapters/`: la única capa que toca la API de WoW. Lee el contexto (jugador, objetivo, grupo, instancia) y lo convierte en un objeto `Situation` plano, que es lo que recibe el core. Recibe la API como parámetro (`_G` en el juego, una falsa en los tests). `Situation.target` solo se rellena con objetivos atacables.
- `ui/`: icono de recomendación, tooltips ampliados y panel de opciones (`ui/Options.lua`, Settings API con opciones "proxy" que llaman a funciones de `Main.lua`; se abre con `/pfd` y desde el menú de addons del minimapa vía `AddonCompartmentFunc` en el `.toc`).
- **Base pública (v0.9.0, auditoría en `docs/quality-audit.md`):** librerías **Ace3** en `Libs/` (cargadas por `embeds.xml`; Ace3 declara `16001`): AceDB (`PaladinForDummiesDB`: ajustes en `profile`, perfil "Default" compartido; peleas, errores, diagnósticos y `welcomed` en `char`), AceConfig + AceDBOptions (`ui/Options.lua`, pestañas y Perfiles), AceGUI (`ui/ReportWindow.lua`). Idiomas propios en `Locales/` (`ns.L`, inglés por defecto, español; opción Idioma en Avanzado; no AceLocale porque solo sigue el idioma del cliente). `core/Migrations.lua` migra el formato plano antiguo. Solo se activa con paladines. Comandos de usuario: `/pfd`, `/pfd help`, `/pfd stats`, `/pfd report` (`core/Report.lua`, texto en inglés para quien mantiene el addon); los de diagnóstico, con el modo desarrollador. Errores: `char.errors` + `geterrorhandler()` una vez por sesión; en el chat solo en modo desarrollador. Se registran `ADDON_ACTION_BLOCKED`/`FORBIDDEN` con la función. Valores por defecto poco intrusivos (sin resumen en el chat, macros apagadas). **Autor: r3b0rNjHs.** Los textos antiguos (rec., chat de peleas, macros) siguen en español: los traduce el paso de idiomas.
- **Aviso "blocked from an action only available to the Blizzard UI" al entrar en una mazmorra (12 nov, v0.8.0):** causa sin identificar. **Diagnosticar antes de cambiar nada** (decisión de Jorge): `ADDON_ACTION_BLOCKED` queda en el informe y `/console taintLog 1` da la traza.
- **Presentación (decisión de Jorge, 12 nov):** fase 1 opciones (v0.8.0) → idiomas (inglés por defecto + español; **se publicará más adelante**) → fase 2 estilo visual unificado → fase 3 Modo edición con LibEditMode. Probar cada fase en el juego antes de la siguiente. Investigación en `docs/research.md`.
- `data/`: reglas declarativas en tablas Lua, versionadas por build del juego. Cada regla lleva el porqué y su confianza (`mechanic` = sale de la mecánica, `consensus` = consenso de guías, `measured` = confirmada con datos propios).

## Producto: capas planeadas
1. **Asesor antes del pull (MVP):** con el contexto fuera de combate (spec, talentos, nivel, maná, objetivo, tipo de contenido y grupo) muestra "Sello X + Sentencia Y" con su porqué. Se congela al entrar en combate.
2. **Perfiles y macros (MVP):** solo, mazmorra de tanque, mazmorra de Ret y banda. Fuera de combate genera macros con condicionales (las evalúa el juego al pulsar).
3. **Repaso tras el combate y A/B personal (MVP):** guarda el sello al empezar, el tipo y nivel del enemigo, la duración y el maná. Con el tiempo da estadísticas propias por sello.
4. **Capa didáctica:** tooltips ampliados, un códice y un simulador de escenarios. Aquí va el seal twisting de Ret (Twist of Light).
5. **Fase 2:** reparto de Sentencias entre paladines **antes de entrar** en la instancia, y paquetes de reglas para exportar e importar.

## Qué se sabe de los sellos en Forever
Confirmado con el grimorio (sondeo 1): la Sentencia **no consume el sello** y cada paladín solo puede tener una Sentencia activa en el objetivo. Las filas marcadas ✔ están confirmadas con el texto del cliente; el resto, por confirmar.

| Sello | Nivel | Mientras está activo | Su Sentencia |
|---|---|---|---|
| Righteousness ✔ | 1 | Daño Sagrado extra por golpe; **las armas lentas hacen más daño por golpe** | Golpe de daño Sagrado |
| Crusader ✔ | 6 | Más poder de ataque **y** ataques un 40% más rápidos con menos daño por golpe | 40 s: el objetivo recibe más daño Sagrado; tus golpes la refrescan |
| Fury (nuevo, tanque) | 10 | Daño Sagrado fijo por golpe y un escudo del 50% de ese daño | Daño extra y provoca a 10 m durante **3 s** (notas del 2 nov) |
| Command ✔ (talento Ret) | 20 | Golpe Sagrado extra del **74%** del daño del arma. La tasa la decide el servidor: **medida unas 3,7 por minuto con el sello puesto** (las guías asumen 7) | Daño Sagrado, el doble contra aturdidos o incapacitados |
| Justice | 22 | Probabilidad de aturdir 2 s | El objetivo no puede huir a toda velocidad |
| Light ✔ | 30 | Probabilidad de curarte | 40 s: quien golpee al objetivo puede curarse |
| Wisdom | 38 | Probabilidad de recuperar maná | Quien golpee al objetivo recupera maná |

Talentos relacionados (notas del 2 nov y deep dive; detalle en `docs/research.md`):
- **Unsealed Wrath** (Ret 31, requiere Repentance; **sustituye a Twist of Light, que ya no existe**): tus golpes guardan una copia del sello activo durante 15 s, hasta 3; al golpear con otro sello se gastan. Confirmado en el sondeo 1: aura `Echo of Command` (1311703), 15 s, 2-3 acumulaciones. **Tooltip del aura en el juego (11 nov):** "Empowers your next melee attack without Seal of Command active with N instances of Seal of Command": se gastan todas en un golpe y **vale cualquier otro sello**, no solo Righteousness (hipótesis: cambiar a Wisdom para recuperar maná). Sin confirmar si cada "instance" es una activación segura o una tirada de su probabilidad.
- Vengeance: hasta 5 acumulaciones, requiere Seal of Command.
- Sacred Arbiter: Holy Strike refresca todas las Sentencias del objetivo, incluidas las de otros paladines.
- Sanctified Judgement: devuelve hasta el 60% del coste del sello juzgado.
- Swift Judgement (Prot): libera el sello al instante, sin compartir enfriamiento con Judgement.
- Improved Seals, Benediction, Reverence. Improved Seal of Fury **eliminado**.

### Primeras reglas (hipótesis)
- Arma lenta → Command, rápida → Righteousness. `consensus`: corte de 3,0 s (Maxroll) o 3,2 s (Conquest Capped), sin justificar; Righteousness también premia el arma lenta. Comparar solo con rangos de Righteousness entrenados.
- Antes del pull: Sentencia de Crusader y luego cambiar al sello de daño (el debuff se queda). `consensus`
- Humanoides que huyen → Justice. `mechanic`
- En solitario con poco maná o en peleas largas → Wisdom. Con poca vida → Light. `consensus` (ojo: maná y vida son secret, no se pueden leer para decidir)
- En grupo: un paladín mantiene la Sentencia de Wisdom (mucho maná en el grupo) o de Light (mucho daño en área) en el jefe. `consensus`
- Tanque → Fury, y Swift Judgement si falla una provocación. `mechanic`
- La Sentencia de Crusader la refrescan tus golpes (cliente): basta con juzgarla una vez por pelea. Duda: ¿Judgement de Command la quita? `mechanic`
- Hammer of Justice + Judgement de Command: el doble de daño (cliente). `mechanic`

## Preguntas abiertas (las responde el sondeo)
Respondidas en el sondeo 1: ver `docs/probe-results/2026-11-11-sondeo-1.md`. Siguen abiertas:
- IDs de spec de Holy y Protección en Forever.
- En mazmorras, ¿se puede saber el tipo de criatura de otra forma (p. ej. el ID del NPC en `UnitGUID`)?
- ¿`ENCOUNTER_START` da el `encounterID`? (Necesita un jefe de mazmorra.)
- ¿Los mensajes de addon funcionan dentro de instancias?
- ¿`C_UnitAuras.GetPlayerAuraBySpellID` también falla en combate?
- ¿Hay alguna forma legible del % de maná o solo se puede mostrar (barras, `C_CurveUtil`)?
- Grimorio de Fury, Justice y Wisdom, y rangos 2-6 de Righteousness (no estaban entrenados).
- ¿El arma y el poder con hechizos siguen legibles dentro de mazmorras? (La wiki los marca `SecretWhenUnitStatsRestricted`.)
- ¿Judgement de Command quita la Sentencia de Crusader?
- Efecto real de Unsealed Wrath: aún no hay peleas con Righteousness.

## Herramientas
- VS Code con la extensión `ketho.wow-api` (anotaciones de la API para el Lua Language Server).
- Referencia: Warcraft Wiki, en especial la página "Patch 1.60.1/API changes/notes".
- WoWUIDev Discord: donde Blizzard anuncia los cambios de API.
- Tests: busted (Lua 5.1) para `core/`.

## Forma de trabajar
- **Si una versión añade archivos al `.toc`, hay que reiniciar el juego** (no basta `/reload`): WoW lee la lista de archivos al arrancar. Avisar a Jorge cada vez.
- Iteraciones cortas: Claude escribe → Jorge prueba en el juego → **manda el archivo de SavedVariables** (`PaladinForDummies.lua`) → se ajusta. El archivo lleva todo: `snapshot` (lo mismo que `/pfd debug`, con versiones del addon y del cliente), `errors` (los errores capturados) y `fights`. Un addon solo puede escribir ese archivo, y el juego lo escribe al hacer `/reload` o al salir.
- Antes de usar una API, comprobar en la Warcraft Wiki que existe en Mainline 12.1.5 y anotar si devuelve secrets.
- Responder a Jorge en español; el código y los identificadores en inglés.
