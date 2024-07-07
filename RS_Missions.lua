--------------------------------
-- Author: Rostal
--------------------------------

local SUPPORT_GAME_VERSION <const> = "3258" -- 1.69


--#region check game version

-- local online_version = NETWORK.GET_ONLINE_VERSION()
local build_version = memory.scan_pattern("8B C3 33 D2 C6 44 24 20"):add(0x24):rip()
-- local CURRENT_GAME_VERSION <const> = string.format("%s-%s", online_version, build_version:get_string())
local CURRENT_GAME_VERSION <const> = build_version:get_string()

local IS_SUPPORT = true
if SUPPORT_GAME_VERSION ~= CURRENT_GAME_VERSION then
    IS_SUPPORT = false
end

--#endregion


--#region functions

local function notify(title, message)
    gui.show_message("[RS Missions] " .. title, message)
end

local function toast(text)
    notify("", tostring(text))
end

local function print(text)
    log.info(tostring(text))
end

local function get_label_text(label)
    return HUD.GET_FILENAME_FOR_AUDIO_CONVERSATION(label)
end

--------------------------------
-- Global Functions
--------------------------------

function GLOBAL_SET_INT(global, value)
    globals.set_int(global, value)
end

function GLOBAL_SET_FLOAT(global, value)
    globals.set_float(global, value)
end

function GLOBAL_SET_STRING(global, value)
    globals.set_string(global, value, string.len(value))
end

function GLOBAL_SET_BOOL(global, value)
    value = value and 1 or 0
    globals.set_int(global, value)
end

function GLOBAL_GET_INT(global)
    return globals.get_int(global)
end

function GLOBAL_GET_FLOAT(global)
    return globals.get_float(global)
end

function GLOBAL_GET_STRING(global)
    return globals.get_string(global)
end

function GLOBAL_GET_BOOL(global)
    return globals.get_int(global) == 1
end

function GLOBAL_SET_BIT(global, bit)
    local value = SET_BIT(globals.get_int(global), bit)
    globals.set_int(global, value)
end

function GLOBAL_CLEAR_BIT(global, bit)
    local value = CLEAR_BIT(globals.get_int(global), bit)
    globals.set_int(global, value)
end

function GLOBAL_BIT_TEST(global, bit)
    return BIT_TEST(globals.get_int(global), bit)
end

function GLOBAL_SET_BITS(global, ...)
    local value = SET_BITS(globals.get_int(global), ...)
    globals.set_int(global, value)
end

--------------------------------
-- Local Functions
--------------------------------

function LOCAL_SET_INT(script_name, script_local, value)
    locals.set_int(script_name, script_local, value)
end

function LOCAL_SET_FLOAT(script_name, script_local, value)
    locals.set_float(script_name, script_local, value)
end

function LOCAL_GET_INT(script_name, script_local)
    return locals.get_int(script_name, script_local)
end

function LOCAL_GET_FLOAT(script_name, script_local)
    return locals.get_float(script_name, script_local)
end

function LOCAL_SET_BIT(script_name, script_local, bit)
    local value = SET_BIT(locals.get_int(script_name, script_local), bit)
    locals.set_int(script_name, script_local, value)
end

function LOCAL_CLEAR_BIT(script_name, script_local, bit)
    local value = CLEAR_BIT(locals.get_int(script_name, script_local), bit)
    locals.set_int(script_name, script_local, value)
end

function LOCAL_SET_BITS(script_name, script_local, ...)
    local value = SET_BITS(locals.get_int(script_name, script_local), ...)
    locals.set_int(script_name, script_local, value)
end

function LOCAL_CLEAR_BITS(script_name, script_local, ...)
    local value = CLEAR_BITS(locals.get_int(script_name, script_local), ...)
    locals.set_int(script_name, script_local, value)
end

--------------------------------
-- Bit Functions
--------------------------------

function SET_BIT(bits, place)
    return (bits | (1 << place))
end

function CLEAR_BIT(bits, place)
    return (bits & ~(1 << place))
end

function BIT_TEST(bits, place)
    return (bits & (1 << place)) ~= 0
end

function SET_BITS(int, ...)
    local bits = { ... }
    for _, bit in ipairs(bits) do
        int = int | (1 << bit)
    end
    return int
end

function CLEAR_BITS(int, ...)
    local bits = { ... }
    for ind, bit in ipairs(bits) do
        int = int & ~(1 << bit)
    end
    return int
end

--------------------------------
-- Script Functions
--------------------------------

function IS_SCRIPT_RUNNING(script_name)
    return SCRIPT.GET_NUMBER_OF_THREADS_RUNNING_THE_SCRIPT_WITH_THIS_HASH(joaat(script_name)) > 0
end

function IS_MISSION_CONTROLLER_SCRIPT_RUNNING()
    return IS_SCRIPT_RUNNING("fm_mission_controller_2020") or IS_SCRIPT_RUNNING("fm_mission_controller")
end

function GET_RUNNING_MISSION_CONTROLLER_SCRIPT()
    local mission_script = "fm_mission_controller"
    if IS_SCRIPT_RUNNING(mission_script) then
        return mission_script
    end

    mission_script = "fm_mission_controller_2020"
    if IS_SCRIPT_RUNNING(mission_script) then
        return mission_script
    end

    return nil
end

function REQUEST_FMMC_SCRIPT_HOST(script_name)
    if NETWORK.NETWORK_GET_HOST_OF_SCRIPT(script_name, 0, 0) ~= PLAYER.PLAYER_ID() then
        network.force_script_host(script_name)
    end
end

--------------------------------
-- Online Functions
--------------------------------

function IS_IN_SESSION()
    return NETWORK.NETWORK_IS_SESSION_STARTED() and not IS_SCRIPT_RUNNING("maintransition")
end

--#endregion


--#region game variables (The shit that needs to be updated with the game version)

------------------------
-- Globals
------------------------

local Globals <const> = {
    GlobalplayerBD = function()
        return 2657971 + 1 + PLAYER.PLAYER_ID() * 465
    end,

    GlobalplayerBD_FM = function()
        return 1845281 + 1 + PLAYER.PLAYER_ID() * 883
    end,

    GlobalplayerBD_FM_2 = function()
        return 1882632 + 1 + PLAYER.PLAYER_ID() * 146
    end,

    GlobalplayerBD_FM_3 = function()
        return 1887305 + 1 + PLAYER.PLAYER_ID() * 610
    end,

    -- NET_HEIST_PLANNING_GENERIC_PLAYER_BD_DATA
    GlobalPlayerBD_NetHeistPlanningGeneric = function()
        return 1972760 + 1 + PLAYER.PLAYER_ID() * 27
    end,
}

-- FMMC_GLOBAL_STRUCT
local g_FMMC_STRUCT <const> = 4718592
local FMMC_STRUCT <const> = {
    iNumParticipants = g_FMMC_STRUCT + 3522,
    iMinNumParticipants = g_FMMC_STRUCT + 3523,

    iDifficulity = g_FMMC_STRUCT + 3525,
    iNumberOfTeams = g_FMMC_STRUCT + 3526,
    iMaxNumberOfTeams = g_FMMC_STRUCT + 3527,
    iNumPlayersPerTeam = g_FMMC_STRUCT + 3529 + 1, -- +[0~3]

    iRootContentIDHash = g_FMMC_STRUCT + 127178,
    tl63MissionName = g_FMMC_STRUCT + 127185,
    tl31LoadedContentID = g_FMMC_STRUCT + 127465,
    tl23NextContentID = g_FMMC_STRUCT + 127493 + 1, -- +[0~5]*6

    iFixedCamera = g_FMMC_STRUCT + 155346,
    iCriticalMinimumForTeam = g_FMMC_STRUCT + 178821 + 1 -- +[0~3]
}

-- FMMC_ROCKSTAR_CREATED_STRUCT
local g_FMMC_ROCKSTAR_CREATED <const> = 794744
local FMMC_ROCKSTAR_CREATED <const> = {
    sMissionHeaderVars = g_FMMC_ROCKSTAR_CREATED + 4 + 1, -- +[iArrayPos]*89
}

-- TRANSITION_SESSION_NON_RESET_VARS
local g_TransitionSessionNonResetVars <const> = 2685444

-- FMMC_STRAND_MISSION_DATA
local g_sTransitionSessionData <const> = 2684504
local sStrandMissionData <const> = g_sTransitionSessionData + 43
local StrandMissionData <const> = {
    bPassedFirstMission = sStrandMissionData + 55,
    bPassedFirstStrandNoReset = sStrandMissionData + 56,
    bIsThisAStrandMission = sStrandMissionData + 57,
    bLastMission = sStrandMissionData + 58
}

-- HEIST_ISLAND_PLAYER_BD_DATA
local GlobalPlayerBD_HeistIsland <const> = {
    -- HEIST_ISLAND_CONFIG
    sConfig = function()
        return 1973625 + 1 + PLAYER.PLAYER_ID() * 53 + 5
    end
}

-- NET_HEIST_PLANNING_GENERIC_PLAYER_BD_DATA
local GlobalPlayerBD_NetHeistPlanningGeneric <const> = {
    stFinaleLaunchTimer = function()
        return Globals.GlobalPlayerBD_NetHeistPlanningGeneric() + 18
    end
}


------------------------
-- Locals
------------------------

