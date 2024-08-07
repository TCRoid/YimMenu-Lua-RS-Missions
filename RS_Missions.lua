--------------------------------
-- Author: Rostal
--------------------------------

local SUPPORT_GAME_VERSION <const> = "1.69-3274"



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

function GLOBAL_GET_VECTOR3(global)
    return globals.get_vec3(global)
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

function LOCAL_GET_BOOL(script_name, script_local)
    return locals.get_int(script_name, script_local) == 1
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

--------------------------------
-- Online Functions
--------------------------------

function IS_IN_SESSION()
    return NETWORK.NETWORK_IS_SESSION_STARTED() and not IS_SCRIPT_RUNNING("maintransition")
end

--------------------------------
-- Misc Functions
--------------------------------

function IS_PLAYER_IN_KOSATKA()
    return INTERIOR.GET_INTERIOR_FROM_ENTITY(PLAYER.PLAYER_PED_ID()) == 281345
end

function IS_THIS_HELP_MESSAGE_BEING_DISPLAYED(textLabel)
    HUD.BEGIN_TEXT_COMMAND_IS_THIS_HELP_MESSAGE_BEING_DISPLAYED(textLabel)
    return HUD.END_TEXT_COMMAND_IS_THIS_HELP_MESSAGE_BEING_DISPLAYED(0) -- HELP_TEXT_SLOT_STANDARD
end

function IS_PLAYER_IN_APARTMENT_PLANNING_ROOM()
    if HUD.IS_HELP_MESSAGE_BEING_DISPLAYED() then
        if IS_THIS_HELP_MESSAGE_BEING_DISPLAYED("HEIST_PRE_DONE2") or IS_THIS_HELP_MESSAGE_BEING_DISPLAYED("HEIST_STR_BG2") or IS_THIS_HELP_MESSAGE_BEING_DISPLAYED("HEIST_PRE_VIEW2") then
            return true
        end
    end
    return false
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
local _g_TransitionSessionNonResetVars <const> = 2685444
-- TRANSITION_SESSION_MAINTAIN_VARS
local _sTransVars <const> = _g_TransitionSessionNonResetVars + 1

local g_TransitionSessionNonResetVars <const> = {
    sTransVars = {
        iCoronaBitSet = _sTransVars + 2813
    },

    bAmIHeistLeader = _g_TransitionSessionNonResetVars + 6381
}


-- FMMC_TRANSITION_SESSION_DATA
local g_sTransitionSessionData <const> = 2684504

-- FMMC_STRAND_MISSION_DATA
local _sStrandMissionData <const> = g_sTransitionSessionData + 43
local sStrandMissionData <const> = {
    bPassedFirstMission = _sStrandMissionData + 55,
    bPassedFirstStrandNoReset = _sStrandMissionData + 56,
    bIsThisAStrandMission = _sStrandMissionData + 57,
    bLastMission = _sStrandMissionData + 58
}


-- HEIST_CLIENT_PLANNING_LOCAL_DATA
local _g_HeistPlanningClient <const> = 1930926
local g_HeistPlanningClient <const> = {
    bHeistCoronaActive = _g_HeistPlanningClient + 2816
}

-- HEIST_CLIENT_SHARED_LOCAL_DATA
local _g_HeistSharedClient <const> = 1934536
local g_HeistSharedClient <const> = {
    PlanningBoardIndex = _g_HeistSharedClient,
    vBoardPosition = _g_HeistSharedClient + 16
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
        return 1972760 + 1 + PLAYER.PLAYER_ID() * 27 + 18
    end
}


------------------------
-- Locals
------------------------

