---------------------------
-- ccServerMsgConfig by Texafornian
--
-- Used by "ccServerMsg" script

------------------
-- DO NOT TOUCH!
------------------

ccServerMsgSettings = {}

ccRestartWarning = {}

------------------
-- GENERAL CONFIG
------------------

-- Messages that appear at specified minute(s) past the hour.
-- Format: { minute(s) past the hour, "message" }
-- Ex: { "15", "Ur Welcome" } will display "Ur Welcome" in chat at 1:15, 2:15, etc.
ccServerMsgSettings.messages = {
    { "15", color.Yellow .. "Want to help create Morrowind, Skyrim, and Cyrodiil? Type /modding for info.\n" },
    { "45", color.Yellow .. "Type /help for all Cornerclub commands. Visit us online at the-cornerclub.com.\n" }
}

-- How often the timer should restart. Only modify this if you know what you're doing.
ccServerMsgSettings.timer = 55

--------------------------
-- RESTART WARNING CONFIG
--------------------------

--------
-- INFO:
--
-- NOTE: This is only applicable to those who have set up automated restarts outside of TES3MP.
-- This can be done with the Windows Task Scheduler or Linux's "crontab".
-- As of TES3MP v0.7.0, there is no way to restart the server from within the program.
--------

-- Must be enabled for everything else in this section to work.
ccRestartWarning.enabled = true

-- Contains your restart times minus 2 minutes.
-- The server will display a "two minute" restart warning at the specified minute(s) past the hour.
-- Format: { hour, minute(s) past the hour } in 24-hour time.
-- Ex: { "12", "30" } = 12:30
ccRestartWarning.times = {
    { "00", "58" },
    { "06", "58" },
    { "12", "58" },
    { "18", "58" }
}

-- The "restart warning" message that appears at the times in ccRestartWarning.times.
ccRestartWarning.message = color.Orange .. "\n=~=~=~=~=~=~=~=~=~=~=\nSERVER WILL RESTART IN 2 MINUTES\n=~=~=~=~=~=~=~=~=~=~=\n\n"
