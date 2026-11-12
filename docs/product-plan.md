# Plan de producto e interfaz (12 nov 2026)

Petición de Jorge: preparar el addon para más usuarios, rehacer la interfaz a conciencia (hoy "muy pobre") y pensar qué más necesita un paladín: nos llamamos *Paladin for Dummies*.

## 1. Qué hay ya en Forever (competencia)

| Addon | Qué hace | Cómo se ve | Notas |
|---|---|---|---|
| [Nyte Lyte's Paladin Toolkit](https://www.curseforge.com/wow/addons/nyte-lytes-paladin-toolkit) (`/ptk`, v0.9.0, ~1,8 mil descargas) | Avisos de aura, bendición y sello que faltan o caducan; sello con barra que se vacía y Echo de Twist of Light; barra de enfriamientos; kit de tanque (Righteous Fury, TAUNT en Judgement con Fury); cuadrícula de bendiciones sincronizada; botón de bendecir en una pulsación; exportar e importar | Iconos en rojo (falta) o borde amarillo (no es lo asignado); barra roja y latido en los últimos 5 s; marcos escalables del 50 al 200 % por spec | El más completo. Dice explícitamente: sin registro de combate, sin consejo de rotación |
| [PallyMe](https://www.curseforge.com/wow/addons/pallyme) (11 nov) | Aura, bendición, sello y Righteous Fury; botones de Judgement, Holy Strike y Consecration; temporizador de golpe; consejo según rol y contenido; guías "New to Paladin?" | Barras "Living Gold" o simples, texturas a elegir, iconos del juego o símbolos dorados, apilado o en fila, guías cian al desbloquear, sonidos por buff con prueba, "ocultar fuera de combate" | El más cuidado visualmente. Clic en el icono = lanzar el hechizo (botón seguro) |
| [Benediction](https://www.curseforge.com/wow/addons/benediction) (12 nov) | Reparto de bendiciones por spec, compatible con PallyPower, PP Forever y Paladin Toolkit | Barra con estilos Minimal, Compact y Detailed; celdas con color de cobertura; botón grande "siguiente bendición" | Inglés, alemán, francés y español |
| [Blessings Board](https://www.curseforge.com/wow/addons/blessings-board), [Forever: Pally Blessings Assignment](https://www.curseforge.com/wow/addons/forever-blessings), [PP Forever](https://www.curseforge.com/wow/addons/pp-forever) | Repartos de bendiciones al estilo PallyPower | Barras compactas, cuadrícula | En combate congelan la foto de antes del pull |

**Conclusión:** los avisos de buffs y el reparto de bendiciones ya están muy cubiertos. **Nadie enseña ni analiza**: ninguno explica por qué un sello, ninguno mide tus peleas y ninguno te dice qué mejorar. Ese es nuestro hueco y encaja con el nombre: *el entrenador del paladín*. No competimos en el reparto de bendiciones: si acaso, convivimos con esos addons.

## 2. Cómo hacen la interfaz los addons buenos

Fuentes: los anteriores, Hekili, ForeCast, Details!, BigWigs y las guías de interfaz de Midnight citadas en `docs/research.md` y `docs/quality-audit.md`.

1. **Silenciosa**: iconos y barras, sin fondos grandes ni marcos de tooltip. La información compite con el juego, no al revés.
2. **Un lenguaje visual de estados**, siempre igual: listo, falta (rojo), caduca (borde y latido), no es lo previsto (amarillo). Movimiento solo cuando hay que actuar, con opción de reducirlo.
3. **Se ve solo cuando sirve**: atenuado u oculto fuera de combate sin objetivo; en combate, solo lo que se puede usar.
4. **Todo se mueve, se escala y se bloquea igual**, a ser posible con el **Modo edición** de Blizzard ([LibEditMode](https://www.curseforge.com/wow/addons/libeditmode): compatible con 12.0; en Forever sin confirmar). Posiciones por spec.
5. **Estilos a elegir** (Minimal, Compact y Detailed en Benediction; Living Gold y Basic en PallyMe), con un buen valor por defecto.
6. **Primeros pasos**: guía para nuevos ("New to Paladin?" de PallyMe), bienvenida una sola vez.
7. **Sonido opcional por aviso**, con botón de prueba.
8. **Atajos de teclado** en el menú de Blizzard (Key Bindings → AddOns).
9. **Exportar e importar** la configuración como texto.
10. **Ventana principal propia** para lo que no es un ajuste (Details!, Benediction): el panel de opciones de Blizzard es para ajustes, no para contenido.

## 3. Sistema de diseño de Paladin for Dummies

Para que todo se vea de la misma familia (fase 2 de presentación):

- **Colores**
  - Oro sagrado `#F2C14E` para acentos y para lo que hay que hacer ya.
  - Rosa del paladín `#F48CBA` solo para la marca (título y logo).
  - Fondos negros al 55-70 %, borde de 1 px negro.
  - Rojo `#E5484D` = falta; ámbar `#F5A524` = caduca o no es lo previsto; verde `#46A758` = bien hecho (solo en el repaso).
- **Iconos**
  - Recorte `SetTexCoord(0.08, 0.92, 0.08, 0.92)`, borde de 1 px y 2 px de separación.
  - Tamaños de 28, 36 y 48 px según el estilo.
  - Insignia en una esquina para "el sello que se juzga".
- **Texto**
  - Fuentes de Blizzard (`GameFontNormal*`, `NumberFontNormal*`) con contorno.
  - Nada de texto dentro del HUD salvo números y avisos de una palabra.
  - Las explicaciones van en el tooltip o en la ventana.
- **Tooltips**
  - Título en oro, una línea de "qué hacer", una de "por qué" y la confianza (mecánica, guías o **medido con tus peleas**) con un pequeño color.
- **Movimiento**
  - Un latido suave solo para "¡CAMBIA!" o "¡VUELVE!" y para lo que falta antes del pull. Opción "reducir animaciones".
- **Estados del HUD**
  - Fuera de combate sin objetivo: atenuado al 40 % o se oculta (a elegir).
  - Con objetivo atacable: el asesor a plena vista.
  - En combate: solo Unsealed Wrath y los avisos que se pueden atender.

## 4. Nueva estructura de la interfaz

1. **HUD** (un solo bloque movible, o cada módulo por separado):
   - **Asesor de sello y Sentencia** (lo de ahora, con el nuevo estilo).
   - **Unsealed Wrath** (lo de ahora).
   - **Centinela**: sello, aura, bendición propia y Righteous Fury que faltan antes del pull.
2. **Tarjeta tras la pelea** (sustituye al resumen en el chat):
   - Un aviso pequeño que aparece unos segundos con una o dos claves ("Juzgaste 4 de 6 veces posibles") y se abre con un clic.
3. **Ventana principal** (`/pfd`, menú del minimapa), con pestañas:
   - **Hoy**: qué te recomiendo y por qué, paso a paso.
   - **Peleas**: historial y evolución.
   - **Macros**: lista con su explicación; se arrastran a la barra.
   - **Aprende**: el códice.
   - **Ajustes**: abre el panel de Blizzard.
4. **Primeros pasos**: un asistente de tres pantallas la primera vez: qué es cada cosa, dónde está y qué macros quieres.

## 5. Qué más puede hacer por un paladín (ideas, por valor y viabilidad)

Viabilidad: ✅ se puede con lo que sabemos · 🔍 hay que sondearlo en Forever · ⛔ límite técnico.

| # | Idea | Para quién | Viabilidad |
|---|---|---|---|
| 1 | **Entrenador de peleas**: tras cada pelea, de 1 a 3 consejos medidos: Sentencias hechas frente a las posibles (8 s), Holy Strike frente a las posibles (10 s), tiempo sin sello, si juzgaste antes del pull, ritmo de cambio con Unsealed Wrath | Todos | ✅ con la `timeline` que ya guardamos |
| 2 | **Comparativa propia con el medidor de daño**: "con cambio de sellos haces un X % más que solo con Command", por arma y nivel | Ret | ✅ desde la v0.9.7, pendiente de probar en el juego |
| 3 | **Centinela antes del pull**: sin sello, sin aura, sin tu bendición, sin Righteous Fury de tanque | Todos | ✅ fuera de combate (auras propias legibles) |
| 4 | **¿Lo tienes en la barra?**: avisa si Judgement, tu sello o las macros PFD no están en tus barras y te deja arrastrarlas desde la ventana | Nuevos | 🔍 `C_ActionBar.FindSpellActionButtons`, `PickupMacro` |
| 5 | **Visita al instructor**: al subir de nivel, qué rangos nuevos puedes aprender y que las macros se actualizarán solas | Subiendo de nivel | 🔍 ¿el grimorio de Forever muestra los hechizos aún no aprendidos? Si no, tabla de rangos por nivel |
| 6 | **Guía de talentos**: el siguiente punto recomendado para tu rama, con su porqué | Subiendo de nivel | 🔍 API de talentos de Forever |
| 7 | **Consejos de situación en mundo abierto**: no-muerto o demonio → Exorcism; humanoide que huye → Justice | Todos | ✅ solo fuera de mazmorras (allí el tipo es secret) |
| 8 | **Tooltips "para dummies"**: una línea de consejo en el tooltip de cada hechizo de paladín | Nuevos | 🔍 el hook de tooltips puede dar secrets en combate: solo fuera de combate |
| 9 | **El códice**: qué es un sello, qué es la Sentencia, Unsealed Wrath, auras, bendiciones, con ejemplos y lo medido por ti | Nuevos | ✅ es contenido |
| 10 | **Ayudante de resurrección**: tras un wipe, la lista de muertos del grupo con un botón para Redemption | Todos | ✅ botón seguro configurado fuera de combate |
| 11 | **Holy y Protección de verdad**: reglas, macros y avisos propios (Fury, Righteous Fury, Holy Shield, Consecration) | Más usuarios | 🔍 faltan los IDs de spec y los hechizos de esas ramas |
| 12 | **Avisos con sonido opcional** y "reducir animaciones" | Todos | ✅ |
| 13 | **Exportar e importar** la configuración | Todos | ✅ |
| 14 | Reparto de bendiciones | Grupos | Ya lo hacen otros: no duplicarlo. Como mucho, leer su reparto |
| 15 | Consejo de rotación en combate en tiempo real | — | ⛔ y contra el principio de Blizzard |

## Decisión de Jorge (12 nov)
- Sí a las ideas 1, 2, 4, 5, 6 y 7. La 8 (Holy y Protección), más adelante. La 3 (¿lo tienes en la barra?), no.
- Dirección visual de las maquetas aprobada.
- **Tono con humor y satírico** (nos llamamos *for Dummies*): chistes en bienvenida, mensajes vacíos, tarjeta tras la pelea y códice; nunca en los avisos que hay que atender. Opción para ponerlo serio.

## 6. Plan propuesto

1. **Sistema de diseño y HUD nuevo**: rehacer el asesor y Unsealed Wrath con el estilo común, los estados (atenuado, con objetivo, en combate) y la tarjeta tras la pelea. Probar en el juego.
2. **Ventana principal** con Hoy, Peleas y Macros; primeros pasos.
3. **Entrenador de peleas** (idea 1) y **centinela** (idea 3): lo más valioso con lo que ya sabemos.
4. **Sondeo 2** para las ideas 🔍 (barras, grimorio de hechizos no aprendidos, talentos, tooltips, LibEditMode en Forever, IDs de Holy y Protección).
5. **Idiomas completos** (todo lo nuevo nace ya en inglés y español).
6. **Modo edición** (LibEditMode) si el sondeo lo confirma.
7. **Aprende** (códice), comparativa de daño, instructor, talentos, resurrección, Holy y Protección.
8. **Publicación.**
