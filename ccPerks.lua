---------------------------
-- ccPerks 0.7.0 by Texafornian
--
-- Requires "ccConfig.lua" in /scripts/ folder!
-- Requires "ccPerksConfig.lua" in /scripts/ folder!
-- Requires "tokenlist.json" in /data/ folder!
--
-- Many thanks to:
-- * ppsychrite
-- * Reinhart
-- * Mupf
-- * Atkana
-- Template written by David-AW for ScriptLoader.lua

------------------
-- DO NOT TOUCH!
------------------

tableHelper = require("tableHelper")
require("ccConfig")
require("ccPerksConfig")

creatureTable = {}
tokenList = {}
warpTable = {}

local ccSettings = {}

ccSettings.Perks = {}
ccSettings.perksText = ""
ccSettings.windowChangeBirthsign = 81100
ccSettings.windowChangeGender = 81101
ccSettings.windowChangeHair = 81102
ccSettings.windowChangeHead = 81103
ccSettings.windowChangeRace = 81104
ccSettings.windowPerks = 81105
ccSettings.windowSetCreature = 81106
ccSettings.windowSpawnPet = 81107
ccSettings.windowWarp = 81108

------------------
-- METHODS SECTION
------------------

local Methods = {}

for i = 1, 43 do -- do not delete/change this.
	Methods[i] = {false}
end

-- Initializes token table
Methods.LoadTokenList = function()
	tes3mp.LogMessage(2, "Reading tokenlist.json")
	tokenList = jsonInterface.load("tokenlist.json")
end

Methods.OnGUIAction = function(pid, idGui, data)
	local pick = 0
    
    if tonumber(data) ~= nil then
        pick = tonumber(data) + 1 -- Mostly for LUA table entries
    end

	if idGui == ccSettings.windowChangeBirthsign then

		if pick < 14 then -- 14 is Cancel
			birthsignChanger(pid, pick)
		end
		return true
	elseif idGui == ccSettings.windowChangeGender then
		pick = pick - 1

		if pick < 2 then -- 2 is Cancel
			genderChanger(pid, pick)
		end
		return true
	elseif idGui == ccSettings.windowChangeHair then

		if hairCancelCheck(pid, pick) == true then
			hairChanger(pid, pick)
		end
		return true
	elseif idGui == ccSettings.windowChangeHead then

		if headCancelCheck(pid, pick) == true then
			headChanger(pid, pick)
		end
		return true
	elseif idGui == ccSettings.windowChangeRace then

		if pick <= #raceTable then
			raceChanger(pid, pick)
		end
		return true
	elseif idGui == ccSettings.windowPerks then

        if pick <= #ccSettings.Perks then
            perksHandler(pid, pick)
        end
		return true
	elseif idGui == ccSettings.windowSetCreature then

		if pick <= #creatureTable then
			creatureChanger(pid, pick)
		end
		return true
	elseif idGui == ccSettings.windowSpawnPet then
		pick = pick - 1

		if pick < 3 then
			spawnPet(pid, pick)
		end
		return true
	elseif idGui == ccSettings.windowWarp then

        if pick <= #spawnTable then
            warpHandler(pid, pick)
        end
        return true
	end

	return false
end

Methods.ProcessLevelUp = function(pid) -- Give tokens every other level-up
	local newLevel = tes3mp.GetLevel(pid)
	local playerName = string.lower(Players[pid].name)
	
	if newLevel <= 78 and math.fmod(newLevel, 2) == 0 then -- Set level cap of 78 and calculate remainder when dividing newLevel by 2
		tes3mp.LogMessage(2, "++++ Player " .. playerName .. " has leveled up to level " .. newLevel .. " (" .. type(newLevel) .. " var) ++++")
		
		nilTokenCheck(playerName)
		
		tokenList.players[playerName].tokens = tokenList.players[playerName].tokens + 1
		jsonInterface.save("tokenlist.json", tokenList)
		tes3mp.SendMessage(pid, color.Gold .. "You've received a token for leveling up! You can use it on /perks." .. color.Default .. "\n", false)
	end
end

Methods.PerksWindow = function(pid)
	local playerName = string.lower(Players[pid].name)
	
	nilTokenCheck(playerName)
	local tokenCounter = tokenList.players[playerName].tokens
    
	local windowLabel = "Current number of tokens: " .. tokenCounter .. "\nPlease choose a perk:"
	tes3mp.ListBox(pid, ccSettings.windowPerks, windowLabel, ccSettings.perksText)
end

Methods.ProcessHCDeath = function(pid)
	local playerName = string.lower(Players[pid].name)

	if tokenList.players[playerName] then
		tes3mp.LogMessage(2, "++++ Removing player " .. playerName .. " from the token file ++++")
		tokenList.players[playerName] = nil
		jsonInterface.save( "tokenlist.json", tokenList)
	end
