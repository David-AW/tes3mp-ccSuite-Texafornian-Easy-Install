---------------------------
-- ccConfig by Texafornian
--
-- Used by "cc" scripts
--
-- Modify everything except for the DO NOT TOUCH section
-- Tables can be edited in any way if the proper format is used

------------------
-- DO NOT TOUCH!
------------------

ccConfig = {}
ccInfoWindow = {}
ccInfoWindow.Window1 = {}
ccInfoWindow.Window2 = {}
ccInfoWindow.Window3 = {}
ccMOTD = {}
ccPunish = {}
ccPunish.Vanilla = {}
ccPunish.Tamriel = {}
ccSafeCells = {}
ccSafeCells.Vanilla = {}
ccSafeCells.Tamriel = {}
ccSpawn = {}
ccSpawn.Vanilla = {}
ccSpawn.Tamriel = {}

------------------
-- GENERAL CONFIG
------------------

-- Paths to various folders.
ccConfig.cellPath = os.getenv("MOD_DIR").."/cell/"
ccConfig.dataPath = os.getenv("MOD_DIR").."/"
ccConfig.playerPath = os.getenv("MOD_DIR").."/player/"

-- If running a server with Tamriel Rebuilt, Province Cyrodiil, and Skyrim: Home of the Nords...
-- ...change "vanilla" to "tamriel"
ccConfig.serverPlugins = "vanilla"

-- Enable various ccScript addons here.
ccConfig.advanceQuestsEnabled = true
ccConfig.hardcoreEnabled = true
ccConfig.perksEnabled = true
ccConfig.serverMsgEnabled = true

-- Delete a player's token and/or faction file after a number of days without logging in.
ccConfig.daysInactive = 30

-- The maximum number of players you've assigned for the server.
ccConfig.numberOfPlayers = 25

------------------------
-- INFO WINDOW CONFIG
------------------------

--------
-- INFO:
--
-- Three information windows that you can customize.
-- 
-- Command = /<command> causes the window to appear.
-- Message = The block of text in the window.
--------

ccInfoWindow.Window1.command = "modding"

ccInfoWindow.Window1.message = "Help build Tamriel!\n\
    Tamriel Rebuilt (Morrowind) and Project Tamriel (Cyrodiil, Skyrim) are always looking for more help.\n\
    Interested in creating interiors and exteriors?\
    How about writing dialogue and/or quests?\
    Maybe you're a modeler, texturer, or animator?\n\
    Your work will be seen on our Tamriel server!\n\
    Visit the following sites to learn more:\
    Tamriel Rebuilt: tamriel-rebuilt.org\
    Project Tamriel: project-tamriel.com"

ccInfoWindow.Window2.command = "schedule"

ccInfoWindow.Window2.message = "Server Schedules:\n\
    Both servers back up all data and reset cells every 6 hours (1 AM, 7 AM, 1 PM, 7 PM EDT)\n\
    Vanilla: Quests reset every 12 hours (1 AM, 1 PM EDT)\
    Tamriel: Quests reset every 24 hours (1 AM EDT)"

ccInfoWindow.Window3.command = nil

ccInfoWindow.Window3.message = nil
    
---------------
-- MOTD CONFIG
---------------

--------
-- INFO:
--
-- By default, the "Message of the Day" displays immediately after chargen.
--------

-- Determines whether players will see a MOTD after chargen.
ccMOTD.enabled = true

-- Customize your MOTD.
ccMOTD.message = color.MediumSeaGreen .. "Welcome to The Cornerclub!" .. color.GoldenRod .. "\
    Join our Discord at the-cornerclub.com\n\
    Rules:\
    1) Don't edit your stats\
    2) Don't spawn-camp\
    3) Don't create server instability\n\
    Commands:\
    " .. color.White .. "/perks" .. color.GoldenRod .. " - Collect/use tokens on special features\
    " .. color.White .. "/help" .. color.GoldenRod .. " - Learn about unique Cornerclub commands\
    " .. color.White .. "/stats" .. color.GoldenRod .. " - See how long you've played\
    " .. color.White .. "/schedule" .. color.GoldenRod .. " - Lists cell and quest reset times\n"