local Locals <const> = {
    ["fm_mission_controller"] = {
        iNextMission = 19746 + 1062,
        iTeamScore = 19746 + 1232 + 1, -- +[0~3]

        iServerGameState = 19746,
        iServerBitSet = 19746 + 1,
        iServerBitSet1 = 19746 + 2,

        iClientBitSet = function()
            return 31621 + 1 + NETWORK.PARTICIPANT_ID_TO_INT() * 292 + 127
        end,

        iLocalBoolCheck11 = 15166,

        tdObjectiveLimitTimer = 26172 + 740 + 1,      -- +[0~3]*2
        tdMultiObjectiveLimitTimer = 26172 + 749 + 1, -- +[0~3]*2
        iMultiObjectiveTimeLimit = 26172 + 765 + 1    -- +[0~3]
    },
    ["fm_mission_controller_2020"] = {
        iNextMission = 50150 + 1583,
        iTeamScore = 50150 + 1770 + 1, -- +[0~3]

        iServerGameState = 50150,
        iServerBitSet = 50150 + 1,
        iServerBitSet1 = 50150 + 2,

        iLocalBoolCheck11 = 48799,

        tdObjectiveLimitTimer = 56798 + 297 + 1,      -- +[0~3]*2
        tdMultiObjectiveLimitTimer = 56798 + 306 + 1, -- +[0~3]*2
        iMultiObjectiveTimeLimit = 56798 + 322 + 1    -- +[0~3]
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
local _sLaunchMissionDetails <const> = 19709
local sLaunchMissionDetails <const> = {
    iMinPlayers = _sLaunchMissionDetails + 15,
    iMaxParticipants = _sLaunchMissionDetails + 32,
    iMissionVariation = _sLaunchMissionDetails + 34
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
    ["DISABLE_STAT_CAP_CHECK"]                          = g_sMPTunables + 158,

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
    local iArrayPos = MISC.GET_CONTENT_ID_INDEX(Data.iRootContentID)

    local tlName = GLOBAL_GET_STRING(FMMC_ROCKSTAR_CREATED.sMissionHeaderVars + iArrayPos * 89)
    local iMaxPlayers = GLOBAL_GET_INT(FMMC_ROCKSTAR_CREATED.sMissionHeaderVars + iArrayPos * 89 + 71)

    GLOBAL_SET_INT(_g_TransitionSessionNonResetVars + 3850, 1)
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

-- g_structLocalHeistControl
local g_sLocalMPHeistControl = {
    _ = 2635126,
    _lhcMyCorona = 2635126 + 3,
}

-- g_structMyHeistCorona
g_sLocalMPHeistControl.lhcMyCorona = {
    mhcAvailable = g_sLocalMPHeistControl._lhcMyCorona,
    mhcContentID = g_sLocalMPHeistControl._lhcMyCorona + 1,
    mhcIsFinale = g_sLocalMPHeistControl._lhcMyCorona + 7,
    mhcIsIntroCutscene = g_sLocalMPHeistControl._lhcMyCorona + 8,
    mhcIsMidStrandCutscene = g_sLocalMPHeistControl._lhcMyCorona + 9,
    mhcMatcID = g_sLocalMPHeistControl._lhcMyCorona + 10,
    mhcInCorona = g_sLocalMPHeistControl._lhcMyCorona + 11,
    mhcAlreadyTransitioned = g_sLocalMPHeistControl._lhcMyCorona + 12,
    mhcIsTutorialHeist = g_sLocalMPHeistControl._lhcMyCorona + 13,
}

local function LAUNCH_APARTMENT_HEIST(ContentID)
    GLOBAL_SET_BOOL(g_sLocalMPHeistControl.lhcMyCorona.mhcAvailable, true)
    GLOBAL_SET_STRING(g_sLocalMPHeistControl.lhcMyCorona.mhcContentID, ContentID)
    GLOBAL_SET_BOOL(g_sLocalMPHeistControl.lhcMyCorona.mhcIsFinale, true)
    GLOBAL_SET_BOOL(g_sLocalMPHeistControl.lhcMyCorona.mhcIsIntroCutscene, false)
    GLOBAL_SET_BOOL(g_sLocalMPHeistControl.lhcMyCorona.mhcIsMidStrandCutscene, false)
    GLOBAL_SET_INT(g_sLocalMPHeistControl.lhcMyCorona.mhcMatcID, -1) -- ILLEGAL_AT_COORDS_ID
    GLOBAL_SET_BOOL(g_sLocalMPHeistControl.lhcMyCorona.mhcInCorona, false)
    GLOBAL_SET_BOOL(g_sLocalMPHeistControl.lhcMyCorona.mhcAlreadyTransitioned, false)
    GLOBAL_SET_BOOL(g_sLocalMPHeistControl.lhcMyCorona.mhcIsTutorialHeist, false)

    GLOBAL_SET_BOOL(g_HeistPlanningClient.bHeistCoronaActive, true)
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

-- `fm_mission_controller` and `fm_mission_controller_2020`
local FM_MISSION_CONTROLLER = {}

function FM_MISSION_CONTROLLER.IS_SCRIPT_HOST(script_name)
    return NETWORK.NETWORK_GET_HOST_OF_SCRIPT(script_name, 0, 0) == PLAYER.PLAYER_ID()
end

function FM_MISSION_CONTROLLER.REQUEST_SCRIPT_HOST(script_name, script_util)
    if FM_MISSION_CONTROLLER.IS_SCRIPT_HOST(script_name) then
        return true
    end

    network.force_script_host(script_name)

    local timeout = 2
    local start_time = os.time()

    while not FM_MISSION_CONTROLLER.IS_SCRIPT_HOST(script_name) do
        if os.time() - start_time > timeout then
            break
        end
        network.force_script_host(script_name)
        script_util:yield()
    end

    return FM_MISSION_CONTROLLER.IS_SCRIPT_HOST(script_name)
end

function FM_MISSION_CONTROLLER.RUN(func)
    script.run_in_fiber(function(script_util)
        local mission_script = GET_RUNNING_MISSION_CONTROLLER_SCRIPT()
        if mission_script == nil then return end

        if not FM_MISSION_CONTROLLER.REQUEST_SCRIPT_HOST(mission_script, script_util) then
            return
        end

        script.execute_as_script(mission_script, function()
            func(mission_script)
        end)
    end)
end

function FM_MISSION_CONTROLLER.INSTANT_FINISH(script_name)
    for i = 0, 5 do
        local tl23NextContentID = GLOBAL_GET_STRING(FMMC_STRUCT.tl23NextContentID + i * 6)
        if tl23NextContentID ~= "" then
            GLOBAL_SET_STRING(FMMC_STRUCT.tl23NextContentID + i * 6, "")
        end
    end

    LOCAL_SET_INT(script_name, Locals[script_name].iNextMission, 5)

    if GLOBAL_GET_BOOL(sStrandMissionData.bIsThisAStrandMission) then
        GLOBAL_SET_BOOL(sStrandMissionData.bPassedFirstMission, true)
        GLOBAL_SET_BOOL(sStrandMissionData.bPassedFirstStrandNoReset, true)
        GLOBAL_SET_BOOL(sStrandMissionData.bLastMission, true)
    end

    LOCAL_SET_BIT(script_name, Locals[script_name].iLocalBoolCheck11, 7)

    for i = 0, 3 do
        LOCAL_SET_INT(script_name, Locals[script_name].iTeamScore + i, 999999)
    end

    LOCAL_SET_BITS(script_name, Locals[script_name].iServerBitSet, 9, 10, 11, 12, 16)
end

local function IS_PLAYER_NEAR_HEIST_PLANNING_BOARD()
    if GLOBAL_GET_INT(g_HeistSharedClient.PlanningBoardIndex) == 0 then
        return false
    end

    local playerPos = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID())
    local boardPos = GLOBAL_GET_VECTOR3(g_HeistSharedClient.vBoardPosition)

    return MISC.GET_DISTANCE_BETWEEN_COORDS(playerPos.x, playerPos.y, playerPos.z,
        boardPos.x, boardPos.y, boardPos.z, true) < 3.5 -- HEIST_CUTSCENE_TRIGGER_m
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
    },

    HeistAwardsStats = {
        -- ProgressBitset, AwardBool
        [1] = { "MPPLY_HEISTFLOWORDERPROGRESS", "MPPLY_AWD_HST_ORDER" },
        [2] = { "MPPLY_HEISTTEAMPROGRESSBITSET", "MPPLY_AWD_HST_SAME_TEAM" },
        [3] = { "MPPLY_HEISTNODEATHPROGREITSET", "MPPLY_AWD_HST_ULT_CHAL" },
        [4] = { "MPPLY_HEIST_1STPERSON_PROG", "MPPLY_AWD_COMPLET_HEIST_1STPER" },
        [5] = { "MPPLY_HEISTMEMBERPROGRESSBITSET", "MPPLY_AWD_COMPLET_HEIST_MEM" }
    },
}