local Locals <const> = {
    ["fm_mission_controller"] = {
        iNextMission = 19746 + 1062,
        iTeamScore = 19746 + 1232 + 1, -- +[0~3]
        iServerBitSet = 19746 + 1,
        iServerBitSet1 = 19746 + 2,

        iLocalBoolCheck11 = 15166
    },
    ["fm_mission_controller_2020"] = {
        iNextMission = 50150 + 1583,
        iTeamScore = 50150 + 1770 + 1, -- +[0~3]
        iServerBitSet = 50150 + 1,
        iServerBitSet1 = 50150 + 2,

        iLocalBoolCheck11 = 48799
    },

    ["fm_content_security_contract"] = {
        iGenericBitset = 7058,
        eEndReason = 7136 + 1278
    },
    ["fm_content_payphone_hit"] = {
        iGenericBitset = 5616,
        eEndReason = 5675 + 683,
        iMissionServerBitSet = 5675 + 740
    },
    ["fm_content_auto_shop_delivery"] = {
        iGenericBitset = 1518,
        eEndReason = 1572 + 83,
        iMissionEntityBitSet = 1572 + 2 + 5
    },
    ["fm_content_bike_shop_delivery"] = {
        iGenericBitset = 1518,
        eEndReason = 1574 + 83,
        iMissionEntityBitSet = 1574 + 2 + 5
    },
}

-- MISSION_TO_LAUNCH_DETAILS
local sLaunchMissionDetails <const> = 19709
local LaunchMissionDetails <const> = {
    iMinPlayers = sLaunchMissionDetails + 15,
    iMissionVariation = sLaunchMissionDetails + 34
}

-- `freemode` Time Trial
-- AMTT_VARS_STRUCT
local sTTVarsStruct <const> = 14386
local TTVarsStruct <const> = {
    iVariation = sTTVarsStruct + 11,
    trialTimer = sTTVarsStruct + 13,
    iPersonalBest = sTTVarsStruct + 25,
    eAMTT_Stage = sTTVarsStruct + 29
}

-- `freemode` RC Bandito Time Trial
-- AMRCTT_VARS_STRUCT
local sRCTTVarsStruct <const> = 14436
local RCTTVarsStruct <const> = {
    eVariation = sRCTTVarsStruct,
    eRunStage = sRCTTVarsStruct + 2,
    timerTrial = sRCTTVarsStruct + 6,
    iPersonalBest = sRCTTVarsStruct + 21
}


local fm_content_xxx = {
    { script = "fm_content_acid_lab_sell",       eEndReason = 5483 + 1294,  iGenericBitset = 5418 },
    { script = "fm_content_acid_lab_setup",      eEndReason = 3348 + 541,   iGenericBitset = 3294 },
    { script = "fm_content_acid_lab_source",     eEndReason = 7654 + 1162,  iGenericBitset = 7577 },
    { script = "fm_content_ammunation",          eEndReason = 2079 + 204,   iGenericBitset = 2025 },
    { script = "fm_content_armoured_truck",      eEndReason = 1902 + 113,   iGenericBitset = 1836 },
    { script = "fm_content_auto_shop_delivery",  eEndReason = 1572 + 83,    iGenericBitset = 1518 },
    { script = "fm_content_bank_shootout",       eEndReason = 2209 + 221,   iGenericBitset = 2138 },
    { script = "fm_content_bar_resupply",        eEndReason = 2275 + 287,   iGenericBitset = 2219 },
    { script = "fm_content_bicycle_time_trial",  eEndReason = 2942 + 83,    iGenericBitset = 2886 },
    { script = "fm_content_bike_shop_delivery",  eEndReason = 1574 + 83,    iGenericBitset = 1518 },
    { script = "fm_content_bounty_targets",      eEndReason = 7019 + 1251,  iGenericBitset = 6941 },
    { script = "fm_content_business_battles",    eEndReason = 5257 + 1138,  iGenericBitset = 5186 },
    { script = "fm_content_cargo",               eEndReason = 5830 + 1148,  iGenericBitset = 5761 },
    { script = "fm_content_cerberus",            eEndReason = 1589 + 91,    iGenericBitset = 1539 },
    { script = "fm_content_chop_shop_delivery",  eEndReason = 1893 + 137,   iGenericBitset = 1835 },
    { script = "fm_content_clubhouse_contracts", eEndReason = 6639 + 1255,  iGenericBitset = 6573 },
    { script = "fm_content_club_management",     eEndReason = 5207 + 775,   iGenericBitset = 5148 },
    { script = "fm_content_club_odd_jobs",       eEndReason = 1794 + 83,    iGenericBitset = 1738 },
    { script = "fm_content_club_source",         eEndReason = 3540 + 674,   iGenericBitset = 3467 },
    { script = "fm_content_convoy",              eEndReason = 2736 + 437,   iGenericBitset = 2672 },
    { script = "fm_content_crime_scene",         eEndReason = 1948 + 151,   iGenericBitset = 1892 },
    { script = "fm_content_daily_bounty",        eEndReason = 2533 + 325,   iGenericBitset = 2480 },
    { script = "fm_content_dispatch_work",       eEndReason = 4856 + 755,   iGenericBitset = 4797 },
    { script = "fm_content_drug_lab_work",       eEndReason = 7884 + 1253,  iGenericBitset = 7820 },
    { script = "fm_content_drug_vehicle",        eEndReason = 1762 + 115,   iGenericBitset = 1707 },
    { script = "fm_content_export_cargo",        eEndReason = 2200 + 191,   iGenericBitset = 2146 },
    { script = "fm_content_ghosthunt",           eEndReason = 1552 + 88,    iGenericBitset = 1499 },
    { script = "fm_content_golden_gun",          eEndReason = 1762 + 93,    iGenericBitset = 1711 },
    { script = "fm_content_gunrunning",          eEndReason = 5639 + 1237,  iGenericBitset = 5566 },
    { script = "fm_content_island_dj",           eEndReason = 3451 + 495,   iGenericBitset = 3374 },
    { script = "fm_content_island_heist",        eEndReason = 13311 + 1339, iGenericBitset = 13220 },
    { script = "fm_content_metal_detector",      eEndReason = 1810 + 93,    iGenericBitset = 1757 },
    { script = "fm_content_movie_props",         eEndReason = 1888 + 137,   iGenericBitset = 1833 },
    { script = "fm_content_parachuter",          eEndReason = 1568 + 83,    iGenericBitset = 1518 },
    { script = "fm_content_payphone_hit",        eEndReason = 5675 + 683,   iGenericBitset = 5616 },
    { script = "fm_content_phantom_car",         eEndReason = 1577 + 83,    iGenericBitset = 1527 },
    { script = "fm_content_pizza_delivery",      eEndReason = 1704 + 83,    iGenericBitset = 1648 },
    { script = "fm_content_possessed_animals",   eEndReason = 1593 + 83,    iGenericBitset = 1541 },
    { script = "fm_content_robbery",             eEndReason = 1732 + 87,    iGenericBitset = 1666 },
    { script = "fm_content_security_contract",   eEndReason = 7136 + 1278,  iGenericBitset = 7058 },
    { script = "fm_content_sightseeing",         eEndReason = 1822 + 84,    iGenericBitset = 1770 },
    { script = "fm_content_skydive",             eEndReason = 3010 + 93,    iGenericBitset = 2953 },
    { script = "fm_content_slasher",             eEndReason = 1597 + 83,    iGenericBitset = 1545 },
    { script = "fm_content_smuggler_ops",        eEndReason = 7600 + 1270,  iGenericBitset = 7523 },
    { script = "fm_content_smuggler_plane",      eEndReason = 1838 + 178,   iGenericBitset = 1771 },
    { script = "fm_content_smuggler_resupply",   eEndReason = 6045 + 1271,  iGenericBitset = 5966 },
    { script = "fm_content_smuggler_sell",       eEndReason = 4015 + 489,   iGenericBitset = 3880 },
    { script = "fm_content_smuggler_trail",      eEndReason = 2051 + 130,   iGenericBitset = 1980 },
    { script = "fm_content_source_research",     eEndReason = 4318 + 1195,  iGenericBitset = 4261 },
    { script = "fm_content_stash_house",         eEndReason = 3521 + 475,   iGenericBitset = 3467 },
    { script = "fm_content_taxi_driver",         eEndReason = 1993 + 83,    iGenericBitset = 1941 },
    { script = "fm_content_tow_truck_work",      eEndReason = 1755 + 91,    iGenericBitset = 1702 },
    { script = "fm_content_tuner_robbery",       eEndReason = 7313 + 1194,  iGenericBitset = 7226 },
    { script = "fm_content_ufo_abduction",       eEndReason = 2858 + 334,   iGenericBitset = 2792 },
    { script = "fm_content_vehicle_list",        eEndReason = 1568 + 83,    iGenericBitset = 1518 },
    { script = "fm_content_vehrob_arena",        eEndReason = 7807 + 1285,  iGenericBitset = 7748 },
    { script = "fm_content_vehrob_cargo_ship",   eEndReason = 7025 + 1224,  iGenericBitset = 6934 },
    { script = "fm_content_vehrob_casino_prize", eEndReason = 9060 + 1231,  iGenericBitset = 8979 },
    { script = "fm_content_vehrob_disrupt",      eEndReason = 4570 + 924,   iGenericBitset = 4511 },
    { script = "fm_content_vehrob_police",       eEndReason = 8847 + 1276,  iGenericBitset = 8772 },
    { script = "fm_content_vehrob_prep",         eEndReason = 11366 + 1272, iGenericBitset = 11265 },
    { script = "fm_content_vehrob_scoping",      eEndReason = 3752 + 508,   iGenericBitset = 3695 },
    { script = "fm_content_vehrob_submarine",    eEndReason = 6125 + 1137,  iGenericBitset = 6041 },
    { script = "fm_content_vehrob_task",         eEndReason = 4773 + 1043,  iGenericBitset = 4705 },
    { script = "fm_content_vip_contract_1",      eEndReason = 8692 + 1157,  iGenericBitset = 8619 },
    { script = "fm_content_xmas_mugger",         eEndReason = 1620 + 83,    iGenericBitset = 1568 },
    { script = "fm_content_xmas_truck",          eEndReason = 1461 + 91,    iGenericBitset = 1409 },
}


