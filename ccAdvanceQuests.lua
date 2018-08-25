---------------------------
-- ccAdvanceQuests 0.7.0 by Texafornian
--
-- Requires "ccConfig.lua" in /scripts/ folder!
--
-- More quests can be added to "questInfo"
-- Format: type, index, quest, actorRefId

-----------------
-- CONFIG SECTION
-----------------

tableHelper = require("tableHelper")
require("ccConfig")
require("ccAdvanceQuestsConfig")

------------------
-- METHODS SECTION
------------------

local ccAdvanceQuests = {}

-- If server isn't set to always wipe world file on restart (ccAdvanceQuestsConfig),
-- then compare the current hour (on startup) to the appropriate wipe time table
ccAdvanceQuests.CheckTime = function()
    tes3mp.LogMessage(2, "Checking time for ccAdvanceQuest")

    if ccAdvanceQuestSettings.alwaysWipeOnRestart == false then
        local currentHour = os.date("%H")
        local wipeTimes = {}

        if string.lower(ccConfig.serverPlugins) == "tamriel" then -- TCC Tamriel
            wipeTimes = ccAdvanceQuestSettings.Tamriel.WipeTimes
        else
            wipeTimes = ccAdvanceQuestSettings.Vanilla.WipeTimes
        end

        for index, value in pairs(wipeTimes) do

            if currentHour == wipeTimes[index][1] then
                advanceQuests()
                break
            end
        end
    else
        advanceQuests()
    end
end

--------------------
-- FUNCTIONS SECTION
--------------------

-- Clear the journal and topics list, add vanilla info (ccAdvanceQuestsConfig),
-- then add Tamriel info if applicable
function advanceQuests()
	tes3mp.LogMessage(2, "Resetting journal and topic entries")

    WorldInstance.data.journal = {}
	WorldInstance.data.topics = {}

	for index, item in pairs(ccAdvanceQuestSettings.Vanilla.Quests) do
		local journalItem = {
			type = item[1],
			index = item[2],
			quest = item[3],
			actorRefId = item[4]
		}

		table.insert(WorldInstance.data.journal, journalItem)
	end
    
	for index, topicId in pairs(ccAdvanceQuestSettings.Vanilla.Topics) do

		if tableHelper.containsValue(WorldInstance.data.topics, topicId[1]) == false then
			table.insert(WorldInstance.data.topics, topicId[1])
		end
	end
    
    if string.lower(ccConfig.serverPlugins) == "tamriel" then -- TCC Tamriel
        
        for index, item in pairs(ccAdvanceQuestSettings.Tamriel.Quests) do
            local journalItem = {
                type = item[1],
                index = item[2],
                quest = item[3],
                actorRefId = item[4]
            }

            table.insert(WorldInstance.data.journal, journalItem)
        end
        
        for index, topicId in pairs(ccAdvanceQuestSettings.Tamriel.Topics) do

            if tableHelper.containsValue(WorldInstance.data.topics, topicId[1]) == false then
                table.insert(WorldInstance.data.topics, topicId[1])
            end
        end
    end

	WorldInstance:Save()
end

return ccAdvanceQuests