----------------------------------------
-- Menu: Main
----------------------------------------

local menu_root <const> = gui.add_tab("RS Missions")

script.run_in_fiber(function()
    local build_version = memory.scan_pattern("8B C3 33 D2 C6 44 24 20"):add(0x24):rip()
    local online_version = build_version:add(0x20)
    local CURRENT_GAME_VERSION <const> = string.format("%s-%s", online_version:get_string(), build_version:get_string())


    menu_root:add_text("支持的GTA版本: " .. SUPPORT_GAME_VERSION)
    menu_root:add_text("当前的GTA版本: " .. CURRENT_GAME_VERSION)

    local status_text = "支持"
    if SUPPORT_GAME_VERSION ~= CURRENT_GAME_VERSION then
        status_text = "不支持当前游戏版本, 请停止使用"
    end
    menu_root:add_text("状态: " .. status_text)
end)



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
    FM_MISSION_CONTROLLER.RUN(function(script_name)
        FM_MISSION_CONTROLLER.INSTANT_FINISH(script_name)
    end)
end)
menu_mission:add_sameline()
menu_mission:add_button("跳到下一个检查点 (解决单人任务卡关问题)", function()
    FM_MISSION_CONTROLLER.RUN(function(mission_script)
        LOCAL_SET_BIT(mission_script, Locals[mission_script].iServerBitSet1, 17)
    end)
end)

