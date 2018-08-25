---------------------------
-- ccServerMsg 0.7.0 by Texafornian
--
-- Requires "ccServerMsgConfig.lua" in /scripts/ folder!
--
-- Many thanks to:
-- Dave for the very first iteration

------------------
-- DO NOT TOUCH!
------------------

require("ccConfig")
require("ccServerMsgConfig")

------------------
-- TIMER SECTION
------------------

-- Creates a timer that calls CheckTime() every specified interval of seconds
local ccServerMsgTimer = tes3mp.CreateTimer("CheckTime", time.seconds(ccServerMsgSettings.timer))

if ccConfig.serverMsgEnabled == true then
    do tes3mp.StartTimer(ccServerMsgTimer) end
end

---------------------
-- FUNCTIONS SECTION
---------------------

-- Check current time against the entries in ccServerMsgConfig
function CheckTime()
    local hour = os.date("%H")
    local msg = ""
    local minute = os.date("%M")

    -- If current hour and minute match an entry in ccRestartWarning.times,
    -- then send a "one minute left" warning message
    if ccRestartWarning.enabled == true then

        for index, value in pairs(ccRestartWarning.times) do

            if hour == ccRestartWarning.times[index][1] and minute == ccRestartWarning.times[index][2] then
                tes3mp.LogMessage(2, "++++ ccServerMsg: Server shutting down in 2 minutes ++++")
                msg = color.Orange .. "\n=~=~=~=~=~=~=~=~=~=~=\nSERVER WILL RESTART IN 2 MINUTES\n=~=~=~=~=~=~=~=~=~=~=\n\n"
                ServerMessage(msg)
            end
        end
    end

    -- If current minute matches a message in ccServerMsgConfig, then
    -- print that message
    for index, value in pairs(ccServerMsgSettings.messages) do

        if minute == ccServerMsgSettings.messages[index][1] then
            msg = ccServerMsgSettings.messages[index][2]
            ServerMessage(msg)
        end
    end

    tes3mp.RestartTimer(ccServerMsgTimer, time.seconds(ccServerMsgSettings.timer))
end

-- Send supplied message to all players on server
function ServerMessage(msg)

    for index, player in pairs(Players) do
        tes3mp.SendMessage(player.pid, msg, false)
    end
end