end

Methods.SetupCreatures = function()
    tes3mp.LogMessage(2, "Populating creatures table with vanilla entries")

    for index, value in ipairs(ccCreature.Vanilla) do

        if ccCreature.Vanilla[index] ~= nil then
            table.insert(creatureTable, ccCreature.Vanilla[index])
            ccCreature.creatureText = ccCreature.creatureText .. ccCreature.Vanilla[index][2] .. "\n"
        end
    end

    if string.lower(ccConfig.serverPlugins) == "tamriel" then -- TCC Tamriel
        tes3mp.LogMessage(2, "Populating creatures table with Tamriel entries")

        for index, value in ipairs(ccCreature.Tamriel) do

            if ccCreature.Tamriel[index] ~= nil then
                table.insert(creatureTable, ccCreature.Tamriel[index])
                ccCreature.creatureText = ccCreature.creatureText .. ccCreature.Tamriel[index][2] .. "\n"
            end
        end

    end

    ccCreature.creatureText = ccCreature.creatureText .. "Cancel"
end

Methods.SetupLottery = function() 
    local count = 0
    
    for index, value in pairs(ccLottery.Tokens) do
        
        if ccLottery.Tokens[index][2] ~= 0 then
            count = count + ccLottery.Tokens[index][2]
        end
    end

    ccLottery.ItemEntries = tableHelper.getCount(ccLottery.Items)
    ccLottery.TokenEntries = count
    ccLottery.TotalEntries = (ccLottery.TokenEntries + ccLottery.ItemEntries + ccLottery.FillerEntries)
end

Methods.SetupPerks = function()
    tes3mp.LogMessage(2, "Populating perks table")

    for index, value in ipairs(ccSettings.Perks) do

        if ccSettings.Perks[index].name ~= nil then
            ccSettings.perksText = ccSettings.perksText .. ccSettings.Perks[index].name .. "\n"
        end
    end

    ccSettings.perksText = ccSettings.perksText .. "Cancel"
end

Methods.SetupRaces = function()
    tes3mp.LogMessage(2, "Populating races table with vanilla entries")

    for index, value in ipairs(ccRace.Vanilla) do

        if ccRace.Vanilla[index] ~= nil then
            table.insert(raceTable, ccRace.Vanilla[index])
            ccRace.raceText = ccRace.raceText .. ccRace.Vanilla[index][10] .. "\n"
        end
    end

    if string.lower(ccConfig.serverPlugins) == "tamriel" then -- TCC Tamriel

        for index, value in ipairs(ccRace.Tamriel) do
            tes3mp.LogMessage(2, "Populating races table with Tamriel entries")
            
            if ccRace.Tamriel[index] ~= nil then
                table.insert(raceTable, ccRace.Tamriel[index])
                ccRace.raceText = ccRace.raceText .. ccRace.Vanilla[index][10] .. "\n"
            end
        end
    end
    
    ccRace.raceText = ccRace.raceText .. "Cancel"
end

Methods.SetupWarp = function()
    tes3mp.LogMessage(2, "Populating warp table")
    
    for index, value in ipairs(spawnTable) do

        if spawnTable[index][4] ~= nil then
            ccWarp.warpText = ccWarp.warpText .. spawnTable[index][6] .. "\n"
        end
    end
    
    ccWarp.warpText = ccWarp.warpText .. "Cancel"
end

Methods.TokenAdd = function(pid, pid2, numTokens) -- Used to manually give a player tokens
	
	if myMod.CheckPlayerValidity(pid, pid2) then
		local playerName = string.lower(Players[tonumber(pid2)].name)
		local tokenCounter = 0
		local message = ""
		
		nilTokenCheck(playerName)
		
		if numTokens ~= nil then
			tokenCounter = tokenList.players[playerName].tokens + numTokens
			message = color.Gold .. "SERVER: " .. playerName .. " has received " .. numTokens .. " token(s)!\n"
		else
			tokenCounter = tokenList.players[playerName].tokens + 1
			message = color.Gold .. "SERVER: " .. playerName .. " has received a token!\n"
		end
		
		tokenList.players[playerName].tokens = tokenCounter
		jsonInterface.save("tokenlist.json", tokenList)
		tes3mp.SendMessage(pid, message, true)
	end
end

