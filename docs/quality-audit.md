# Auditoría de calidad: de "addon de Jorge" a addon publicable (12 nov 2026)

Hasta la v0.8.0 el addon se ha construido para un único usuario (Jorge) y para hacer pruebas. Este documento compara lo que hacen los addons buenos con lo que tenemos, y propone un plan.

## Fuentes
- Hekili, el addon de rotación de referencia: [wiki Getting Started](https://github.com/Hekili/hekili/wiki/Getting-Started), [informes de errores](https://github.winds-ss.workers.dev/Hekili/hekili/wiki/Report-an-Issue). Ya no es compatible con Midnight; para Forever hay un fork ([Hekili Forever](https://www.curseforge.com/wow/addons/hekili-forever)).
- Competidores en Forever: [ForeCast](https://www.curseforge.com/wow/addons/forecast) (`/fc`, `/fc report`) y [Rotation Pilot](https://www.curseforge.com/wow/addons/rotation-pilot) (`/rp`, "early release"). Blizzard tiene su propio [Assisted Highlight / Single-Button Assistant](https://www.icy-veins.com/wow/single-button-assistant-assisted-highlight-guide) desde 11.1.7; `C_AssistedCombat` existe en Forever (sondeo 1).
- Guías de desarrollo: [Warcraft Wiki: tu primer addon con Ace3](https://warcraft.wiki.gg/wiki/WelcomeHome:_Your_first_Ace3_Addon), [Creating a slash command](https://wowpedia.fandom.com/wiki/Creating_a_slash_command), [Ace3 for Dummies](https://wowpedia.fandom.com/wiki/Ace3_for_Dummies), [better-addons.com](https://www.better-addons.com/ai-coding-guide/), [plantilla de addon de Midnight: publicación](https://wow-midnight-addon-template.vercel.app/publishing/), [BigWigs packager](https://github.com/BigWigsMods/packager) y [su uso con GitHub Actions](https://warcraft.wiki.gg/wiki/Using_the_BigWigs_Packager_with_GitHub_Actions).
- Ya investigado: Settings API, addon compartment, LibEditMode y estilo (`docs/research.md`).

## Lo que hacen los addons buenos
1. **Funcionan nada más instalarlos**, con valores por defecto sensatos y poco intrusivos. Lo opcional empieza apagado (Hekili oculta cooldowns, interrupciones y defensivas hasta que tú los activas).
2. **De lo simple a lo avanzado:** lo básico, a la vista; lo avanzado, separado y avisado.
3. **Un tooltip en cada opción** que explica qué hace.
4. **Un mensaje de bienvenida una sola vez**, guardado en SavedVariables, y nada de mensajes en el chat por defecto.
5. **Pocos comandos para el usuario:** uno abre las opciones y otro genera un **informe de errores** (`/fc report`, instantáneas de Hekili). Las herramientas de desarrollo no están a la vista.
6. **Un informe de errores copiable:** la instantánea del momento del fallo. Los errores de Lua se envían a BugSack/BugGrabber (`geterrorhandler()`) en lugar de imprimirse en el chat.
7. **Una tabla de valores por defecto y migraciones** al cambiar de versión, sin perder los ajustes del usuario. Y una forma de restablecerlo todo.
8. **Separan lo de la cuenta y lo del personaje.** Con AceDB, perfiles por personaje, clase o reino, con copiar y restablecer.
9. **Idiomas desde el principio:** el inglés por defecto y traducciones. Ningún texto fijo en el código.
10. **Respetan la interfaz de Blizzard:** Modo edición, panel de opciones, menú de addons del minimapa y estilo coherente.
11. **Una publicación profesional:** README para el usuario, LICENSE, CHANGELOG, `.pkgmeta`, BigWigs packager con GitHub Actions, Luacheck, capturas, `## Version: @project-version@`, `X-Curse-Project-ID`, `X-Wago-ID`, `Notes` traducidas.
12. **Rendimiento:** agrupar eventos que llegan en ráfaga (por ejemplo `SPELLS_CHANGED`) con un temporizador; nada de `OnUpdate` si un evento basta.

## Lo que le falta a Paladin for Dummies
| # | Problema | Por qué importa para un usuario cualquiera |
|---|---|---|
| 1 | **Se carga y actúa con cualquier clase** | Un guerrero vería la ventana de sellos y recomendaciones sin sentido |
| 2 | **Todo está pensado para Retribución con Unsealed Wrath** | Un paladín Sagrado, tanque o de nivel bajo recibe recomendaciones y macros que no le sirven |
| 3 | **Las peleas y ajustes son de cuenta**, no del personaje | Dos paladines de la misma cuenta mezclan estadísticas y posiciones |
| 4 | **No hay primeros pasos ni bienvenida** | Quien lo instala no sabe qué es la ventana ni qué hacer |
| 5 | **Por defecto el chat se llena tras cada pelea** | Es lo primero que la gente desactiva o lo que hace que desinstale |
| 6 | **Los comandos de desarrollo están a la vista** (`debug`, `ui`, `echo debug`, `test`, `spec`, `quiet`…) | Confunden; los addons buenos dejan uno o dos comandos |
| 7 | **No hay forma de informar de un error** | Sin `report`, un fallo de otro jugador no se puede diagnosticar |
| 8 | **Los errores se imprimen en el chat** en vez de ir a BugSack | Molesto y poco estándar |
| 9 | **No hay valores por defecto centralizados ni migraciones** | Cada versión cambia claves a mano (`hidden`, `echo`, `quiet`, `macros`…) |
| 10 | **Todo en español fijo**, incluidos los nombres de las macros ("PFD Golpe") y los porqués de las reglas | La mayoría de jugadores no habla español |
| 11 | **El estilo es improvisado y distinto entre el asesor y el widget** | Se nota "casero" |
| 12 | **Se mueve con comandos o arrastrando**, no con el Modo edición | No sigue la convención actual |
| 13 | **No hay README de usuario, licencia, changelog ni empaquetado**; PalaProbe y los documentos internos están en la misma carpeta del repo | No se puede publicar tal cual |
| 14 | **El autor del `.toc` es tu nombre real** y las notas dicen "(en desarrollo)" | Hay que decidir cómo firmarlo al publicarlo |
| 15 | **`refresh()` se ejecuta con cada evento**, también en ráfagas | Trabajo de más; lo normal es agrupar |

Lo que ya está bien: arquitectura con core probado, TDD, uso de spellID, respeto de los valores secret, panel de opciones nativo, menú del minimapa e icono.

## Plan propuesto (por orden)
1. **Base pública:** desactivarse con otras clases; activar las funciones según spec y talentos (el widget solo con Unsealed Wrath; las macros solo con sus hechizos); datos y posiciones por personaje; tabla de valores por defecto y migraciones; valores por defecto poco intrusivos (sin resumen en el chat); bienvenida una sola vez con "primeros pasos"; comandos de usuario reducidos a `/pfd` (opciones), `/pfd report` (informe copiable) y `/pfd help`, con los de desarrollo tras un modo desarrollador; errores enviados a BugSack; agrupar eventos.
2. **Idiomas:** inglés por defecto y español, incluidos los nombres de las macros y los porqués de las reglas.
3. **Estilo visual unificado** (fase 2).
4. **Modo edición** (fase 3).
5. **Publicación:** README de usuario con capturas, LICENSE, CHANGELOG, `.pkgmeta` (sin PalaProbe, `docs/`, `spec/` ni `CLAUDE.md`), BigWigs packager con GitHub Actions, Luacheck, `@project-version@` e IDs de CurseForge y Wago.

## Decisiones pendientes
- **¿Ace3 o API nativa?** Ace3 (AceDB, AceConfig, AceLocale) da perfiles, opciones y traducciones probadas por miles de addons, pero añade librerías. La API nativa es más ligera y ya la usamos, pero los perfiles y las traducciones habría que hacerlos a mano.
- **Firma del autor** al publicar.
