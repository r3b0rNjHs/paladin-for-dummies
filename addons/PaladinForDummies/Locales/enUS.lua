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

  WHY_HUMANOID_JUSTICE = "Humanoids run away at low health; Justice stuns them and its Judgement stops them from fleeing.",
  WHY_RET_COMMAND = "Command hits for 74% of your weapon damage: it is the Retribution damage seal.",
  WHY_PREPULL_CRUSADER = "Judgement no longer uses up the seal: judge Crusader before the pull (the target takes more Holy damage for 40 s), then switch to your damage seal.",
  WHY_FALLBACK_RIGHTEOUSNESS = "Righteousness is available from level 1 and adds Holy damage to every hit.",

  OPT_GUIDE_HINT = "New to paladins? Open |cfff2c14eGuide|r, just below in the list: seals, Judgement, Unsealed Wrath, what to do in each situation and your own numbers.",
  OPT_GUIDE = [==[Guide]==],
  GUIDE_START_TITLE = [==[Start here]==],
  GUIDE_START_H_WHAT = [==[What it does for you]==],
  GUIDE_START_BEFORE = [==[|cfff2c14eBefore the pull|r
It tells you which seal to fight with and which seal to judge. You see it in the little two-icon window, "Seal" and "Judgement".]==],
  GUIDE_START_DURING = [==[|cfff2c14eIn combat|r
If you have the Unsealed Wrath talent, it tells you when to switch seals: |cfff2c14eSWITCH!|r and |cfff2c14eBACK!|r.]==],
  GUIDE_START_AFTER = [==[|cfff2c14eAfter the fight|r
It keeps every fight so you can see how you are doing. Your numbers are in this very guide.]==],
  GUIDE_START_H_ICONS = [==[How to read the icons]==],
  GUIDE_START_COLORS = [==[|cfff2c14eGold ring|r: what I recommend.
|cffe5484dRed border and "!"|r: something is missing.
|cfff5a524Amber|r: about to expire, or not what was planned.

Hover an icon for the why.]==],
  GUIDE_START_SOURCES = [==[In every tooltip, a little square tells you where the advice comes from:
|TInterface\Buttons\WHITE8X8:10:10:0:0:8:8:0:8:0:8:156:195:240|t the spell's own mechanics
|TInterface\Buttons\WHITE8X8:10:10:0:0:8:8:0:8:0:8:245:165:36|t community guides (not measured yet)
|TInterface\Buttons\WHITE8X8:10:10:0:0:8:8:0:8:0:8:70:167:88|t measured with your own fights]==],
  GUIDE_START_JOKE = [==[Nobody is born knowing which seal to use. Well, maybe Uther. Relax.]==],
  GUIDE_BASICS_TITLE = [==[Seals and Judgement]==],
  GUIDE_BASICS_H_SEAL = [==[The seal]==],
  GUIDE_BASICS_SEAL = [==[A buff you put on yourself. It lasts |cfff2c14e30 s|r and adds something to every hit: Holy damage, healing, mana...

You wear |cfff2c14eone at a time|r: putting on another replaces it.]==],
  GUIDE_BASICS_H_JUDGEMENT = [==[Judgement]==],
  GUIDE_BASICS_JUDGEMENT = [==[A single spell that |cfff2c14eunleashes your current seal|r on the enemy. What it does depends on the seal: a damage hit, a 40 s effect...

In Forever it |cfff2c14edoes not use up the seal|r: you keep it. Measured cooldown: 8 s.]==],
  GUIDE_BASICS_H_RULES = [==[Three golden rules]==],
  GUIDE_BASICS_RULE_ONE = [==[|cfff2c14e1. One Judgement per paladin.|r
Judging another seal replaces the previous one.]==],
  GUIDE_BASICS_RULE_PREPULL = [==[|cfff2c14e2. Judge before you fight.|r
Put on Crusader, cast Judgement on the enemy (it takes more Holy damage for 40 s) and switch to your damage seal.]==],
  GUIDE_BASICS_RULE_STRIKE = [==[|cfff2c14e3. Holy Strike goes with Judgement.|r
Measured cooldown: 10 s. The PFD Golpe macro casts both with one key.]==],
  GUIDE_BASICS_JOKE = [==[Yes, judging a murloc is allowed. He started it.]==],
  GUIDE_SEALS_TITLE = [==[The seals, one by one]==],
  GUIDE_SEALS_H_DAMAGE = [==[For damage]==],
  GUIDE_SEAL_RIGHTEOUSNESS = [==[|cfff2c14eSeal of Righteousness|r · level 1
While on: extra Holy damage on every hit (more with slow weapons).
Its Judgement: a Holy damage hit.
When: your damage seal until you get Command, and half of the Unsealed Wrath switch.]==],
  GUIDE_SEAL_COMMAND = [==[|cfff2c14eSeal of Command|r · level 20 · Retribution talent
While on: sometimes an extra Holy hit for 74% of your weapon damage. Measured: about 3.7 times per minute (guides promise 7).
Its Judgement: Holy damage, doubled if the enemy is stunned.
When: the Retribution damage seal, best with a slow weapon.]==],
  GUIDE_SEALS_H_PREPULL = [==[For before the pull]==],
  GUIDE_SEAL_CRUSADER = [==[|cfff2c14eSeal of the Crusader|r · level 6
While on: more attack power and 40% faster attacks, but weaker ones.
Its Judgement: for 40 s the target takes more Holy damage; your hits refresh it.
When: to judge it before the pull.]==],
  GUIDE_SEALS_H_SUSTAIN = [==[For staying alive]==],
  GUIDE_SEAL_LIGHT = [==[|cfff2c14eSeal of Light|r · level 30
While on: a chance to heal you when you hit.
Its Judgement: for 40 s, whoever hits the target may be healed.
When: if the group takes a lot of damage, or solo when your health is tight.]==],
  GUIDE_SEAL_WISDOM = [==[|cfff2c14eSeal of Wisdom|r · level 38 · not checked in game
While on: a chance to restore mana when you hit.
Its Judgement: whoever hits the target restores mana.
When: long fights or when your mana is tight.]==],
  GUIDE_SEALS_H_SPECIAL = [==[For specific cases]==],
  GUIDE_SEAL_JUSTICE = [==[|cfff2c14eSeal of Justice|r · level 22 · not checked in game
While on: a chance to stun for 2 s.
Its Judgement: the target cannot run away at full speed.
When: against humanoids that flee at low health.]==],
  GUIDE_SEAL_FURY = [==[|cfff2c14eSeal of Fury|r · level 10 · new in Forever · not checked
While on: fixed Holy damage per hit and a shield worth 50% of it.
Its Judgement: extra damage and taunts enemies within 10 yd for 3 s.
When: if you tank.]==],
  GUIDE_SEALS_JOKE = [==[Seven seals and only one hand to press them. That is what we are here for.]==],
  GUIDE_UNSEALED_TITLE = [==[Unsealed Wrath]==],
  GUIDE_UNSEALED_H_WHAT = [==[What it is]==],
  GUIDE_UNSEALED_WHAT = [==[A Retribution talent (requires Repentance). Every hit stores |cfff2c14ea copy|r of your current seal for 15 s, up to 3.

When you hit with |cfff2c14eanother|r seal, they are all spent at once and that hit adds their effects.]==],
  GUIDE_UNSEALED_H_HOW = [==[How to play it, in three steps]==],
  GUIDE_UNSEALED_STEP_1 = [==[|cfff2c14e1. Build up.|r Fight with Command until you have 3 copies. The display says |cfff2c14eSWITCH!|r and shows the Righteousness icon: that is where you are going.]==],
  GUIDE_UNSEALED_STEP_2 = [==[|cfff2c14e2. Switch and hit.|r Put on Righteousness and land a hit: the Command copies are spent.]==],
  GUIDE_UNSEALED_STEP_3 = [==[|cfff2c14e3. Go back.|r With 1 copy of Righteousness the display says |cfff2c14eBACK!|r: Command again, and start over.]==],
  GUIDE_UNSEALED_SHORTCUT = [==[Shortcut: the |cfff2c14ePFD Unsealed|r macro switches between both seals with a single key.]==],
  GUIDE_UNSEALED_H_MEASURED = [==[Measured so far]==],
  GUIDE_UNSEALED_MEASURED = [==[A good cycle: about 11 s with Command (3 hits with a 3.4 s weapon) and about 4 s with Righteousness.

How much damage it adds is being measured with the damage meter. Other seals also spend the copies: switching to Wisdom to restore mana is still to be tested.]==],
  GUIDE_UNSEALED_JOKE = [==[It is juggling, but with holy seals and a murloc watching.]==],
  GUIDE_SITUATIONS_TITLE = [==[What to do in each situation]==],
  GUIDE_SIT_SOLO = [==[|cfff2c14eLeveling solo|r
Judge Crusader before the pull and fight with Command (or Righteousness if you do not have it yet). In long fights, if mana or health is tight: Wisdom or Light.]==],
  GUIDE_SIT_DUNGEON = [==[|cfff2c14eDungeons, as Retribution|r
Crusader before the pull, Command and seal switching with Unsealed Wrath. Press PFD Golpe whenever Judgement or Holy Strike is ready.]==],
  GUIDE_SIT_BOSS = [==[|cfff2c14eBosses, with another paladin|r
Agree beforehand: one keeps up the Judgement of Wisdom (if the group spends a lot of mana) or of Light (if it takes a lot of damage). Guides agree.]==],
  GUIDE_SIT_FLEE = [==[|cfff2c14eHumanoids that run away|r
Justice: it stuns them and its Judgement stops them from fleeing at full speed. Or Hammer of Justice at the right moment.]==],
  GUIDE_SIT_UNDEAD = [==[|cfff2c14eUndead and demons|r
Exorcism hits them hard (in Classic it only worked on them; still to be confirmed in Forever). PFD Exorcismo macro.]==],
  GUIDE_SIT_TANK = [==[|cfff2c14eIf you tank|r
Seal of Fury: its Judgement taunts nearby enemies for 3 s. Full help for tanks and healers will come later.]==],
  GUIDE_SIT_JOKE = [==[Special situation: the group is dead and you are still alive. Bubble Hearth. Just kidding. (Or not?)]==],
  GUIDE_MACROS_TITLE = [==[The macros]==],
  GUIDE_MACROS_INTRO = [==[The addon can create character macros for you (Options → Macros) with your client's spell names. They update themselves when you learn new ranks. None of them casts anything on its own: you press the key.]==],
  GUIDE_MACRO_GOLPE = [==[|cfff2c14ePFD Golpe|r
Judgement and Holy Strike on one key. Judgement does not trigger the global cooldown, so both go out.]==],
  GUIDE_MACRO_UNSEALED = [==[|cfff2c14ePFD Unsealed|r
Switches between Command and Righteousness. Every fight starts on Command.]==],
  GUIDE_MACRO_SELLO = [==[|cfff2c14ePFD Sello|r
Command; holding Shift, Righteousness.]==],
  GUIDE_MACRO_UTILITY = [==[|cfff2c14eThe utility ones|r
Heals, protection, freedom, blessings, auras, resurrection... They go to the ally under your mouse (or to you) without changing your target.]==],
  GUIDE_MACROS_JOKE = [==[You have 18 character macro slots. Choose wisely, like a paladin. Well, better than a paladin.]==],
  GUIDE_NUMBERS_TITLE = [==[Your numbers]==],
  GUIDE_NUMBERS_EMPTY = [==[No fights saved on this character yet. Go hit something and come back.]==],
  GUIDE_NUMBERS_FIGHTS = [==[Fights saved: %s]==],
  GUIDE_NUMBERS_COMMAND = [==[Seal of Command: %s procs per minute (guides say 7)]==],
  GUIDE_NUMBERS_TWIST = [==[Fights with seal switching: %s]==],
  GUIDE_NUMBERS_NOTE = [==[They come from your saved fights: the more, the more reliable.]==],
  GUIDE_GLOSSARY_TITLE = [==[Glossary]==],
  GUIDE_GLOSSARY_TEXT = [==[|cfff2c14ePull|r: the moment the fight starts.

|cfff2c14eBuff / debuff|r: a good effect on you / a bad one on the enemy.

|cfff2c14eProc|r: an effect that triggers by chance when you hit, like Command.

|cfff2c14eCD (cooldown)|r: how long a spell takes to be ready again.

|cfff2c14eGCD (global cooldown)|r: the 1.5 s pause after almost any spell.

|cfff2c14eStack|r: several copies of the same effect, like the Unsealed Wrath ones.

|cfff2c14eAggro|r: who the enemy wants to hit. Spoiler: whoever annoys it most.

|cfff2c14eBubble Hearth|r: Divine Shield, then your hearthstone. Paladin cultural heritage.]==],
  GUIDE_FAQ_TITLE = [==[FAQ]==],
  GUIDE_FAQ_Q_COMBAT = [==[Why does the advisor disappear in combat?]==],
  GUIDE_FAQ_A_COMBAT = [==[The advice is for before the pull, and in combat the game hides almost everything from addons. You can keep it visible under Advisor → When to show it.]==],
  GUIDE_FAQ_Q_AUTO = [==[Does this play for me?]==],
  GUIDE_FAQ_A_AUTO = [==[No. No button casts anything on its own, and Blizzard does not allow real-time rotation advice. This is for learning.]==],
  GUIDE_FAQ_Q_SOURCE = [==[Can I trust the advice?]==],
  GUIDE_FAQ_A_SOURCE = [==[Look at the little colored square in the tooltip: blue, it comes from the spell's mechanics; amber, from guides not measured yet; green, measured with your fights.]==],
  GUIDE_FAQ_Q_BUG = [==[I found a bug.]==],
  GUIDE_FAQ_A_BUG = [==[Advanced → Error report: copy it and send it. Thank you, really.]==],
  GUIDE_FAQ_JOKE = [==[|cfff2c14eCan I wear two seals at once?|r
No. Many tried before you.]==],
})