------------------------
-- Tunables
------------------------

local g_sMPTunables <const> = 262145
local Tunables <const> = {
    ["HIGH_ROCKSTAR_MISSIONS_MODIFIER"]                 = g_sMPTunables + 2403,
    ["LOW_ROCKSTAR_MISSIONS_MODIFIER"]                  = g_sMPTunables + 2407,

    ["IH_PRIMARY_TARGET_VALUE_TEQUILA"]                 = g_sMPTunables + 29458,
    ["IH_PRIMARY_TARGET_VALUE_PEARL_NECKLACE"]          = g_sMPTunables + 29459,
    ["IH_PRIMARY_TARGET_VALUE_BEARER_BONDS"]            = g_sMPTunables + 29460,
    ["IH_PRIMARY_TARGET_VALUE_PINK_DIAMOND"]            = g_sMPTunables + 29461,
    ["IH_PRIMARY_TARGET_VALUE_MADRAZO_FILES"]           = g_sMPTunables + 29462,
    ["IH_PRIMARY_TARGET_VALUE_SAPPHIRE_PANTHER_STATUE"] = g_sMPTunables + 29463,

    ["IH_DEDUCTION_FENCING_FEE"]                        = g_sMPTunables + 29467,
    ["IH_DEDUCTION_PAVEL_CUT"]                          = g_sMPTunables + 29468,
}


------------------------
-- Functions
------------------------

local g_sCURRENT_UGC_STATUS <const> = 2693440
local g_iMissionEnteryType <const> = 1057440

local function LAUNCH_MISSION(Data)
    notify("启动差事", "请稍等...")

    local iArrayPos = MISC.GET_CONTENT_ID_INDEX(Data.iRootContentID)

    local tlName = GLOBAL_GET_STRING(FMMC_ROCKSTAR_CREATED.sMissionHeaderVars + iArrayPos * 89)
    local iMaxPlayers = GLOBAL_GET_INT(FMMC_ROCKSTAR_CREATED.sMissionHeaderVars + iArrayPos * 89 + 71)

    GLOBAL_SET_INT(g_TransitionSessionNonResetVars + 3850, 1)
    GLOBAL_SET_INT(g_sCURRENT_UGC_STATUS + 1, 0)
    GLOBAL_SET_BIT(g_sTransitionSessionData + 3, 2)

    if Data.iMissionEnteryType then
        GLOBAL_SET_INT(g_iMissionEnteryType, Data.iMissionEnteryType)
    end

    if Data.iMissionType == 274 then
        GLOBAL_SET_BIT(g_sTransitionSessionData + 3, 13)
        GLOBAL_SET_BIT(Globals.GlobalplayerBD_FM_2() + 33, 28)
    elseif Data.iMissionType == 260 then
        GLOBAL_SET_BIT(g_sTransitionSessionData + 3, 11)
        GLOBAL_SET_BIT(Globals.GlobalplayerBD_FM_2() + 33, 27)
    elseif Data.iMissionType == 233 or Data.iMissionType == 235 then
        GLOBAL_SET_BIT(g_sTransitionSessionData + 3, 4)
        GLOBAL_SET_BIT(Globals.GlobalplayerBD_FM_2() + 33, 12)

        GLOBAL_SET_BIT(g_sTransitionSessionData + 2, 29)
    end

    GLOBAL_SET_INT(g_sTransitionSessionData + 9, Data.iMissionType)
    GLOBAL_SET_STRING(g_sTransitionSessionData + 863, tlName)
    GLOBAL_SET_INT(g_sTransitionSessionData + 42, iMaxPlayers)
    GLOBAL_CLEAR_BIT(g_sTransitionSessionData + 2, 14)
    GLOBAL_SET_BIT(g_sTransitionSessionData, 5)
    GLOBAL_SET_BIT(g_sTransitionSessionData, 8)
    GLOBAL_CLEAR_BIT(g_sTransitionSessionData, 7)
    GLOBAL_CLEAR_BIT(g_sTransitionSessionData, 15)
    GLOBAL_SET_INT(g_sTransitionSessionData + 719, 1)

    GLOBAL_SET_INT(Globals.GlobalplayerBD_FM() + 96, 8)
end

local function IS_PLAYER_BOSS_OF_A_GANG()
    return GLOBAL_GET_INT(Globals.GlobalplayerBD_FM_3() + 10) == PLAYER.PLAYER_ID()
end

local function COMPLETE_DAILY_CHALLENGE()
    for i = 0, 2, 1 do
        GLOBAL_SET_INT(2359296 + 1 + 0 * 5569 + 681 + 4244 + 1 + i * 3 + 1, 1)
    end
end

local function COMPLETE_WEEKLY_CHALLENGE()
    local g_sWeeklyChallenge = 2737992

    GLOBAL_SET_INT(g_sWeeklyChallenge + 1 + 0 * 6 + 3, 0)
    GLOBAL_SET_INT(g_sWeeklyChallenge + 1 + 0 * 6 + 4, 0)

    local target = GLOBAL_GET_INT(g_sWeeklyChallenge + 1 + 0 * 6 + 2)
    GLOBAL_SET_INT(g_sWeeklyChallenge + 1 + 0 * 6 + 1, target)
end

local function BROADCAST_GB_BOSS_WORK_REQUEST_SERVER(iMission)
    local user = PLAYER.PLAYER_ID()

    GLOBAL_SET_INT(Globals.GlobalplayerBD_FM_3() + 10 + 32, iMission)

    network.trigger_script_event(1 << user, {
        1613825825,
        PLAYER.PLAYER_ID(),
        -1,
        iMission,
        -1, -1, -1, -1
    })
end

local function INSTANT_FINISH_FM_CONTENT_MISSION(script_name)
    network.force_script_host(script_name)

    LOCAL_SET_BIT(script_name, Locals[script_name].iGenericBitset + 1 + 0, 11)
    LOCAL_SET_INT(script_name, Locals[script_name].eEndReason, 3)
end

local function INSTANT_FINISH_FM_MISSION_CONTROLLER()
    local mission_script = GET_RUNNING_MISSION_CONTROLLER_SCRIPT()
    if mission_script == nil then
        return
    end

    REQUEST_FMMC_SCRIPT_HOST(mission_script)

    for i = 0, 5 do
        local tl23NextContentID = GLOBAL_GET_STRING(FMMC_STRUCT.tl23NextContentID + i * 6)
        if tl23NextContentID ~= "" then
            GLOBAL_SET_STRING(FMMC_STRUCT.tl23NextContentID + i * 6, "")
        end
    end

    if GLOBAL_GET_BOOL(StrandMissionData.bIsThisAStrandMission) then
        GLOBAL_SET_BOOL(StrandMissionData.bPassedFirstMission, true)
        GLOBAL_SET_BOOL(StrandMissionData.bPassedFirstStrandNoReset, true)
        GLOBAL_SET_BOOL(StrandMissionData.bLastMission, true)
    end
    LOCAL_SET_INT(mission_script, Locals[mission_script].iNextMission, 5)

    LOCAL_SET_BIT(mission_script, Locals[mission_script].iLocalBoolCheck11, 7)

    for i = 0, 3 do
        LOCAL_SET_INT(mission_script, Locals[mission_script].iTeamScore + i, 999999)
    end

    LOCAL_SET_BITS(mission_script, Locals[mission_script].iServerBitSet, 9, 10, 11, 12, 16)
end

--#endregion


local Tables <const> = {
    IslandHeist = {
        ApproachVehicle = {
            get_label_text("H4P_FIN1_SUBM_T"), -- KOSATKA
            get_label_text("H4P_FIN1_BOMB_T"), -- ALKONOST
            get_label_text("H4P_FIN1_SMPL_T"), -- VELUM
            get_label_text("H4P_FIN1_SHEL_T"), -- STEALTH ANNIHILATOR
            get_label_text("H4P_FIN1_PBOA_T"), -- PATROL BOAT
            get_label_text("H4P_FIN1_SBOA_T")  -- LONGFIN
        },
        InfiltrationPoint = {
            get_label_text("H4P_FIN2_AIRS_T"), -- AIRSTRIP
            get_label_text("H4P_FIN2_PARA_T"), -- HALO JUMP
            get_label_text("H4P_FIN2_WBEA_T"), -- WEST BEACH
            get_label_text("H4P_FIN2_MDOC_T"), -- MAIN DOCK
            get_label_text("H4P_FIN2_NDOC_T"), -- NORTH DOCK
            get_label_text("H4P_FIN2_NDRP_T"), -- NORTH DROP ZONE
            get_label_text("H4P_FIN2_SDRP_T"), -- SOUTH DROP ZONE
            get_label_text("H4P_FIN2_DTUN_T")  -- DRAINAGE TUNNEL
        },
        CompoundEntrance = {
            get_label_text("H4P_INT5_MGAT_T"), -- MAIN GATE
            get_label_text("H4P_INT5_NWAL_T"), -- NORTH WALL
            get_label_text("H4P_INT5_NSGT_T"), -- NORTH GATE
            get_label_text("H4P_INT5_SWAL_T"), -- SOUTH WALL
            get_label_text("H4P_INT5_SSGT_T"), -- SOUTH GATE
            get_label_text("H4P_INT5_DTUN_T")  -- DRAINAGE TUNNEL
        },
        EscapePoint = {
            get_label_text("H4P_FIN4_AIRS_T"), -- AIRSTRIP
            get_label_text("H4P_FIN4_MDOC_T"), -- MAIN DOCK
            get_label_text("H4P_FIN4_NDOC_T"), -- NORTH DOCK
            get_label_text("H4P_FIN4_SUBM_T")  -- KOSATKA
        },
        TimeOfDay = {
            get_label_text("H4P_FIN5_TDAY_T"), -- DAY
            get_label_text("H4P_FIN5_TNGT_T")  -- NIGHT
        },
        WeaponLoadout = {
            get_label_text("H4P_FIN6_SHOT_T"), -- AGGRESSOR
            get_label_text("H4P_FIN6_RIFL_T"), -- CONSPIRATOR
            get_label_text("H4P_FIN6_SNIP_T"), -- CRACK SHOT
            get_label_text("H4P_FIN6_MKSM_T"), -- SABOTEUR
            get_label_text("H4P_FIN6_MKAR_T")  -- MARKSMAN
        }
    }
}



