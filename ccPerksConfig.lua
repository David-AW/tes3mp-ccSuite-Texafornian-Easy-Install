---------------------------
-- ccPerksConfig by Texafornian
--
-- Used by "ccPerks" script
--
-- Modify everything except for the DO NOT TOUCH section
-- Tables can be edited in any way if the proper format is used

------------------
-- DO NOT TOUCH!
------------------

ccPerksSettings = {}

ccCreature = {}
ccLottery = {}
ccRace = {}
ccWarp = {}

-- Updated automatically by server on startup
ccLottery.TokenEntries = 0
ccLottery.ItemEntries = 0
ccLottery.TotalEntries = 0
ccCreature.creatureText = ""
ccRace.raceText = ""
ccWarp.warpText = ""

------------------
-- GENERAL CONFIG
------------------

--------
-- INFO:
--
-- NOTE: If you want to change the order in which perks appear, or which 
-- perks are available to the player, then go to the bottom of ccPerks.lua 
-- and modify the table. Don't edit the "name" and "storedFunc" values 
-- in the entries.
--------

-- Change the token cost (non-Admin) for various perks.
ccPerksSettings.tokenCostBirthsign = 1
ccPerksSettings.tokenCostCreature = 1
ccPerksSettings.tokenCostGender = 1
ccPerksSettings.tokenCostHair = 1
ccPerksSettings.tokenCostHead = 1
ccPerksSettings.tokenCostLottery = 1
ccPerksSettings.tokenCostPet = 1
ccPerksSettings.tokenCostRace = 1
ccPerksSettings.tokenCostWarp = 1

-------------------
-- CHARACTER CONFIG
-------------------

