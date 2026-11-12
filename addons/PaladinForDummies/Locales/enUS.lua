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
  DEV_ONLY = "That command needs developer mode (Options > Advanced).",

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
  DEV_ONLY_FUN = "That command is for people in lab coats (developer mode, under Options > Advanced).",
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
  SPELL_WISDOM = [==[Seal of Wisdom]==],
  SPELL_JUSTICE = [==[Seal of Justice]==],
  SPELL_FURY = [==[Seal of Fury]==],
  GUIDE_PLAN_TITLE = [==[Your plan]==],
  GUIDE_PLAN_INTRO = [==[This is what to do with what you know right now (level %s). It updates itself when you learn new spells.]==],
  GUIDE_PLAN_H_BEFORE = [==[Before the fight]==],
  GUIDE_PLAN_SEAL_ONLY = [==[Put on {RIGHTEOUSNESS}. It is your seal: it makes every hit stronger.]==],
  GUIDE_PLAN_PREPULL_1 = [==[|cfff2c14e1.|r Put on {CRUSADER}.]==],
  GUIDE_PLAN_PREPULL_2 = [==[|cfff2c14e2.|r Target the enemy and cast {JUDGEMENT} on it. For 40 s it takes more Holy damage.]==],
  GUIDE_PLAN_PREPULL_3 = [==[|cfff2c14e3.|r Put on {DAMAGE_SEAL} and go. It is your seal for the fight.]==],
  GUIDE_PLAN_H_DURING = [==[During the fight]==],
  GUIDE_PLAN_JUDGE = [==[Cast {JUDGEMENT} every time it is ready (every 8 s). It does not take your seal away: use it freely.]==],
  GUIDE_PLAN_STRIKE = [==[Same with {HOLY_STRIKE} (every 10 s). Tip: the PFD Golpe macro casts both with one key.]==],
  GUIDE_PLAN_UNSEALED = [==[Do you have the Unsealed Wrath talent? Watch the display: on SWITCH! put on {RIGHTEOUSNESS} and land a hit; on BACK!, {COMMAND} again. The Unsealed Wrath chapter explains it.]==],
  GUIDE_PLAN_REFRESH = [==[The seal lasts 30 s. If it runs out, put {DAMAGE_SEAL} on again: without a seal you hit much softer.]==],
  GUIDE_PLAN_H_NEXT = [==[Coming up]==],
  GUIDE_PLAN_NEXT_CRUSADER = [==[At level 6 you learn {CRUSADER}. Your plan will gain a step before each fight.]==],
  GUIDE_PLAN_NEXT_STRIKE = [==[Soon you will learn {HOLY_STRIKE}: an extra hit you can use every 10 s.]==],
  GUIDE_PLAN_NEXT_COMMAND = [==[If you go down the Retribution tree, at level 20 the {COMMAND} talent becomes your damage seal.]==],
  GUIDE_HELP_TITLE = [==[How the addon helps]==],
  GUIDE_HELP_BEFORE = [==[|cfff2c14eBefore the fight|r
A little window with two icons: the seal to fight with and the one to use with {JUDGEMENT} before you start. Hover them to see the steps.]==],
  GUIDE_HELP_DURING = [==[|cfff2c14eDuring the fight|r
If you have Unsealed Wrath, an icon tells you when to switch seals: SWITCH! and BACK!.]==],
  GUIDE_HELP_AFTER = [==[|cfff2c14eAfterwards|r
It keeps your fights. The Your fights chapter shows how you are doing.]==],
  GUIDE_HELP_H_ICONS = [==[What the colors mean]==],
  GUIDE_HELP_COLORS = [==[|cfff2c14eGold ring|r: what I recommend.
|cffe5484dRed border and "!"|r: something is missing.
|cfff5a524Amber|r: about to run out.]==],
  GUIDE_HELP_SOURCES = [==[In the box that appears when you hover, a little square tells you where the advice comes from:
|TInterface\Buttons\WHITE8X8:10:10:0:0:8:8:0:8:0:8:156:195:240|t how the spell works
|TInterface\Buttons\WHITE8X8:10:10:0:0:8:8:0:8:0:8:245:165:36|t what the guides recommend
|TInterface\Buttons\WHITE8X8:10:10:0:0:8:8:0:8:0:8:70:167:88|t your own fights]==],
  GUIDE_HELP_JOKE = [==[Nobody is born knowing which seal to use. Well, maybe Uther. Relax.]==],
  GUIDE_BASICS_TITLE = [==[Seals and Judgement]==],
  GUIDE_BASICS_H_SEAL = [==[What is a seal?]==],
  GUIDE_BASICS_SEAL = [==[A spell you put on yourself. It lasts 30 s and improves your hits: more damage, healing yourself, getting mana back...

You can only wear one at a time. Putting on another removes the previous one.]==],
  GUIDE_BASICS_H_JUDGEMENT = [==[And Judgement?]==],
  GUIDE_BASICS_JUDGEMENT = [==[{JUDGEMENT} is a spell you cast on the enemy. What it does depends on the seal you are wearing at that moment: a damage hit, an effect that lasts 40 s...

It does not take your seal away: you keep wearing it.]==],
  GUIDE_BASICS_H_RULES = [==[Three things worth knowing]==],
  GUIDE_BASICS_RULE_ONE = [==[|cfff2c14eOnly your last Judgement counts.|r
If you cast {JUDGEMENT} with another seal, the previous one disappears from the enemy.]==],
  GUIDE_BASICS_RULE_PREPULL = [==[|cfff2c14eThe classic trick:|r put on {CRUSADER}, cast {JUDGEMENT} on the enemy, then switch to the seal you will fight with.]==],
  GUIDE_BASICS_RULE_STRIKE = [==[|cfff2c14eUse them as soon as they are ready.|r
{JUDGEMENT} every 8 s and {HOLY_STRIKE} every 10 s. Leaving them waiting loses damage.]==],
  GUIDE_BASICS_JOKE = [==[Yes, judging a murloc is allowed. He started it.]==],
  GUIDE_SEALS_TITLE = [==[The seals, one by one]==],
  GUIDE_SEALS_H_DAMAGE = [==[For damage]==],
  GUIDE_SEAL_RIGHTEOUSNESS = [==[{RIGHTEOUSNESS} · from level 1
Every hit does extra Holy damage. Even more with slow weapons.
When: your damage seal until you get {COMMAND}.]==],
  GUIDE_SEAL_COMMAND = [==[{COMMAND} · level 20, Retribution talent
Every now and then, a very strong extra hit (about 3 or 4 times a minute).
When: your damage seal if you play Retribution. Best with a slow weapon.]==],
  GUIDE_SEALS_H_PREPULL = [==[For before the fight]==],
  GUIDE_SEAL_CRUSADER = [==[{CRUSADER} · level 6
You attack faster, but each hit is weaker.
Its Judgement: for 40 s the enemy takes more Holy damage.
When: cast {JUDGEMENT} with it on before the fight, then switch.]==],
  GUIDE_SEALS_H_SUSTAIN = [==[For staying alive]==],
  GUIDE_SEAL_LIGHT = [==[{LIGHT} · level 30
Sometimes you heal yourself when you hit.
When: if your health is tight.]==],
  GUIDE_SEAL_WISDOM = [==[{WISDOM} · level 38
Sometimes you get mana back when you hit.
When: if you run out of mana in long fights.]==],
  GUIDE_SEALS_H_SPECIAL = [==[For specific cases]==],
  GUIDE_SEAL_JUSTICE = [==[{JUSTICE} · level 22
Sometimes stuns the enemy for 2 s, and its Judgement stops it from running away.
When: against humanoids that flee when low on health.]==],
  GUIDE_SEAL_FURY = [==[{FURY} · level 10, new (to be confirmed)
Holy damage on every hit and a small shield. Its Judgement makes nearby enemies attack you.
When: if you are the group's tank.]==],
  GUIDE_SEALS_JOKE = [==[Seven seals and only one hand to press them. That is what we are here for.]==],
  GUIDE_UNSEALED_TITLE = [==[Unsealed Wrath]==],
  GUIDE_UNSEALED_WHAT = [==[A Retribution talent. With it, every hit stores a copy of your seal (up to 3). When you hit with a different seal, all those copies are released at once on that hit.

In short: switching seals at the right moment does a lot more damage.]==],
  GUIDE_UNSEALED_H_HOW = [==[How to do it, in three steps]==],
  GUIDE_UNSEALED_STEP_1 = [==[|cfff2c14e1. Build up.|r Fight with {COMMAND}. When the display says |cfff2c14eSWITCH!|r, you have 3 copies.]==],
  GUIDE_UNSEALED_STEP_2 = [==[|cfff2c14e2. Switch and hit.|r Put on {RIGHTEOUSNESS} and land a hit. That releases the copies.]==],
  GUIDE_UNSEALED_STEP_3 = [==[|cfff2c14e3. Go back.|r When it says |cfff2c14eBACK!|r, put {COMMAND} on again and repeat.]==],
  GUIDE_UNSEALED_SHORTCUT = [==[Shortcut: the PFD Unsealed macro does the switch with one key. Press it when you see SWITCH! and when you see BACK!.]==],
  GUIDE_UNSEALED_JOKE = [==[It is juggling, but with holy seals and a murloc watching.]==],
  GUIDE_SITUATIONS_TITLE = [==[What to do when]==],
  GUIDE_SIT_SOLO = [==[|cfff2c14eLeveling on your own|r
Follow Your plan. If you always run out of mana, try fighting with {WISDOM}; if out of health, with {LIGHT}.]==],
  GUIDE_SIT_DUNGEON = [==[|cfff2c14eIn a dungeon|r
Your usual plan. Cast {JUDGEMENT} and {HOLY_STRIKE} as soon as they are ready and, if you have Unsealed Wrath, follow the display.]==],
  GUIDE_SIT_GROUP = [==[|cfff2c14eWith another paladin in the group|r
Talk before you start: if the group spends a lot of mana, one of you judges with {WISDOM}; if it takes a lot of damage, with {LIGHT}.]==],
  GUIDE_SIT_FLEE = [==[|cfff2c14eEnemies that run away|r
Some humanoids run off at low health and bring their friends. {HAMMER} stuns them; {JUSTICE} helps too.]==],
  GUIDE_SIT_UNDEAD = [==[|cfff2c14eUndead and demons|r
{EXORCISM} hits them really hard. Use it whenever it is ready.]==],
  GUIDE_SIT_DANGER = [==[|cfff2c14eIf you are about to die|r
{DIVINE_SHIELD} makes you immune for a few seconds. Use them to heal or to get out of there.]==],
  GUIDE_SIT_JOKE = [==[Special situation: the group is dead and you are still alive. Bubble Hearth. Just kidding. (Or not?)]==],
  GUIDE_MACROS_TITLE = [==[The macros]==],
  GUIDE_MACROS_INTRO = [==[A macro is a button that does several things at once. The addon can create them for you: turn it on in Options > Macros and drag them to your bar from the macro window (type /macro).]==],
  GUIDE_MACRO_GOLPE = [==[|cfff2c14ePFD Golpe|r
Casts {JUDGEMENT} and {HOLY_STRIKE} with one key. Press it as soon as it lights up.]==],
  GUIDE_MACRO_UNSEALED = [==[|cfff2c14ePFD Unsealed|r
Switches between {COMMAND} and {RIGHTEOUSNESS}. Every fight starts on {COMMAND}.]==],
  GUIDE_MACRO_SELLO = [==[|cfff2c14ePFD Sello|r
{COMMAND}; holding Shift, {RIGHTEOUSNESS}.]==],
  GUIDE_MACRO_UTILITY = [==[|cfff2c14eThe helper ones|r
Heals, protections, blessings, auras, resurrection... They go to the teammate under your mouse (or to you) without losing your enemy target.]==],
  GUIDE_MACROS_JOKE = [==[You have 18 character macro slots. Choose wisely, like a paladin. Well, better than a paladin.]==],
  GUIDE_FIGHTS_TITLE = [==[Your fights]==],
  GUIDE_FIGHTS_EMPTY = [==[No fights saved on this character yet. Go hit something and come back.]==],
  GUIDE_FIGHTS_COUNT = [==[Fights saved: %s]==],
  GUIDE_FIGHTS_JUDGE = [==[You use {JUDGEMENT} %s out of every 10 times you could.]==],
  GUIDE_FIGHTS_STRIKE = [==[You use {HOLY_STRIKE} %s out of every 10 times you could.]==],
  GUIDE_FIGHTS_TIP = [==[To improve: press PFD Golpe every time it lights up. Do not wait for anything.]==],
  GUIDE_FIGHTS_GOOD = [==[Great job! You hardly miss any.]==],
  GUIDE_FIGHTS_TWIST = [==[Fights where you switched seals with Unsealed Wrath: %s]==],
  GUIDE_GLOSSARY_TITLE = [==[Glossary]==],
  GUIDE_GLOSSARY_TEXT = [==[|cfff2c14ePull|r: starting the fight.

|cfff2c14eBuff|r: a good effect on you. |cfff2c14eDebuff|r: a bad effect on the enemy.

|cfff2c14eProc|r: something that triggers by luck when you hit.

|cfff2c14eCooldown (CD)|r: how long a spell takes to be ready again.

|cfff2c14eGlobal cooldown (GCD)|r: the 1.5 s pause after almost any spell.

|cfff2c14eAggro|r: who the enemy wants to hit. Spoiler: whoever annoys it most.

|cfff2c14eBubble Hearth|r: casting {DIVINE_SHIELD} and using your hearthstone. Paladin cultural heritage.]==],
  GUIDE_FAQ_TITLE = [==[FAQ]==],
  GUIDE_FAQ_Q_COMBAT = [==[Why does the little window disappear when I fight?]==],
  GUIDE_FAQ_A_COMBAT = [==[Its advice is for before you start. To always see it: Options > Advisor > When to show it.]==],
  GUIDE_FAQ_Q_AUTO = [==[Does this play for me?]==],
  GUIDE_FAQ_A_AUTO = [==[No. No button casts anything on its own, and the game does not let an addon tell you what to press mid-fight. You learn here, then you do it yourself.]==],
  GUIDE_FAQ_Q_SOURCE = [==[Can I trust the advice?]==],
  GUIDE_FAQ_A_SOURCE = [==[Look at the little colored square when you hover: blue, it comes from how the spell works; amber, from what guides say; green, from your own fights.]==],
  GUIDE_FAQ_Q_BUG = [==[Something does not work.]==],
  GUIDE_FAQ_A_BUG = [==[Options > Advanced > Error report. Copy it and send it to whoever maintains the addon. Thank you, really.]==],
  GUIDE_FAQ_JOKE = [==[|cfff2c14eCan I wear two seals at once?|r
No. Many tried before you.]==],
})