Methods.TokenAddAll = function(origPid, numTokens) -- Used to manually give all connected player tokens
	local changeMade = false

	for pid, p in pairs(Players) do -- Check connected players for faction's entry and send message
		
		if p ~= nil and p:IsLoggedIn() and p.pid ~= origPid then
			local playerName = string.lower(Players[p.pid].name)
			local tokenCounter = 0
			local message = ""

			nilTokenCheck(playerName)
			
			if numTokens ~= nil then
				tokenCounter = tokenList.players[playerName].tokens + numTokens
				message = color.Gold .. "SERVER: " .. playerName .. " has received " .. numTokens .. " token(s)!\n"
			else
				tokenCounter = tokenList.players[playerName].tokens + 1
				message = color.Gold .. "SERVER: " .. playerName .. " has received a token!\n"
			end
			tokenList.players[playerName].tokens = tokenCounter
			changeMade = true
			tes3mp.SendMessage(p.pid, message, true)
		end
	end
	
	if changeMade == true then
		jsonInterface.save("tokenlist.json", tokenList)
	end
end

Methods.TokenCheck = function(pid, pid2) -- Used to check number of tokens
	local tokenCounter = 0
	local message = ""
	
	if myMod.CheckPlayerValidity(pid, pid2) then
		local playerName = Players[tonumber(pid2)].name
		
		nilTokenCheck(playerName)
		
		tokenCounter = tokenList.players[playerName].tokens
		
		if tokenCounter <= 0 then
			message = color.Gold .. playerName .. " doesn't have any tokens.\n"
		else
			message = color.Gold .. playerName .. " has " .. tokenCounter .. " token(s).\n"
		end
	end
	tes3mp.SendMessage(pid, message, false)
end

Methods.TokenClean = function() -- Used to clean nil or "inactive" (>30 days) player entries in tokenList
	tes3mp.LogMessage(2, "Cleaning tokenlist.json...")
	local tokenPlayers = tokenList.players
	
	for pid, p in pairs(tokenPlayers) do
		
		if p.claimdate == "" or type(p.claimdate) == "string" then
			tokenList.players[pid] = nil
			tes3mp.LogMessage(2,"...deleting an empty token entry...")
		else
			local diff = (os.time() - p.claimdate)
			
			if (diff / 86400) > ccConfig.daysInactive then
				tokenList.players[pid] = nil
				tes3mp.LogMessage(2,"...deleting an inactive token entry...")
			end
		end
	end
	
	jsonInterface.save("tokenlist.json", tokenList)
	tes3mp.LogMessage(2, "...tokenlist.json has been cleaned")
end

--------------------
-- FUNCTIONS SECTION
--------------------

function birthsignChanger(pid, pick)
	local message = ""
	local birthsignSet = {"elfborn", "wombburned", "lady's favor", "trollkin", "mooncalf", "fay", "blessed touch sign", "star-cursed", "moonshadow sign", "charioteer", "hara", "beggar's nose", "warwryd"}
	local playerName = string.lower(Players[pid].name)
	local birthsign = birthsignSet[pick]

	tes3mp.LogMessage(2, "++++ " .. playerName .. " tried to use /setbirthsign with pick of " .. pick .. " ++++")
	
	if birthsign == Players[pid].data.character.birthsign then -- Check whether player already has this birthsign
		message = color.Gold .. "You already have that Birthsign.\n"
		tes3mp.SendMessage(pid, message, false)
		return false
	end
	
	nilTokenCheck(playerName)

	if Players[pid]:IsAdmin() then
	else

		if tokenCalc(pid, playerName, ccPerksSettings.tokenCostBirthsign) == false then
			return false
		end
	end
	
	Players[pid].data.character.birthsign = birthsign
	-- Players[pid]:LoadCharacter() - Sets level to 1 but could be fixed via setcreature solution
	message = color.Gold .. "Your Birthsign is now " .. birthsign .. ".\nReconnect to the server to apply the change.\n"
	tes3mp.SendMessage(pid, message, false)
end

function creatureChanger(pid, pick)
	local creature = ""
	local playerName = string.lower(Players[pid].name)

    tes3mp.LogMessage(2, "++++ " .. playerName .. " tried to use /setcreature with pick of " .. pick .. " ++++")

	nilTokenCheck(playerName)

	if Players[pid]:IsAdmin() then
	else

		if tokenCalc(pid, playerName, ccPerksSettings.tokenCostCreature) == false then
			return false
		end
	end

    if ccCreature.Vanilla[pick] ~= nil then
        creature = ccCreature.Vanilla[pick][1]
    end

	-- Store current player info 
	local tempAttrs = Players[pid].data.attributes
	local tempStats = Players[pid].data.stats
	local tempSkills = Players[pid].data.skills
	local tempSpells = Players[pid].data.spellbook

	-- Creature model cmd sets player info to level 1
	tes3mp.SetCreatureModel(pid, creature, false)
	tes3mp.SendBaseInfo(pid)

	-- Restore player's info
	Players[pid].data.attributes = tempAttrs
	Players[pid].data.stats = tempStats
	Players[pid].data.skills = tempSkills
	Players[pid].data.spellbook = tempSpells
	tes3mp.SendAttributes(pid)
	tes3mp.SendStatsDynamic(pid)
	tes3mp.SendSkills(pid)
	tes3mp.SendLevel(pid)
	tes3mp.SendSpellbookChanges(pid)

	-- Equipment need to be re-equipped for bonuses to take effect again
	Players[pid]:LoadEquipment()

	local message = color.Gold .. "Other players now see you as a " .. ccCreature.Vanilla[pick][2] .. ".\n"
	tes3mp.SendMessage(pid, message, false)