----------------------------------------
-- Menu: Main
----------------------------------------

local menu_root <const> = gui.add_tab("RS Missions")

menu_root:add_text("支持的GTA版本: " .. SUPPORT_GAME_VERSION)
menu_root:add_text("当前GTA版本: " .. CURRENT_GAME_VERSION)
local status_text = IS_SUPPORT and "支持" or "不支持当前游戏版本, 请停止使用"
menu_root:add_text("状态: " .. status_text)



----------------------------------------
-- Menu: Freemode Mission
----------------------------------------

local menu_feemode_mission <const> = menu_root:add_tab("[RSM] 自由模式任务")

menu_feemode_mission:add_text("*所有功能均在单人战局测试可用*")


menu_feemode_mission:add_text("<<  启动任务  >>")

local freemode_mission_select = 0
menu_feemode_mission:add_imgui(function()
    freemode_mission_select, clicked = ImGui.Combo("选择自由模式任务", freemode_mission_select, {
        "安保合约 (富兰克林)", "电话暗杀 (富兰克林)", "蠢人帮差事 (达克斯)", "赌场工作 (贝克女士)", "藏匿屋"
    }, 5, 5)
end)

local FMMC_TYPE <const> = {
    [0] = 263,
    [1] = 262,
    [2] = 307,
    [3] = 243,
    [4] = 308
}

menu_feemode_mission:add_button("启动 自由模式任务", function()
    BROADCAST_GB_BOSS_WORK_REQUEST_SERVER(FMMC_TYPE[freemode_mission_select])
end)


menu_feemode_mission:add_separator()
menu_feemode_mission:add_text("<<  直接完成任务  >>")

menu_feemode_mission:add_button("直接完成 安保合约", function()
    local script_name = "fm_content_security_contract"
    if not IS_SCRIPT_RUNNING(script_name) then
        return
    end
    INSTANT_FINISH_FM_CONTENT_MISSION(script_name)
end)

menu_feemode_mission:add_button("直接完成 电话暗杀", function()
    local script_name = "fm_content_payphone_hit"
    if not IS_SCRIPT_RUNNING(script_name) then
        return
    end
    INSTANT_FINISH_FM_CONTENT_MISSION(script_name)
end)
menu_feemode_mission:add_sameline()
menu_feemode_mission:add_button("直接完成 电话暗杀(暗杀奖励)", function()
    local script_name = "fm_content_payphone_hit"
    if not IS_SCRIPT_RUNNING(script_name) then
        return
    end
    LOCAL_SET_BIT(script_name, Locals[script_name].iMissionServerBitSet + 1, 1)
    INSTANT_FINISH_FM_CONTENT_MISSION(script_name)
end)

menu_feemode_mission:add_button("直接完成 改装铺服务", function()
    local script_name = "fm_content_auto_shop_delivery"
    if not IS_SCRIPT_RUNNING(script_name) then
        return
    end
    if PED.IS_PED_IN_ANY_VEHICLE(PLAYER.PLAYER_PED_ID(), false) then
        TASK.CLEAR_PED_TASKS_IMMEDIATELY(PLAYER.PLAYER_PED_ID())
    end

    LOCAL_SET_BIT(script_name, Locals[script_name].iMissionEntityBitSet + 1 + 0 * 3 + 1 + 0, 4)
    INSTANT_FINISH_FM_CONTENT_MISSION(script_name)
end)
menu_feemode_mission:add_sameline()
menu_feemode_mission:add_button("直接完成 摩托车服务", function()
    local script_name = "fm_content_bike_shop_delivery"
    if not IS_SCRIPT_RUNNING(script_name) then
        return
    end
    if PED.IS_PED_IN_ANY_VEHICLE(PLAYER.PLAYER_PED_ID(), false) then
        TASK.CLEAR_PED_TASKS_IMMEDIATELY(PLAYER.PLAYER_PED_ID())
    end

    LOCAL_SET_BIT(script_name, Locals[script_name].iMissionEntityBitSet + 1 + 0 * 3 + 1 + 0, 4)
    INSTANT_FINISH_FM_CONTENT_MISSION(script_name)
end)

menu_feemode_mission:add_text("")

menu_feemode_mission:add_button("直接完成 fm_content_xx 自由模式任务", function()
    for _, item in pairs(fm_content_xxx) do
        if IS_SCRIPT_RUNNING(item.script) then
            LOCAL_SET_BIT(item.script, item.iGenericBitset + 1 + 0, 11)
            LOCAL_SET_INT(item.script, item.eEndReason, 3)
        end
    end
end)
menu_feemode_mission:add_text("可以完成大部分的自由模式任务，但部分任务并不会判定任务成功")


menu_feemode_mission:add_separator()
menu_feemode_mission:add_text("<<  时间挑战赛  >>")

local TimeTrialParTime = {
    [0] = 103200,
    [1] = 124400,
    [2] = 124900,
    [3] = 46300,
    [4] = 249500,
    [5] = 104000,
    [6] = 38500,
    [7] = 70100,
    [8] = 135000,
    [9] = 127200,
    [10] = 101300,
    [11] = 77800,
    [12] = 58800,
    [13] = 149400,
    [14] = 60000,
    [15] = 79000,
    [16] = 103400,
    [17] = 84200,
    [18] = 178800,
    [19] = 86600,
    [20] = 76600,
    [21] = 54200,
    [22] = 100000,
    [23] = 125000,
    [24] = 120000,
    [25] = 155000,
    [26] = 80000,
    [27] = 144000,
    [28] = 136000,
    [29] = 110000,
    [30] = 86000,
    [31] = 130000
}
menu_feemode_mission:add_button("直接完成 时间挑战赛", function()
    local script_name = "freemode"
    if not IS_SCRIPT_RUNNING(script_name) then
        return
    end

    if LOCAL_GET_INT(script_name, TTVarsStruct.eAMTT_Stage) == 3 then -- AMTT_GOTO
        local iVariation = LOCAL_GET_INT(script_name, TTVarsStruct.iVariation)
        local iParTime = TimeTrialParTime[iVariation]
        if iParTime == nil then
            iParTime = 1000 -- 1s
        else
            iParTime = iParTime - 1000
        end
        local iStartTime = NETWORK.GET_NETWORK_TIME() - iParTime

        network.force_script_host(script_name)

        LOCAL_SET_INT(script_name, TTVarsStruct.trialTimer, iStartTime)
        LOCAL_SET_INT(script_name, TTVarsStruct.eAMTT_Stage, 4) -- AMTT_END
    end
end)

menu_feemode_mission:add_sameline()

local RCTimeTrialParTime = {
    [0] = 110000,
    [1] = 90000,
    [2] = 80000,
    [3] = 87000,
    [4] = 70000,
    [5] = 92000,
    [6] = 125000,
    [7] = 72000,
    [8] = 113000,
    [9] = 80000,
    [10] = 83000,
    [11] = 78000,
    [12] = 87000,
    [13] = 82000,
}
menu_feemode_mission:add_button("直接完成 RC匪徒时间挑战赛", function()
    local script_name = "freemode"
    if not IS_SCRIPT_RUNNING(script_name) then
        return
    end

    if LOCAL_GET_INT(script_name, RCTTVarsStruct.eRunStage) == 4 then -- ARS_TRIAL
        local eVariation = LOCAL_GET_INT(script_name, RCTTVarsStruct.eVariation)
        local iParTime = RCTimeTrialParTime[eVariation]
        if iParTime == nil then
            iParTime = 1000 -- 1s
        else
            iParTime = iParTime - 1000
        end
        local iStartTime = NETWORK.GET_NETWORK_TIME() - iParTime

        network.force_script_host(script_name)

        LOCAL_SET_INT(script_name, RCTTVarsStruct.timerTrial, iStartTime)
        LOCAL_SET_INT(script_name, RCTTVarsStruct.eRunStage, 6) -- ARS_END
    end
end)


menu_feemode_mission:add_separator()
menu_feemode_mission:add_button("完成每日挑战", function()
    COMPLETE_DAILY_CHALLENGE()
end)
menu_feemode_mission:add_sameline()
menu_feemode_mission:add_button("完成每周挑战", function()
    COMPLETE_WEEKLY_CHALLENGE()
end)






