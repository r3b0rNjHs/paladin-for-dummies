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

  OPT_GUIDE = [==[Guía]==],
  GUIDE_START_TITLE = [==[Empieza aquí]==],
  GUIDE_START_WHAT = [==[Paladin for Dummies es tu entrenador de paladín. Hace tres cosas:

|cfff2c14e1. Antes del pull|r te dice con qué sello pelear y qué sello juzgar.
|cfff2c14e2. En combate|r te avisa de cuándo cambiar de sello con Unsealed Wrath.
|cfff2c14e3. Después|r guarda tus peleas para que veas cómo lo haces y qué mejorar.]==],
  GUIDE_START_HUD = [==[Cómo leer los iconos:
- |cfff2c14eAnillo de oro|r: lo que te recomiendo.
- |cfff2c14eBorde rojo y !|r: te falta algo.
- |cfff2c14eÁmbar|r: caduca pronto o no es lo previsto.

Pasa el ratón por un icono para ver el porqué. El cuadradito de color dice de dónde sale el consejo: azul, de la mecánica del hechizo; ámbar, de las guías de la comunidad; verde, medido con tus propias peleas.]==],
  GUIDE_START_JOKE = [==[Nadie nace sabiendo qué sello poner. Bueno, quizá Uther. Tú tranquilo.]==],
  GUIDE_BASICS_TITLE = [==[Sellos y Sentencia]==],
  GUIDE_BASICS_SEAL = [==[|cfff2c14eUn sello|r es un buff que te pones tú: dura 30 s y añade algo a cada golpe (daño Sagrado, curarte, maná...). Solo puedes llevar uno a la vez: al ponerte otro, el anterior desaparece.]==],
  GUIDE_BASICS_JUDGEMENT = [==[|cfff2c14eJudgement (la Sentencia)|r es un solo hechizo que libera el sello que llevas sobre el enemigo. Lo que hace depende del sello: un golpe de daño, un efecto de 40 s sobre el objetivo... En Forever |cfff2c14eno consume el sello|r: lo sigues llevando. Enfriamiento medido: 8 s.]==],
  GUIDE_BASICS_RULES = [==[Reglas que conviene saber:
- Cada paladín solo puede tener |cfff2c14euna Sentencia activa|r en el objetivo.
- Por eso el truco clásico es juzgar un sello antes del pull (Crusader, que deja al enemigo recibiendo más daño Sagrado) y después cambiar al sello con el que vas a pelear.
- |cfff2c14eHoly Strike|r (enfriamiento medido: 10 s) va bien junto a Judgement: la macro PFD Golpe lanza los dos con una tecla.]==],
  GUIDE_BASICS_JOKE = [==[Sí, juzgar a un múrloc está permitido. Él empezó.]==],
  GUIDE_SEALS_TITLE = [==[Los sellos, uno a uno]==],
  GUIDE_SEAL_RIGHTEOUSNESS = [==[|cfff2c14eSeal of Righteousness|r (nivel 1)
Mientras lo llevas: daño Sagrado extra en cada golpe; con armas lentas, más por golpe.
Su Sentencia: un golpe de daño Sagrado.
Cuándo: tu sello de daño hasta que tengas Command, y la otra mitad del cambio con Unsealed Wrath.]==],
  GUIDE_SEAL_CRUSADER = [==[|cfff2c14eSeal of the Crusader|r (nivel 6)
Mientras lo llevas: más poder de ataque y ataques un 40 % más rápidos, con menos daño por golpe.
Su Sentencia: 40 s en los que el objetivo recibe más daño Sagrado; tus golpes la refrescan.
Cuándo: para juzgarlo antes del pull.]==],
  GUIDE_SEAL_COMMAND = [==[|cfff2c14eSeal of Command|r (nivel 20, talento de Retribución)
Mientras lo llevas: a veces un golpe Sagrado extra del 74 % del daño del arma. Medido: unas 3,7 veces por minuto (las guías prometen 7; optimistas).
Su Sentencia: daño Sagrado, el doble contra enemigos aturdidos o incapacitados (Hammer of Justice y luego Judgement).
Cuándo: el sello de daño de Retribución, mejor con arma lenta.]==],
  GUIDE_SEAL_LIGHT = [==[|cfff2c14eSeal of Light|r (nivel 30)
Mientras lo llevas: probabilidad de curarte al golpear.
Su Sentencia: 40 s en los que quien golpee al objetivo puede curarse.
Cuándo: en grupo con mucho daño recibido, o en solitario si vas justo de vida.]==],
  GUIDE_SEAL_FURY = [==[|cfff2c14eSeal of Fury|r (nivel 10, nuevo en Forever, para tanques)
Mientras lo llevas: daño Sagrado fijo por golpe y un escudo del 50 % de ese daño.
Su Sentencia: daño extra y provoca a los enemigos a 10 m durante 3 s.
Cuándo: si tanqueas. (Según las notas del parche; aún sin comprobar en el juego.)]==],
  GUIDE_SEAL_JUSTICE = [==[|cfff2c14eSeal of Justice|r (nivel 22)
Mientras lo llevas: probabilidad de aturdir 2 s.
Su Sentencia: el objetivo no puede huir a toda velocidad.
Cuándo: contra humanoides que huyen con poca vida. (Aún sin comprobar en el juego.)]==],
  GUIDE_SEAL_WISDOM = [==[|cfff2c14eSeal of Wisdom|r (nivel 38)
Mientras lo llevas: probabilidad de recuperar maná al golpear.
Su Sentencia: quien golpee al objetivo recupera maná.
Cuándo: en peleas largas o si vas justo de maná. (Aún sin comprobar en el juego.)]==],
  GUIDE_SEALS_JOKE = [==[Siete sellos y una sola mano para pulsarlos. Para eso estamos.]==],
  GUIDE_UNSEALED_TITLE = [==[Unsealed Wrath]==],
  GUIDE_UNSEALED_WHAT = [==[|cfff2c14eUnsealed Wrath|r es un talento de Retribución (requiere Repentance). Cada golpe guarda una copia del sello que llevas durante 15 s, hasta 3. Al golpear con |cfff2c14eotro|r sello, se gastan todas de golpe y ese golpe suma sus efectos.]==],
  GUIDE_UNSEALED_HOW = [==[Cómo se juega:
1. Pelea con Command hasta tener 3 copias: el indicador dice |cfff2c14e¡CAMBIA!|r y te enseña el icono de Righteousness, que es adonde vas.
2. Cambia a Righteousness y da un golpe: las copias se gastan.
3. Con 1 copia de Righteousness: |cfff2c14e¡VUELVE!|r a Command.
La macro PFD Unsealed alterna los dos sellos con una sola tecla.]==],
  GUIDE_UNSEALED_MEASURED = [==[Lo medido hasta ahora: un ciclo bien hecho son unos 11 s con Command (3 golpes con un arma de 3,4 s) y unos 4 s con Righteousness. Cuánto daño suma exactamente se está midiendo con el medidor de daño. Las copias se gastan con cualquier otro sello, no solo Righteousness: cambiar a Wisdom para recuperar maná está por probar.]==],
  GUIDE_UNSEALED_JOKE = [==[Es como hacer malabares, pero con sellos sagrados y un múrloc mirando.]==],
  GUIDE_SITUATIONS_TITLE = [==[Qué hacer en cada situación]==],
  GUIDE_SIT_SOLO = [==[|cfff2c14eSubiendo de nivel, en solitario|r
Juzga Crusader antes del pull y pelea con Command (o Righteousness si aún no tienes Command). En peleas largas, si vas justo de maná o de vida, Wisdom o Light. (Consenso de guías.)]==],
  GUIDE_SIT_DUNGEON = [==[|cfff2c14eMazmorra, como Retribución|r
Crusader antes del pull, Command y cambio de sellos con Unsealed Wrath. Pulsa PFD Golpe cada vez que Judgement o Holy Strike estén listos. Dentro de las mazmorras el juego no deja a los addons saber el tipo de enemigo.]==],
  GUIDE_SIT_BOSS = [==[|cfff2c14eJefes y peleas largas en grupo|r
Si hay otro paladín, poneos de acuerdo antes: uno mantiene la Sentencia de Wisdom (si el grupo gasta mucho maná) o la de Light (si recibe mucho daño). Cada paladín solo tiene una Sentencia en el objetivo. (Consenso de guías.)]==],
  GUIDE_SIT_FLEE = [==[|cfff2c14eHumanoides que huyen|r
Justice los aturde y su Sentencia les impide huir a toda velocidad. El asesor te lo propone en mundo abierto.]==],
  GUIDE_SIT_UNDEAD = [==[|cfff2c14eNo-muertos y demonios|r
Exorcism hace mucho daño contra ellos (en Classic solo funcionaba con ellos; por confirmar en Forever). Tienes la macro PFD Exorcismo.]==],
  GUIDE_SIT_TANK = [==[|cfff2c14eSi tanqueas|r
Seal of Fury: su Sentencia provoca 3 s a los enemigos cercanos. La ayuda completa para tanques y sanadores llegará más adelante.]==],
  GUIDE_SIT_JOKE = [==[Situación especial: el grupo ha muerto y tú sigues vivo. Bubble Hearth. Es broma. (¿O no?)]==],
  GUIDE_MACROS_TITLE = [==[Las macros]==],
  GUIDE_MACROS_INTRO = [==[El addon puede crearte macros de personaje con los nombres de hechizo de tu cliente (Opciones → Macros). Se actualizan solas cuando aprendes rangos nuevos. Ninguna lanza nada por sí sola: tú pulsas.]==],
  GUIDE_MACROS_LIST = [==[- |cfff2c14ePFD Golpe|r: Judgement y Holy Strike en una tecla (Judgement no gasta el tiempo global).
- |cfff2c14ePFD Unsealed|r: alterna Command y Righteousness; cada pelea empieza en Command.
- |cfff2c14ePFD Sello|r: Command; con Shift, Righteousness.
- |cfff2c14eDe utilidad|r: curas, protección, libertad, bendiciones, auras, resurrección... Lanzan sobre el aliado que tengas bajo el ratón (o sobre ti) sin cambiar tu objetivo.]==],
  GUIDE_MACROS_JOKE = [==[Tienes 18 huecos de macros de personaje. Elige con cabeza, como un paladín. Bueno, mejor que un paladín.]==],
  GUIDE_NUMBERS_TITLE = [==[Tus números]==],
  GUIDE_NUMBERS_EMPTY = [==[Todavía no hay peleas guardadas en este personaje. Ve a pegarle a algo y vuelve.]==],
  GUIDE_NUMBERS_FIGHTS = [==[Peleas guardadas: %d.]==],
  GUIDE_NUMBERS_COMMAND = [==[Seal of Command: %s activaciones por minuto con el sello puesto (las guías dicen 7).]==],
  GUIDE_NUMBERS_TWIST = [==[Peleas con cambio de sellos (Unsealed Wrath): %d.]==],
  GUIDE_NUMBERS_NOTE = [==[Se calculan con tus peleas guardadas. Más peleas, números más fiables.]==],
  GUIDE_GLOSSARY_TITLE = [==[Glosario]==],
  GUIDE_GLOSSARY_TEXT = [==[- |cfff2c14ePull|r: el momento de empezar la pelea.
- |cfff2c14eBuff / debuff|r: efecto bueno sobre ti / malo sobre el enemigo.
- |cfff2c14eProc|r: efecto que salta por probabilidad al golpear (como Command).
- |cfff2c14eCD (enfriamiento)|r: lo que tarda un hechizo en volver a estar listo.
- |cfff2c14eGCD (tiempo global)|r: la pausa de 1,5 s tras casi cualquier hechizo.
- |cfff2c14eStack (acumulación)|r: varias copias del mismo efecto, como las de Unsealed Wrath.
- |cfff2c14eAggro|r: a quién quiere pegar el enemigo. Spoiler: al que más le molesta.
- |cfff2c14eBubble Hearth|r: Divine Shield y luego la piedra de hogar. Patrimonio cultural del paladín.]==],
  GUIDE_FAQ_TITLE = [==[Preguntas frecuentes]==],
  GUIDE_FAQ_TEXT = [==[|cfff2c14e¿Por qué el asesor desaparece en combate?|r
El consejo es para antes del pull, y en combate el juego oculta casi todo a los addons. Puedes cambiarlo en Asesor → Cuándo se ve.

|cfff2c14e¿Esto juega por mí?|r
No. Ningún botón lanza nada solo y Blizzard no permite consejos de rotación en tiempo real. Aquí se aprende.

|cfff2c14e¿De dónde sale cada consejo?|r
Mira el cuadradito de color del tooltip: la mecánica del hechizo, las guías o tus propias peleas.

|cfff2c14eHe encontrado un error.|r
Avanzado → Informe de errores: cópialo y mándalo.]==],
  GUIDE_FAQ_JOKE = [==[|cfff2c14e¿Puedo llevar dos sellos a la vez?|r
No. Lo intentaron muchos antes que tú.]==],
  OPT_GUIDE_HINT = "¿Nuevo con el paladín? Abre la |cfff2c14eGuía|r, justo debajo en la lista: sellos, Sentencia, Unsealed Wrath, qué hacer en cada situación y tus propios números.",
})