end

function genderChanger(pid, gender)
	local message = ""
	local playerName = string.lower(Players[pid].name)
	local race = string.lower(Players[pid].data.character.race)

	tes3mp.LogMessage(2, "++++ " .. playerName .. " (" .. race .. ") tried to use /setgender " .. gender .. " ++++")

	if gender == Players[pid].data.character.gender then -- Check whether player already has this gender
		tes3mp.SendMessage(pid, color.Gold .. "You already have that gender.\n", false)
		return false
	end

    local genderHair = (gender * 4) + 2
    local genderHead = (gender * 4) + 4

    -- Find corresponding entry in raceTable
    local holdIndex = parseRaceTable(race)

    local hair = raceTable[holdIndex][genderHair] .. "01"
	local head = raceTable[holdIndex][genderHead] .. "01"

    if race == "t_sky_reachman" then
        hair = hair .. "a"
        head = head .. "a"
    end
    
	nilTokenCheck(playerName)

	if Players[pid]:IsAdmin() then
	else

		if tokenCalc(pid, playerName, ccPerksSettings.tokenCostGender) == false then
			return false
		end
	end

	Players[pid].data.character.gender = gender
	Players[pid].data.character.hair = hair
	Players[pid].data.character.head = head

	message = color.Gold .. "Your gender has been switched.\nReconnect to the server to apply the change.\n"
	tes3mp.SendMessage(pid, message, false)
end

function hairCancelCheck(pid, pick)
    local genderHairNum = (Players[pid].data.character.gender * 4) + 3
	local race = string.lower(Players[pid].data.character.race)

    -- Find corresponding entry in raceTable
    local holdIndex = parseRaceTable(race)

    if pick <= raceTable[holdIndex][genderHairNum] then
        return true
    else
        return false 
    end
end

function hairChanger(pid, pick)
	local message = ""
    local gender = Players[pid].data.character.gender
	local playerName = string.lower(Players[pid].name)
	local race = string.lower(Players[pid].data.character.race)

	tes3mp.LogMessage(2, "++++ " .. playerName .. " (" .. race .. ") tried to use /sethair " .. pick .. " ++++")

    if pick < 10 then
		pick = "0" .. pick
        
        if race == "t_sky_reachman" then
            pick = pick .. "a"
        end
	end

    -- Find corresponding entry in raceTable
    local holdIndex = parseRaceTable(race)

    -- Check whether player already has this head
    local chosenHair = ""
    local genderHair = (gender * 4) + 2

    chosenHair = raceTable[holdIndex][genderHair] .. pick

    if chosenHair == string.lower(Players[pid].data.character.hair) then
        tes3mp.SendMessage(pid, color.Gold .. "You already have that hairstyle.\n", false)
        return false
    end

	nilTokenCheck(playerName)

	if Players[pid]:IsAdmin() then
	else

		if tokenCalc(pid, playerName, ccPerksSettings.tokenCostHair) == false then
			return false
		end
	end

	Players[pid].data.character.hair = raceTable[holdIndex][genderHair] .. pick

	message = color.Gold .. "Your hairstyle is now " .. chosenHair .. ".\nReconnect to the server to apply the change.\n"
	tes3mp.SendMessage(pid, message, false)
end

function headCancelCheck(pid, pick)
    local genderHeadNum = (Players[pid].data.character.gender * 4) + 5
	local race = string.lower(Players[pid].data.character.race)

    -- Find corresponding entry in raceTable
    local holdIndex = parseRaceTable(race)

    if pick <= raceTable[holdIndex][genderHeadNum] then
        return true
    else
        return false 
    end
end