----------------------------------------
-- Menu: Heist Mission
----------------------------------------

local menu_mission <const> = menu_root:add_tab("[RSM] 抢劫任务")

local MenuHMission = {}

menu_mission:add_text("*所有功能均在单人战局测试可用*")

--------------------------------
-- General
--------------------------------

menu_mission:add_text("<<  通用  >>")

MenuHMission["SetMinPlayers"] = menu_mission:add_checkbox("最小玩家数为 1 (强制任务单人可开)")
menu_mission:add_sameline()
MenuHMission["SetMaxTeams"] = menu_mission:add_checkbox("最大团队数为 1 (用于多团队任务)")

menu_mission:add_button("直接完成任务 (通用)", function()
    INSTANT_FINISH_FM_MISSION_CONTROLLER()
end)
menu_mission:add_sameline()
menu_mission:add_button("跳到下一个检查点 (解决单人任务卡关问题)", function()
    local mission_script = GET_RUNNING_MISSION_CONTROLLER_SCRIPT()
    if mission_script ~= nil then
        REQUEST_FMMC_SCRIPT_HOST(mission_script)
        LOCAL_SET_BIT(mission_script, Locals[mission_script].iServerBitSet1, 17)
    end
end)

MenuHMission["DisableMissionAggroFail"] = menu_mission:add_checkbox("禁止因触发惊动而任务失败")
menu_mission:add_sameline()
MenuHMission["DisableMissionFail"] = menu_mission:add_checkbox("禁止任务失败")
menu_mission:add_sameline()
menu_mission:add_button("允许任务失败", function()
    MenuHMission["DisableMissionFail"]:set_enabled(false)

    local mission_script = GET_RUNNING_MISSION_CONTROLLER_SCRIPT()
    if mission_script ~= nil then
        REQUEST_FMMC_SCRIPT_HOST(mission_script)
        LOCAL_CLEAR_BIT(mission_script, Locals[mission_script].iLocalBoolCheck11, 7)
    end
end)

--------------------------------
-- Launch Mission
--------------------------------

menu_mission:add_separator()
menu_mission:add_text("<<  启动差事  >>")
menu_mission:add_text("未对室内类型进行检查, 启动差事前确保在正确的室内")
menu_mission:add_text("点击启动差事后, 耐心等待差事加载")


menu_mission:add_button("启动差事: 别惹德瑞", function()
    if IS_MISSION_CONTROLLER_SCRIPT_RUNNING() then
        return
    end

    if stats.get_int("MPX_FIXER_HQ_OWNED") <= 0 then
        notify("启动差事", "你需要拥有事务所")
        return
    end
    if not IS_PLAYER_BOSS_OF_A_GANG() then
        notify("启动差事", "你需要注册为老大")
        return
    end

    local Data = {
        iRootContentID = 1645353926, -- Tunable: FIXER_INSTANCED_STORY_MISSION_ROOT_CONTENT_ID5
        iMissionType = 0,            -- FMMC_TYPE_MISSION
        iMissionEnteryType = 81,     -- ciMISSION_ENTERY_TYPE_FIXER_WORLD_TRIGGER
    }

    LAUNCH_MISSION(Data)
end)
menu_mission:add_sameline()
menu_mission:add_text("要求: 1. 注册为老大; 2. 拥有事务所")


menu_mission:add_button("启动差事: 犯罪现场 (潜行)", function()
    if IS_MISSION_CONTROLLER_SCRIPT_RUNNING() then
        return
    end

    local Data = {
        iRootContentID = 13546844, -- Tunable: SALV23_CHICKEN_FACTORY_RAID_ROOT_CONTENT_ID_6
        iMissionType = 0,          -- FMMC_TYPE_MISSION
        iMissionEnteryType = 32,   -- ciMISSION_ENTERY_TYPE_V2_CORONA
    }

    LAUNCH_MISSION(Data)
end)
menu_mission:add_sameline()
menu_mission:add_button("启动差事: 犯罪现场 (强攻)", function()
    if IS_MISSION_CONTROLLER_SCRIPT_RUNNING() then
        return
    end

    local Data = {
        iRootContentID = 2107866924, -- Tunable: SALV23_CHICKEN_FACTORY_RAID_ROOT_CONTENT_ID_5
        iMissionType = 0,            -- FMMC_TYPE_MISSION
        iMissionEnteryType = 32,     -- ciMISSION_ENTERY_TYPE_V2_CORONA
    }

    LAUNCH_MISSION(Data)
end)

menu_mission:add_text("")


local IslandHeistConfig = {
    bHardModeEnabled = false,

    eApproachVehicle = 6 - 1,
    eInfiltrationPoint = 3,
    eCompoundEntrance = 0,
    eEscapePoint = 1,
    eTimeOfDay = 1 - 1,

    eWeaponLoadout = 1 - 1,
    bUseSuppressors = true
}
menu_mission:add_button("启动差事: 佩里科岛抢劫", function()
    if IS_MISSION_CONTROLLER_SCRIPT_RUNNING() then
        return
    end

    if stats.get_int("MPX_IH_SUB_OWNED") <= 0 then
        notify("启动差事", "你需要拥有虎鲸")
        return
    end
    if not IS_PLAYER_BOSS_OF_A_GANG() then
        notify("启动差事", "你需要注册为老大")
        return
    end
    if INTERIOR.GET_INTERIOR_FROM_ENTITY(PLAYER.PLAYER_PED_ID()) ~= 281345 then
        notify("启动差事", "你需要在虎鲸内部")
        return
    end


    local Data = {
        iRootContentID = -1172878953, -- Tunable: H4_ROOT_CONTENT_ID_0
        iMissionType = 260,           -- FMMC_TYPE_HEIST_ISLAND_FINALE
        iMissionEnteryType = 67,      -- ciMISSION_ENTERY_TYPE_HEIST_ISLAND_TABLE
    }

    LAUNCH_MISSION(Data)
end)
menu_mission:add_sameline()
menu_mission:add_text("要求: 1. 注册为老大; 2. 拥有虎鲸; 3. 在虎鲸内部;")

local menu_island_heist_config = {
    initialized = false,
    can_show = false
}
menu_mission:add_button("设置终章面板", function()
    menu_island_heist_config.can_show = not menu_island_heist_config.can_show
end)
menu_mission:add_sameline()
menu_mission:add_text("如果没有完成必须前置，需要设置终章面板后才可点击继续按钮")

menu_mission:add_imgui(function()
    if menu_island_heist_config.can_show and ImGui.Begin("佩里科岛抢劫 终章面板设置") then
        if not menu_island_heist_config.initialized then
            ImGui.SetWindowSize(400, 500)
            menu_island_heist_config.initialized = true
        end

        IslandHeistConfig.bHardModeEnabled = ImGui.Checkbox(
            get_label_text("IHB_HARD_MODE"),
            IslandHeistConfig.bHardModeEnabled)

        IslandHeistConfig.eApproachVehicle = ImGui.Combo(
            get_label_text("H4P_FIN0_APRV_T"),
            IslandHeistConfig.eApproachVehicle,
            Tables.IslandHeist.ApproachVehicle, 6)

        IslandHeistConfig.eInfiltrationPoint = ImGui.Combo(
            get_label_text("H4P_INT0_ENTR_T"),
            IslandHeistConfig.eInfiltrationPoint,
            Tables.IslandHeist.InfiltrationPoint, 8)

        IslandHeistConfig.eCompoundEntrance = ImGui.Combo(
            get_label_text("H4P_INT0_COMP_T"),
            IslandHeistConfig.eCompoundEntrance,
            Tables.IslandHeist.CompoundEntrance, 6)

        IslandHeistConfig.eEscapePoint = ImGui.Combo(
            get_label_text("H4P_INT0_EXIT_T"),
            IslandHeistConfig.eEscapePoint,
            Tables.IslandHeist.EscapePoint, 4)

        IslandHeistConfig.eTimeOfDay = ImGui.Combo(
            get_label_text("H4P_FIN0_TIMD_T"),
            IslandHeistConfig.eTimeOfDay,
            Tables.IslandHeist.TimeOfDay, 2)

        IslandHeistConfig.eWeaponLoadout = ImGui.Combo(
            get_label_text("H4P_FIN0_WEAP_T"),
            IslandHeistConfig.eWeaponLoadout,
            Tables.IslandHeist.WeaponLoadout, 5)

        IslandHeistConfig.bUseSuppressors = ImGui.Checkbox(
            get_label_text("H4P_FIN6_SUPP_T"),
            IslandHeistConfig.bUseSuppressors)


        if ImGui.Button("设置终章面板", 200, 50) then
            local sConfig = GlobalPlayerBD_HeistIsland.sConfig()
            local Data = IslandHeistConfig

            GLOBAL_SET_INT(sConfig + 35, Data.eWeaponLoadout + 1)
            GLOBAL_SET_BOOL(sConfig + 38, Data.bHardModeEnabled)
            if Data.bHardModeEnabled then
                GLOBAL_SET_INT(FMMC_STRUCT.iDifficulity, 2)
            else
                GLOBAL_SET_INT(FMMC_STRUCT.iDifficulity, 1)
            end
            GLOBAL_SET_INT(sConfig + 39, Data.eApproachVehicle + 1)
            GLOBAL_SET_INT(sConfig + 40, Data.eInfiltrationPoint)
            GLOBAL_SET_INT(sConfig + 41, Data.eCompoundEntrance)
            GLOBAL_SET_INT(sConfig + 42, Data.eEscapePoint)
            GLOBAL_SET_INT(sConfig + 43, Data.eTimeOfDay + 1)
            GLOBAL_SET_BOOL(sConfig + 44, Data.bUseSuppressors)
        end

        if ImGui.Button("强制点击 继续 按钮", 200, 50) then
            GLOBAL_SET_INT(GlobalPlayerBD_NetHeistPlanningGeneric.stFinaleLaunchTimer() + 1, 1)
            GLOBAL_SET_INT(GlobalPlayerBD_NetHeistPlanningGeneric.stFinaleLaunchTimer(), 0)
        end

        ImGui.End()
    end
end)

