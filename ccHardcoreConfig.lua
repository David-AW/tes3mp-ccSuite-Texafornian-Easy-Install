---------------------------
-- ccHardcoreConfig by Texafornian
--
-- Used by "ccHardcore" script
--
-- HUGE thanks to:
-- Dave for the original deathDrop.lua
-- Mupf for modifying deathDrop.lua
-- Atkana and Rickoff for modifying deathDrop.lua to only drop gold
-- 
-- Modify everything except for the DO NOT TOUCH section
-- Tables can be edited in any way if the proper format is used

------------------
-- DO NOT TOUCH!
------------------

ccHardcoreSettings = {}

ccDeathDrop = {}
ccDeathDrop.Vanilla = {}
ccDeathDrop.Tamriel = {}

------------------
-- GENERAL CONFIG
------------------

-- How much harder the game should be for HC players.
-- Set it to 0 for no extra difficulty.
ccHardcoreSettings.addedDifficulty = 25

-- If enabled, then a player will not be deleted when they die in a "safe cell" (ccConfig.lua).
ccHardcoreSettings.useSafeCells = true

--------------------
-- DEATH DROP CONFIG
--------------------

--------
-- INFO:
--
-- The people in the header deserve the credit for this.
-- I've only modified deathDrop.lua and included it in ccHardcore as a method.
--
-- NOTE: Only player gold and the "otherDrops" will drop right now! 
-- Need to figure out how to package packets together.
--------

-- If enabled, then the inventory of a Hardcore player who dies will 
-- be dropped on the ground, allowing other players to loot them.
ccDeathDrop.enabled = true

-- If enabled, then Hardcore players will only drop their gold when they die.
-- "ccDeathDrop.enabled" must be set to true for this to work.
-- ccDeathDrop.dropOnlyGold = true

-- Drop additional items that the player wasn't necessarily carrying.
-- "ccDeathDrop.enabled" must be set to true for this to work.
-- Anyone else remember Diablo II's ears?
-- Format: { "refID", count, charge }
ccDeathDrop.Vanilla.otherDrops = {
    { "misc_skull00", 1, -1 },
}

ccDeathDrop.Tamriel.otherDrops = {}