-- If hardcore mode is enabled, then this message will appear immediately below the above message.
-- A "Yes/No" prompt will appear below this message. "Yes" activates Hardcore Mode.
ccMOTD.messageHC = color.GoldenRod .. "Would you like to enable " .. color.Red .. "Hardcore Mode?" .. color.GoldenRod .. "\
    - Increased difficulty\
    - Character deletion upon death\
    - View the top rankings via /ladder"

-----------------
-- PUNISH CONFIG
-----------------

--------
-- INFO:
--
-- Sends a player to a random forsaken place when you don't feel like kicking or banning.
-- 
-- Interior cells: Preferably without doors.
-- Exterior cells: Preferably the ocean.
--------

ccPunish.Vanilla.Interiors = {
    { "Mark's Vampire Test Cell " },
    { "Mournhold" }, -- test cell
    { "Solstheim" } -- test cell
}

ccPunish.Vanilla.Exteriors = {
    { "30, 30", 249856, 249856, 0, 0 } -- ocean
}

ccPunish.Tamriel.Interiors = {}

ccPunish.Tamriel.Exteriors = {}

--------------------
-- SAFE CELLS CONFIG
--------------------

--------
-- INFO:
--
-- List of cells where players aren't punished for dying.
--
-- NOTE: This only protects Hardcore players at the moment.
--
-- If ccHardcore is enabled, you can modify ccHardcoreConfig.lua's 
-- ccHardcoreSettings.useSafeCells to use these cells or not.
--------

-- Must be set to true for everything in this section to be applied.
ccSafeCells.enabled = true

-- If enabled, then all of the cells in the Spawn Config section below will be added 
-- automatically to the list of safe cells.
ccSafeCells.useSpawnCells = true

-- List of additional protected cells. These are added to the list regardless of 
-- whether ccSafeCells.useSpawnCells is enabled.
-- Format: { "cell ID" }
ccSafeCells.Vanilla = {
    { "vor lair, chambers of alta vor" }
}

ccSafeCells.Tamriel = {}

----------------
-- SPAWN CONFIG
----------------

--------
-- INFO:
--
-- All entries can be modfied/added/removed and the spawn tables.
-- are generated/randomized automatically on start-up.
--
-- Format (items): { "refID", count, charge }
-- Format (clothes): { "refID", count (this should be 1), charge }
--------

-- Must be set to true for specific classes to receive items after chargen.
-- See ccSpawn.Vanilla.ClassItems & ccSpawn.Tamriel.ClassItems.
ccSpawn.startingClassItems = true

-- Must be set to true for players with specific skills to receive items after chargen.
-- See ccSpawn.Vanilla.MajorSkillItems & ccSpawn.Tamriel.MajorSkillItems.
ccSpawn.startingSkillItems = true

-- The minimum skill level that a player must have for a skill to receive a weapon 
-- after chargen.
-- If it's set to 0, then everyone will receive everything from the tables.
ccSpawn.startingSkillMinLevel = 35

-- Must be set to true for player to receive a weapon after chargen.
-- Server will iterate through a player's skills and give the first 
-- weapon category that meets the minimum skill threshold (see below).
ccSpawn.startingWeapon = true

-- The minimum skill level that a player must have for a weapon
-- skill to receive a weapon after chargen.
-- If it's set to 0, then everyone will receive something from the same weapon category.
ccSpawn.startingWeaponMinLevel = 40