function headChanger(pid, pick)
	local message = ""
    local gender = Players[pid].data.character.gender
	local playerName = string.lower(Players[pid].name)
	local race = string.lower(Players[pid].data.character.race)

	tes3mp.LogMessage(2, "++++ " .. playerName .. " (" .. race .. ") tried to use /sethead " .. pick .. " ++++")

    if pick < 10 then
		pick = "0" .. pick
        
        if race == "t_sky_reachman" then
            pick = pick .. "a"
        end
	end

    -- Find corresponding entry in raceTable
    local holdIndex = parseRaceTable(race)

    -- Check whether player already has this head
    local chosenHead = ""
    local genderHead = (gender * 4) + 4

    chosenHead = raceTable[holdIndex][genderHead] .. pick

    if chosenHead == string.lower(Players[pid].data.character.head) then
        tes3mp.SendMessage(pid, color.Gold .. "You already have that head.\n", false)
        return false
    end

	nilTokenCheck(playerName)

	if Players[pid]:IsAdmin() then
	else

		if tokenCalc(pid, playerName, ccPerksSettings.tokenCostHead) == false then
			return false
		end
	end

	Players[pid].data.character.head = raceTable[holdIndex][genderHead] .. pick

	message = color.Gold .. "Your head is now " .. chosenHead .. ".\nReconnect to the server to apply the change.\n"
	tes3mp.SendMessage(pid, message, false)
end

function lotteryHandler(pid) -- Used to generate prizes for tokens
	local playerName = string.lower(Players[pid].name)
	local item = {}
	local message = ""
    
	math.random(); math.random() -- Try to improve RNG
	local rando = math.random(1, ccLottery.TotalEntries)
	
	tes3mp.LogMessage(2, "++++ " .. playerName .. " uses /lottery with rando = " .. rando .. " ++++")
	
	nilTokenCheck(playerName)
		
	if Players[pid]:IsAdmin() then
	else
		
		if tokenCalc(pid, playerName, ccPerksSettings.tokenCostLottery) == false then
			return false
		end
	end
	
    -- First block of entries consists of item prizes in MethodsConfig
    if rando >= 1 and rando <= ccLottery.ItemEntries then
        local lotteryPrize = {}
        local lotteryMessage = {}
        
        if ccLottery.Items[rando] ~= nil then
            lotteryPrize = {
                refId = ccLottery.Items[rando][1],
                count = ccLottery.Items[rando][2],
                charge = ccLottery.Items[rando][3]
            }
        else
            tes3mp.LogMessage(2, "++++ Methods.lotteryHandler: Failure in first block check with rando = " .. rando)
            tes3mp.SendMessage(pid, color.Red .. "LOTTERY: Error occurred. Please contact an admin!\n", false)
            return false
        end
        
        message = color.Gold .. "LOTTERY: You won " .. ccLottery.Items[rando][4]
        
        -- Check whether item exists in inventory
        -- If not, increase its count by proper amount
        if Players[pid].data.inventory.refId ~= nil then 
            Players[pid].data.inventory.count = Players[pid].data.inventory.count + 
                lotteryPrize.count
        else
            table.insert(Players[pid].data.inventory, lotteryPrize)
        end
        
        Players[pid]:LoadInventory()
        Players[pid]:LoadEquipment()
    
    -- Second block of entries consists of token prizes defined in MethodsConfig
    elseif ccLottery.TokenEntries > 0 and rando > ccLottery.ItemEntries and 
        rando <= (ccLottery.TokenEntries + ccLottery.ItemEntries) then
        
        local rando2 = 	math.random(1, ccLottery.TokenEntries)
        local entryCounter = 0
        local tokenCount = tokenList.players[playerName].tokens
        local error = true
        
        -- Iterate through each reward in the token table in MethodsConfig and total up the entries
        -- Check if "rando2" falls within the total number of entries at the end of a reward
        for index, value in ipairs(ccLottery.Tokens) do
            entryCounter = entryCounter + ccLottery.Tokens[index][2]
            
            if rando2 <= entryCounter then
                error = false
                tokenCount = tokenCount + ccLottery.Tokens[index][1]
                message = color.Gold .. "LOTTERY: You won " .. ccLottery.Tokens[index][3]
                break
            end
        end
        
        if error == true then
            tes3mp.LogMessage(2, "++++ Methods.lotteryHandler: Failure in second block check with rando2 = " .. rando2)
            tes3mp.SendMessage(pid, color.Red .. "LOTTERY: Error occurred. Please contact an admin!\n", false)
            return false
        end
        
        tokenList.players[playerName].tokens = tokenCount
        jsonInterface.save("tokenlist.json", tokenList)
	else
		message = color.Gold .. "LOTTERY: You didn't win anything this time...\n"
	end
    
	tes3mp.SendMessage(pid, message, false)
end