menu_mission:add_text("")


local auto_shop_final_select = 0
menu_mission:add_imgui(function()
    auto_shop_final_select, clicked = ImGui.Combo("选择改装铺合约", auto_shop_final_select, {
        "联合储蓄合约", "大钞交易", "银行合约", "电控单元差事", "监狱合约", "IAA 交易", "失落摩托帮合约", "数据合约"
    }, 8, 5)
end)
menu_mission:add_button("启动差事: 改装铺抢劫", function()
    if IS_MISSION_CONTROLLER_SCRIPT_RUNNING() then
        return
    end

    local auto_shop_final_root_content = {
        [0] = 2064133602, -- Tunable: TUNER_ROBBERY_FINALE_ROOT_CONTENT_ID0
        [1] = 1364299584,
        [2] = 14434931,
        [3] = 808119513,
        [4] = -554734818,
        [5] = -1750247281,
        [6] = 1767266297,
        [7] = -1931849607
    }

    if stats.get_int("MPX_AUTO_SHOP_OWNED") <= 0 then
        notify("启动差事", "你需要拥有改装铺")
        return
    end
    if not IS_PLAYER_BOSS_OF_A_GANG() then
        notify("启动差事", "你需要注册为老大")
        return
    end
    if not INTERIOR.IS_INTERIOR_SCENE() then
        notify("启动差事", "你需要在改装铺内部")
        return
    end


    local Data = {
        iRootContentID = auto_shop_final_root_content[auto_shop_final_select],
        iMissionType = 274,      -- FMMC_TYPE_TUNER_ROBBERY_FINALE
        iMissionEnteryType = 69, -- ciMISSION_ENTERY_TYPE_TUNER_JOB_BOARD
    }

    LAUNCH_MISSION(Data)
end)
menu_mission:add_sameline()
menu_mission:add_text("要求: 1. 注册为老大; 2. 拥有改装铺; 3. 在改装铺内部")

menu_mission:add_text("")


local doomsday_heist_final_select = 0
menu_mission:add_imgui(function()
    doomsday_heist_final_select, clicked = ImGui.Combo("选择末日豪劫终章", doomsday_heist_final_select, {
        "数据泄露", "波格丹危机", "末日将至"
    }, 3)
end)
menu_mission:add_button("启动差事: 末日豪劫 终章", function()
    if IS_MISSION_CONTROLLER_SCRIPT_RUNNING() then
        return
    end

    local doomsday_heist_final_root_content = {
        [0] = 1175383697, -- Tunable: FHM_FLOW_ROOTCONTENT_ID_3
        [1] = -411752237,
        [2] = -1176220645
    }

    if stats.get_int("MPX_DBASE_OWNED") <= 0 then
        notify("启动差事", "你需要拥有设施")
        return
    end
    if not IS_PLAYER_BOSS_OF_A_GANG() then
        notify("启动差事", "你需要注册为老大")
        return
    end
    if not INTERIOR.IS_INTERIOR_SCENE() then
        notify("启动差事", "你需要在设施内部")
        return
    end


    local Data = {
        iRootContentID = doomsday_heist_final_root_content[doomsday_heist_final_select],
        iMissionType = 235, -- FMMC_TYPE_FM_GANGOPS_FIN
    }

    LAUNCH_MISSION(Data)
end)
menu_mission:add_sameline()
menu_mission:add_text("要求: 1. 注册为老大; 2. 拥有设施; 3. 在设施内部")

menu_mission:add_text("")


local doomsday_heist_setup_select = 0
menu_mission:add_imgui(function()
    doomsday_heist_setup_select, clicked = ImGui.Combo("选择末日豪劫准备任务", doomsday_heist_setup_select, {
        "亡命速递", "拦截信号", "服务器群组",
        "复仇者", "营救 ULP", "抢救硬盘", "潜水艇侦察",
        "营救 14 号探员", "护送 ULP", "巴拉杰", "可汗贾利", "空中防御"
    }, 12, 5)
end)
menu_mission:add_button("启动差事: 末日豪劫 准备任务", function()
    if IS_MISSION_CONTROLLER_SCRIPT_RUNNING() then
        return
    end

    local doomsday_heist_setup_root_content = {
        [0] = -1984590517, -- Tunable: FHM_FLOW_ROOTCONTENT_ID_0
        [1] = -1306877878,
        [2] = 83978007,

        [3] = 1673641696,
        [4] = 1549726198,
        [5] = 1146411126,
        [6] = 1981951486,

        [7] = 1865386823,
        [8] = 1374735669,
        [9] = -1651202044,
        [10] = 1579954143,
        [11] = -110733685
    }

    if stats.get_int("MPX_DBASE_OWNED") <= 0 then
        notify("启动差事", "你需要拥有设施")
        return
    end
    if not IS_PLAYER_BOSS_OF_A_GANG() then
        notify("启动差事", "你需要注册为老大")
        return
    end
    if not INTERIOR.IS_INTERIOR_SCENE() then
        notify("启动差事", "你需要在设施内部")
        return
    end


    local Data = {
        iRootContentID = doomsday_heist_setup_root_content[doomsday_heist_setup_select],
        iMissionType = 233, -- FMMC_TYPE_FM_GANGOPS
    }

    LAUNCH_MISSION(Data)
end)
menu_mission:add_sameline()
menu_mission:add_text("要求: 1. 注册为老大; 2. 拥有设施; 3. 在设施内部")



menu_mission:add_separator()
menu_mission:add_text("<<  限制差事收入  >>")
MenuHMission["MissionEarningHigh"] = menu_mission:add_input_int("最高收入")
MenuHMission["MissionEarningLow"] = menu_mission:add_input_int("最低收入")
MenuHMission["MissionEarningModifier"] = menu_mission:add_checkbox("开启限制差事收入 [0 ~ 15000000]")
menu_mission:add_sameline()
menu_mission:add_button("取消差事收入限制", function()
    MenuHMission["MissionEarningModifier"]:set_enabled(false)

    GLOBAL_SET_FLOAT(Tunables["HIGH_ROCKSTAR_MISSIONS_MODIFIER"], 0)
    GLOBAL_SET_FLOAT(Tunables["LOW_ROCKSTAR_MISSIONS_MODIFIER"], 0)
end)

menu_mission:add_text("数值为0, 则不进行限制; 限制最低收入后, 差事最终结算时最低收入就为设置的值;")









----------------------------------------
-- Menu: Automation
----------------------------------------

local menu_automation <const> = menu_root:add_tab("[RSM] 自动化任务")

local MenuMMoney = {}


--------------------------------
-- Auto Island Heist
--------------------------------

menu_automation:add_text("<<  全自动佩里科岛抢劫  >>")

menu_automation:add_text("*仅适用于单人*")
menu_automation:add_text("要求: 1. 开启后无需任何操作，只需等待任务结束; 2. 自动注册CEO可能会有问题，可以提前注册")

-- menu_automation:add_button("设置偏好出生地点为 虎鲸", function()
--     stats.set_int("MPX_SPAWN_LOCATION_SETTING", 16)
-- end)
-- menu_automation:add_sameline()
-- menu_automation:add_text("然后切换战局即可")


local bTransitionSessionSkipLbAndNjvs = g_sTransitionSessionData + 702

local _coronaMenuData = 17445
local coronaMenuData = {
    iCurrentSelection = _coronaMenuData + 911,
}

local _sLaunchMissionDetails = 19709
local sLaunchMissionDetails2 = {
    iIntroStatus = _sLaunchMissionDetails,
    iHeistStatus = _sLaunchMissionDetails + 3,
    iLobbyStatus = _sLaunchMissionDetails + 4,
    iInviteScreenStatus = _sLaunchMissionDetails + 6,
    iInCoronaStatus = _sLaunchMissionDetails + 7,
    iBettingStatus = _sLaunchMissionDetails + 10,
    iLoadStatus = _sLaunchMissionDetails + 11,

    iMaxParticipants = _sLaunchMissionDetails + 32,
}