-- List of cells/locations where players can randomly spawn after chargen.
-- Format (cells): { "cell ID", Xcoord, Ycoord, Zcoord, Zrot, "displayed name" }
ccSpawn.Vanilla.Cells = {
    { "-3, 6", -16523, 54362, 1973, 2.73, "Ald'Ruhn" },
    { "-11, 15", -89353, 128479, 110, 1.86, "Ald Velothi" },
    { "-3, -3", -20986, -17794, 865, -0.87, "Balmora" },
    { "-2, 2", -12238, 20554, 1514, -2.77, "Caldera" },
    { "7, 22", 62629, 185197, 131, -2.83, "Dagon Fel" },
    { "2, -13", 20769, -103041, 107, -0.87, "Ebonheart" },
    { "-8, 3", -58009, 26377, 52, -1.49, "Gnaar Mok" },
    { "-11, 11", -86910, 90044, 1021, 0.44, "Gnisis" },
    { "-6, -5", -49093, -40154, 78, 0.94, "Hla Oad" },
    { "-9, 17", -69502, 142754, 50, 2.89, "Khuul" },
    { "-3, 12", -22622, 101142, 1725, 0.28, "Maar Gan" },
    { "12, -8", 103871, -58060, 1423, 2.2, "Molag Mar" },
    { "0, -7", 2341, -56259, 1477, 2.13, "Pelagiad" },
    { "17, 4", 141415, 39670, 213, 2.47, "Sadrith Mora" },
    { "6, -6", 52855, -48216, 897, 2.36, "Suran" },
    { "14, 4", 122576, 40955, 59, 1.16, "Tel Aruhn" },
    { "14, -13", 119124, -101518, 51, 3.08, "Tel Branora" },
    { "13, 14", 106608, 115787, 53, -0.39, "Tel Mora" },
    { "3, -10", 36412, -74454, 59, -1.66, "Vivec" },
    { "11, 14", 101402, 114893, 158, -2.03, "Vos" }
}

-- Specific classes will receive these items after chargen if ccSpawn.startingClassItems = true.
-- More items and/or classes can be added by following the format.
-- Format: { "name of class", { "refID", count, charge }, <more items here> }
ccSpawn.Vanilla.ClassItems = {
    { "bard", { "misc_de_lute_01", 1, -1 }, { "misc_de_drum_01", 1, -1 } },
    { "healer", { "common_robe_02", 1, -1 } },
    { "mage", { "common_robe_02", 1, -1 } },
    { "monk", { "common_robe_01", 1, -1 } },
    { "pilgrim", { "bk_PilgrimsPath", 1, -1 } },
    { "sorcerer", { "common_robe_02", 1, -1 } }
}

-- Players with specific major skills will receive items in this table after chargen.
-- Delete any or all entries if you don't want players to spawn with certain things.
-- Format: { "name of major skill", { "refID", count, charge }, <more items here> }
ccSpawn.Vanilla.SkillItems = {
    { "alchemy", { "apparatus_a_mortar_01", 1, -1 }, { "apparatus_a_alembic_01", 1, -1 } },
    { "armorer", { "hammer_repair", 3, -1 } },
    { "block", { "nordic_leather_shield", 1, -1 } },
    { "enchant", { "misc_soulgem_common", 2, -1 } },
    { "security", { "pick_apprentice_01", 2, -1 }, { "probe_apprentice_01", 2, -1 } }
}

-- Players will receive all items in this table after chargen.
-- Delete any or all entries if you don't want players to spawn with certain things.
ccSpawn.Vanilla.MiscItems = {
    { "p_restore_health_b", 3, -1 },
    { "p_restore_fatigue_b", 3, -1 },
    { "p_restore_magicka_b", 3, -1 },
    { "gold_001", 75, -1 }
}

-- Players will receive one of these weapons after chargen if their skill is high enough.
ccSpawn.Vanilla.Axes = {
    { "chitin war axe", 1, -1 },
    { "iron battle axe", 1, -1 },
    { "iron war axe", 1, -1 },
    { "miner's pick", 1, -1 }
}

-- Players will receive one of these weapons after chargen if their skill is high enough.
ccSpawn.Vanilla.BluntWeapons = {
    { "chitin club", 1, -1 },
    { "iron club", 1, -1 },
    { "iron mace", 1, -1 },
    { "iron warhammer", 1, -1 },
    { "spiked club", 1, -1 },
    { "wooden staff", 1, -1 }
}