MenuHMission["DisableMissionAggroFail"] = menu_mission:add_checkbox("禁止因触发惊动而任务失败")
menu_mission:add_sameline()
MenuHMission["DisableMissionFail"] = menu_mission:add_checkbox("禁止任务失败 (仅单人可用)")
menu_mission:add_sameline()
menu_mission:add_button("允许任务失败", function()
    MenuHMission["DisableMissionFail"]:set_enabled(false)

    FM_MISSION_CONTROLLER.RUN(function(mission_script)
        LOCAL_CLEAR_BIT(mission_script, Locals[mission_script].iLocalBoolCheck11, 7)
    end)
end)

MenuHMission["ObjectiveTimeLimit"] = menu_mission:add_input_int("任务剩余时间")
menu_mission:add_button("设置任务剩余时间", function()
    local value = MenuHMission["ObjectiveTimeLimit"]:get_value()
    if value < 0 then
        value = 0
    elseif value > 9999 then
        value = 9999
    end
    MenuHMission["ObjectiveTimeLimit"]:set_value(value)

    FM_MISSION_CONTROLLER.RUN(function(mission_script)
        local team = PLAYER.GET_PLAYER_TEAM(PLAYER.PLAYER_ID())

        LOCAL_SET_INT(mission_script, Locals[mission_script].iMultiObjectiveTimeLimit + team, value * 60 * 1000)
    end)
end)
menu_mission:add_sameline()
menu_mission:add_text("(单位: 分钟, 右下角的剩余时间倒计时)")
menu_mission:add_sameline()
MenuHMission["LockObjectiveLimitTimer"] = menu_mission:add_checkbox("锁定任务剩余时间")



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
    notify("启动差事", "请稍等...")
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
    notify("启动差事", "请稍等...")
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
    notify("启动差事", "请稍等...")
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
    if not IS_PLAYER_IN_KOSATKA() then
        notify("启动差事", "你需要在虎鲸内部")
        return
    end


    local Data = {
        iRootContentID = -1172878953, -- Tunable: H4_ROOT_CONTENT_ID_0
        iMissionType = 260,           -- FMMC_TYPE_HEIST_ISLAND_FINALE
        iMissionEnteryType = 67,      -- ciMISSION_ENTERY_TYPE_HEIST_ISLAND_TABLE
    }

    LAUNCH_MISSION(Data)
    notify("启动差事", "请稍等...")
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


local apartment_heist_final_select = 0
menu_mission:add_imgui(function()
    apartment_heist_final_select, clicked = ImGui.Combo("选择公寓抢劫任务", apartment_heist_final_select, {
        "全福银行差事", "越狱", "突袭人道研究实验室", "首轮募资", "太平洋标准银行差事"
    }, 5)
end)
menu_mission:add_button("启动差事: 公寓抢劫任务 终章", function()
    if IS_MISSION_CONTROLLER_SCRIPT_RUNNING() then
        return
    end

    local apartment_heist_final_content = {
        [0] = "_T5Vz_ZV2kiIdfzRP3fJYQ",
        [1] = "ISSREsbrtUGrxSiLmlUCRA",
        [2] = "82ihljX03UO9tTUoLbukSQ",
        [3] = "qr5DtZrmrkGad_9pemY39g",
        [4] = "tYc3SkqXTk6ia7j0lezrbQ"
    }

    if not INTERIOR.IS_INTERIOR_SCENE() then
        notify("启动差事", "你需要在公寓内部")
        return
    end
    if not IS_PLAYER_NEAR_HEIST_PLANNING_BOARD() then
        notify("启动差事", "你需要在抢劫计划面板附近")
        return
    end

    local ContentID = apartment_heist_final_content[apartment_heist_final_select]
    LAUNCH_APARTMENT_HEIST(ContentID)
    notify("启动差事", "请稍等...")
end)
menu_mission:add_sameline()
menu_mission:add_button("跳过动画 (点击 开始游戏 之前使用)", function()
    GLOBAL_SET_BIT(g_TransitionSessionNonResetVars.sTransVars.iCoronaBitSet + 1 + 4, 0)   -- CORONA_HEIST_CUTSCENE_HAS_BEEN_VALIDATED
    GLOBAL_CLEAR_BIT(g_TransitionSessionNonResetVars.sTransVars.iCoronaBitSet + 1 + 4, 1) -- CORONA_HEIST_FINALE_CUTSCENE_CAN_PLAY
end)
menu_mission:add_text("要求: 1. 需要在公寓内部 抢劫计划面板附近; 2. 启动差事后右下角没有提示下载，就动两下")

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
    notify("启动差事", "请稍等...")
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
    notify("启动差事", "请稍等...")
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
    notify("启动差事", "请稍等...")
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

