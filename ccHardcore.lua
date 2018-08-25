---------------------------
-- ccHardcore 0.7.0 by Texafornian
--
-- Requires "ccConfig.lua" in /scripts/ folder!
-- Requires "ccHardcoreSettings.lua" in /scripts/ folder!
--
-- Many thanks to:
-- * Mupf

------------------
-- DO NOT TOUCH!
------------------

require("ccConfig")
require("ccHardcoreConfig")
require("config")

deathDropTable = {}
ladderList = {}

local ccSettings = {}

ccSettings.currentLadder = ""
ccSettings.windowLadder = 81200

------------------
-- METHODS SECTION
------------------

local Methods = {}

for i = 1, 43 do -- do not delete/change this.
	Methods[i] = {false}
end

-- Initializes ladder table
Methods.LoadLadderList = function()
	tes3mp.LogMessage(2, "Reading ladder_" .. os.date("%y%m") .. ".json")
	ladderList = jsonInterface.load("ladder_" .. os.date("%y%m") .. ".json")
end

-- Used to enable hardcore mode for new players
Methods.HardcoreMode = function(pid)
    local newDifficulty = config.difficulty + MethodsSettings.addedDifficulty
    local playerNameLC = string.lower(Players[pid].name)

    -- Enable hardcore mode
    Players[pid].data.hardcoreMode.enabled = 1
    Players[pid]:Save()

    -- Increase player's difficulty
    tes3mp.SetDifficulty(pid, newDifficulty)
    tes3mp.SendSettings(pid)
    
    -- Avoid edge case where player creates character on last day then new month starts before server restart
    if Methods.LadderExists() == true then
        local hcLadder = "ladder_" .. os.date("%y%m")

        if ladderList.players[playerNameLC] then -- Ensure there's no residual pre-death info saved from another player
            ladderList.players[playerNameLC] = nil
            jsonInterface.save( hcLadder .. ".json", ladderList)
        end

        local player = {} -- Create a table entry for this player in the ladder file
        player.displayName = Players[pid].data.login.name
        player.level = 1
        ladderList.players[playerNameLC] = player
        jsonInterface.save("ladder_" .. ccSettings.currentLadder .. ".json", ladderList)

        tes3mp.SendMessage(pid, color.Orange .. Players[pid].name .. " has enabled " .. color.Red .. "Hardcore Mode." .. color.Orange .. " Good luck!\n", true)
    else
        tes3mp.SendMessage(pid, color.Red .. "Failed to start Hardcore mode. Please contact an admin to delete your character and try again after the next server restart.\n", false)
    end
end

-- Used to automatically generate monthly Hardcore ladders
Methods.LadderCheck = function()
    ccSettings.currentLadder = os.date("%y%m")
    local ladderFile = io.open(ccConfig.dataPath .. "ladder_" .. ccSettings.currentLadder .. ".json", "r")
    
    -- https://stackoverflow.com/questions/16367524/copy-csv-file-to-new-file-in-lua
    if Methods.LadderExists() == true then -- Ladder file is present so do nothing
        tes3mp.LogMessage(1, "File for ladder " .. ccSettings.currentLadder .. " is present")
        return true
    else -- Ladder file is not present, so copy the contents of the template file and write to new file using current month as title
        tes3mp.LogMessage(1, "++++ File for ladder " .. ccSettings.currentLadder .. " is not present. Copying template file. ++++")
        
        local templateFile = io.open(ccConfig.dataPath .. "ladderTemplate.json", "r")
        local copyTemplate = templateFile:read("*a")
        templateFile:close()
        
        tes3mp.LogMessage(1, "++++ Template file copied. Writing JSON table. ++++")
        
        ladderFile = io.open(ccConfig.dataPath .. "ladder_" .. ccSettings.currentLadder .. ".json", "w")
        ladderFile:write(copyTemplate)
        ladderFile:close()
        tes3mp.LogMessage(1, "++++ File for ladder " .. ccSettings.currentLadder .. " created. ++++")
        return true
    end
