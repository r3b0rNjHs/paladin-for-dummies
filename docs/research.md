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