local function getInputValue(input, min_value, max_value)
    local input_value = input:get_value()

    if input_value < min_value then
        input:set_value(min_value)
        return min_value
    end

    if input_value > max_value then
        input:set_value(max_value)
        return max_value
    end

    return input_value
end




local bTransitionSessionSkipLbAndNjvs = g_sTransitionSessionData + 702

local _coronaMenuData = 17445
local coronaMenuData = {
    iCurrentSelection = _coronaMenuData + 911
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





g_HeistPlanningClient.bLaunchTimerExpired = 1930926 + 2812



local CORONA_STATUS_ENUM = {
    CORONA_STATUS_IDLE = 0,
    CORONA_STATUS_INTRO = 9,
    CORONA_STATUS_TEAM_DM = 26,
    CORONA_STATUS_HEIST_PLANNING = 27,
    CORONA_STATUS_GENERIC_HEIST_PLANNING = 34
}

local function GET_CORONA_STATUS()
    return GLOBAL_GET_INT(Globals.GlobalplayerBD_FM() + 193)
end

local function IS_PLAYER_IN_CORONA()
    return GLOBAL_GET_INT(Globals.GlobalplayerBD_FM() + 193) ~= CORONA_STATUS_ENUM.CORONA_STATUS_IDLE
end



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


local AutoIslandHeistStatus <const> = {
    Disable = 0,
    Freemode = 1,
    InKotsatka = 2,
    RegisterAsCEO = 3,
    CoronaIntro = 4,
    CoronaHeistPlanning = 5,
    CoronaTeamDM = 6,
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

AutoIslandHeist.menu.delay = menu_automation:add_input_int("延迟1 [0 ~ 5000] (毫秒, 到达新的状态后的等待时间)")
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
                    AutoIslandHeist.setStatus(AutoIslandHeistStatus.CoronaIntro)
                end
            end
        end
    elseif eStatus == AutoIslandHeistStatus.RegisterAsCEO then
        if IS_PLAYER_BOSS_OF_A_GANG() then
            script_util:sleep(setting.delay)

            AutoIslandHeist.setStatus(AutoIslandHeistStatus.InKotsatka)
        end
    elseif eStatus == AutoIslandHeistStatus.CoronaIntro then
        local script_name = "fmmc_launcher"
        if IS_SCRIPT_RUNNING(script_name) then
            if GET_CORONA_STATUS() == CORONA_STATUS_ENUM.CORONA_STATUS_INTRO then
                script_util:sleep(setting.delay)

                LOCAL_SET_INT(script_name, sLaunchMissionDetails.iMaxParticipants, 1)

                AutoIslandHeist.notify("开始游戏...")
                AutoIslandHeist.setStatus(AutoIslandHeistStatus.CoronaHeistPlanning)
            end
        end
    elseif eStatus == AutoIslandHeistStatus.CoronaHeistPlanning then
        if IS_SCRIPT_RUNNING("heist_island_planning") then
            local script_name = "fmmc_launcher"
            if IS_SCRIPT_RUNNING(script_name) then
                if GET_CORONA_STATUS() == CORONA_STATUS_ENUM.CORONA_STATUS_GENERIC_HEIST_PLANNING then
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
                    AutoIslandHeist.setStatus(AutoIslandHeistStatus.CoronaTeamDM)
                end
            end
        end
    elseif eStatus == AutoIslandHeistStatus.CoronaTeamDM then
        local script_name = "fmmc_launcher"
        if IS_SCRIPT_RUNNING(script_name) then
            if GET_CORONA_STATUS() == CORONA_STATUS_ENUM.CORONA_STATUS_TEAM_DM then
                script_util:sleep(setting.delay)

                -- ciCORONA_LOBBY_START_GAME
                LOCAL_SET_INT(script_name, coronaMenuData.iCurrentSelection, 14)

                -- FRONTEND_CONTROL, INPUT_FRONTEND_ACCEPT
                PAD.SET_CONTROL_VALUE_NEXT_FRAME(2, 201, 1.0)

                AutoIslandHeist.notify("准备就绪，进入任务...")
                AutoIslandHeist.setStatus(AutoIslandHeistStatus.InMission)
            end
        end
    elseif eStatus == AutoIslandHeistStatus.InMission then
        if IS_IN_SESSION() then
            local script_name = "fm_mission_controller_2020"
            if IS_SCRIPT_RUNNING(script_name) then
                -- GAME_STATE_RUNNING
                if LOCAL_GET_INT(script_name, Locals[script_name].iServerGameState) == 6 then
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
                    FM_MISSION_CONTROLLER.INSTANT_FINISH(script_name)

                    GLOBAL_SET_BOOL(bTransitionSessionSkipLbAndNjvs, true)

                    AutoIslandHeist.notify("直接完成任务...")
                    AutoIslandHeist.setStatus(AutoIslandHeistStatus.MissionEnd)
                end
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




menu_automation:add_separator()




--------------------------------
-- Auto Apartment Heist
--------------------------------

menu_automation:add_text("<<  全自动公寓抢劫  >>")

menu_automation:add_text("*仅适用于单人*")
menu_automation:add_text("同时完成所有奖章挑战, 可获得1400多万")
menu_automation:add_text("要求: 1. 需要在公寓内部 抢劫计划面板附近; 2. 启动差事后右下角没有提示下载，就动两下; 3. 如果精英挑战没有完成就增加延迟")


local AutoApartmentHeistStatus <const> = {
    Disable = 0,
    InPlanningRoom = 1,
    CoronaIntro = 2,
    CoronaHeistPlanning = 3,
    CoronaTeamDM = 4,
    InMission = 5,
    MissionEnd = 6,
    Cleanup = 7
}


local AutoApartmentHeist = {
    button = 0,
    enable = false,
    status = AutoApartmentHeistStatus.Disable,

    minPlayers = false,
    maxTeams = false,

    menu = {},
    setting = {
        delay = 1500
    }
}

function AutoApartmentHeist.processHeistAward()
    for _, item in pairs(Tables.HeistAwardsStats) do
        stats.set_int(item[1], 268435455)
        stats.set_bool(item[2], false)
    end


    local script_name = "fm_mission_controller"

    -- Ultimate Challenge
    GLOBAL_SET_INT(FMMC_STRUCT.iDifficulity, 2)
    -- First Person
    GLOBAL_SET_INT(FMMC_STRUCT.iFixedCamera, 1)
    -- Member
    GLOBAL_SET_BOOL(g_TransitionSessionNonResetVars.bAmIHeistLeader, false)
    LOCAL_CLEAR_BIT(script_name, Locals[script_name].iClientBitSet(), 20) -- PBBOOL_HEIST_HOST
end

function AutoApartmentHeist.setStatus(eStatus)
    AutoApartmentHeist.status = eStatus
end

function AutoApartmentHeist.toggleButtonName(toggle)
    if toggle then
        AutoApartmentHeist.button:set_text("开启 全自动公寓抢劫")
    else
        AutoApartmentHeist.button:set_text("停止 全自动公寓抢劫")
    end
end

function AutoApartmentHeist.cleanup()
    MenuHMission["SetMinPlayers"]:set_enabled(AutoApartmentHeist.minPlayers)
    MenuHMission["SetMaxTeams"]:set_enabled(AutoApartmentHeist.maxTeams)

    AutoApartmentHeist.enable = false
    AutoApartmentHeist.status = AutoApartmentHeistStatus.Disable
    AutoApartmentHeist.toggleButtonName(true)
end

function AutoApartmentHeist.notify(text)
    notify("全自动公寓抢劫", text)
end

AutoApartmentHeist.menu.delay = menu_automation:add_input_int("延迟2 [0 ~ 5000] (毫秒, 到达新的状态后的等待时间)")
AutoApartmentHeist.menu.delay:set_value(AutoApartmentHeist.setting.delay)


AutoApartmentHeist.button = menu_automation:add_button("开启 全自动公寓抢劫", function()
    if AutoApartmentHeist.enable then
        AutoApartmentHeist.enable = false
        return
    end

    if IS_MISSION_CONTROLLER_SCRIPT_RUNNING() then
        return
    end
    if not INTERIOR.IS_INTERIOR_SCENE() then
        AutoApartmentHeist.notify("你需要在公寓内部")
        return
    end
    if not IS_PLAYER_NEAR_HEIST_PLANNING_BOARD() then
        AutoApartmentHeist.notify("你需要在抢劫计划面板附近")
        return
    end

    AutoApartmentHeist.minPlayers = MenuHMission["SetMinPlayers"]:is_enabled()
    AutoApartmentHeist.maxTeams = MenuHMission["SetMaxTeams"]:is_enabled()

    MenuHMission["SetMinPlayers"]:set_enabled(true)
    MenuHMission["SetMaxTeams"]:set_enabled(true)

    AutoApartmentHeist.setting.delay = getInputValue(AutoApartmentHeist.menu.delay, 0, 5000)

    AutoApartmentHeist.toggleButtonName(false)
    AutoApartmentHeist.enable = true

    AutoApartmentHeist.setStatus(AutoApartmentHeistStatus.InPlanningRoom)
end)
menu_automation:add_sameline()
menu_automation:add_button("清除奖章挑战记录", function()
    for _, item in pairs(Tables.HeistAwardsStats) do
        stats.set_int(item[1], 0)
        stats.set_bool(item[2], false)
    end
    notify("清除奖章挑战记录", "完成")
end)


script.register_looped("RS_Missions.AutoApartmentHeist", function(script_util)
    if AutoApartmentHeist.status == AutoApartmentHeistStatus.Disable then
        return
    end

    if not AutoApartmentHeist.enable then
        AutoApartmentHeist.cleanup()
        AutoApartmentHeist.notify("已停止...")
        return
    end

    local setting = AutoApartmentHeist.setting
    local eStatus = AutoApartmentHeist.status

    if eStatus == AutoApartmentHeistStatus.InPlanningRoom then
        local ContentID = "tYc3SkqXTk6ia7j0lezrbQ"
        LAUNCH_APARTMENT_HEIST(ContentID)

        AutoApartmentHeist.notify("启动差事...")
        AutoApartmentHeist.setStatus(AutoApartmentHeistStatus.CoronaIntro)
    elseif eStatus == AutoApartmentHeistStatus.CoronaIntro then
        local script_name = "fmmc_launcher"
        if IS_SCRIPT_RUNNING(script_name) then
            if GET_CORONA_STATUS() == CORONA_STATUS_ENUM.CORONA_STATUS_INTRO then
                script_util:sleep(setting.delay)

                LOCAL_SET_INT(script_name, sLaunchMissionDetails.iMaxParticipants, 1)

                GLOBAL_SET_BIT(g_TransitionSessionNonResetVars.sTransVars.iCoronaBitSet + 1 + 4, 0)   -- CORONA_HEIST_CUTSCENE_HAS_BEEN_VALIDATED
                GLOBAL_CLEAR_BIT(g_TransitionSessionNonResetVars.sTransVars.iCoronaBitSet + 1 + 4, 1) -- CORONA_HEIST_FINALE_CUTSCENE_CAN_PLAY

                AutoApartmentHeist.notify("开始游戏...")
                AutoApartmentHeist.setStatus(AutoApartmentHeistStatus.CoronaHeistPlanning)
            end
        end
    elseif eStatus == AutoApartmentHeistStatus.CoronaHeistPlanning then
        if GET_CORONA_STATUS() == CORONA_STATUS_ENUM.CORONA_STATUS_HEIST_PLANNING then
            script_util:sleep(setting.delay)

            GLOBAL_SET_BOOL(g_HeistPlanningClient.bLaunchTimerExpired, true)

            AutoApartmentHeist.notify("继续...")
            AutoApartmentHeist.setStatus(AutoApartmentHeistStatus.CoronaTeamDM)
        end
    elseif eStatus == AutoApartmentHeistStatus.CoronaTeamDM then
        local script_name = "fmmc_launcher"
        if IS_SCRIPT_RUNNING(script_name) then
            if GET_CORONA_STATUS() == CORONA_STATUS_ENUM.CORONA_STATUS_TEAM_DM then
                script_util:sleep(setting.delay)

                -- ciCORONA_LOBBY_START_GAME
                LOCAL_SET_INT(script_name, coronaMenuData.iCurrentSelection, 14)

                -- FRONTEND_CONTROL, INPUT_FRONTEND_ACCEPT
                PAD.SET_CONTROL_VALUE_NEXT_FRAME(2, 201, 1.0)

                AutoApartmentHeist.notify("准备就绪，进入任务...")
                AutoApartmentHeist.setStatus(AutoApartmentHeistStatus.InMission)
            end
        end
    elseif eStatus == AutoApartmentHeistStatus.InMission then
        if IS_IN_SESSION() then
            local script_name = "fm_mission_controller"
            if IS_SCRIPT_RUNNING(script_name) then
                -- GAME_STATE_RUNNING
                if LOCAL_GET_INT(script_name, Locals[script_name].iServerGameState) == 9 then
                    script_util:sleep(setting.delay + 1000)

                    AutoApartmentHeist.processHeistAward()
                    FM_MISSION_CONTROLLER.INSTANT_FINISH(script_name)

                    AutoApartmentHeist.notify("直接完成任务...")
                    AutoApartmentHeist.setStatus(AutoApartmentHeistStatus.MissionEnd)
                end
            end
        end
    elseif eStatus == AutoApartmentHeistStatus.MissionEnd then
        if not IS_SCRIPT_RUNNING("fm_mission_controller") then
            AutoApartmentHeist.notify("任务已完成...")
            AutoApartmentHeist.setStatus(AutoApartmentHeistStatus.Cleanup)
        end
    elseif eStatus == AutoApartmentHeistStatus.Cleanup then
        AutoApartmentHeist.cleanup()
        AutoApartmentHeist.notify("结束...")
        return false
    end
end)






----------------------------------------
-- Menu: Misc
----------------------------------------

local menu_misc <const> = menu_root:add_tab("[RSM] 其它")

local MenuMisc = {}

menu_misc:add_text("零食和护甲")
MenuMisc["DisableStatCapCheck"] = menu_misc:add_checkbox("禁用最大携带量限制")
menu_misc:add_sameline()
menu_misc:add_button("零食数量 9999", function()
    local value = 9999
    stats.set_int("MPX_NO_BOUGHT_YUM_SNACKS", value)
    stats.set_int("MPX_NO_BOUGHT_HEALTH_SNACKS", value)
    stats.set_int("MPX_NO_BOUGHT_EPIC_SNACKS", value)
    stats.set_int("MPX_NUMBER_OF_ORANGE_BOUGHT", value)
    stats.set_int("MPX_NUMBER_OF_BOURGE_BOUGHT", value)
    stats.set_int("MPX_NUMBER_OF_CHAMP_BOUGHT", value)
    stats.set_int("MPX_CIGARETTES_BOUGHT", value)
    stats.set_int("MPX_NUMBER_OF_SPRUNK_BOUGHT", value)
    toast("完成！")
end)
menu_misc:add_sameline()
menu_misc:add_button("护甲数量 9999", function()
    local value = 9999
    stats.set_int("MPX_MP_CHAR_ARMOUR_1_COUNT", value)
    stats.set_int("MPX_MP_CHAR_ARMOUR_2_COUNT", value)
    stats.set_int("MPX_MP_CHAR_ARMOUR_3_COUNT", value)
    stats.set_int("MPX_MP_CHAR_ARMOUR_4_COUNT", value)
    stats.set_int("MPX_MP_CHAR_ARMOUR_5_COUNT", value)
    toast("完成！")
end)








--------------------------------
-- Loop Script
--------------------------------

script.register_looped("RS_Missions.Main", function()
    if MenuHMission["SetMinPlayers"]:is_enabled() then
        local script_name = "fmmc_launcher"
        if IS_SCRIPT_RUNNING(script_name) then
            local iArrayPos = LOCAL_GET_INT(script_name, sLaunchMissionDetails.iMissionVariation)
            if iArrayPos > 0 then
                if GLOBAL_GET_INT(FMMC_ROCKSTAR_CREATED.sMissionHeaderVars + iArrayPos * 89 + 69) > 1 then
                    GLOBAL_SET_INT(FMMC_ROCKSTAR_CREATED.sMissionHeaderVars + iArrayPos * 89 + 69, 1)
                    LOCAL_SET_INT(script_name, sLaunchMissionDetails.iMinPlayers, 1)
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
        FM_MISSION_CONTROLLER.RUN(function(mission_script)
            LOCAL_CLEAR_BITS(mission_script, Locals[mission_script].iServerBitSet1, 24, 28)
        end)
    end

    if MenuHMission["DisableMissionFail"]:is_enabled() then
        FM_MISSION_CONTROLLER.RUN(function(mission_script)
            LOCAL_SET_BIT(mission_script, Locals[mission_script].iLocalBoolCheck11, 7)
        end)
    end

    if MenuHMission["LockObjectiveLimitTimer"]:is_enabled() then
        FM_MISSION_CONTROLLER.RUN(function(mission_script)
            local team = PLAYER.GET_PLAYER_TEAM(PLAYER.PLAYER_ID())

            if LOCAL_GET_BOOL(mission_script, Locals[mission_script].tdObjectiveLimitTimer + team * 2 + 1) then
                LOCAL_SET_INT(mission_script, Locals[mission_script].tdObjectiveLimitTimer + team * 2,
                    NETWORK.GET_NETWORK_TIME())
            end
            if LOCAL_GET_BOOL(mission_script, Locals[mission_script].tdMultiObjectiveLimitTimer + team * 2 + 1) then
                LOCAL_SET_INT(mission_script, Locals[mission_script].tdMultiObjectiveLimitTimer + team * 2,
                    NETWORK.GET_NETWORK_TIME())
            end
        end)
    end

    if MenuMisc["DisableStatCapCheck"]:is_enabled() then
        GLOBAL_SET_INT(Tunables["DISABLE_STAT_CAP_CHECK"], 1)
    end
end)

script.register_looped("RS_Missions.MissionEarning", function()
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
