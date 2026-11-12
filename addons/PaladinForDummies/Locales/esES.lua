-- Español. Las claves que falten se muestran en inglés.
local _, ns = ...

ns.Locales.register("esES", {
  WELCOME_1 = "¡Bienvenido! La ventanita muestra el sello y la Sentencia que convienen contra tu objetivo antes del pull. Pasa el ratón por los iconos para ver por qué.",
  WELCOME_2 = "Escribe |cffffd100/pfd|r para las opciones (o usa el menú de addons del minimapa).",
  NOT_A_PALADIN = "Este addon es solo para paladines; en este personaje se queda inactivo.",
  HELP_HEADER = "Comandos:",
  HELP_OPTIONS = "|cffffd100/pfd|r: abrir las opciones",
  HELP_STATS = "|cffffd100/pfd stats|r: estadísticas de tus peleas",
  HELP_REPORT = "|cffffd100/pfd report|r: informe para copiar y adjuntar al avisar de un error",
  HELP_DEV = "Modo desarrollador: debug | ui | echodebug | test A|B|off | spec ret|prot|holy|auto",
  OPTIONS_AFTER_COMBAT = "No se pueden abrir las opciones en combate: se abrirán al terminar la pelea.",
  OPTIONS_UNAVAILABLE = "No se pudo abrir el panel de opciones. Escribe /pfd help para ver los comandos.",
  DEV_ONLY = "Ese comando necesita el modo desarrollador (Opciones → Avanzado).",

  OPT_INTRO = "Paladin for Dummies te ayuda a elegir sellos y Sentencias, muestra las copias de Unsealed Wrath y guarda estadísticas de tus peleas. Todo es opcional.",
  OPT_SHOW = "Mostrar",
  OPT_LOCK = "Bloquear posición",
  OPT_LOCK_DESC = "Evita arrastrarla sin querer. Los tooltips siguen funcionando.",
  OPT_SCALE = "Tamaño",
  OPT_RESET_POSITION = "Restablecer posición",

  OPT_ADVISOR = "Asesor",
  OPT_ADVISOR_DESC = "Antes de cada pull, una ventanita muestra con qué sello pelear y qué sello juzgar. Se congela durante el combate.",
  OPT_ADVISOR_SHOW_DESC = "La ventana con el sello y la Sentencia recomendados.",

  OPT_ECHO = "Unsealed Wrath",
  OPT_ECHO_DESC = "Con el talento Unsealed Wrath, tus golpes guardan copias de tu sello. Este indicador las muestra y se ilumina cuando toca cambiar de sello. Solo aparece mientras tienes copias.",
  OPT_ECHO_SHOW_DESC = "Echo of Command y Echo of Righteousness, con el aviso de cambio.",
  OPT_ECHO_MOVE = "Mover",
  OPT_ECHO_MOVE_DESC = "Muestra un recuadro para arrastrarlo. Pulsa otra vez para fijarlo.",
  ECHO_UNLOCKED = "Indicador desbloqueado: arrástralo y fíjalo con clic derecho o pulsando Mover otra vez.",
  ECHO_DRAG_HINT = "Arrastra para moverlo · clic derecho o pulsa Mover otra vez para fijarlo",
  ECHO_LOCKED = "Indicador fijado en su sitio.",
  ECHO_RESET = "Indicador de vuelta a su sitio inicial.",

  OPT_MACROS = "Macros",
  OPT_MACROS_DESC = "Macros de personaje escritas con los nombres de hechizo de tu cliente. La mayoría lanzan sobre el aliado bajo el ratón (o sobre ti) sin cambiar tu objetivo enemigo. Tú eliges cuáles crear: hay 18 huecos de macros de personaje.",
  OPT_MACROS_AUTO = "Crear y mantener al día",
  OPT_MACROS_AUTO_DESC = "Crea las macros marcadas y las actualiza fuera de combate cuando aprendes rangos nuevos.",
  OPT_MACROS_NOW = "Crear o actualizar ahora",
  OPT_MACROS_LIST = "Qué macros",
  OPT_MACRO_TOGGLE_DESC = "Desmarcada, el addon ni la crea ni la actualiza. Nunca borra macros: quítala desde /macro si quieres.",

  OPT_REVIEW = "Repaso del combate",
  OPT_REVIEW_DESC = "Cada pelea se guarda en este personaje: sellos usados, Sentencias, Holy Strike y activaciones de Seal of Command.",
  OPT_REVIEW_CHAT = "Resumen en el chat tras cada pelea",
  OPT_REVIEW_STATS = "Mostrar estadísticas",
  OPT_REVIEW_RESET = "Borrar peleas guardadas",
  OPT_REVIEW_RESET_CONFIRM = "¿Borrar todas las peleas guardadas de este personaje?",
  FIGHTS_DELETED = "Peleas guardadas borradas.",

  OPT_ADVANCED = "Avanzado",
  OPT_LANGUAGE = "Idioma",
  OPT_LANGUAGE_DESC = "Se aplica tras /reload.",
  OPT_LANGUAGE_AUTO = "Automático (idioma del juego)",
  OPT_DEV = "Modo desarrollador",
  OPT_DEV_DESC = "Activa comandos de diagnóstico y muestra los errores en el chat.",
  OPT_REPORT = "Informe de errores",
  OPT_REPORT_DESC = "Abre un texto para copiar con tu configuración y los últimos errores, para adjuntarlo al avisar de un fallo.",
  OPT_RESET_ALL = "Restablecer ajustes",
  OPT_RESET_ALL_CONFIRM = "¿Restablecer todos los ajustes de este perfil a sus valores por defecto?",
  OPT_PROFILES = "Perfiles",

  REPORT_TITLE = "Paladin for Dummies: informe de errores",
  REPORT_HINT = "Pulsa Ctrl+A y Ctrl+C para copiarlo.",

  ADVISOR_SEAL = "Sello",
  ADVISOR_JUDGEMENT = "Sentencia",
  TIP_BEFORE_PULL = "Antes del pull",
  TIP_WHY = "Por qué",
  STEP_APPLY = "Ponte %s",
  STEP_JUDGE = "Lanza %s sobre el objetivo",
  STEP_SWITCH = "Cambia a %s para la pelea",
  CONF_MECHANIC = "Sale de la mecánica del hechizo",
  CONF_CONSENSUS = "Consenso de guías (aún sin medir)",
  CONF_MEASURED = "Medido con tus peleas",
  TIP_TEST = "Prueba en marcha: %s",
  TIP_NO_ADVICE = "Aún no hay consejo: selecciona un enemigo.",
  ECHO_SWITCH = "¡CAMBIA!",
  ECHO_BACK = "¡VUELVE!",
  OPT_VISIBILITY = "Cuándo se ve",
  OPT_VISIBILITY_DESC = "El consejo es para antes del pull: con un enemigo seleccionado se ve entero y en combate se aparta.",
  OPT_VIS_FADE = "Atenuado sin objetivo",
  OPT_VIS_HIDE = "Solo con un enemigo seleccionado",
  OPT_VIS_ALWAYS = "Siempre, también en combate",
  OPT_REDUCE_MOTION = "Reducir animaciones",
  OPT_REDUCE_MOTION_DESC = "Sin latidos en los avisos. Se aplica tras /reload.",

  WELCOME_1_FUN = "¡Bienvenido, paladín! Sí, tú: el que lleva tres sellos en la barra y no sabe cuál pulsar. Esta ventanita te lo dice antes de cada pull. Pasa el ratón por los iconos para ver el porqué. Sin juzgarte (para eso está Judgement).",
  NOT_A_PALADIN_FUN = "Esto es solo para paladines. Bonito personaje, pero aquí no hay sellos que vigilar. Me quedo calladito.",
  TIP_NO_ADVICE_FUN = "Selecciona a un enemigo. Pegarle al aire no cuenta como entrenar.",
  OPTIONS_AFTER_COMBAT_FUN = "¿Abrir las opciones en mitad de la pelea? Valiente. El juego no te deja: te las abro en cuanto el bicho deje de pegarte.",
  FIGHTS_DELETED_FUN = "Peleas borradas. Nadie sabrá nunca lo de aquel múrloc.",
  DEV_ONLY_FUN = "Ese comando es para gente con bata de laboratorio (modo desarrollador, en Opciones → Avanzado).",
  ECHO_LOCKED_FUN = "Indicador fijado. Firme como un paladín a mitad de un Bubble Hearth.",
  ECHO_RESET_FUN = "Indicador de vuelta a casa. Más rápido que un Bubble Hearth.",
  OPT_INTRO_FUN = "Paladin for Dummies: porque nadie nace sabiendo qué sello poner. Consejo antes del pull, avisos de Unsealed Wrath en combate y un repaso cariñoso de tus peleas. Todo es opcional, como el casco.",
  OPT_TONE = "Tono",
  OPT_TONE_DESC = "Con humor, algunos mensajes llevan su chiste. Los avisos siempre van en serio. Algunos textos cambian tras /reload.",
  OPT_TONE_FUN = "Con humor",
  OPT_TONE_PLAIN = "Serio",

  WHY_HUMANOID_JUSTICE = "Los humanoides huyen con poca vida; Justice los aturde y su Sentencia impide que huyan.",
  WHY_RET_COMMAND = "Command golpea por el 74 % del daño del arma: es el sello de daño de Retribución.",
  WHY_PREPULL_CRUSADER = "La Sentencia ya no consume el sello: juzga Crusader antes del pull (el objetivo recibe más daño Sagrado durante 40 s) y cambia a tu sello de daño.",
  WHY_FALLBACK_RIGHTEOUSNESS = "Righteousness está disponible desde el nivel 1 y añade daño Sagrado a cada golpe.",

  OPT_GUIDE_HINT = "¿Nuevo con el paladín? Abre la |cfff2c14eGuía|r, justo debajo en la lista: sellos, Sentencia, Unsealed Wrath, qué hacer en cada situación y tus propios números.",
  OPT_GUIDE = [==[Guía]==],
  SPELL_WISDOM = [==[Sello de sabiduría]==],
  SPELL_JUSTICE = [==[Sello de justicia]==],
  SPELL_FURY = [==[Sello de furia]==],
  GUIDE_PLAN_TITLE = [==[Tu plan]==],
  GUIDE_PLAN_INTRO = [==[Esto es lo que te toca hacer con lo que sabes ahora (nivel %s). Se actualiza solo cuando aprendes hechizos nuevos.]==],
  GUIDE_PLAN_H_BEFORE = [==[Antes de pelear]==],
  GUIDE_PLAN_SEAL_ONLY = [==[Ponte {RIGHTEOUSNESS}. Es tu sello: hace que cada golpe pegue más.]==],
  GUIDE_PLAN_PREPULL_1 = [==[|cfff2c14e1.|r Ponte {CRUSADER}.]==],
  GUIDE_PLAN_PREPULL_2 = [==[|cfff2c14e2.|r Selecciona al enemigo y lánzale {JUDGEMENT}. Durante 40 s recibirá más daño Sagrado.]==],
  GUIDE_PLAN_PREPULL_3 = [==[|cfff2c14e3.|r Ponte {DAMAGE_SEAL} y a por él. Es tu sello para la pelea.]==],
  GUIDE_PLAN_H_DURING = [==[Durante la pelea]==],
  GUIDE_PLAN_JUDGE = [==[Lanza {JUDGEMENT} cada vez que esté listo (cada 8 s). No te quita el sello: úsalo sin miedo.]==],
  GUIDE_PLAN_STRIKE = [==[Lo mismo con {HOLY_STRIKE} (cada 10 s). Truco: la macro PFD Golpe lanza los dos con una sola tecla.]==],
  GUIDE_PLAN_UNSEALED = [==[¿Tienes el talento Unsealed Wrath? Mira el indicador: con ¡CAMBIA! ponte {RIGHTEOUSNESS} y da un golpe; con ¡VUELVE!, otra vez {COMMAND}. Lo explica el capítulo Unsealed Wrath.]==],
  GUIDE_PLAN_REFRESH = [==[El sello dura 30 s. Si se te acaba, vuelve a ponerte {DAMAGE_SEAL}: sin sello pegas mucho menos.]==],
  GUIDE_PLAN_H_NEXT = [==[Lo próximo]==],
  GUIDE_PLAN_NEXT_CRUSADER = [==[A nivel 6 aprenderás {CRUSADER}. Tu plan ganará un paso antes de cada pelea.]==],
  GUIDE_PLAN_NEXT_STRIKE = [==[Pronto aprenderás {HOLY_STRIKE}: un golpe extra que podrás usar cada 10 s.]==],
  GUIDE_PLAN_NEXT_COMMAND = [==[Si vas por la rama de Retribución, a nivel 20 el talento {COMMAND} será tu sello para pegar.]==],
  GUIDE_HELP_TITLE = [==[Cómo te ayuda el addon]==],
  GUIDE_HELP_BEFORE = [==[|cfff2c14eAntes de pelear|r
Una ventanita con dos iconos: el sello con el que pelear y el que conviene lanzar con {JUDGEMENT} antes de empezar. Pasa el ratón por encima para ver los pasos.]==],
  GUIDE_HELP_DURING = [==[|cfff2c14eDurante la pelea|r
Si tienes Unsealed Wrath, un icono te dice cuándo cambiar de sello: ¡CAMBIA! y ¡VUELVE!.]==],
  GUIDE_HELP_AFTER = [==[|cfff2c14eDespués|r
Guarda tus peleas. En el capítulo Tus peleas ves qué tal lo haces.]==],
  GUIDE_HELP_H_ICONS = [==[Qué significan los colores]==],
  GUIDE_HELP_COLORS = [==[|cfff2c14eAnillo dorado|r: lo que te recomiendo.
|cffe5484dBorde rojo y "!"|r: te falta algo.
|cfff5a524Ámbar|r: está a punto de acabarse.]==],
  GUIDE_HELP_SOURCES = [==[En la ventanita que sale al pasar el ratón, un cuadradito dice de dónde sale el consejo:
|TInterface\Buttons\WHITE8X8:10:10:0:0:8:8:0:8:0:8:156:195:240|t de cómo funciona el hechizo
|TInterface\Buttons\WHITE8X8:10:10:0:0:8:8:0:8:0:8:245:165:36|t de lo que recomiendan las guías
|TInterface\Buttons\WHITE8X8:10:10:0:0:8:8:0:8:0:8:70:167:88|t de tus propias peleas]==],
  GUIDE_HELP_JOKE = [==[Nadie nace sabiendo qué sello poner. Bueno, quizá Uther. Tú tranquilo.]==],
  GUIDE_BASICS_TITLE = [==[Sellos y Sentencia]==],
  GUIDE_BASICS_H_SEAL = [==[¿Qué es un sello?]==],
  GUIDE_BASICS_SEAL = [==[Un hechizo que te pones a ti mismo. Dura 30 s y mejora tus golpes: más daño, curarte, recuperar maná...

Solo puedes llevar uno a la vez. Si te pones otro, el anterior se quita.]==],
  GUIDE_BASICS_H_JUDGEMENT = [==[¿Y la Sentencia?]==],
  GUIDE_BASICS_JUDGEMENT = [==[{JUDGEMENT} es un hechizo que lanzas al enemigo. Lo que le hace depende del sello que lleves en ese momento: un golpe de daño, un efecto que dura 40 s...

No te quita el sello: lo sigues llevando.]==],
  GUIDE_BASICS_H_RULES = [==[Tres cosas que conviene saber]==],
  GUIDE_BASICS_RULE_ONE = [==[|cfff2c14eSolo cuenta tu última Sentencia.|r
Si lanzas {JUDGEMENT} con otro sello, la anterior desaparece del enemigo.]==],
  GUIDE_BASICS_RULE_PREPULL = [==[|cfff2c14eEl truco de siempre:|r ponte {CRUSADER}, lánzale {JUDGEMENT} al enemigo y luego cámbiate al sello con el que vas a pelear.]==],
  GUIDE_BASICS_RULE_STRIKE = [==[|cfff2c14eÚsalos en cuanto estén listos.|r
{JUDGEMENT} cada 8 s y {HOLY_STRIKE} cada 10 s. Si los dejas esperando, pierdes daño.]==],
  GUIDE_BASICS_JOKE = [==[Sí, juzgar a un múrloc está permitido. Él empezó.]==],
  GUIDE_SEALS_TITLE = [==[Los sellos, uno a uno]==],
  GUIDE_SEALS_H_DAMAGE = [==[Para hacer daño]==],
  GUIDE_SEAL_RIGHTEOUSNESS = [==[{RIGHTEOUSNESS} · desde nivel 1
Cada golpe hace daño Sagrado extra. Con armas lentas, más aún.
Cuándo: es tu sello para pegar hasta que tengas {COMMAND}.]==],
  GUIDE_SEAL_COMMAND = [==[{COMMAND} · nivel 20, talento de Retribución
De vez en cuando, un golpe extra muy fuerte (unas 3 o 4 veces por minuto).
Cuándo: tu sello para pegar si vas de Retribución. Mejor con un arma lenta.]==],
  GUIDE_SEALS_H_PREPULL = [==[Para antes de empezar]==],
  GUIDE_SEAL_CRUSADER = [==[{CRUSADER} · nivel 6
Atacas más rápido, pero cada golpe pega menos.
Su Sentencia: durante 40 s el enemigo recibe más daño Sagrado.
Cuándo: lánzale {JUDGEMENT} con él puesto antes de pelear y cámbiate.]==],
  GUIDE_SEALS_H_SUSTAIN = [==[Para aguantar]==],
  GUIDE_SEAL_LIGHT = [==[{LIGHT} · nivel 30
A veces te curas al golpear.
Cuándo: si vas justo de vida.]==],
  GUIDE_SEAL_WISDOM = [==[{WISDOM} · nivel 38
A veces recuperas maná al golpear.
Cuándo: si te quedas sin maná en peleas largas.]==],
  GUIDE_SEALS_H_SPECIAL = [==[Para casos concretos]==],
  GUIDE_SEAL_JUSTICE = [==[{JUSTICE} · nivel 22
A veces aturde al enemigo 2 s, y su Sentencia le impide huir corriendo.
Cuándo: contra humanoides que huyen cuando les queda poca vida.]==],
  GUIDE_SEAL_FURY = [==[{FURY} · nivel 10, nuevo (por confirmar)
Daño Sagrado en cada golpe y un pequeño escudo. Su Sentencia hace que los enemigos cercanos te ataquen.
Cuándo: si eres el tanque del grupo.]==],
  GUIDE_SEALS_JOKE = [==[Siete sellos y una sola mano para pulsarlos. Para eso estamos.]==],
  GUIDE_UNSEALED_TITLE = [==[Unsealed Wrath]==],
  GUIDE_UNSEALED_WHAT = [==[Un talento de Retribución. Con él, cada golpe guarda una copia de tu sello (hasta 3). Cuando golpeas con otro sello distinto, todas esas copias se sueltan a la vez en ese golpe.

En resumen: cambiar de sello en el momento justo hace mucho más daño.]==],
  GUIDE_UNSEALED_H_HOW = [==[Cómo se hace, en tres pasos]==],
  GUIDE_UNSEALED_STEP_1 = [==[|cfff2c14e1. Acumula.|r Pelea con {COMMAND}. Cuando el indicador diga |cfff2c14e¡CAMBIA!|r, ya tienes 3 copias.]==],
  GUIDE_UNSEALED_STEP_2 = [==[|cfff2c14e2. Cambia y golpea.|r Ponte {RIGHTEOUSNESS} y da un golpe. Ahí se sueltan las copias.]==],
  GUIDE_UNSEALED_STEP_3 = [==[|cfff2c14e3. Vuelve.|r Cuando diga |cfff2c14e¡VUELVE!|r, ponte otra vez {COMMAND} y repite.]==],
  GUIDE_UNSEALED_SHORTCUT = [==[Atajo: la macro PFD Unsealed hace el cambio con una sola tecla. Púlsala cuando veas ¡CAMBIA! y cuando veas ¡VUELVE!.]==],
  GUIDE_UNSEALED_JOKE = [==[Es como hacer malabares, pero con sellos sagrados y un múrloc mirando.]==],
  GUIDE_SITUATIONS_TITLE = [==[Qué hacer en cada caso]==],
  GUIDE_SIT_SOLO = [==[|cfff2c14eSubiendo de nivel, tú solo|r
Sigue Tu plan. Si siempre te quedas sin maná, prueba a pelear con {WISDOM}; si sin vida, con {LIGHT}.]==],
  GUIDE_SIT_DUNGEON = [==[|cfff2c14eEn una mazmorra|r
Tu plan de siempre. Lanza {JUDGEMENT} y {HOLY_STRIKE} en cuanto estén listos y, si tienes Unsealed Wrath, haz caso al indicador.]==],
  GUIDE_SIT_GROUP = [==[|cfff2c14eCon otro paladín en el grupo|r
Hablad antes de empezar: si el grupo gasta mucho maná, que uno juzgue con {WISDOM}; si recibe mucho daño, con {LIGHT}.]==],
  GUIDE_SIT_FLEE = [==[|cfff2c14eEnemigos que huyen|r
Algunos humanoides salen corriendo con poca vida y traen a sus amigos. {HAMMER} los aturde; {JUSTICE} también ayuda.]==],
  GUIDE_SIT_UNDEAD = [==[|cfff2c14eNo-muertos y demonios|r
{EXORCISM} les hace muchísimo daño. Úsalo siempre que esté listo.]==],
  GUIDE_SIT_DANGER = [==[|cfff2c14eSi estás a punto de morir|r
{DIVINE_SHIELD} te hace inmune unos segundos. Aprovecha para curarte o para salir de ahí.]==],
  GUIDE_SIT_JOKE = [==[Situación especial: el grupo ha muerto y tú sigues vivo. Bubble Hearth. Es broma. (¿O no?)]==],
  GUIDE_MACROS_TITLE = [==[Las macros]==],
  GUIDE_MACROS_INTRO = [==[Una macro es un botón que hace varias cosas a la vez. El addon puede crearlas por ti: actívalo en Opciones → Macros y arrástralas a tu barra desde la ventana de macros (escribe /macro).]==],
  GUIDE_MACRO_GOLPE = [==[|cfff2c14ePFD Golpe|r
Lanza {JUDGEMENT} y {HOLY_STRIKE} con una sola tecla. Púlsala en cuanto se ilumine.]==],
  GUIDE_MACRO_UNSEALED = [==[|cfff2c14ePFD Unsealed|r
Cambia entre {COMMAND} y {RIGHTEOUSNESS}. Cada pelea empieza en {COMMAND}.]==],
  GUIDE_MACRO_SELLO = [==[|cfff2c14ePFD Sello|r
{COMMAND}; si mantienes Mayúsculas, {RIGHTEOUSNESS}.]==],
  GUIDE_MACRO_UTILITY = [==[|cfff2c14eLas de ayuda|r
Curas, protecciones, bendiciones, auras, resurrección... Van al compañero que tengas bajo el ratón (o a ti) sin perder de vista al enemigo.]==],
  GUIDE_MACROS_JOKE = [==[Tienes 18 huecos de macros de personaje. Elige con cabeza, como un paladín. Bueno, mejor que un paladín.]==],
  GUIDE_FIGHTS_TITLE = [==[Tus peleas]==],
  GUIDE_FIGHTS_EMPTY = [==[Todavía no hay peleas guardadas en este personaje. Ve a pegarle a algo y vuelve.]==],
  GUIDE_FIGHTS_COUNT = [==[Peleas guardadas: %s]==],
  GUIDE_FIGHTS_JUDGE = [==[Usas {JUDGEMENT} %s de cada 10 veces que podrías.]==],
  GUIDE_FIGHTS_STRIKE = [==[Usas {HOLY_STRIKE} %s de cada 10 veces que podrías.]==],
  GUIDE_FIGHTS_TIP = [==[Para mejorar: pulsa PFD Golpe cada vez que se ilumine. Sin esperar a nada.]==],
  GUIDE_FIGHTS_GOOD = [==[¡Muy bien! Casi no dejas pasar ninguna.]==],
  GUIDE_FIGHTS_TWIST = [==[Peleas en las que cambiaste de sello con Unsealed Wrath: %s]==],
  GUIDE_GLOSSARY_TITLE = [==[Glosario]==],
  GUIDE_GLOSSARY_TEXT = [==[|cfff2c14ePull|r: empezar la pelea ("tirar" del enemigo).

|cfff2c14eBuff|r: efecto bueno que llevas encima. |cfff2c14eDebuff|r: efecto malo sobre el enemigo.

|cfff2c14eProc|r: algo que salta por suerte al golpear.

|cfff2c14eEnfriamiento (CD)|r: el tiempo que tarda un hechizo en volver a estar listo.

|cfff2c14eTiempo global (GCD)|r: la pausa de 1,5 s después de casi cualquier hechizo.

|cfff2c14eAggro|r: a quién quiere pegar el enemigo. Spoiler: al que más le molesta.

|cfff2c14eBubble Hearth|r: ponerte {DIVINE_SHIELD} y usar la piedra de hogar. Patrimonio cultural del paladín.]==],
  GUIDE_FAQ_TITLE = [==[Preguntas frecuentes]==],
  GUIDE_FAQ_Q_COMBAT = [==[¿Por qué la ventanita desaparece al pelear?]==],
  GUIDE_FAQ_A_COMBAT = [==[Su consejo es para antes de empezar. Si la quieres ver siempre: Opciones → Asesor → Cuándo se ve.]==],
  GUIDE_FAQ_Q_AUTO = [==[¿Esto juega por mí?]==],
  GUIDE_FAQ_A_AUTO = [==[No. Ningún botón lanza nada solo y el juego no permite que un addon te diga qué pulsar en mitad de la pelea. Aquí se aprende, y luego lo haces tú.]==],
  GUIDE_FAQ_Q_SOURCE = [==[¿Me puedo fiar de los consejos?]==],
  GUIDE_FAQ_A_SOURCE = [==[Mira el cuadradito de color al pasar el ratón: azul, sale de cómo funciona el hechizo; ámbar, de lo que dicen las guías; verde, de tus propias peleas.]==],
  GUIDE_FAQ_Q_BUG = [==[Algo no funciona.]==],
  GUIDE_FAQ_A_BUG = [==[Opciones → Avanzado → Informe de errores. Cópialo y mándaselo a quien mantiene el addon. Gracias, de verdad.]==],
  GUIDE_FAQ_JOKE = [==[|cfff2c14e¿Puedo llevar dos sellos a la vez?|r
No. Lo intentaron muchos antes que tú.]==],
})