end

-- Ensures the correct ladder file is present, mostly for end-of-month edge case
Methods.LadderExists = function() 
    local hcLadder = os.date("%y%m") -- The main check
    local ladderFile = io.open(ccConfig.dataPath .. "ladder_" .. hcLadder .. ".json", "r")

    if ladderFile then return true
    else return false
    end
end

-- Called from /ladder command, ranks players in current ladder file
Methods.LadderParse = function(pid)

    -- Account for end-of-month edge case
    if Methods.LadderExists() == false then
        tes3mp.SendMessage(2, color.Red .. "Please wait until the next server restart for the new ladder." .. color.Default .. "\n", false)
        return false
    end

    local ladderChars = ladderList.players
    local ladderLabel = "Hardcore Ladder Rankings (" .. os.date("%y") .. "-" .. os.date("%m") .. ")"
    local ladderRanks = ""
    local ladderRaw = {}

    -- Populate temporary table "ladderRaw" with all players in current ladder
    for pid, p in pairs(ladderChars) do 
        local name = p.displayName
        local level = p.level
        ladderRaw[name] = level
    end

    -- Sort ladderRaw by highest-to-lowest
    for k,v in spairs(ladderRaw, function(t,a,b) return t[b] < t[a] end) do
        ladderRanks = ladderRanks .. k .. " (Level " .. v .. ")" .. "\n" 
    end

    -- Display the sorted players in a scrolllable box
    tes3mp.ListBox(pid, ccSettings.windowLadder, ladderLabel, ladderRanks)
end

Methods.ProcessDeath = function(pid)
    deathLog(pid)

    local diffDays = 0
    local diffHours = 0
    local diffMinutes = 0
    local playerName = string.lower(Players[pid].name)
    local playerNameLC = string.lower(Players[pid].data.login.name)
    local timePlayed = Players[pid].data.timeKeeping.timePlayed

    diffDays, diffHours, diffMinutes = scriptLoader.GetScript("ccScript").ParseTime(timePlayed, nil, 2)

    tes3mp.SendMessage(pid, color.Red .. "RIP: " .. playerName .. " died after surviving for " .. diffDays .. " day(s), " .. diffHours .. " hour(s), " .. diffMinutes .. " minute(s).\n", true)

    if ccDeathDrop.enabled == true then
        deathDrop(pid)
    end

    if Methods.LadderExists() == true then
        local hcLadder = "ladder_" .. os.date("%y%m")
        
        if ladderList.players[playerNameLC] then
            tes3mp.LogMessage(2, "++++ Removing player " .. playerName .. " from the ladder file ++++")
            ladderList.players[playerNameLC] = nil
            jsonInterface.save( hcLadder .. ".json", ladderList)
        end
    end

    -- Thanks to mupf for this approach
    os.remove(ccConfig.playerPath .. Players[pid].data.login.name .. ".json")
    Players[pid]:Kick()
end

Methods.SetupDeathDrop = function()
    tes3mp.LogMessage(2, "Populating death drop table with vanilla entries")

    for index, entryData in ipairs(ccDeathDrop.Vanilla.otherDrops) do
        table.insert(deathDropTable, entryData)
    end

    if string.lower(ccConfig.serverPlugins) == "tamriel" then -- TCC Tamriel
        tes3mp.LogMessage(2, "Populating death drop table with Tamriel entries")

        for index, entryData in ipairs(ccDeathDrop.Tamriel.otherDrops) do
            table.insert(deathDropTable, entryData)
        end
    end
end

--------------------
-- FUNCTIONS SECTION
--------------------