local function REGISTER_AS_A_CEO()
    script.run_in_fiber(function(script_util)
        local ePiStage = 1526

        local g_iPIM_SubMenu = 2710428
        local PIMenuData = {
            iCurrentSelection = 2710523 + 8191
        }
        local g_bPIM_ResetMenuNow = 2710431


        local script_name = "am_pi_menu"
        if not IS_SCRIPT_RUNNING(script_name) then
            return
        end

        repeat
            script_util:yield(10)
            -- PLAYER_CONTROL, INPUT_INTERACTION_MENU
            PAD.SET_CONTROL_VALUE_NEXT_FRAME(0, 244, 1.0)
        until LOCAL_GET_INT(script_name, ePiStage) == 1

        GLOBAL_SET_INT(g_iPIM_SubMenu, 116) -- REGISTER AS A BOSS
        GLOBAL_SET_INT(PIMenuData.iCurrentSelection, 0)

        GLOBAL_SET_BOOL(g_bPIM_ResetMenuNow, true)

        script_util:sleep(50)

        -- FRONTEND_CONTROL, INPUT_CELLPHONE_SELECT
        PAD.SET_CONTROL_VALUE_NEXT_FRAME(2, 176, 1.0)

        repeat
            script_util:yield()
        until GLOBAL_GET_INT(g_iPIM_SubMenu) == 27 -- Start an Organization
        GLOBAL_SET_INT(PIMenuData.iCurrentSelection, 0)

        script_util:sleep(10)

        -- FRONTEND_CONTROL, INPUT_CELLPHONE_SELECT
        PAD.SET_CONTROL_VALUE_NEXT_FRAME(2, 176, 1.0)

        script_util:sleep(10)

        -- FRONTEND_CONTROL, INPUT_FRONTEND_ACCEPT
        PAD.SET_CONTROL_VALUE_NEXT_FRAME(2, 201, 1.0)

        script_util:sleep(10)

        if LOCAL_GET_INT(script_name, ePiStage) == 1 then
            -- PLAYER_CONTROL, INPUT_INTERACTION_MENU
            PAD.SET_CONTROL_VALUE_NEXT_FRAME(0, 244, 1.0)
        end
    end)
end

local function JOIN_INVITE_ONLY_SESSION()
    script.run_in_fiber(function(script_util)
        local g_Private_Players_FM_SESSION_Menu_Choice = 1575035
        local g_PauseMenuMissionCreatorData = {
            iBS_PauseMenuFlags = 1574589
        }

        -- FM_SESSION_MENU_CHOICE_JOIN_CLOSED_INVITE_ONLY
        GLOBAL_SET_INT(g_Private_Players_FM_SESSION_Menu_Choice, 11)

        -- bsPauseRequestingTransition, bsPauseMenuRequestingNewSession
        GLOBAL_SET_BITS(g_PauseMenuMissionCreatorData.iBS_PauseMenuFlags, 0, 5)

        script_util:sleep(200)

        GLOBAL_SET_INT(g_PauseMenuMissionCreatorData.iBS_PauseMenuFlags, 0)
    end)
end

local function IS_PLAYER_IN_KOSATKA()
    return INTERIOR.GET_INTERIOR_FROM_ENTITY(PLAYER.PLAYER_PED_ID()) == 281345
end

local function getInputValue(input, min_value, max_value)
    local input_value = input:get_value()

    if input_value < min_value then
        input_value = min_value
    elseif input_value > max_value then
        input_value = max_value
    end

    input:set_value(input_value)
    return input_value
end



local AutoIslandHeistStatus <const> = {
    Disable = 0,
    Freemode = 1,
    InKotsatka = 2,
    RegisterAsCEO = 3,
    IntroScreen = 4,
    HeistPlanningScreen = 5,
    InCoronaScreen = 6,
    InMission = 7,
    MissionEnd = 8,
    Cleanup = 9
}


local AutoIslandHeist = {
    button = 0,
    enable = false,
    status = AutoIslandHeistStatus.Disable,
    spawnLocation = nil,

    menu = {},
    setting = {
        rewardValue = 2000000,
        addRandom = true,
        disableCut = false,
        delay = 1500
    }
}

function AutoIslandHeist.setStatus(eStatus)
    AutoIslandHeist.status = eStatus
end

function AutoIslandHeist.getSpawnLocation()
    return stats.get_int("MPX_SPAWN_LOCATION_SETTING")
end

function AutoIslandHeist.setSpawnLocation(iLocation)
    stats.set_int("MPX_SPAWN_LOCATION_SETTING", iLocation)
end

function AutoIslandHeist.toggleButtonName(toggle)
    if toggle then
        AutoIslandHeist.button:set_text("开启 全自动佩里科岛抢劫")
    else
        AutoIslandHeist.button:set_text("停止 全自动佩里科岛抢劫")
    end
end

function AutoIslandHeist.cleanup()
    if AutoIslandHeist.spawnLocation then
        AutoIslandHeist.setSpawnLocation(AutoIslandHeist.spawnLocation)
    end

    AutoIslandHeist.enable = false
    AutoIslandHeist.status = AutoIslandHeistStatus.Disable
    AutoIslandHeist.toggleButtonName(true)
end

function AutoIslandHeist.notify(text)
    notify("全自动佩里科岛抢劫", text)
end

AutoIslandHeist.menu.rewardValue = menu_automation:add_input_int("主要目标价值 [0 ~ 2550000] (0: 默认价值)")
AutoIslandHeist.menu.rewardValue:set_value(AutoIslandHeist.setting.rewardValue)

AutoIslandHeist.menu.addRandom = menu_automation:add_checkbox("添加随机数 (主要目标价值加上 0~50000 的随机数)")
AutoIslandHeist.menu.addRandom:set_enabled(AutoIslandHeist.setting.addRandom)
menu_automation:add_sameline()
AutoIslandHeist.menu.disableCut = menu_automation:add_checkbox("禁用NPC分红")
AutoIslandHeist.menu.disableCut:set_enabled(AutoIslandHeist.setting.disableCut)

AutoIslandHeist.menu.delay = menu_automation:add_input_int("延迟 [0 ~ 5000] (毫秒, 到达新的状态后的等待时间)")
AutoIslandHeist.menu.delay:set_value(AutoIslandHeist.setting.delay)


AutoIslandHeist.button = menu_automation:add_button("开启 全自动佩里科岛抢劫", function()
    if AutoIslandHeist.enable then
        AutoIslandHeist.enable = false
        return
    end

    if IS_MISSION_CONTROLLER_SCRIPT_RUNNING() then
        return
    end
    if stats.get_int("MPX_IH_SUB_OWNED") <= 0 then
        AutoIslandHeist.notify("你需要拥有虎鲸")
        return
    end

    AutoIslandHeist.setting.rewardValue = getInputValue(AutoIslandHeist.menu.rewardValue, 0, 2550000)
    AutoIslandHeist.setting.addRandom = AutoIslandHeist.menu.addRandom:is_enabled()
    AutoIslandHeist.setting.disableCut = AutoIslandHeist.menu.disableCut:is_enabled()
    AutoIslandHeist.setting.delay = getInputValue(AutoIslandHeist.menu.delay, 0, 5000)

    
    if AutoIslandHeist.setting.rewardValue > 0 then
        -- Add random value
        if AutoIslandHeist.setting.addRandom then
            AutoIslandHeist.setting.rewardValue = AutoIslandHeist.setting.rewardValue +
                math.random(0, 50000)
        end

        -- Calculate estimated reward value
        local estimatedValue = AutoIslandHeist.setting.rewardValue
        if not AutoIslandHeist.setting.disableCut then
            estimatedValue = math.ceil(estimatedValue * 0.88)
        end
        AutoIslandHeist.notify("预计收入: " .. estimatedValue)
    end


    AutoIslandHeist.toggleButtonName(false)
    AutoIslandHeist.enable = true
    AutoIslandHeist.spawnLocation = nil

    AutoIslandHeist.setStatus(AutoIslandHeistStatus.Freemode)
end)