function nilTokenCheck(playerName) -- Used to create and manage entries in tokenlist.json	
	-- Check whether an entry for this character name exists
	if tokenList.players[playerName] == nil then 
		local name = {}
		name.tokens = 0
		name.claimdate = 0
		tokenList.players[playerName] = name
		jsonInterface.save("tokenlist.json", tokenList)
	end
end

-- Iterate through raceTable and find match for player's race, then store index
function parseRaceTable(race)
    local holdIndex = 0

    for index, value in ipairs(raceTable) do

        if raceTable[index] ~= nil and raceTable[index][1] == race then
            holdIndex = index
            break
        end
    end
    
    if holdIndex ~= 0 then
        return holdIndex
    else
        tes3mp.LogMessage(2, "++++ Methods.parseRaceTable failed for race " .. race)
        tes3mp.SendMessage(pid, color.Red .. "HoldIndex error occurred. Please contact an admin!\n", false)
        return false
    end
end

function perksHandler(pid, pick)
    tes3mp.LogMessage(2, "++++ Methods.perkHandler called")
    ccSettings.Perks[pick].storedFunc(pid)
end

function raceChanger(pid, pick)
	local message = ""
	local playerName = string.lower(Players[pid].name)
	local race = string.lower(Players[pid].data.character.race)

	tes3mp.LogMessage(2, "++++ " .. playerName .. " (" .. race .. ") tried to use /setrace " .. pick .. " ++++")

	if raceTable[pick][1] ~= nil then

        if string.lower(raceTable[pick][1]) == Players[pid].data.character.race then -- Check whether player already has this race
            tes3mp.SendMessage(pid, color.Gold .. "You already are that race.\n", false)
            return false
        end
    else
        tes3mp.LogMessage(2, "++++ Methods.raceChanger: Failure in initial nil check with pick = " .. pick)
        tes3mp.SendMessage(pid, color.Red .. "RACE CHANGER: Error occurred. Please contact an admin!\n", false)
        return false
	end

	nilTokenCheck(playerName)
	
	if Players[pid]:IsAdmin() then
	else

		if tokenCalc(pid, playerName, ccPerksSettings.tokenCostRace) == false then
			return false
		end
	end

    local hair = raceTable[pick][6] .. "01"
    local head = raceTable[pick][8] .. "01"
    
    if raceTable[pick][1] == "t_sky_reachman" then
        hair = hair .. "a"
        head = head .. "a"
    end
    
	Players[pid].data.character.gender = 1
	Players[pid].data.character.hair = hair
	Players[pid].data.character.head = head
	Players[pid].data.character.race = raceTable[pick][1]

	-- Add racial spells if needed
	if raceTable[pick][1] == "argonian" then
		tes3mp.AddSpell(pid, "argonian breathing")
	elseif raceTable[pick][1] == "khajiit" then
		tes3mp.AddSpell(pid, "eye of night")
	end

	tes3mp.SendSpellbookChanges(pid)
	Players[pid]:Save()
	
	message = color.Gold .. "Your race is now " .. ccRace.Vanilla[pick][10] .. ".\nReconnect to the server to apply the change.\n"
	tes3mp.SendMessage(pid, message, false)
end

function spawnPet(pid, pet)
	local message = ""
	local playerName = string.lower(Players[pid].name)

	tes3mp.LogMessage(2, "++++ " .. playerName .. " tried to use /spawnpet " .. pet .. " ++++")

	if Players[pid].data.pets then
	else
		local petInfo = {}

		petInfo.packRatSpawnTime = 0
		petInfo.ratSpawnTime = 0
		petInfo.scribSpawnTime = 0
		
		Players[pid].data.pets = petInfo
	end

	local spawnCommand = ""
	local timeStored = 0

	if pet == 0 then -- Pack rat
		timeStored = Players[pid].data.pets.packRatSpawnTime
		spawnCommand = "placeatme Rat_pack_rerlas 1 10 0"
	elseif pet == 1 then -- Rat
		timeStored = Players[pid].data.pets.ratSpawnTime
		spawnCommand = "placeatme rat_rerlas 1 10 0"
	elseif pet == 2 then -- Scrib
		timeStored = Players[pid].data.pets.scribSpawnTime
		spawnCommand = "placeatme scrib_rerlas 1 10 0"
	end

	if timeStored == 0 or type(timeStored) == "number" then -- This should happen
		local diff = (os.time() - timeStored)
		tes3mp.LogMessage(2, "++++ diff == " .. diff .. " ++++")
		
		if (diff / 86400) <= 1 then
			message = color.Red .. "You've already spawned that pet today.\n"
			tes3mp.SendMessage(pid, message, false)
			return false
		end
	end

	nilTokenCheck(playerName)

	if Players[pid]:IsAdmin() then
	else
		if tokenCalc(pid, playerName, ccPerksSettings.tokenCostPet) == false then
			return false
		end
		
		if pet == 0 then
			Players[pid].data.pets.packRatSpawnTime = os.time()
		elseif pet == 1 then
			Players[pid].data.pets.ratSpawnTime = os.time()
		elseif pet == 2 then
			Players[pid].data.pets.scribSpawnTime = os.time()
		end
	end

	Players[pid]:Save()

	myMod.RunConsoleCommandOnPlayer(pid, spawnCommand)
	tes3mp.LogMessage(2, "++++ " .. playerName .. " successfully used /spawnpet " .. pet .. " ++++")

	message = color.Gold .. "You now have a pet.\n"
	tes3mp.SendMessage(pid, message, false)