--------
-- INFO:
--
-- Information used by the various "changer" perks.
--
-- Don't change these entries unless you know what you're doing.
--
-- Format: { "ID", "female hair ID", # female hairstyles, "female head ID", # female heads, "male hair ID",
-- # male hairstyles, "male head ID", # male heads, "displayed name" }
--------

-- Vanilla races
ccRace.Vanilla = {
    { "high elf", "b_n_high elf_f_hair_", 4, "b_n_high elf_f_head_", 6, "b_n_high elf_m_hair_", 5, "b_n_high elf_m_head_", 6, "Altmer" },
    { "argonian", "b_n_argonian_f_hair", 5, "b_n_argonian_f_head_", 3, "b_n_argonian_m_hair", 6, "b_n_argonian_m_head_", 3, "Argonian" },
    { "wood elf", "b_n_wood elf_f_hair_", 5, "b_n_wood elf_f_head_", 6, "b_n_wood elf_m_hair_", 6, "b_n_wood elf_m_head_", 8, "Bosmer" },
    { "breton", "b_n_breton_f_hair_", 5, "b_n_breton_f_head_", 6, "b_n_breton_m_hair_", 5, "b_n_breton_m_head_", 8, "Breton" },
    { "dark elf", "b_n_dark elf_f_hair_", 24, "b_n_dark elf_f_head_", 10, "b_n_dark elf_m_hair_", 26, "b_n_dark elf_m_head_", 17, "Dunmer" },
    { "imperial", "b_n_imperial_f_hair_", 7, "b_n_imperial_f_head_", 7, "b_n_imperial_m_hair_", 9, "b_n_imperial_m_head_", 7, "Imperial" },
    { "khajiit", "b_n_khajiit_f_hair", 5, "b_n_khajiit_f_head_", 4, "b_n_khajiit_m_hair", 5, "b_n_khajiit_m_head_", 4, "Khajiit" },
    { "nord", "b_n_nord_f_hair_", 5, "b_n_nord_f_head_", 8, "b_n_nord_m_hair", 7, "b_n_nord_m_head_", 8, "Nord" },
    { "orc", "b_n_orc_f_hair_", 5, "b_n_orc_f_head_", 3, "b_n_orc_m_hair_", 5, "b_n_orc_m_head_", 4, "Orsimer" },
    { "redguard", "b_n_redguard_f_hair_", 5, "b_n_redguard_f_head_", 6, "b_n_redguard_m_hair_", 6, "b_n_redguard_m_head_", 6, "Redguard" }
}

-- Races added by Tamriel_Data.esm
ccRace.Tamriel = {
    { "t_els_cathay", "t_b_kcr_hairfemale_", 5, "t_b_kcr_headfemale_", 4, "t_b_kc_hairmale_", 5, "t_b_kc_headmale_", 3, "Cathay" },
    { "t_els_cathay-raht", "t_b_kcr_hairfemale_", 5, "t_b_kcr_headfemale_", 3, "t_b_kcr_hairmale_", 5, "t_b_kcr_headmale_", 4, "Cathay-raht" },
    { "t_pya_seaelf", "t_b_mao_hairfemale_", 4, "t_b_mao_headfemale_", 5, "t_b_mao_hairmale_", 5, "t_b_mao_headmale_", 6, "Maormer" },
    { "t_els_ohmes", "t_b_ko_hairfemale_", 26, "t_b_ko_headfemale_", 16, "t_b_ko_hairmale_", 17, "t_b_ko_headmale_", 15, "Ohmes" },
    { "t_els_ohmes-raht", "t_b_kor_hairfemale_", 24, "t_b_kor_headfemale_", 5, "t_b_kor_hairmale_", 5, "t_b_kor_headmale_", 3, "Ohmes-raht" },
    { "t_sky_reachman", "t_b_rea_hairfemshotn_", 8, "t_b_rea_headfemshotn_", 6, "t_b_rea_hairmaleshotn_", 7, "t_b_rea_headmaleshotn_", 10, "Reachman" }, -- Requires letter "a" after the number
    { "t_els_suthay", "t_b_ks_hairfemale_", 5, "t_b_ks_headfemale_", 4, "t_b_ks_hairmale_", 5, "t_b_ks_headmale_", 4, "Suthay" }
}

------------------
-- CREATURE CONFIG
------------------

--------
-- INFO:
--
-- "Appear as Creature" list is generated automatically by the server on start-up.
--
-- Creatures can be added/removed/modified, but be aware that some
-- vanilla creatures have been omitted because they crash the server.
-- For example: Almalexia and her variant.
--
-- Format: { "refID", "displayed name" }
--------

ccCreature.Vanilla = {
    { "alit", "Alit" },
    { "ancestor_ghost", "Ancestor Ghost" },
    { "ascended_sleeper", "Ascended Sleeper" },
    { "ash_ghoul", "Ash Ghoul" },
    { "ash_slave", "Ash Slave" },
    { "dagoth endus", "Ash Vampire" },
    { "ash_zombie", "Ash Zombie" },
    { "netch_betty", "Betty Netch" },
    { "netch_bull", "Bull Netch" },
    { "atronach_flame", "Atronach (Flame)" },
    { "atronach_frost", "Atronach (Frost)" },
    { "atronach_storm", "Atronach (Storm)" },
    { "BM_bear_black", "Bear (Black)" },
    { "BM_bear_brown", "Bear (Brown)" },
    { "BM_bear_snow_unique", "Bear (Snow)" },
    { "BM_bear_be_UNIQUE", "Bear (Snow Variant)" },
    { "BM_frost_boar", "Boar" },
    { "bonelord", "Bonelord" },
    { "bonewalker", "Bonewalker (Lesser)" },
    { "bonewalker_greater", "Bonewalker (Greater)" },
    { "centurion_projectile", "Centurion Archer" },
    { "centurion_sphere", "Centurion Sphere" },
    { "centurion_steam", "Centurion Steam" },
    { "clannfear", "Clannfear" },
    { "cliff racer", "Cliff Racer" },
    { "corprus_lame", "Corprus (Lame)" },
    { "corprus_stalker", "Corprus (Stalker)" },
    { "daedroth", "Daedroth" },
    { "dagoth_ur_1", "Dagoth Ur" },
    { "BM_draugr01", "Draugr" },
    { "dremora", "Dremora" },
    { "dreugh", "Dreugh" },
    { "durzog_wild", "Durzog (Wild)" },
    { "durzog_war", "Durzog (War)" },
    { "dwarven ghost", "Dwemer Ghost" },
    { "fabricant_hulking", "Fabricant (Hulking)" },
    { "fabricant_verminous", "Fabricant (Verminous)" },
    { "bm_frost_giant", "Frost Giant" },
    { "goblin_grunt", "Goblin Grunt" },
    { "goblin_bruiser", "Goblin Bruiser" },
    { "goblin_warchief1", "Goblin Warchief" },
    { "guar", "Guar" },
    { "guar_white", "Guar (Unique)" },
    { "BM_hircine", "Hircine" },
    { "BM_hircine_huntaspect", "Hircine (Hunt)" },
    { "BM_hircine_spdaspect", "Hircine (Speed)" },
    { "BM_hircine_straspect", "Hircine (Strength)" },
    { "BM_horker", "Horker" },
    { "BM_horker_swim_UNIQUE", "Horker (Unique)" },
    { "hunger", "Hunger" },
    { "BM_ice_troll", "Ice Troll" },
    { "imperfect", "Imperfect" },
    { "kagouti", "Kagouti" },
    { "kwama forager", "Kwama Forager" },
    { "Kwama Queen", "Kwama Queen" },
    { "kwama warrior", "Kwama Warrior" },
    { "kwama worker", "Kwama Worker" },
    { "lich", "Lich" },
    { "lich_barilzar", "Lich (Unique)" },
    { "mudcrab", "Mudcrab" },
    { "nix-hound", "Nix-Hound" },
    { "ogrim", "Ogrim" },
    { "rat", "Rat" },
    { "Rat_pack_rerlas", "Rat (Variant)" },
    { "glenmoril_raven", "Raven" },
    { "BM_riekling", "Riekling" },
    { "BM_riekling_mounted", "Riekling (Mounted)" },
    { "scamp", "Scamp" },
    { "scrib", "Scrib" },
    { "shalk", "Shalk" },
    { "skeleton", "Skeleton" },
    { "BM_spriggan", "Spriggan" },
    { "BM_udyrfrykte", "Udyrfrykte" },
    { "vivec_god", "Vivec" },
    { "winged twilight", "Winged Twilight" },
    { "BM_wolf_grey", "Wolf (Gray)" },
    { "BM_wolf_red", "Wolf (Red)" },
    { "BM_wolf_skeleton", "Wolf (Skeleton)" },
    { "BM_wolf_snow_unique", "Wolf (Snow)" },
    { "yagrum bagarn", "Yagrum Bagarn" }
}

-- WIP
ccCreature.Tamriel = {
    { "T_Cyr_Cre_Mino_01", "Minotaur" }
}

------------------
-- LOTTERY CONFIG
------------------

--------
-- INFO:
--
-- The more "entries" something has, the more likely it is to be won.
--
-- All filler, token, and item entries are added up by the server on start-up.
--------

-- Adds blank entries to the lottery to lower the chances that a player will win any tokens or items.
-- If set to 0, then a player will always win something.
ccLottery.FillerEntries = 35

-- Winnable token values. All entries can be modified/removed/added.
-- Format: { Number of tokens, number of entries, name }
-- If number of entries is set to 0, then it will never be winnable.
ccLottery.Tokens = {
    { 1, 11, "1 token!\n" },
    { 2, 7, "2 tokens!\n" },
    { 5, 4, "5 tokens!\n" },
    { 10, 2, "10 tokens!\n" },
    { 25, 1, "25 tokens!!!\n" }
}

-- Winnable lottery prizes. All entries can be modified/removed/added.
-- Format: { refID, count, charge, name/type }
ccLottery.Items = {
    { "ingred_bread_01_UNI3", 2, -1, "some Muffins!\n" },
    { "ingred_scrib_jelly_02", 2, -1, "some rare ingredients!\n" },
    { "ingred_heartwood_01", 2, -1, "some rare ingredients!\n" },
    { "key_Andas_tomb", 1, -1, "a unique key!\n" },
    { "key_aurane1", 1, -1, "a unique key!\n" },
    { "key_Falas_chest", 1, -1, "a unique key!\n" },
    { "key_j'zhirr", 1, -1, "a unique key!\n" },
    { "key_sethan", 1, -1, "a unique key!\n" },
    { "apparatus_sm_alembic_01", 1, -1, "a unique alchemical tool!\n" },
    { "apparatus_sm_calcinator_01", 1, -1, "a unique alchemical tool!\n" },
    { "apparatus_sm_mortar_01", 1, -1, "a unique alchemical tool!\n" },
    { "apparatus_sm_retort_01", 1, -1, "a unique alchemical tool!\n" },
    { "veloths_shield", 1, 15, "a unique shield!\n" },
    { "steel_towershield_ancient", 1, -1, "a unique shield!\n" },
    { "BM_hunter_battleaxe_unique", 1, -1, "a unique weapon!\n" },
    { "daedric_club_tgdc", 1, -1, "a unique weapon!\n" },
    { "herder_crook", 1, 80, "a unique weapon!\n" },
    { "iron fork", 1, -1, "a unique weapon!\n" },
    { "axe_queen_of_bats_unique", 1, 500, "a unique weapon!\n" },
    { "staff_of_llevule", 1, 50, "a unique weapon!\n" },
    { "ebony_dagger_mehrunes", 1, -1, "a unique weapon!\n" },
    { "clutterbane", 1, 10, "a unique weapon!\n" },
    { "throwing knife of sureflight", 7, -1, "a unique weapon!\n" },
    { "slippers_of_doom", 1, 120, "a unique pair of shoes!\n" },
    { "robe of burdens", 1, 75, "a unique robe!\n" },
    { "mandas_locket", 1, -1, "a unique amulet!\n" },
    { "fenrick's doorjam ring", 1, 5, "a unique ring!\n" },
    { "Recall_Ring", 1, 90, "a unique ring!\n" },
    { "common_ring_tsiya", 1, -1, "a unique ring!\n" },
    { "fur_colovian_helm_white", 1, -1, "a unique hat!\n" },
    { "gondolier_helm", 1, -1, "an uncommon hat!\n" },
    { "Misc_flask_grease", 1, -1, "a Jar of Grease!\n" },
    { "skeleton_key", 1, -1, "a rare lockpick!\n" },
    { "light_com_lantern_02_inf", 1, -1, "a rare lantern!\n" },
    { "misc_com_plate_02_tgrc", 1, -1, "a unique Blue Plate! This one is nice.\n" },
    { "misc_com_plate_06_tgrc", 1, -1, "a unique Brown Plate! This one seems to last longer.\n" }
}