script.register_looped("RS_Missions.AutoIslandHeist", function(script_util)
    if AutoIslandHeist.status == AutoIslandHeistStatus.Disable then
        return
    end

    if not AutoIslandHeist.enable then
        AutoIslandHeist.cleanup()
        AutoIslandHeist.notify("已停止...")
        return
    end

    local setting = AutoIslandHeist.setting
    local eStatus = AutoIslandHeist.status

    if eStatus == AutoIslandHeistStatus.Freemode then
        if not IS_PLAYER_IN_KOSATKA() then
            AutoIslandHeist.spawnLocation = AutoIslandHeist.getSpawnLocation()
            AutoIslandHeist.setSpawnLocation(16) -- MP_SETTING_SPAWN_SUBMARINE
            JOIN_INVITE_ONLY_SESSION()

            AutoIslandHeist.notify("切换战局到虎鲸...")
        end
        AutoIslandHeist.setStatus(AutoIslandHeistStatus.InKotsatka)
    elseif eStatus == AutoIslandHeistStatus.InKotsatka then
        if IS_IN_SESSION() then
            if IS_PLAYER_IN_KOSATKA() then
                script_util:sleep(setting.delay)

                if not IS_PLAYER_BOSS_OF_A_GANG() then
                    REGISTER_AS_A_CEO()

                    AutoIslandHeist.notify("注册为CEO...")
                    AutoIslandHeist.setStatus(AutoIslandHeistStatus.RegisterAsCEO)
                else
                    local Data = {
                        iRootContentID = -1172878953, -- HIM_STUB
                        iMissionType = 260,           -- FMMC_TYPE_HEIST_ISLAND_FINALE
                        iMissionEnteryType = 67,      -- ciMISSION_ENTERY_TYPE_HEIST_ISLAND_TABLE
                    }
                    LAUNCH_MISSION(Data)

                    AutoIslandHeist.notify("启动差事...")
                    AutoIslandHeist.setStatus(AutoIslandHeistStatus.IntroScreen)
                end
            end
        end
    elseif eStatus == AutoIslandHeistStatus.RegisterAsCEO then
        if IS_PLAYER_BOSS_OF_A_GANG() then
            script_util:sleep(setting.delay)

            AutoIslandHeist.setStatus(AutoIslandHeistStatus.InKotsatka)
        end
    elseif eStatus == AutoIslandHeistStatus.IntroScreen then
        local script_name = "fmmc_launcher"
        if IS_SCRIPT_RUNNING(script_name) then
            -- FM_MISSION_INTRO_SCREEN_MAINTAIN
            if LOCAL_GET_INT(script_name, sLaunchMissionDetails2.iIntroStatus) == 3 then
                script_util:sleep(setting.delay)

                LOCAL_SET_INT(script_name, sLaunchMissionDetails2.iMaxParticipants, 1)

                AutoIslandHeist.notify("开始游戏...")
                AutoIslandHeist.setStatus(AutoIslandHeistStatus.HeistPlanningScreen)
            end
        end
    elseif eStatus == AutoIslandHeistStatus.HeistPlanningScreen then
        if IS_SCRIPT_RUNNING("heist_island_planning") then
            local script_name = "fmmc_launcher"
            if IS_SCRIPT_RUNNING(script_name) then
                -- FM_MISSION_LOAD_IN_CORONA_SCENE_COMPLETE
                if LOCAL_GET_INT(script_name, sLaunchMissionDetails2.iLoadStatus) == 2 then
                    script_util:sleep(setting.delay)


                    local sConfig = GlobalPlayerBD_HeistIsland.sConfig()

                    local Data = {
                        bHardModeEnabled = false,
                        eApproachVehicle = 6,
                        eInfiltrationPoint = 3,
                        eCompoundEntrance = 0,
                        eEscapePoint = 1,
                        eTimeOfDay = 1,
                        eWeaponLoadout = 1,
                        bUseSuppressors = true
                    }
                    GLOBAL_SET_INT(sConfig + 35, Data.eWeaponLoadout)
                    GLOBAL_SET_BOOL(sConfig + 38, Data.bHardModeEnabled)
                    GLOBAL_SET_INT(FMMC_STRUCT.iDifficulity, 1)

                    GLOBAL_SET_INT(sConfig + 39, Data.eApproachVehicle)
                    GLOBAL_SET_INT(sConfig + 40, Data.eInfiltrationPoint)
                    GLOBAL_SET_INT(sConfig + 41, Data.eCompoundEntrance)
                    GLOBAL_SET_INT(sConfig + 42, Data.eEscapePoint)
                    GLOBAL_SET_INT(sConfig + 43, Data.eTimeOfDay)
                    GLOBAL_SET_BOOL(sConfig + 44, Data.bUseSuppressors)

                    GLOBAL_SET_INT(GlobalPlayerBD_NetHeistPlanningGeneric.stFinaleLaunchTimer() + 1, 1)
                    GLOBAL_SET_INT(GlobalPlayerBD_NetHeistPlanningGeneric.stFinaleLaunchTimer(), 0)

                    AutoIslandHeist.notify("设置面板并继续...")
                    AutoIslandHeist.setStatus(AutoIslandHeistStatus.InCoronaScreen)
                end
            end
        end
    elseif eStatus == AutoIslandHeistStatus.InCoronaScreen then
        if IS_SCRIPT_RUNNING("heist_island_planning") then
            local script_name = "fmmc_launcher"
            if IS_SCRIPT_RUNNING(script_name) then
                -- FM_MISSION_IN_CORONA_SCREEN_MAINTAIN
                if LOCAL_GET_INT(script_name, sLaunchMissionDetails2.iInCoronaStatus) == 4 then
                    script_util:sleep(setting.delay)

                    -- ciCORONA_LOBBY_START_GAME
                    LOCAL_SET_INT(script_name, coronaMenuData.iCurrentSelection, 14)

                    -- FRONTEND_CONTROL, INPUT_FRONTEND_ACCEPT
                    PAD.SET_CONTROL_VALUE_NEXT_FRAME(2, 201, 1.0)

                    AutoIslandHeist.notify("准备就绪，进入任务...")
                    AutoIslandHeist.setStatus(AutoIslandHeistStatus.InMission)
                end
            end
        end
    elseif eStatus == AutoIslandHeistStatus.InMission then
        if IS_IN_SESSION() then
            if IS_SCRIPT_RUNNING("fm_mission_controller_2020") then
                script_util:sleep(setting.delay + 3000)

                if setting.rewardValue > 0 then
                    local rewardValue = setting.rewardValue
                    GLOBAL_SET_INT(Tunables["IH_PRIMARY_TARGET_VALUE_TEQUILA"], rewardValue)
                    GLOBAL_SET_INT(Tunables["IH_PRIMARY_TARGET_VALUE_PEARL_NECKLACE"], rewardValue)
                    GLOBAL_SET_INT(Tunables["IH_PRIMARY_TARGET_VALUE_BEARER_BONDS"], rewardValue)
                    GLOBAL_SET_INT(Tunables["IH_PRIMARY_TARGET_VALUE_PINK_DIAMOND"], rewardValue)
                    GLOBAL_SET_INT(Tunables["IH_PRIMARY_TARGET_VALUE_MADRAZO_FILES"], rewardValue)
                    GLOBAL_SET_INT(Tunables["IH_PRIMARY_TARGET_VALUE_SAPPHIRE_PANTHER_STATUE"], rewardValue)
                end
                if setting.disableCut then
                    GLOBAL_SET_FLOAT(Tunables["IH_DEDUCTION_FENCING_FEE"], 0)
                    GLOBAL_SET_FLOAT(Tunables["IH_DEDUCTION_PAVEL_CUT"], 0)
                end
                INSTANT_FINISH_FM_MISSION_CONTROLLER()

                GLOBAL_SET_BOOL(bTransitionSessionSkipLbAndNjvs, true)

                AutoIslandHeist.notify("直接完成任务...")
                AutoIslandHeist.setStatus(AutoIslandHeistStatus.MissionEnd)
            end
        end
    elseif eStatus == AutoIslandHeistStatus.MissionEnd then
        if not IS_SCRIPT_RUNNING("fm_mission_controller_2020") then
            AutoIslandHeist.notify("任务已完成...")
            AutoIslandHeist.setStatus(AutoIslandHeistStatus.Cleanup)
        end
    elseif eStatus == AutoIslandHeistStatus.Cleanup then
        AutoIslandHeist.cleanup()
        AutoIslandHeist.notify("结束...")
        return false
    end
end)






--------------------------------
-- Loop Script
--------------------------------

script.register_looped("RS_Missions.Main", function()
    if MenuHMission["SetMinPlayers"]:is_enabled() then
        local script = "fmmc_launcher"
        if IS_SCRIPT_RUNNING(script) then
            local iArrayPos = LOCAL_GET_INT(script, LaunchMissionDetails.iMissionVariation)
            if iArrayPos > 0 then
                if GLOBAL_GET_INT(FMMC_ROCKSTAR_CREATED.sMissionHeaderVars + iArrayPos * 89 + 69) > 1 then
                    GLOBAL_SET_INT(FMMC_ROCKSTAR_CREATED.sMissionHeaderVars + iArrayPos * 89 + 69, 1)
                    LOCAL_SET_INT(script, LaunchMissionDetails.iMinPlayers, 1)
                end

                GLOBAL_SET_INT(FMMC_STRUCT.iMinNumParticipants, 1)
                GLOBAL_SET_INT(FMMC_STRUCT.iNumPlayersPerTeam, 1)
                GLOBAL_SET_INT(FMMC_STRUCT.iCriticalMinimumForTeam, 0)
            end
        end
    end

    if MenuHMission["SetMaxTeams"]:is_enabled() then
        GLOBAL_SET_INT(FMMC_STRUCT.iNumberOfTeams, 1)
        GLOBAL_SET_INT(FMMC_STRUCT.iMaxNumberOfTeams, 1)
    end

    if MenuHMission["DisableMissionAggroFail"]:is_enabled() then
        local mission_script = GET_RUNNING_MISSION_CONTROLLER_SCRIPT()
        if mission_script ~= nil then
            REQUEST_FMMC_SCRIPT_HOST(mission_script)
            LOCAL_CLEAR_BITS(mission_script, Locals[mission_script].iServerBitSet1, 24, 28)
        end
    end

    if MenuHMission["DisableMissionFail"]:is_enabled() then
        local mission_script = GET_RUNNING_MISSION_CONTROLLER_SCRIPT()
        if mission_script ~= nil then
            REQUEST_FMMC_SCRIPT_HOST(mission_script)
            LOCAL_SET_BIT(mission_script, Locals[mission_script].iLocalBoolCheck11, 7)
        end
    end
end)

script.register_looped("RS_Missions.Mission_Earning", function()
    local earning_max = MenuHMission["MissionEarningHigh"]:get_value()
    local earning_min = MenuHMission["MissionEarningLow"]:get_value()

    if earning_max < 0 then
        MenuHMission["MissionEarningHigh"]:set_value(0)
    elseif earning_max > 15000000 then
        MenuHMission["MissionEarningHigh"]:set_value(15000000)
    end

    if earning_min < 0 then
        MenuHMission["MissionEarningLow"]:set_value(0)
    elseif earning_min > 15000000 then
        MenuHMission["MissionEarningLow"]:set_value(15000000)
    end

    if MenuHMission["MissionEarningModifier"]:is_enabled() then
        if earning_max ~= 0 then
            GLOBAL_SET_FLOAT(Tunables["HIGH_ROCKSTAR_MISSIONS_MODIFIER"], earning_max)
        end
        if earning_min ~= 0 then
            GLOBAL_SET_FLOAT(Tunables["LOW_ROCKSTAR_MISSIONS_MODIFIER"], earning_min)
        end
    end
end)