-- Logs death reason for HC characters
function deathLog(pid)
    local deathReason = tes3mp.GetDeathReason(pid)

    tes3mp.LogMessage(1, "Original death reason was " .. deathReason)

    if deathReason ~= "suicide" then
        local playerKiller = deathReason

        for pid, player in pairs(Players) do

            if string.lower(playerKiller) == string.lower(player.name) then

                if player.data.ipAddresses ~= nil then
                    local ipAddressT = ""

                    for index, ipAddress in pairs(player.data.ipAddresses) do
                        ipAddressT = ipAddressT .. ipAddress

                        if index < #player.data.ipAddresses then
                            ipAddressT = ipAddressT .. ", "
                        end
                    end

                    tes3mp.LogMessage(2, "++++ " .. deathReason .. " (" .. ipAddressT .. ") PKed in cell " .. tes3mp.GetCell(pid) .. " (" .. tes3mp.GetPosX(pid) .. ", " .. tes3mp.GetPosY(pid) .. ", " .. tes3mp.GetPosZ(pid) .. ") ++++")
                end
            end
        end
    end
end

-- Drops a dead Hardcore player's gold on the ground
function deathDrop(pid)
    tes3mp.LogMessage(2, "++++ Running Methods's deathDrop function ++++")

    -- First drop mandatory "otherDrops" from MethodsConfig (if any)
    if #deathDropTable > 0 then
        tes3mp.LogMessage(2, "++++ deathDrop: deathDropTable has entries ++++")

        for index, value in pairs(deathDropTable) do
            dropItem(pid, deathDropTable[index][1], deathDropTable[index][2])
        end
    end

    -- Then look for any gold in player's inventory
    tes3mp.LogMessage(2, "++++ deathDrop: Looking for gold in player inventory ++++")

    for index, value in pairs(Players[pid].data.inventory) do

        if string.lower(Players[pid].data.inventory[index].refId) == "gold_001" then
            tes3mp.LogMessage(2, "++++ deathDrop: Dropping gold ++++")
            dropItem(pid, "gold_001", Players[pid].data.inventory[index].count)
            break
        end
    end
end

-- Drops an item on the ground and sends a packet to everyone else
function dropItem(pid, refId, count)
    local mpNum = WorldInstance:GetCurrentMpNum() + 1
    local cell = tes3mp.GetCell(pid)
    local location = {
        posX = tes3mp.GetPosX(pid), 
        posY = tes3mp.GetPosY(pid), 
        posZ = tes3mp.GetPosZ(pid)
    }
    local refIndex =  0 .. "-" .. mpNum

    WorldInstance:SetCurrentMpNum(mpNum)
    tes3mp.SetCurrentMpNum(mpNum)

    LoadedCells[cell]:InitializeObjectData(refIndex, refId)
    LoadedCells[cell].data.objectData[refIndex].location = location
    table.insert(LoadedCells[cell].data.packets.place, refIndex)
    LoadedCells[cell]:Save()

    for onlinePid, player in pairs(Players) do

        if player:IsLoggedIn() then
            tes3mp.InitializeEvent(onlinePid)
            tes3mp.SetEventCell(cell)
            tes3mp.SetObjectRefId(refId)
            tes3mp.SetObjectCount(count)
            tes3mp.SetObjectRefNumIndex(0)
            tes3mp.SetObjectMpNum(mpNum)

            tes3mp.SetObjectPosition(location.posX, location.posY, location.posZ)
            tes3mp.AddWorldObject()
            tes3mp.SendObjectPlace()
        end
    end
end

-- Sorts a given table by highest-to-lowest values
-- https://stackoverflow.com/questions/15706270/sort-a-table-in-lua
function spairs(t, order) 
    local keys = {}

    for k in pairs(t) do keys[#keys+1] = k end
    
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    local i = 0
    return function()
        i = i + 1
        
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

Methods[USES_COMMAND][1] = true
Methods[USES_COMMAND].Func = function(pid, isAdmin, isModerator, cmd, message) -- On player sent command (parameter "cmd" is a table)

	if cmd[1] == "ladder" then
		Methods.LadderParse(pid)
		return COMMAND_EXECUTED
	end
	
	return DO_NOTHING
end

return Methods