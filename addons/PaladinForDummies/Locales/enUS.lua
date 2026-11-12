-- English (default). Keys are identifiers; every key must exist here.
local _, ns = ...

ns.Locales.register("enUS", {
  -- Welcome and help
  WELCOME_1 = "Welcome! The small window shows the seal and the Judgement that suit your target before you pull. Hover the icons to see why.",
  WELCOME_2 = "Type |cffffd100/pfd|r for options (or use the addon menu on the minimap).",
  NOT_A_PALADIN = "This addon is only for paladins; it stays inactive on this character.",
  HELP_HEADER = "Commands:",
  HELP_OPTIONS = "|cffffd100/pfd|r: open the options",
  HELP_STATS = "|cffffd100/pfd stats|r: your fight statistics",
  HELP_REPORT = "|cffffd100/pfd report|r: copyable report to attach to a bug report",
  HELP_DEV = "Developer mode: debug | ui | echodebug | test A|B|off | spec ret|prot|holy|auto",
  OPTIONS_AFTER_COMBAT = "You cannot open the options in combat: they will open after combat.",
  OPTIONS_UNAVAILABLE = "The options panel could not be opened. Type /pfd help for commands.",
  DEV_ONLY = "That command needs developer mode (Options → Advanced).",

  -- Options: general
  OPT_INTRO = "Paladin for Dummies helps you choose seals and Judgements, shows your Unsealed Wrath echoes and keeps statistics of your fights. Everything is optional.",
  OPT_SHOW = "Show",
  OPT_LOCK = "Lock position",
  OPT_LOCK_DESC = "Stops it from being dragged by accident. Tooltips keep working.",
  OPT_SCALE = "Size",
  OPT_RESET_POSITION = "Reset position",

  -- Options: advisor
  OPT_ADVISOR = "Advisor",
  OPT_ADVISOR_DESC = "Before each pull, a small window shows which seal to fight with and which seal to judge. It freezes during combat.",
  OPT_ADVISOR_SHOW_DESC = "The window with the recommended seal and Judgement.",

  -- Options: Unsealed Wrath
  OPT_ECHO = "Unsealed Wrath",
  OPT_ECHO_DESC = "With the Unsealed Wrath talent, your hits store copies of your seal. This display shows them and lights up when it is time to switch seals. It only appears while you have copies.",
  OPT_ECHO_SHOW_DESC = "Echo of Command and Echo of Righteousness, with the switch alert.",
  OPT_ECHO_MOVE = "Move",
  OPT_ECHO_MOVE_DESC = "Shows a box to drag it. Press again to lock it.",
  ECHO_UNLOCKED = "Display unlocked: drag it, then right-click it or press Move again to lock it.",
  ECHO_DRAG_HINT = "Drag to move · right-click or press Move again to lock",
  ECHO_LOCKED = "Display locked in place.",
  ECHO_RESET = "Display back to its default position.",

  -- Options: macros
  OPT_MACROS = "Macros",
  OPT_MACROS_DESC = "Character macros written with your client's spell names. Most cast on the ally under your mouse (or yourself) without changing your enemy target. You choose which ones to create: there are 18 character macro slots.",
  OPT_MACROS_AUTO = "Create and keep up to date",
  OPT_MACROS_AUTO_DESC = "Creates the selected macros and updates them out of combat when you learn new ranks.",
  OPT_MACROS_NOW = "Create or update now",
  OPT_MACROS_LIST = "Which macros",
  OPT_MACRO_TOGGLE_DESC = "Unticked, the addon neither creates nor updates it. It never deletes macros: remove it from /macro if you want.",

  -- Options: combat review
  OPT_REVIEW = "Combat review",
  OPT_REVIEW_DESC = "Each fight is recorded for this character: seals used, Judgements, Holy Strikes and Seal of Command procs.",
  OPT_REVIEW_CHAT = "Summary in chat after each fight",
  OPT_REVIEW_STATS = "Show statistics",
  OPT_REVIEW_RESET = "Delete stored fights",
  OPT_REVIEW_RESET_CONFIRM = "Delete all stored fights of this character?",
  FIGHTS_DELETED = "Stored fights deleted.",

  -- Options: advanced
  OPT_ADVANCED = "Advanced",
  OPT_LANGUAGE = "Language",
  OPT_LANGUAGE_DESC = "Takes effect after /reload.",
  OPT_LANGUAGE_AUTO = "Automatic (game language)",
  OPT_DEV = "Developer mode",
  OPT_DEV_DESC = "Enables diagnostic commands and prints errors in chat.",
  OPT_REPORT = "Bug report",
  OPT_REPORT_DESC = "Opens a copyable text with your setup and the latest errors, to attach to a bug report.",
  OPT_RESET_ALL = "Reset settings",
  OPT_RESET_ALL_CONFIRM = "Reset all settings of this profile to their defaults?",
  OPT_PROFILES = "Profiles",

  -- Report window
  REPORT_TITLE = "Paladin for Dummies: bug report",
  REPORT_HINT = "Press Ctrl+A and Ctrl+C to copy it.",

  ADVISOR_SEAL = "Seal",
  ADVISOR_JUDGEMENT = "Judgement",
  TIP_BEFORE_PULL = "Before the pull",
  TIP_WHY = "Why",
  STEP_APPLY = "Put on %s",
  STEP_JUDGE = "Cast %s on your target",
  STEP_SWITCH = "Switch to %s for the fight",
  CONF_MECHANIC = "From the spell's own mechanics",
  CONF_CONSENSUS = "Guides agree (not measured yet)",
  CONF_MEASURED = "Measured with your fights",
  TIP_TEST = "Test running: %s",
  TIP_NO_ADVICE = "No advice yet: target an enemy.",
  ECHO_SWITCH = "SWITCH!",
  ECHO_BACK = "BACK!",
  OPT_VISIBILITY = "When to show it",
  OPT_VISIBILITY_DESC = "The advice is for before the pull: with an enemy targeted it is fully visible, and in combat it steps aside.",
  OPT_VIS_FADE = "Faded without a target",
  OPT_VIS_HIDE = "Only with an enemy targeted",
  OPT_VIS_ALWAYS = "Always, also in combat",
  OPT_REDUCE_MOTION = "Reduce animations",
  OPT_REDUCE_MOTION_DESC = "No pulsing on warnings. Applies after /reload.",

  WELCOME_1_FUN = "Welcome, paladin! Yes, you: the one with three seals on the bar and no idea which to press. This little window tells you before every pull. Hover the icons for the why. No judging (that is what Judgement is for).",
  NOT_A_PALADIN_FUN = "This one is for paladins only. Lovely character, but there are no seals to watch here. I will keep quiet.",
  TIP_NO_ADVICE_FUN = "Target an enemy. Swinging at the air does not count as practice.",
  OPTIONS_AFTER_COMBAT_FUN = "Opening the options mid-fight? Bold. The game will not allow it: they will open as soon as the mob stops hitting you.",
  FIGHTS_DELETED_FUN = "Fights deleted. Nobody will ever know about that murloc.",
  DEV_ONLY_FUN = "That command is for people in lab coats (developer mode, under Options → Advanced).",
  ECHO_LOCKED_FUN = "Display locked. Steadfast, like a paladin halfway through a Bubble Hearth.",
  ECHO_RESET_FUN = "Display back home. Faster than a Bubble Hearth.",
  OPT_INTRO_FUN = "Paladin for Dummies: because nobody is born knowing which seal to use. Advice before the pull, Unsealed Wrath warnings in combat and a friendly review of your fights afterwards. Everything is optional, like the helmet.",
  OPT_TONE = "Tone",
  OPT_TONE_DESC = "With humor, some messages come with a joke. Warnings are always plain. Some texts change after /reload.",
  OPT_TONE_FUN = "With humor",
  OPT_TONE_PLAIN = "Serious",
})
