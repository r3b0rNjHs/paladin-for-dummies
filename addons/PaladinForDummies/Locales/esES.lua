-- Español. Las claves que falten se muestran en inglés.
local _, ns = ...

ns.Locales.register("esES", {
  WELCOME_1 = [==[¡Bienvenido! Antes de cada pelea, si te falta algo (el sello que toca, tu aura, tu bendición...), aparecerá un aviso con su icono. Pasa el ratón por encima para ver qué hacer. Y abre la Guía en /pfd: empieza por Tu plan.]==],
  WELCOME_2 = "Escribe |cffffd100/pfd|r para la ventana principal (o usa el menú de addons del minimapa), y |cffffd100/pfd opciones|r para los ajustes.",
  NOT_A_PALADIN = "Este addon es solo para paladines; en este personaje se queda inactivo.",
  HELP_HEADER = "Comandos:",
  HELP_OPTIONS = "|cffffd100/pfd|r: ventana principal · |cffffd100/pfd opciones|r: ajustes",
  HELP_STATS = "|cffffd100/pfd stats|r: estadísticas de tus peleas",
  HELP_REPORT = "|cffffd100/pfd report|r: informe para copiar y adjuntar al avisar de un error",
  HELP_DEV = "Modo desarrollador: debug | ui | echodebug | test A|B|off | spec ret|prot|holy|auto",
  OPTIONS_AFTER_COMBAT = "No se pueden abrir las opciones en combate: se abrirán al terminar la pelea.",
  OPTIONS_UNAVAILABLE = "No se pudo abrir el panel de opciones. Escribe /pfd help para ver los comandos.",
  DEV_ONLY = "Ese comando necesita el modo desarrollador (Opciones > Avanzado).",

  OPT_INTRO = "Paladin for Dummies te ayuda a elegir sellos y Sentencias, muestra las copias de Unsealed Wrath y guarda estadísticas de tus peleas. Todo es opcional.",
  OPT_SHOW = "Mostrar",
  OPT_SCALE = "Tamaño",
  OPT_RESET_POSITION = "Restablecer posición",

  OPT_ADVISOR = [==[Aviso antes del pull]==],
  OPT_ADVISOR_DESC = [==[Con un enemigo seleccionado y fuera de combate, te avisa solo si te falta algo: el sello que toca, tu aura, tu bendición, Righteous Fury si tanqueas, o un consejo para ese enemigo. Si todo está bien, no ves nada.]==],
  OPT_ADVISOR_SHOW_DESC = [==[Los iconos que aparecen cuando te falta algo antes de pelear.]==],

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
  OPT_REDUCE_MOTION = "Reducir animaciones",
  OPT_REDUCE_MOTION_DESC = "Sin latidos en los avisos. Se aplica tras /reload.",

  WELCOME_1_FUN = [==[¡Bienvenido, paladín! Sí, tú: el que lleva tres sellos en la barra y no sabe cuál pulsar. Antes de cada pelea te avisaré si se te olvida algo, como un buen escudero. Y en /pfd tienes la Guía: empieza por Tu plan. Sin juzgarte (para eso está Judgement).]==],
  NOT_A_PALADIN_FUN = "Esto es solo para paladines. Bonito personaje, pero aquí no hay sellos que vigilar. Me quedo calladito.",
  TIP_NO_ADVICE_FUN = "Selecciona a un enemigo. Pegarle al aire no cuenta como entrenar.",
  OPTIONS_AFTER_COMBAT_FUN = "¿Abrir las opciones en mitad de la pelea? Valiente. El juego no te deja: te las abro en cuanto el bicho deje de pegarte.",
  FIGHTS_DELETED_FUN = "Peleas borradas. Nadie sabrá nunca lo de aquel múrloc.",
  DEV_ONLY_FUN = "Ese comando es para gente con bata de laboratorio (modo desarrollador, en Opciones > Avanzado).",
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
Con un enemigo seleccionado, si te falta algo aparece su icono: el sello que toca, tu aura, tu bendición o un consejo para ese enemigo. Pasa el ratón por encima para ver qué hacer. Si todo está bien, no aparece nada.]==],
  GUIDE_HELP_DURING = [==[|cfff2c14eDurante la pelea|r
Si tienes Unsealed Wrath, un icono te dice cuándo cambiar de sello: ¡CAMBIA! y ¡VUELVE!.]==],
  GUIDE_HELP_AFTER = [==[|cfff2c14eDespués|r
Guarda tus peleas. En el capítulo Tus peleas ves qué tal lo haces.]==],
  GUIDE_HELP_H_ICONS = [==[Qué significan los colores]==],
  GUIDE_HELP_COLORS = [==[|cfff2c14eAnillo dorado|r: lo que te recomiendo.
|cffe5484dBorde rojo y "!"|r: te falta algo.
|cfff5a524Ámbar|r: está a punto de acabarse.]==],
  GUIDE_HELP_SOURCES = [==[Al pasar el ratón por un aviso, un cuadradito dice de dónde sale el consejo:
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
  GUIDE_MACROS_INTRO = [==[Una macro es un botón que hace varias cosas a la vez. El addon puede crearlas por ti: actívalo en Opciones > Macros y arrástralas a tu barra desde la ventana de macros (escribe /macro).]==],
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
  GUIDE_FAQ_Q_COMBAT = [==[¿Por qué casi nunca veo el aviso?]==],
  GUIDE_FAQ_A_COMBAT = [==[¡Buena señal! Solo aparece cuando, con un enemigo seleccionado, te falta algo antes de pelear. En combate se aparta. Si quieres cambiarlo de sitio: Opciones > Aviso antes del pull > Mover.]==],
  GUIDE_FAQ_Q_AUTO = [==[¿Esto juega por mí?]==],
  GUIDE_FAQ_A_AUTO = [==[No. Ningún botón lanza nada solo y el juego no permite que un addon te diga qué pulsar en mitad de la pelea. Aquí se aprende, y luego lo haces tú.]==],
  GUIDE_FAQ_Q_SOURCE = [==[¿Me puedo fiar de los consejos?]==],
  GUIDE_FAQ_A_SOURCE = [==[Mira el cuadradito de color al pasar el ratón: azul, sale de cómo funciona el hechizo; ámbar, de lo que dicen las guías; verde, de tus propias peleas.]==],
  GUIDE_FAQ_Q_BUG = [==[Algo no funciona.]==],
  GUIDE_FAQ_A_BUG = [==[Opciones > Avanzado > Informe de errores. Cópialo y mándaselo a quien mantiene el addon. Gracias, de verdad.]==],
  GUIDE_FAQ_JOKE = [==[|cfff2c14e¿Puedo llevar dos sellos a la vez?|r
No. Lo intentaron muchos antes que tú.]==],
  MACRO_GROUP_COMBAT = [==[Para pelear]==],
  MACRO_GROUP_HEAL = [==[Para curar y ayudar]==],
  MACRO_GROUP_SAFETY = [==[Para salir vivo]==],
  MACRO_GROUP_CONTROL = [==[Para controlar al enemigo]==],
  MACRO_GROUP_BUFFS = [==[Bendiciones y auras]==],
  OPT_MACRO_CREATE = [==[Crear]==],
  OPT_MACROS_HOW = [==[Marca las que quieras y pulsa Crear o actualizar ahora. Después escribe /macro, abre la pestaña de tu personaje y arrastra cada una a tu barra. Bajo el ratón significa el compañero sobre el que tienes el puntero, sin tener que seleccionarlo.]==],
  MACRO_DESC_GOLPE = [==[{JUDGEMENT} y {HOLY_STRIKE} con una sola tecla. Púlsala cada vez que se ilumine.]==],
  MACRO_DESC_UNSEALED = [==[Cambia entre {COMMAND} y {RIGHTEOUSNESS}; cada pelea empieza en {COMMAND}. Para Unsealed Wrath: púlsala con ¡CAMBIA! y con ¡VUELVE!.]==],
  MACRO_DESC_SELLO = [==[{COMMAND}. Con |cfff2c14eMayúsculas|r: {RIGHTEOUSNESS}.]==],
  MACRO_DESC_EXORCISMO = [==[{EXORCISM} a tu objetivo y empieza a atacar. Ideal contra no-muertos y demonios.]==],
  MACRO_DESC_CURA = [==[{FLASH_OF_LIGHT} al compañero bajo el ratón (o a ti). Con |cfff2c14eMayúsculas|r: {HOLY_LIGHT}, más lenta y más fuerte.]==],
  MACRO_DESC_PURIFICAR = [==[{PURIFY} al compañero bajo el ratón (o a ti): quita venenos y enfermedades.]==],
  MACRO_DESC_LIBERTAD = [==[{FREEDOM} al compañero bajo el ratón (o a ti): lo libera de lentitudes y raíces.]==],
  MACRO_DESC_RESUCITAR = [==[{REDEMPTION} al compañero muerto que tengas bajo el ratón o seleccionado.]==],
  MACRO_DESC_ESCUDO = [==[{DIVINE_SHIELD}: inmune unos segundos. Pulsa otra vez para quitártelo y volver a pegar.]==],
  MACRO_DESC_PROTECCION = [==[{PROTECTION} al compañero bajo el ratón o al que esté atacando tu enemigo. Con |cfff2c14eAlt|r: {DIVINE_PROTECTION} sobre ti.]==],
  MACRO_DESC_MANOS = [==[{LAY_ON_HANDS} al compañero bajo el ratón (o a ti): le devuelve toda la vida. Para emergencias.]==],
  MACRO_DESC_MARTILLO = [==[{HAMMER} al enemigo: lo aturde. Corta lo que estés lanzando para que salga al momento.]==],
  MACRO_DESC_ARREPENTIR = [==[{REPENTANCE} al enemigo: lo deja fuera de combate un rato.]==],
  MACRO_DESC_BENDICION = [==[{MIGHT} al compañero bajo el ratón (o a tu objetivo). Con |cfff2c14eCtrl|r: {KINGS}.]==],
  MACRO_DESC_AURAS = [==[{DEVOTION}. Con |cfff2c14eCtrl|r: {RETRIBUTION_AURA}.]==],
  ALERT_SEAL_MISSING = [==[No llevas sello. Ponte %s: sin sello pegas mucho menos.]==],
  ALERT_SEAL_WRONG = [==[Para esta pelea toca %s.]==],
  ALERT_AURA = [==[No llevas ninguna aura. Ponte %s: se queda puesta y ayuda a todo el grupo.]==],
  ALERT_BLESSING = [==[No llevas ninguna bendición. Ponte %s: dura varios minutos.]==],
  ALERT_FURY = [==[Eres el tanque y no llevas %s: sin ella, los enemigos irán a por tus compañeros.]==],
  ALERT_EXORCISM = [==[Es un no-muerto o un demonio: %s les hace muchísimo daño. Empieza con él.]==],
  ALERT_LABEL_AURA = [==[Aura]==],
  ALERT_LABEL_BLESSING = [==[Bendición]==],
  ALERT_LABEL_FURY = [==[Furia]==],
  ALERT_LABEL_TIP = [==[Consejo]==],
  ALERT_DRAG_HINT = [==[Arrastra para moverlo · clic derecho o pulsa Mover otra vez para fijarlo]==],
  ALERT_UNLOCKED = [==[Aviso desbloqueado: arrástralo y fíjalo con clic derecho o pulsando Mover otra vez.]==],
  ALERT_LOCKED = [==[Aviso fijado. Solo aparecerá cuando te falte algo antes de pelear.]==],
  OPT_ALERT_MOVE_DESC = [==[Muestra un recuadro para colocarlo donde quieras. Pulsa otra vez para fijarlo.]==],
  OPT_ADVISOR_DESC_FUN = [==[Como un buen escudero: solo abre la boca cuando se te olvida algo antes de pelear (el sello, el aura, la bendición, Righteous Fury si tanqueas, o un consejo para ese enemigo). Si todo está bien, calladito.]==],
  OPT_TRAINER = [==[Modo entrenador]==],
  OPT_TRAINER_DESC = [==[Para practicar: tras una pelea, si hay algo que mejorar, un aviso pequeño te lo dice (como mucho uno cada 3 minutos). Al desactivarlo, el resumen de la sesión. También con /pfd entrenador.]==],
  HELP_TRAINER = [==[|cfff2c14e/pfd entrenador|r: activar o desactivar el modo entrenador]==],
  TRAINER_ON = [==[Modo entrenador activado. Juega normal: si veo algo que mejorar, te aviso (como mucho cada 3 minutos). Desactívalo para ver el resumen de la sesión.]==],
  TRAINER_ON_FUN = [==[Modo entrenador activado. Silbato al cuello. Juega normal: si veo algo, te lo digo (sin gritar y como mucho cada 3 minutos). Desactívalo para ver qué tal ha ido.]==],
  TRAINER_OFF_EMPTY = [==[Modo entrenador desactivado. No ha dado tiempo a ninguna pelea.]==],
  TRAINER_SUMMARY = [==[Resumen de la sesión: %s peleas.]==],
  TRAINER_SUMMARY_JUDGE = [==[{JUDGEMENT}: %s de cada 10 veces posibles%s.]==],
  TRAINER_SUMMARY_STRIKE = [==[{HOLY_STRIKE}: %s de cada 10 veces posibles%s.]==],
  TRAINER_CHANGE = [==[ (%s frente a la sesión anterior)]==],
  TRAINER_TIP_TITLE = [==[Entrenador]==],
  TRAINER_TIP_NO_SEAL = [==[Has peleado %s s sin sello. Póntelo antes de empezar: sin sello pegas mucho menos.]==],
  TRAINER_TIP_JUDGE = [==[{JUDGEMENT} se quedó listo sin usar %s veces. Lánzalo cada vez que se ilumine.]==],
  TRAINER_TIP_JUDGE_FUN = [==[{JUDGEMENT} se quedó %s veces esperando a que le hicieras caso. Úsalo, que no muerde.]==],
  TRAINER_TIP_STRIKE = [==[{HOLY_STRIKE} se quedó listo sin usar %s veces. Con PFD Golpe sale junto a {JUDGEMENT}.]==],
  TRAINER_TIP_STRIKE_FUN = [==[{HOLY_STRIKE} se ha pasado %s turnos en el banquillo. Con PFD Golpe sale junto a {JUDGEMENT}.]==],
  TRAINER_TIP_HINT = [==[Clic para abrir la guía.]==],
  WIN_TAB_TODAY = [==[Hoy]==],
  WIN_TAB_FIGHTS = [==[Peleas]==],
  WIN_TAB_MACROS = [==[Macros]==],
  WIN_SETTINGS = [==[Ajustes]==],
  WIN_PLAN = [==[Tu plan]==],
  WIN_NOW = [==[Ahora mismo]==],
  WIN_NOW_NO_TARGET = [==[Selecciona un enemigo y te digo si te falta algo antes de pelear.]==],
  WIN_NOW_OK = [==[Todo en orden. A por él.]==],
  WIN_NOW_OK_FUN = [==[Todo en orden. Ese bicho no sabe lo que le espera.]==],
  WIN_ALERT_SEAL = [==[Ponte %s]==],
  WIN_ALERT_AURA = [==[Sin aura: ponte %s]==],
  WIN_ALERT_BLESSING = [==[Sin bendición: ponte %s]==],
  WIN_ALERT_FURY = [==[Tanque sin %s]==],
  WIN_ALERT_TIP = [==[Empieza con %s]==],
  WIN_TRAINER_ON = [==[Activar modo entrenador]==],
  WIN_TRAINER_OFF = [==[Desactivar modo entrenador]==],
  WIN_DAMAGE = [==[De dónde sale tu daño (últimas 200 peleas)]==],
  WIN_DAMAGE_EMPTY = [==[Todavía no hay datos del medidor de daño. Pelea un poco y vuelve.]==],
  WIN_MELEE = [==[Golpe normal]==],
  WIN_LAST = [==[Tus últimas peleas]==],
  WIN_COL_DURATION = [==[Duración]==],
  WIN_COL_DPS = [==[Daño por segundo]==],
  WIN_COL_JUDGE = [==[Sentencias]==],
  WIN_COL_STYLE = [==[Sellos]==],
  STYLE_TWIST = [==[Cambio de sellos]==],
  STYLE_NONE = [==[Sin sello]==],
  STYLE_MIXED = [==[Varios sellos]==],
  WIN_MACROS_HINT = [==[Arrastra una macro a tu barra. Las grises aún no están creadas: créalas en Ajustes > Macros. Pasa el ratón para ver qué hace cada una.]==],
  WIN_MACRO_MISSING = [==[Aún no está creada: márcala en Ajustes > Macros y pulsa Crear o actualizar ahora.]==],
  WIN_COMBAT = [==[En combate no se pueden arrastrar macros. Espera a terminar la pelea.]==],
  WIN_WELCOME_TITLE = [==[Bienvenido, paladín]==],
  WIN_WELCOME_1 = [==[|cfff2c14e1. Tu plan.|r En esta pestaña tienes lo que te toca hacer con los hechizos que conoces ahora, paso a paso. Cambia solo cuando aprendes algo nuevo.]==],
  WIN_WELCOME_2 = [==[|cfff2c14e2. El aviso antes del pull.|r Cuando selecciones a un enemigo, si te falta algo (el sello, el aura, la bendición...) aparecerá su icono. Si no ves nada, es que vas bien.]==],
  WIN_WELCOME_3 = [==[|cfff2c14e3. Unsealed Wrath.|r Si tienes ese talento, un icono te dirá en combate cuándo cambiar de sello: ¡CAMBIA! y ¡VUELVE!.]==],
  WIN_WELCOME_4 = [==[|cfff2c14e4. ¿Más?|r La Guía lo explica todo con calma, en Macros tienes botones que te ahorran trabajo y el modo entrenador te dice qué mejorar. Vuelve aquí cuando quieras con /pfd.]==],
  WIN_WELCOME_OK = [==[¡Entendido!]==],
  WIN_WELCOME_OK_FUN = [==[¡Por la Luz!]==],
})
