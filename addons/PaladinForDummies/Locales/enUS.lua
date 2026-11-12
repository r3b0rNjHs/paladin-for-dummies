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
  ECHO_UNLOCKED = "Display unlocked: drag it and press Move again to lock it.",
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
})
