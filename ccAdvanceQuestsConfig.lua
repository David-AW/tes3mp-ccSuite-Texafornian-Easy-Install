---------------------------
-- ccAdvanceQuestsConfig by Texafornian
--
-- Used by "ccAdvanceQuests" script

------------------
-- DO NOT TOUCH!
------------------

ccAdvanceQuestSettings = {}
ccAdvanceQuestSettings.Vanilla = {}
ccAdvanceQuestSettings.Tamriel = {}

------------------
-- GENERAL CONFIG
------------------

--------
-- INFO:
--
-- This can wipe the world file (optional), advance specific quests,
-- and give the player a list of dialogue topics.
--
-- All entries can be modfied/added/removed. Double-check your commas!
--------

-- If enabled, the server will wipe the world file every time the server restarts.
-- WARNING: If enabled, server crashes will lead to unscheduled wipes!
ccAdvanceQuestSettings.alwaysWipeOnRestart = false

-- If ccAdvanceQuestSettings.alwaysWipeOnRestart is set to false, then the server
-- will wipe the world file and advance quests IF the server restarts during 
-- the following hours.
ccAdvanceQuestSettings.Vanilla.WipeTimes = {
    { "00" },
    { "13" },
    { "12" }
}

-- Format (quests): { type, journal index, "questID", "actorRefId" }
ccAdvanceQuestSettings.Vanilla.Quests = {
	{ 0, 12, "a1_1_findspymaster", "caius cosades" }, 
	{ 0, 60, "tr_dbattack", "player" }
}

-- Format (topics): { "topic name" }
ccAdvanceQuestSettings.Vanilla.Topics = {
	{ "Balmora" },
	{ "Caius Cosades" },
	{ "Dark Brotherhood" },
	{ "fines and compensation" },
	{ "little advice" },
	{ "little secret" },
	{ "latest rumors" },
	{ "orders" },
	{ "report to Caius Cosades" },
	{ "transport to Mournhold" },
	{ "transport to Vvardenfell" }
}

ccAdvanceQuestSettings.Tamriel.WipeTimes = {
    { "00" }
}

ccAdvanceQuestSettings.Tamriel.Quests = {}

ccAdvanceQuestSettings.Tamriel.Topics = {}