end

function tokenCalc(pid, playerName, tokenCost) -- Used to check number of tokens before perk is applied
	local message = ""
	local tokenCounter = tokenList.players[playerName].tokens
	
	if tokenCounter >= 1 then
		tokenCounter = tokenList.players[playerName].tokens - tokenCost
		tokenList.players[playerName].tokens = tokenCounter
		jsonInterface.save("tokenlist.json", tokenList)
		message = color.Gold .. "You use a token and now have " .. tokenCounter .. " token(s).\n"
		tes3mp.SendMessage(pid, message, false)
	else
		message = color.Gold .. "You don't have enough tokens to use this perk.\n"
		tes3mp.SendMessage(pid, message, false)
		return false
	end
end

function tokenClaim(pid) -- Used to give one token per day
	local getToken = 0
	local playerName = string.lower(Players[pid].name)
	local message = ""
	
	nilTokenCheck(playerName)
	
	local timeStored = tokenList.players[playerName].claimdate
	tes3mp.LogMessage(2, "++++ timeStored == " .. timeStored .. " ++++")
	
	if timeStored == 0 or type(timeStored) == "number" then -- This should happen
		local diff = (os.time() - timeStored)
		
		tes3mp.LogMessage(2, "++++ diff == " .. diff .. " ++++")
		if (diff / 86400) > 1 then
			getToken = 1
		end
	elseif type(timeStored) == "string" then -- This shouldn't happen, takes care of "" values
		getToken = 1
	end

	if getToken == 1 then
		tokenList.players[playerName].claimdate = os.time()
		tokenList.players[playerName].tokens = tokenList.players[playerName].tokens + 1
		jsonInterface.save("tokenlist.json", tokenList)
		
		message = color.Gold .. "You've claimed your daily token. Type /perks for a list of commands that you can use.\n"
		tes3mp.LogMessage(2, "++++ " .. playerName .. " uses /claimtoken ++++")
	else
		message = color.Gold .. "You've already claimed your daily token.\n"
	end
	
	tes3mp.SendMessage(pid, message, false)
end

function warpHandler(pid, destination)
	local playerName = string.lower(Players[pid].name)
	local message = ""

	tes3mp.LogMessage(2, "++++ " .. playerName .. " tried to use /warp " .. destination .. " ++++")

	nilTokenCheck(playerName)

	if Players[pid]:IsAdmin() then
	else
    
		if tokenCalc(pid, playerName, ccPerksSettings.tokenCostWarp) == false then
			return false
		end
	end
	
	tes3mp.SetCell(pid, spawnTable[destination][1])
	tes3mp.SendCell(pid)
	tes3mp.SetPos(pid, spawnTable[destination][2], spawnTable[destination][3], spawnTable[destination][4])
	tes3mp.SetRot(pid, 0, spawnTable[destination][5])
	tes3mp.SendPos(pid)
end

function windowBirthsign(pid)
	local windowLabel = "Please choose a birthsign (" .. ccPerksSettings.tokenCostBirthsign .. " token(s)):"
    local windowText = "The Apprentice\nThe Atronach\nThe Lady\nThe Lord\nThe Lover\nThe Mage\nThe Ritual\nThe Serpent\nThe Shadow\nThe Steed\nThe Thief\nThe Tower\nThe Warrior\nCancel"
	tes3mp.ListBox(pid, ccSettings.windowChangeBirthsign, windowLabel, windowText)
end

function windowCreature(pid)

	if Players[pid].data.shapeshift.isWerewolf then
		
		if Players[pid].data.shapeshift.isWerewolf == true then
			tes3mp.SendMessage(pid, color.Red .. "You can't use that perk as a werewolf." .. color.Default .. "\n", false)
			return false
		end
	end

    local windowLabel = "Please choose a creature (" .. ccPerksSettings.tokenCostCreature .. " token(s)):"
	tes3mp.ListBox(pid, ccSettings.windowSetCreature, windowLabel, ccCreature.creatureText)