-- Players will receive one of these weapons after chargen if their skill is high enough.
ccSpawn.Vanilla.Longblades = {
    { "iron broadsword", 1, -1 },
    { "iron claymore", 1, -1 },
    { "iron longsword", 1, -1 },
    { "iron saber", 1, -1 }
}

ccSpawn.Vanilla.MarksmanAmmo = {
    { "chitin arrow", 50, -1 },
    { "iron arrow", 50, -1 }
}

-- Players will receive one of these weapons after chargen if their skill is high enough.
ccSpawn.Vanilla.MarksmanWeapons = {
    { "chitin short bow", 1, -1 },
    { "long bow", 1, -1 },
    { "short bow", 1, -1 }
}

-- Players will receive one of these weapons after chargen if their skill is high enough. 
ccSpawn.Vanilla.Shortblades = {
    { "chitin dagger", 1, -1 },
    { "chitin shortsword", 1, -1 },
    { "iron dagger", 1, -1 },
    { "iron shortsword", 1, -1 },
    { "iron tanto", 1, -1 },
    { "iron wakizashi", 1, -1 }
}

-- Players will receive one of these weapons after chargen if their skill is high enough.
ccSpawn.Vanilla.Spears = {
    { "chitin spear", 1, -1 },
    { "iron halberd", 1, -1 },
    { "iron long spear", 1, -1 },
    { "iron spear", 1, -1 }
}

-- Players will receive one of these pairs of pants after chargen.
ccSpawn.Vanilla.Pants = {
    { "common_pants_01", 1, -1 },
    { "common_pants_02", 1, -1 },
    { "common_pants_03", 1, -1 },
    { "common_pants_04", 1, -1 },
    { "common_pants_05", 1, -1 },
    { "common_pants_06", 1, -1 },
    { "common_pants_07", 1, -1 }
}

-- Players will receive one of these shirts after chargen.
ccSpawn.Vanilla.Shirts = {
    { "common_shirt_01", 1, -1 },
    { "common_shirt_02", 1, -1 },
    { "common_shirt_03", 1, -1 },
    { "common_shirt_04", 1, -1 },
    { "common_shirt_05", 1, -1 },
    { "common_shirt_06", 1, -1 },
    { "common_shirt_07", 1, -1 }
}

-- Players will receive one of these pairs of shoes after chargen.
ccSpawn.Vanilla.Shoes = {
    { "common_shoes_01", 1, -1 },
    { "common_shoes_02", 1, -1 },
    { "common_shoes_03", 1, -1 },
    { "common_shoes_04", 1, -1 },
    { "common_shoes_05", 1, -1 }
}

-- Players will receive one of these skirts after chargen.
ccSpawn.Vanilla.Skirts = {
    { "common_skirt_01", 1, -1 },
    { "common_skirt_02", 1, -1 },
    { "common_skirt_03", 1, -1 },
    { "common_skirt_04", 1, -1 },
    { "common_skirt_05", 1, -1 }
}

-- Additional cells/locations that are added to vanilla table 
-- if "tamriel" is chosen above.
ccSpawn.Tamriel.Cells = {
    { "-106, 8", -862215, 66311, 86, 2.89, "Karthwasten" },
    { "136, -52", -1106032, -421883, 237, -2.06, "Stirk" }
}

-- WIP tables.
ccSpawn.Tamriel.ClassItems = {}

ccSpawn.Tamriel.SkillItems = {}

ccSpawn.Tamriel.MiscItems = {}

ccSpawn.Tamriel.Axes = {}

ccSpawn.Tamriel.BluntWeapons = {}

ccSpawn.Tamriel.Longswords = {}

ccSpawn.Tamriel.MarksmanWeapons = {}

ccSpawn.Tamriel.MarksmanAmmo = {}

ccSpawn.Tamriel.Shortswords = {}

ccSpawn.Tamriel.Spears = {}

ccSpawn.Tamriel.Pants = {}

ccSpawn.Tamriel.Shirts = {}

ccSpawn.Tamriel.Shoes = {}

ccSpawn.Tamriel.Skirts = {}