end

function windowGender(pid)
    local windowLabel = "Please choose a gender (" .. ccPerksSettings.tokenCostGender .. " token(s)):"
    local windowText = "Female\nMale\nCancel"
	tes3mp.ListBox(pid, ccSettings.windowChangeGender, windowLabel, windowText)
end

function windowHair(pid)
    local genderHairNum = (Players[pid].data.character.gender * 4) + 3
	local race = string.lower(Players[pid].data.character.race)
	local windowText = ""

    -- Find corresponding entry in raceTable
    local holdIndex = parseRaceTable(race)

    for i = 1, raceTable[holdIndex][genderHairNum] do
        windowText = windowText .. "Style " .. i .. "\n"
    end

    windowText = windowText .. "Cancel"

    local windowLabel = "Please choose a hairstyle (" .. ccPerksSettings.tokenCostHair .. " token(s)):"
	tes3mp.ListBox(pid, ccSettings.windowChangeHair, windowLabel, windowText)
end

function windowHead(pid)
    local genderHeadNum = (Players[pid].data.character.gender * 4) + 5
	local race = string.lower(Players[pid].data.character.race)
	local windowText = ""

    -- Find corresponding entry in raceTable
    local holdIndex = parseRaceTable(race)

    for i = 1, raceTable[holdIndex][genderHeadNum] do
        windowText = windowText .. "Style " .. i .. "\n"
    end

    windowText = windowText .. "Cancel"

    local windowLabel = "Please choose a head (" .. ccPerksSettings.tokenCostHead .. " token(s)):"
	tes3mp.ListBox(pid, ccSettings.windowChangeHead, windowLabel, windowText)
end

function windowPet(pid)
	local windowLabel = "Please choose a pet (" .. ccPerksSettings.tokenCostPet .. " token(s)):\nThey might adopt someone else if you log out!"
    local windowText = "Pack Rat\nRat\nScrib\nCancel"
	tes3mp.ListBox(pid, ccSettings.windowSpawnPet, windowLabel, windowText)
end

function windowRace(pid)
    local windowLabel = "Please choose a race (" .. ccPerksSettings.tokenCostRace .. " token(s)):"
	tes3mp.ListBox(pid, ccSettings.windowChangeRace, windowLabel, ccRace.raceText)
end

function windowWarp(pid)
    local windowLabel = "Please choose a destination (" .. ccPerksSettings.tokenCostWarp .. " token(s)):"
	tes3mp.ListBox(pid, ccSettings.windowWarp, windowLabel, ccWarp.warpText)
end

-- ********************
-- ::::CHAT METHODS::::
-- ********************

-- DO_NOTHING skips this script and moves to the next.
-- COMMAND_EXECUTED skips all future scripts (Because command was executed)

Methods[USES_COMMAND][1] = true
Methods[USES_COMMAND].Func = function(pid, isAdmin, isModerator, cmd, message) -- On player sent command (parameter "cmd" is a table)

	if cmd[1] == "addtoken" and cmd[2] == "all" and tonumber(cmd[3]) ~= nil and isAdmin then
		Methods.TokenAddAll(pid, tonumber(cmd[3]))
		return COMMAND_EXECUTED
	elseif cmd[1] == "addtoken" and tonumber(cmd[2]) ~= nil and tonumber(cmd[3]) ~= nil and isAdmin then
		Methods.TokenAdd(pid, tonumber(cmd[2]), tonumber(cmd[3]))
		return COMMAND_EXECUTED
	elseif cmd[1] == "checktoken" and cmd[2] ~= nil and isAdmin then
		Methods.TokenCheck(pid, cmd[2])
		return COMMAND_EXECUTED
	elseif cmd[1] == "perks" then
		Methods.PerksWindow(pid)
		return COMMAND_EXECUTED
	end
		
	return DO_NOTHING
end


-- Methods commands available to the player.
-- NOTE: Don't edit anything inside the entries.
-- If you want to prevent a player from using a command, just remove it from this table.
ccSettings.Perks = {
    { name = "Claim Daily Token", storedFunc = tokenClaim },
    { name = "Appear as Creature", storedFunc = windowCreature },
    { name = "Change Birthsign", storedFunc = windowBirthsign },
    { name = "Change Gender", storedFunc = windowGender },
    { name = "Change Hair", storedFunc = windowHair },
    { name = "Change Head", storedFunc = windowHead },
    { name = "Change Race", storedFunc = windowRace },
    { name = "Lottery", storedFunc = lotteryHandler },
    { name = "Spawn Pet", storedFunc = windowPet },
    { name = "Warp", storedFunc = windowWarp }
}

return Methods
