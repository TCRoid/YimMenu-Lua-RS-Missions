----------------------------------------------------------------
-- Author: Rostal
-- Github: https://github.com/TCRoid/YimMenu-Lua-RS-Missions
----------------------------------------------------------------

local SUPPORT_GAME_VERSION <const> = "1.70-3411"


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

local function get_label_text(labelName)
    local text = HUD.GET_FILENAME_FOR_AUDIO_CONVERSATION(labelName)
    if text == "" or text == "NULL" then
        return text
    end

    text = string.gsub(text, "~n~", "\n")
    text = string.gsub(text, "µ", " ")
    return text
end

local function get_input_value(input, min_value, max_value)
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

local function check_input_value(input_value, min_value, max_value, default_value)
    if not input_value then
        return default_value
    end

    if input_value < min_value then
        return min_value
    end

    if input_value > max_value then
        return max_value
    end

    return input_value
end

local function add_toggle_button(menu_parent, menu_name, on_change, default_on)
    local toggle = default_on
    local button

    button = menu_parent:add_button(string.format("%s: < %s >", menu_name, toggle and "开" or "关"), function()
        toggle = not toggle
        button:set_text(string.format("%s: < %s >", menu_name, toggle and "开" or "关"))

        if on_change then
            on_change(toggle)
        end
    end)

    return button
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

function SPOOF_SCRIPT(script_name, func)
    script.run_in_fiber(function()
        if not IS_SCRIPT_RUNNING(script_name) then
            return
        end
        network.force_script_host(script_name)

        script.execute_as_script(script_name, function()
            if not NETWORK.NETWORK_IS_HOST_OF_THIS_SCRIPT() then
                return
            end

            func(script_name)
        end)
    end)
end

--------------------------------
-- Online Functions
--------------------------------

function IS_IN_SESSION()
    return NETWORK.NETWORK_IS_SESSION_STARTED() and not IS_SCRIPT_RUNNING("maintransition")
end

function CAN_LAUNCH_MISSION()
    return not (NETWORK.NETWORK_IS_ACTIVITY_SESSION() or IS_PLAYER_IN_CORONA())
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
        return 2657991 + 1 + PLAYER.PLAYER_ID() * 467
    end,

    GlobalplayerBD_FM = function()
        return 1845221 + 1 + PLAYER.PLAYER_ID() * 889
    end,

    GlobalplayerBD_FM_3 = function()
        return 1887549 + 1 + PLAYER.PLAYER_ID() * 611
    end,

    g_Outgoing_Call_Pause_Answering_Time = 23446,
}


-- FMMC_GLOBAL_STRUCT
local _g_FMMC_STRUCT <const> = 4718592
local g_FMMC_STRUCT <const> = {
    iNumParticipants = _g_FMMC_STRUCT + 3522,
    iMinNumParticipants = _g_FMMC_STRUCT + 3523,

    iDifficulity = _g_FMMC_STRUCT + 3525,
    iNumberOfTeams = _g_FMMC_STRUCT + 3526,
    iMaxNumberOfTeams = _g_FMMC_STRUCT + 3527,
    iNumPlayersPerTeam = _g_FMMC_STRUCT + 3529 + 1, -- +[0~3]

    tl63MissionName = _g_FMMC_STRUCT + 127185,
    iRootContentIDHash = _g_FMMC_STRUCT + 128476,
    tl31LoadedContentID = _g_FMMC_STRUCT + 128763,
    tl23NextContentID = _g_FMMC_STRUCT + 128791 + 1, -- +[0~5]*6

    iFixedCamera = _g_FMMC_STRUCT + 157365,
    iCriticalMinimumForTeam = _g_FMMC_STRUCT + 180865 + 1 -- +[0~3]
}

-- FMMC_ROCKSTAR_CREATED_STRUCT
local _g_FMMC_ROCKSTAR_CREATED <const> = 794744
local g_FMMC_ROCKSTAR_CREATED <const> = {
    sMissionHeaderVars = _g_FMMC_ROCKSTAR_CREATED + 4 + 1 -- +[iArrayPos]*89
}


-- TRANSITION_SESSION_NON_RESET_VARS
local _g_TransitionSessionNonResetVars <const> = 2685658
-- TRANSITION_SESSION_MAINTAIN_VARS
local _sTransVars <const> = _g_TransitionSessionNonResetVars + 1

local g_TransitionSessionNonResetVars <const> = {
    sTransVars = {
        iCoronaBitSet = _sTransVars + 2813
    },

    bAmIHeistLeader = _g_TransitionSessionNonResetVars + 6393
}


-- FMMC_TRANSITION_SESSION_DATA
local g_sTransitionSessionData <const> = 2684718

-- FMMC_STRAND_MISSION_DATA
local _sStrandMissionData <const> = g_sTransitionSessionData + 43
local sStrandMissionData <const> = {
    bPassedFirstMission = _sStrandMissionData + 55,
    bPassedFirstStrandNoReset = _sStrandMissionData + 56,
    bIsThisAStrandMission = _sStrandMissionData + 57,
    bLastMission = _sStrandMissionData + 58
}


-- HEIST_CLIENT_PLANNING_LOCAL_DATA
local _g_HeistPlanningClient <const> = 1931285
local g_HeistPlanningClient <const> = {
    bHeistCoronaActive = _g_HeistPlanningClient + 2816
}

-- HEIST_CLIENT_SHARED_LOCAL_DATA
local _g_HeistSharedClient <const> = 1934895
local g_HeistSharedClient <const> = {
    PlanningBoardIndex = _g_HeistSharedClient,
    vBoardPosition = _g_HeistSharedClient + 16
}


-- HEIST_ISLAND_PLAYER_BD_DATA
local GlobalPlayerBD_HeistIsland <const> = {
    -- HEIST_ISLAND_CONFIG
    sConfig = function()
        return 1974391 + 1 + PLAYER.PLAYER_ID() * 53 + 5
    end
}

-- NET_HEIST_PLANNING_GENERIC_PLAYER_BD_DATA
local GlobalPlayerBD_NetHeistPlanningGeneric <const> = {
    stFinaleLaunchTimer = function()
        return 1973526 + 1 + PLAYER.PLAYER_ID() * 27 + 18
    end
}


-- SIMPLE_INTERIOR_GLOBAL_DATA
local g_SimpleInteriorData <const> = {
    bTriggerExit = 1943917 + 3847
}


------------------------
-- Locals
------------------------

local Locals <const> = {
    ["fm_mission_controller"] = {
        iNextMission = 19781 + 1062,
        iTeamScore = 19781 + 1232 + 1, -- +[0~3]

        iServerGameState = 19781,
        iServerBitSet = 19781 + 1,
        iServerBitSet1 = 19781 + 2,

        iClientBitSet = function()
            return 31656 + 1 + NETWORK.PARTICIPANT_ID_TO_INT() * 293 + 127
        end,

        iLocalBoolCheck11 = 15200,

        tdObjectiveLimitTimer = 26207 + 740 + 1,      -- +[0~3]*2
        tdMultiObjectiveLimitTimer = 26207 + 749 + 1, -- +[0~3]*2
        iMultiObjectiveTimeLimit = 26207 + 765 + 1    -- +[0~3]
    },
    ["fm_mission_controller_2020"] = {
        iNextMission = 52171 + 1589,
        iTeamScore = 52171 + 1776 + 1, -- +[0~3]

        iServerGameState = 52171,
        iServerBitSet = 52171 + 1,
        iServerBitSet1 = 52171 + 2,

        iLocalBoolCheck11 = 50815,

        tdObjectiveLimitTimer = 58874 + 297 + 1,      -- +[0~3]*2
        tdMultiObjectiveLimitTimer = 58874 + 306 + 1, -- +[0~3]*2
        iMultiObjectiveTimeLimit = 58874 + 322 + 1    -- +[0~3]
    },


    ["fm_content_auto_shop_delivery"] = {
        iMissionEntityBitSet = 1625 + 2 + 5
    },
    ["fm_content_bike_shop_delivery"] = {
        iMissionEntityBitSet = 1627 + 2 + 5
    },
    ["fm_content_payphone_hit"] = {
        iMissionServerBitSet = 5778 + 747
    },
    ["fm_content_smuggler_ops"] = {
        iMissionBitSet = 7728 + 1334
    },
}

-- MISSION_TO_LAUNCH_DETAILS
local _sLaunchMissionDetails <const> = 19875
local sLaunchMissionDetails <const> = {
    iMinPlayers = _sLaunchMissionDetails + 15,
    iMaxParticipants = _sLaunchMissionDetails + 32,
    iMissionVariation = _sLaunchMissionDetails + 34
}

-- `freemode` Time Trial
-- AMTT_VARS_STRUCT
local sTTVarsStruct <const> = 14486
local TTVarsStruct <const> = {
    iVariation = sTTVarsStruct + 11,
    trialTimer = sTTVarsStruct + 13,
    iPersonalBest = sTTVarsStruct + 25,
    eAMTT_Stage = sTTVarsStruct + 29
}

-- `freemode` RC Bandito Time Trial
-- AMRCTT_VARS_STRUCT
local sRCTTVarsStruct <const> = 14536
local RCTTVarsStruct <const> = {
    eVariation = sRCTTVarsStruct,
    eRunStage = sRCTTVarsStruct + 2,
    timerTrial = sRCTTVarsStruct + 6,
    iPersonalBest = sRCTTVarsStruct + 21
}


local FM_CONTENT_XXX = {
    ["fm_content_acid_lab_sell"] = {
        eEndReason = 5653 + 1309,
        iGenericBitset = 5557
    },
    ["fm_content_acid_lab_setup"] = {
        eEndReason = 3421 + 541,
        iGenericBitset = 3355
    },
    ["fm_content_acid_lab_source"] = {
        eEndReason = 7771 + 1165,
        iGenericBitset = 7663
    },
    ["fm_content_ammunation"] = {
        eEndReason = 2140 + 204,
        iGenericBitset = 2081
    },
    ["fm_content_armoured_truck"] = {
        eEndReason = 1975 + 113,
        iGenericBitset = 1906
    },
    ["fm_content_arms_trafficking"] = {
        eEndReason = 5718 + 1237,
        iGenericBitset = 5597
    },
    ["fm_content_auto_shop_delivery"] = {
        eEndReason = 1625 + 83,
        iGenericBitset = 1569
    },
    ["fm_content_bank_shootout"] = {
        eEndReason = 2284 + 221,
        iGenericBitset = 2206
    },
    ["fm_content_bar_resupply"] = {
        eEndReason = 2344 + 287,
        iGenericBitset = 2281
    },
    ["fm_content_bicycle_time_trial"] = {
        eEndReason = 3058 + 83,
        iGenericBitset = 3000
    },
    ["fm_content_bike_shop_delivery"] = {
        eEndReason = 1627 + 83,
        iGenericBitset = 1569
    },
    ["fm_content_bounty_targets"] = {
        eEndReason = 7137 + 1254,
        iGenericBitset = 7028
    },
    ["fm_content_business_battles"] = {
        eEndReason = 5365 + 1138,
        iGenericBitset = 5263
    },
    ["fm_content_cargo"] = {
        eEndReason = 5979 + 1157,
        iGenericBitset = 5883
    },
    ["fm_content_cerberus"] = {
        eEndReason = 1642 + 91,
        iGenericBitset = 1590
    },
    ["fm_content_chop_shop_delivery"] = {
        eEndReason = 1957 + 137,
        iGenericBitset = 1897
    },
    ["fm_content_clubhouse_contracts"] = {
        eEndReason = 6761 + 1258,
        iGenericBitset = 6664
    },
    ["fm_content_club_management"] = {
        eEndReason = 5307 + 784,
        iGenericBitset = 5229
    },
    ["fm_content_club_odd_jobs"] = {
        eEndReason = 1856 + 83,
        iGenericBitset = 1798
    },
    ["fm_content_club_source"] = {
        eEndReason = 3632 + 674,
        iGenericBitset = 3539
    },
    ["fm_content_community_outreach"] = {
        eEndReason = 2066 + 191,
        iGenericBitset = 2008
    },
    ["fm_content_convoy"] = {
        eEndReason = 2812 + 437,
        iGenericBitset = 2737
    },
    ["fm_content_crime_scene"] = {
        eEndReason = 2023 + 151,
        iGenericBitset = 1964
    },
    ["fm_content_daily_bounty"] = {
        eEndReason = 2612 + 328,
        iGenericBitset = 2549
    },
    ["fm_content_dispatch_work"] = {
        eEndReason = 5622 + 972,
        iGenericBitset = 5535
    },
    ["fm_content_drug_lab_work"] = {
        eEndReason = 8010 + 1262,
        iGenericBitset = 7915
    },
    ["fm_content_drug_vehicle"] = {
        eEndReason = 1820 + 115,
        iGenericBitset = 1762
    },
    ["fm_content_export_cargo"] = {
        eEndReason = 2263 + 191,
        iGenericBitset = 2204
    },
    ["fm_content_ghosthunt"] = {
        eEndReason = 1606 + 88,
        iGenericBitset = 1551
    },
    ["fm_content_golden_gun"] = {
        eEndReason = 1833 + 93,
        iGenericBitset = 1780
    },
    ["fm_content_gunrunning"] = {
        eEndReason = 5759 + 1237,
        iGenericBitset = 5655
    },
    ["fm_content_hacker_cargo_finale"] = {
        eEndReason = 7671 + 1289,
        iGenericBitset = 7535
    },
    ["fm_content_hacker_cargo_prep"] = {
        eEndReason = 5336 + 1099,
        iGenericBitset = 5247
    },
    ["fm_content_hacker_house_finale"] = {
        eEndReason = 8126 + 1173,
        iGenericBitset = 8001
    },
    ["fm_content_hacker_house_prep"] = {
        eEndReason = 6976 + 1283,
        iGenericBitset = 6844
    },
    ["fm_content_hacker_whistle_fin"] = {
        eEndReason = 6653 + 1162,
        iGenericBitset = 6514
    },
    ["fm_content_hacker_whistle_prep"] = {
        eEndReason = 6475 + 982,
        iGenericBitset = 6371
    },
    ["fm_content_hacker_zancudo_fin"] = {
        eEndReason = 8535 + 1166,
        iGenericBitset = 8431
    },
    ["fm_content_hacker_zancudo_prep"] = {
        eEndReason = 5279 + 988,
        iGenericBitset = 5174
    },
    ["fm_content_island_dj"] = {
        eEndReason = 3532 + 501,
        iGenericBitset = 3442
    },
    ["fm_content_island_heist"] = {
        eEndReason = 13433 + 1357,
        iGenericBitset = 13311
    },
    ["fm_content_metal_detector"] = {
        eEndReason = 1881 + 93,
        iGenericBitset = 1826
    },
    ["fm_content_movie_props"] = {
        eEndReason = 1947 + 137,
        iGenericBitset = 1888
    },
    ["fm_content_parachuter"] = {
        eEndReason = 1621 + 83,
        iGenericBitset = 1569
    },
    ["fm_content_payphone_hit"] = {
        eEndReason = 5778 + 689,
        iGenericBitset = 5703
    },
    ["fm_content_phantom_car"] = {
        eEndReason = 1630 + 83,
        iGenericBitset = 1578
    },
    ["fm_content_pizza_delivery"] = {
        eEndReason = 1774 + 83,
        iGenericBitset = 1716
    },
    ["fm_content_possessed_animals"] = {
        eEndReason = 1646 + 83,
        iGenericBitset = 1592
    },
    ["fm_content_robbery"] = {
        eEndReason = 1809 + 87,
        iGenericBitset = 1741
    },
    ["fm_content_security_contract"] = {
        eEndReason = 7268 + 1295,
        iGenericBitset = 7159
    },
    ["fm_content_sightseeing"] = {
        eEndReason = 1875 + 84,
        iGenericBitset = 1821
    },
    ["fm_content_skydive"] = {
        eEndReason = 3120 + 93,
        iGenericBitset = 3061
    },
    ["fm_content_slasher"] = {
        eEndReason = 1650 + 83,
        iGenericBitset = 1596
    },
    ["fm_content_smuggler_ops"] = {
        eEndReason = 7728 + 1276,
        iGenericBitset = 7620
    },
    ["fm_content_smuggler_plane"] = {
        eEndReason = 1894 + 178,
        iGenericBitset = 1823
    },
    ["fm_content_smuggler_resupply"] = {
        eEndReason = 6166 + 1277,
        iGenericBitset = 6056
    },
    ["fm_content_smuggler_sell"] = {
        eEndReason = 4133 + 489,
        iGenericBitset = 3991
    },
    ["fm_content_smuggler_trail"] = {
        eEndReason = 2122 + 130,
        iGenericBitset = 2048
    },
    ["fm_content_source_research"] = {
        eEndReason = 4431 + 1198,
        iGenericBitset = 4343
    },
    ["fm_content_stash_house"] = {
        eEndReason = 3602 + 475,
        iGenericBitset = 3538
    },
    ["fm_content_taxi_driver"] = {
        eEndReason = 2066 + 83,
        iGenericBitset = 2012
    },
    ["fm_content_tow_truck_work"] = {
        eEndReason = 1812 + 91,
        iGenericBitset = 1757
    },
    ["fm_content_tuner_robbery"] = {
        eEndReason = 7436 + 1200,
        iGenericBitset = 7322
    },
    ["fm_content_ufo_abduction"] = {
        eEndReason = 2934 + 334,
        iGenericBitset = 2861
    },
    ["fm_content_vehicle_list"] = {
        eEndReason = 1621 + 83,
        iGenericBitset = 1569
    },
    ["fm_content_vehrob_arena"] = {
        eEndReason = 7922 + 1285,
        iGenericBitset = 7832
    },
    ["fm_content_vehrob_cargo_ship"] = {
        eEndReason = 7237 + 1227,
        iGenericBitset = 7115
    },
    ["fm_content_vehrob_casino_prize"] = {
        eEndReason = 9221 + 1234,
        iGenericBitset = 9109
    },
    ["fm_content_vehrob_disrupt"] = {
        eEndReason = 4680 + 924,
        iGenericBitset = 4597
    },
    ["fm_content_vehrob_police"] = {
        eEndReason = 9045 + 1279,
        iGenericBitset = 8939
    },
    ["fm_content_vehrob_prep"] = {
        eEndReason = 11493 + 1281,
        iGenericBitset = 11361
    },
    ["fm_content_vehrob_scoping"] = {
        eEndReason = 3839 + 508,
        iGenericBitset = 3769
    },
    ["fm_content_vehrob_submarine"] = {
        eEndReason = 6250 + 1137,
        iGenericBitset = 6135
    },
    ["fm_content_vehrob_task"] = {
        eEndReason = 4884 + 1046,
        iGenericBitset = 4790
    },
    ["fm_content_vip_contract_1"] = {
        eEndReason = 8817 + 1166,
        iGenericBitset = 8713
    },
    ["fm_content_xmas_mugger"] = {
        eEndReason = 1673 + 83,
        iGenericBitset = 1619
    },
    ["fm_content_xmas_truck"] = {
        eEndReason = 1520 + 91,
        iGenericBitset = 1466
    },

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

local g_sCURRENT_UGC_STATUS <const> = 2693671
local g_iMissionEnteryType <const> = 1057440

local function CLEAR_TRANSITION_SESSIONS_CREATE_WITH_OPEN_MATCHMAKING()
    GLOBAL_SET_INT(g_sTransitionSessionData + 717, 0)
end

local function SET_TRANSITION_SESSIONS_FORCE_ME_HOST_QUICK_MATCH()
    GLOBAL_SET_INT(g_sTransitionSessionData + 719, 1)
end

local function _LAUNCH_MISSION(Data)
    local iArrayPos = MISC.GET_CONTENT_ID_INDEX(Data.iRootContentID)

    local tlName = GLOBAL_GET_STRING(FMMC_ROCKSTAR_CREATED.sMissionHeaderVars + iArrayPos * 89)
    local iMaxPlayers = GLOBAL_GET_INT(FMMC_ROCKSTAR_CREATED.sMissionHeaderVars + iArrayPos * 89 + 71)

    GLOBAL_SET_INT(_g_TransitionSessionNonResetVars + 3851, 1)

    GLOBAL_SET_INT(g_sCURRENT_UGC_STATUS + 1, 0)
    GLOBAL_SET_BIT(g_sTransitionSessionData + 3, 2)

    if Data.iMissionEnteryType then
        GLOBAL_SET_INT(g_iMissionEnteryType, Data.iMissionEnteryType)
    end

    GLOBAL_SET_INT(g_sTransitionSessionData + 9, Data.iMissionType)
    GLOBAL_SET_STRING(g_sTransitionSessionData + 863, tlName)
    GLOBAL_SET_INT(g_sTransitionSessionData + 42, iMaxPlayers)

    GLOBAL_CLEAR_BIT(g_sTransitionSessionData + 2, 14)

    GLOBAL_SET_BIT(g_sTransitionSessionData, 5)
    GLOBAL_SET_BIT(g_sTransitionSessionData, 8)

    GLOBAL_CLEAR_BIT(g_sTransitionSessionData, 7)
    GLOBAL_CLEAR_BIT(g_sTransitionSessionData, 15)

    CLEAR_TRANSITION_SESSIONS_CREATE_WITH_OPEN_MATCHMAKING()
    SET_TRANSITION_SESSIONS_FORCE_ME_HOST_QUICK_MATCH()

    GLOBAL_SET_INT(Globals.GlobalplayerBD_FM() + 96, 8)
end

-- g_structLocalHeistControl
local g_sLocalMPHeistControl = {
    _lhcMyCorona = 2635079 + 3
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

function IS_PLAYER_BOSS_OF_A_GANG()
    return GLOBAL_GET_INT(Globals.GlobalplayerBD_FM_3() + 10) == PLAYER.PLAYER_ID()
end

function IS_PLAYER_IN_CORONA()
    return GLOBAL_GET_INT(Globals.GlobalplayerBD_FM() + 193) ~= 0
end

local function COMPLETE_DAILY_CHALLENGE()
    for i = 0, 2, 1 do
        GLOBAL_SET_INT(2359296 + 1 + 0 * 5571 + 681 + 4245 + 1 + i * 3 + 1, 1)
    end
end

local function COMPLETE_WEEKLY_CHALLENGE()
    local g_sWeeklyChallenge = 2738865

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
        user,
        -1,
        iMission,
        -1, -1, -1, -1
    })
end

local function INSTANT_FINISH_FM_CONTENT_MISSION(script_name)
    LOCAL_SET_BIT(script_name, FM_CONTENT_XXX[script_name].iGenericBitset + 1 + 0, 11)
    LOCAL_SET_INT(script_name, FM_CONTENT_XXX[script_name].eEndReason, 3)
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
        local tl23NextContentID = GLOBAL_GET_STRING(g_FMMC_STRUCT.tl23NextContentID + i * 6)
        if tl23NextContentID ~= "" then
            GLOBAL_SET_STRING(g_FMMC_STRUCT.tl23NextContentID + i * 6, "")
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

------------------------
-- Scr Functions
------------------------

local function GB_BOSS_REGISTER(gangType)
    script.run_in_fiber(function()
        local pattern = "2D 03 14 00 00 72 72"

        scr_function.call_script_function("am_pi_menu", "GB_BOSS_CREATE_GANG",
            pattern, "void", {
                { "bool", false },    -- bDoMessage
                { "int",  gangType }, -- gangType = GT_VIP, GT_BIKER
                { "int",  208508824 } -- iParam2 ??
            })
    end)
end

local function GB_BOSS_RETIRE()
    script.run_in_fiber(function()
        local pattern = "2D 01 03 00 00 38 00 56 62"

        scr_function.call_script_function("am_pi_menu", "GB_BOSS_RETIRE",
            pattern, "void", {
                { "bool", true } -- bDoMessage
            })
    end)
end

local function LAUNCH_MISSION(iRootContentIDHash)
    local pattern = "2D 09 19 00 00 38 01"

    local iArrayPos = MISC.GET_CONTENT_ID_INDEX(iRootContentIDHash)
    scr_function.call_script_function("freemode", "SET_VARS_WHEN_LAUNCHING_V2_CORONA",
        pattern, "void", {
            { "int",  -1 },        -- iSeries
            { "int",  iArrayPos }, -- iArrayPos
            { "bool", false },     -- bOnCall
            { "int",  -1 },        -- iPlaylistType
            { "bool", true },      -- bSkipSkyCam
            { "bool", false },     -- bSetExitVector
            { "bool", false },     -- bFromWall
            { "bool", true },      -- bSetSkipWarning
            { "int",  -1 }         -- iForceJobEntryType
        })

    CLEAR_TRANSITION_SESSIONS_CREATE_WITH_OPEN_MATCHMAKING()
    SET_TRANSITION_SESSIONS_FORCE_ME_HOST_QUICK_MATCH()
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


    ------------------------
    -- Business
    ------------------------

    NightclubGoodsName = {
        [0] = get_label_text("CLUB_STOCK0"), -- Cargo and Shipments
        [1] = get_label_text("CLUB_STOCK1"), -- Sporting Goods
        [2] = get_label_text("CLUB_STOCK2"), -- South American Imports
        [3] = get_label_text("CLUB_STOCK3"), -- Pharmaceutical Research
        [4] = get_label_text("CLUB_STOCK4"), -- Organic Produce
        [5] = get_label_text("CLUB_STOCK5"), -- Printing & Copying
        [6] = get_label_text("CLUB_STOCK6")  -- Cash Creation
    },
    BikerFactoryName = {
        [0] = get_label_text("BKR_FACTORY_0"), -- Document Forgery Office
        [1] = get_label_text("BKR_FACTORY_1"), -- Weed Farm
        [2] = get_label_text("BKR_FACTORY_2"), -- Counterfeit Cash Factory
        [3] = get_label_text("BKR_FACTORY_3"), -- Meth Lab
        [4] = get_label_text("BKR_FACTORY_4")  -- Cocaine Lockup
    },
    BikerFactoryType = {
        -- [FACTORY_ID]
        [1]  = 3, -- FACTORY_TYPE_METH
        [2]  = 1, -- FACTORY_TYPE_WEED
        [3]  = 4, -- FACTORY_TYPE_CRACK
        [4]  = 2, -- FACTORY_TYPE_FAKE_MONEY
        [5]  = 0, -- FACTORY_TYPE_FAKE_IDS

        [6]  = 3,
        [7]  = 1,
        [8]  = 4,
        [9]  = 2,
        [10] = 0,

        [11] = 3,
        [12] = 1,
        [13] = 4,
        [14] = 2,
        [15] = 0,

        [16] = 3,
        [17] = 1,
        [18] = 4,
        [19] = 2,
        [20] = 0
    },
    HangarGoodsName = {
        [0] = get_label_text("HAN_CRG_ANIMAL"), -- Animal Materials
        [1] = get_label_text("HAN_CRG_ART"),    -- Art & Antiques
        [2] = get_label_text("HAN_CRG_CHEMS"),  -- Chemicals
        [3] = get_label_text("HAN_CRG_GOODS"),  -- Counterfeit Goods
        [4] = get_label_text("HAN_CRG_JEWEL"),  -- Jewelry & Gemstones
        [5] = get_label_text("HAN_CRG_MEDS"),   -- Medical Supplies
        [6] = get_label_text("HAN_CRG_NARC"),   -- Narcotics
        [7] = get_label_text("HAN_CRG_TOBAC"),  -- Tobacco & Alcohol
        -- [8] = get_label_text("HAN_CRG_MIXED"),  -- Cargo
    },
    HangaModelIndexGoodType = {
        [1] = 5,
        [2] = 5,
        [3] = 7,
        [4] = 7,
        [5] = 1,
        [6] = 1,
        [7] = 6,
        [8] = 6,
        [9] = 4,
        [10] = 4,
        [11] = 0,
        [12] = 0,
        [13] = 3,
        [14] = 3,
        [15] = 2,
        [16] = 2,
    },

}

local PACKED_MP_INT_HANGAR_PRODUCT_0 <const> = 16011



--------------------------------------------------------
--                MAIN MENU
--------------------------------------------------------

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




--------------------------------------------------------
--                BUSINESS MONITOR
--------------------------------------------------------

local menu_business_monitor <const> = menu_root:add_tab("[RSM] 资产监视")

local BusinessMonitor = {
    Caps = {
        Nightclub = {
            [0] = 50,  -- Cargo
            [1] = 100, -- Weapons
            [2] = 10,  -- Cocaine
            [3] = 20,  -- Meth
            [4] = 80,  -- Weed
            [5] = 60,  -- Forgery
            [6] = 40   -- Cash
        },
        Biker = {
            [0] = 60, -- Forgery
            [1] = 80, -- Weed
            [2] = 40, -- Cash
            [3] = 20, -- Meth
            [4] = 10  -- Cocaine
        },
        Bunker = {
            product = 100,
            research = 60
        },
        AcidLab = 160,
        Warehouse = {
            [1]  = 16,  -- "MP_WHOUSE_0",
            [2]  = 16,  -- "MP_WHOUSE_1",
            [3]  = 16,  -- "MP_WHOUSE_2",
            [4]  = 16,  -- "MP_WHOUSE_3",
            [5]  = 16,  -- "MP_WHOUSE_4",
            [6]  = 111, -- "MP_WHOUSE_5",
            [7]  = 42,  -- "MP_WHOUSE_6",
            [8]  = 111, -- "MP_WHOUSE_7",
            [9]  = 16,  -- "MP_WHOUSE_8",
            [10] = 42,  -- "MP_WHOUSE_9",
            [11] = 42,  -- "MP_WHOUSE_10",
            [12] = 42,  -- "MP_WHOUSE_11",
            [13] = 42,  -- "MP_WHOUSE_12",
            [14] = 42,  -- "MP_WHOUSE_13",
            [15] = 42,  -- "MP_WHOUSE_14",
            [16] = 111, -- "MP_WHOUSE_15",
            [17] = 111, -- "MP_WHOUSE_16",
            [18] = 111, -- "MP_WHOUSE_17",
            [19] = 111, -- "MP_WHOUSE_18",
            [20] = 111, -- "MP_WHOUSE_19",
            [21] = 42,  -- "MP_WHOUSE_20",
            [22] = 111, -- "MP_WHOUSE_21",
        },
        Hangar = 50,
    },

    SafeCash = {
        {
            name = "夜总会",
            stat = "MPX_CLUB_SAFE_CASH_VALUE",
            cap = 250000
        },
        {
            name = "游戏厅",
            stat = "MPX_ARCADE_SAFE_CASH_VALUE",
            cap = 100000
        },
        {
            name = "事务所",
            stat = "MPX_FIXER_SAFE_CASH_VALUE",
            cap = 250000
        },
        {
            name = "摩托帮会所",
            stat = "MPX_BIKER_BAR_RESUPPLY_CASH",
            cap = 100000
        },
        {
            name = "回收站",
            stat = "MPX_SALVAGE_SAFE_CASH_VALUE",
            cap = 250000
        },
        {
            name = "保金办公室",
            stat = "MPX_BAIL_SAFE_CASH_VALUE",
            cap = 100000
        },
        {
            name = "服装厂",
            stat = "MPX_HDEN24_SAFE_CASH_VALUE",
            cap = 100000
        }
    }
}

menu_business_monitor:add_imgui(function()
    if not IS_IN_SESSION() then
        ImGui.Text("仅在线上模式战局内可用")
        return
    end


    -- Safe Cash
    ImGui.SeparatorText("保险箱")
    for _, item in pairs(BusinessMonitor.SafeCash) do
        local safe_cash = stats.get_int(item.stat)
        local text = item.name .. ": " .. safe_cash
        if safe_cash >= item.cap then
            text = text .. " [!!]"
        end
        ImGui.BulletText(text)
    end


    -- Nightclub
    if stats.get_int("MPX_NIGHTCLUB_OWNED") > 0 then
        ImGui.SeparatorText("夜总会")

        local popularity = math.floor(stats.get_int("MPX_CLUB_POPULARITY") / 10)
        ImGui.BulletText("人气: " .. popularity .. "%")

        for i = 0, 6 do
            local name = Tables.NightclubGoodsName[i]
            local product = stats.get_int("MPX_HUB_PROD_TOTAL_" .. i)
            local cap = BusinessMonitor.Caps.Nightclub[i]

            local text = name .. ": " .. product .. "/" .. cap
            if product >= cap then
                text = text .. " [!!]"
            end
            ImGui.BulletText(text)
        end
    end


    -- Bunker
    if stats.get_int("MPX_FACTORYSLOT5") > 0 then
        ImGui.SeparatorText("地堡")

        ImGui.Bullet()

        local supply = stats.get_int("MPX_MATTOTALFORFACTORY5")
        ImGui.Text("原材料: " .. supply .. "%")
        ImGui.SameLine(220)

        local product = stats.get_int("MPX_PRODTOTALFORFACTORY5")
        local cap = BusinessMonitor.Caps.Bunker.product
        local text = "货物: " .. product .. "/" .. cap
        if product >= cap then
            text = text .. " [!!]"
        end
        ImGui.Text(text)
        ImGui.SameLine(360)

        local research = stats.get_int("MPX_RESEARCHTOTALFORFACTORY5")
        local cap = BusinessMonitor.Caps.Bunker.research
        local text = "研究: " .. research .. "/" .. cap
        ImGui.Text(text)
    end


    -- Acid Lab
    if stats.get_int("MPX_XM22_LAB_OWNED") == -1576586413 then
        ImGui.SeparatorText("致幻剂实验室")

        ImGui.Bullet()

        local supply = stats.get_int("MPX_MATTOTALFORFACTORY6")
        ImGui.Text("原材料: " .. supply .. "%")
        ImGui.SameLine(220)

        local product = stats.get_int("MPX_PRODTOTALFORFACTORY6")
        local cap = BusinessMonitor.Caps.AcidLab
        local text = "货物: " .. product .. "/" .. cap
        if product >= cap then
            text = text .. " [!!]"
        end
        ImGui.Text(text)
    end


    -- Biker
    if stats.get_int("MPX_PROP_CLUBHOUSE") > 0 then
        ImGui.SeparatorText("摩托帮")

        for i = 0, 4 do
            local factory_id = stats.get_int("MPX_FACTORYSLOT" .. i)
            if factory_id > 0 then
                local factory_type = Tables.BikerFactoryType[factory_id]

                local factory_name = Tables.BikerFactoryName[factory_type]
                ImGui.BulletText(factory_name)
                ImGui.SameLine(220)

                local supply = stats.get_int("MPX_MATTOTALFORFACTORY" .. i)
                ImGui.Text("原材料: " .. supply .. "%")
                ImGui.SameLine(360)

                local product = stats.get_int("MPX_PRODTOTALFORFACTORY" .. i)
                local cap = BusinessMonitor.Caps.Biker[factory_type]
                local text = "货物: " .. product .. "/" .. cap
                if product >= cap then
                    text = text .. " [!!]"
                end
                ImGui.Text(text)
            end
        end
    end


    -- Special Cargo
    if stats.get_int("MPX_PROP_OFFICE") > 0 then
        ImGui.SeparatorText("CEO 特种货物")

        for i = 0, 4 do
            local warehouse_id = stats.get_int("MPX_PROP_WHOUSE_SLOT" .. i)
            if warehouse_id > 0 then
                local warehouse_name = get_label_text("MP_WHOUSE_" .. warehouse_id - 1)
                ImGui.BulletText(warehouse_name)
                ImGui.SameLine(220)

                local special_item = stats.get_int("MPX_SPCONTOTALFORWHOUSE" .. i)
                ImGui.Text("特殊物品: " .. special_item)
                ImGui.SameLine(360)

                local special_crate = stats.get_int("MPX_CONTOTALFORWHOUSE" .. i)
                local warehouse_cap = BusinessMonitor.Caps.Warehouse[warehouse_id]
                local text = "货物总数: " .. special_crate .. "/" .. warehouse_cap
                if special_crate >= warehouse_cap then
                    text = text .. " [!!]"
                end
                ImGui.Text(text)
            end
        end
    end


    -- Hangar
    if stats.get_int("MPX_HANGAR_OWNED") > 0 then
        ImGui.SeparatorText("机库")

        local product = stats.get_int("MPX_HANGAR_CONTRABAND_TOTAL")
        local cap = BusinessMonitor.Caps.Hangar
        local text = "货物总数: " .. product .. "/" .. cap
        if product >= cap then
            text = text .. " [!!]"
        end
        ImGui.BulletText(text)


        local hangar_products = {
            [0] = 0,
            [1] = 0,
            [2] = 0,
            [3] = 0,
            [4] = 0,
            [5] = 0,
            [6] = 0,
            [7] = 0
        }
        for slot = 0, 49 do
            local model_index = stats.get_packed_stat_int(PACKED_MP_INT_HANGAR_PRODUCT_0 + slot)
            if model_index > 0 then
                local good_type = Tables.HangaModelIndexGoodType[model_index]
                hangar_products[good_type] = hangar_products[good_type] + 1
            end
        end
        for i = 0, 7 do
            local name = Tables.HangarGoodsName[i]
            ImGui.BulletText(name .. ": " .. hangar_products[i])
        end
    end


    ImGui.Spacing()
    ImGui.Separator()
    local formatted_date = os.date("%Y-%m-%d %H:%M:%S", os.time())
    ImGui.Text("当前时间：" .. formatted_date)
end)




--------------------------------------------------------
--                FREEMODE MISSION
--------------------------------------------------------

local menu_feemode_mission <const> = menu_root:add_tab("[RSM] 自由模式任务")

menu_feemode_mission:add_text("*所有功能均在单人战局测试可用*")


menu_feemode_mission:add_text("<<  启动任务  >>")

local freemode_mission_list = {
    { 263, "安保合约 (富兰克林)" },
    { 262, "电话暗杀 (富兰克林)" },
    { 307, "蠢人帮差事 (达克斯)" },
    { 243, "赌场工作 (贝克女士)" },
    { 308, "藏匿屋" },
    { 295, "出口混合货物 (办公室)" },
    { 296, "武装国度合约 (地堡)" },
    { 298, "请求地堡研究 (14号探员)" },
    { 301, "请求夜总会货物 (尤汗)" },
    { 317, "LSA 行动 (复仇者)" },
    { 337, "保金办公室悬赏目标" },
    { 338, "玛德拉索雇凶" },
    { 339, "派遣工作" },
}

local freemode_mission = {
    fmmc_type = {},
    mission_list = {},

    mission_select = 0,
}

for key, item in pairs(freemode_mission_list) do
    freemode_mission.fmmc_type[key] = item[1]
    freemode_mission.mission_list[key] = item[2]
end

menu_feemode_mission:add_imgui(function()
    freemode_mission.mission_select, clicked = ImGui.Combo("选择自由模式任务", freemode_mission.mission_select,
        freemode_mission.mission_list, 13, 5)
end)
freemode_mission.mission_variation = menu_feemode_mission:add_input_int("Mission Variation [-1 ~ 99]")
freemode_mission.mission_variation:set_value(-1)

menu_feemode_mission:add_button("启动 自由模式任务", function()
    script.run_in_fiber(function()
        local iMission = freemode_mission.fmmc_type[freemode_mission.mission_select + 1]
        local iVariation = get_input_value(freemode_mission.mission_variation, -1, 99)

        network.trigger_script_event(1 << PLAYER.PLAYER_ID(), {
            1450115979, -- GB_NON_BOSS_CHALLENGE_REQUEST
            PLAYER.PLAYER_ID(),
            -1,
            iMission,
            iVariation
        })
    end)
end)
menu_feemode_mission:add_sameline()
menu_feemode_mission:add_text("部分任务需要注册为老大才可以开启")


menu_feemode_mission:add_separator()
menu_feemode_mission:add_text("<<  直接完成任务  >>")

menu_feemode_mission:add_button("直接完成 fm_content 自由模式任务", function()
    script.run_in_fiber(function()
        for script_name, item in pairs(FM_CONTENT_XXX) do
            if IS_SCRIPT_RUNNING(script_name) then
                network.force_script_host(script_name)

                script.execute_as_script(script_name, function()
                    if not NETWORK.NETWORK_IS_HOST_OF_THIS_SCRIPT() then
                        return
                    end
                    INSTANT_FINISH_FM_CONTENT_MISSION(script_name)
                end)
            end
        end
    end)
end)
menu_feemode_mission:add_sameline()
menu_feemode_mission:add_text("可以完成大部分的自由模式任务，但部分任务并不会判定任务成功")


menu_feemode_mission:add_button("直接完成 电话暗杀(暗杀奖励)", function()
    SPOOF_SCRIPT("fm_content_payphone_hit", function(script_name)
        LOCAL_SET_BIT(script_name, Locals[script_name].iMissionServerBitSet + 1, 1)
        INSTANT_FINISH_FM_CONTENT_MISSION(script_name)
    end)
end)
menu_feemode_mission:add_sameline()
menu_feemode_mission:add_button("直接完成 LSA 行动(附加行动)", function()
    SPOOF_SCRIPT("fm_content_smuggler_ops", function(script_name)
        LOCAL_SET_BIT(script_name, Locals[script_name].iMissionBitSet + 1 + 0, 0)
        INSTANT_FINISH_FM_CONTENT_MISSION(script_name)
    end)
end)

menu_feemode_mission:add_button("直接完成 改装铺服务", function()
    SPOOF_SCRIPT("fm_content_auto_shop_delivery", function(script_name)
        if PED.IS_PED_IN_ANY_VEHICLE(PLAYER.PLAYER_PED_ID(), false) then
            TASK.CLEAR_PED_TASKS_IMMEDIATELY(PLAYER.PLAYER_PED_ID())
        end

        LOCAL_SET_BIT(script_name, Locals[script_name].iMissionEntityBitSet + 1 + 0 * 3 + 1 + 0, 4)
        INSTANT_FINISH_FM_CONTENT_MISSION(script_name)
    end)
end)
menu_feemode_mission:add_sameline()
menu_feemode_mission:add_button("直接完成 摩托车服务", function()
    SPOOF_SCRIPT("fm_content_bike_shop_delivery", function(script_name)
        if PED.IS_PED_IN_ANY_VEHICLE(PLAYER.PLAYER_PED_ID(), false) then
            TASK.CLEAR_PED_TASKS_IMMEDIATELY(PLAYER.PLAYER_PED_ID())
        end

        LOCAL_SET_BIT(script_name, Locals[script_name].iMissionEntityBitSet + 1 + 0 * 3 + 1 + 0, 4)
        INSTANT_FINISH_FM_CONTENT_MISSION(script_name)
    end)
end)


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
    script.run_in_fiber(function()
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
    script.run_in_fiber(function()
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
end)


menu_feemode_mission:add_separator()
menu_feemode_mission:add_button("完成每日挑战", function()
    COMPLETE_DAILY_CHALLENGE()
end)
menu_feemode_mission:add_sameline()
menu_feemode_mission:add_button("完成每周挑战", function()
    COMPLETE_WEEKLY_CHALLENGE()
end)




--------------------------------------------------------
--                HEIST MISSION
--------------------------------------------------------

local menu_mission <const> = menu_root:add_tab("[RSM] 抢劫任务")

local MenuHMission = {}

local IslandHeistConfig = {
    menu = {
        initialized = false,
        showUI = false
    },

    bHardModeEnabled = false,

    eApproachVehicle = 6 - 1,
    eInfiltrationPoint = 3,
    eCompoundEntrance = 0,
    eEscapePoint = 1,
    eTimeOfDay = 1 - 1,

    eWeaponLoadout = 1 - 1,
    bUseSuppressors = true
}

IslandHeistConfig.menu.drawUI = function()
    if ImGui.Begin("佩里科岛抢劫 终章面板设置") then
        if not IslandHeistConfig.menu.initialized then
            ImGui.SetWindowSize(400, 500)
            IslandHeistConfig.menu.initialized = true
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
                GLOBAL_SET_INT(g_FMMC_STRUCT.iDifficulity, 2)
            else
                GLOBAL_SET_INT(g_FMMC_STRUCT.iDifficulity, 1)
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
    end
    ImGui.End()
end

local HeistMissionSelect = {
    apartmentFinal = 0,
    autoShop = 0,
    doomsdayFinal = 0,
    doomsdaySetup = 0,

    mission = 0,
}

menu_mission:add_imgui(function()
    ImGui.Text("*所有功能均在单人战局测试可用*")

    --------------------------------
    -- General
    --------------------------------

    ImGui.SeparatorText("通用")

    MenuHMission.SetMinPlayers = ImGui.Checkbox("最小玩家数为 1 (强制任务单人可开)", MenuHMission.SetMinPlayers)
    ImGui.SameLine()
    MenuHMission.SetMaxTeams = ImGui.Checkbox("最大团队数为 1 (用于多团队任务)", MenuHMission.SetMaxTeams)

    if ImGui.Button("直接完成任务 (通用)", 160, 40) then
        FM_MISSION_CONTROLLER.RUN(function(script_name)
            FM_MISSION_CONTROLLER.INSTANT_FINISH(script_name)
        end)
    end
    ImGui.SameLine()
    if ImGui.Button("跳到下一个检查点 (解决单人任务卡关问题)", 320, 40) then
        FM_MISSION_CONTROLLER.RUN(function(mission_script)
            LOCAL_SET_BIT(mission_script, Locals[mission_script].iServerBitSet1, 17)
        end)
    end

    MenuHMission.DisableMissionAggroFail = ImGui.Checkbox("禁止因触发惊动而任务失败", MenuHMission.DisableMissionAggroFail)
    ImGui.SameLine()
    MenuHMission.DisableMissionFail = ImGui.Checkbox("禁止任务失败 (仅单人可用)", MenuHMission.DisableMissionFail)
    ImGui.SameLine()
    if ImGui.Button("允许任务失败") then
        MenuHMission.DisableMissionFail = false

        FM_MISSION_CONTROLLER.RUN(function(mission_script)
            LOCAL_CLEAR_BIT(mission_script, Locals[mission_script].iLocalBoolCheck11, 7)
        end)
    end

    MenuHMission.ObjectiveTimeLimit = check_input_value(MenuHMission.ObjectiveTimeLimit, 0, 10000, 0)
    MenuHMission.ObjectiveTimeLimit = ImGui.InputInt("任务剩余时间 [0~10000]", MenuHMission.ObjectiveTimeLimit)
    if ImGui.Button("设置任务剩余时间") then
        local value = MenuHMission.ObjectiveTimeLimit
        FM_MISSION_CONTROLLER.RUN(function(mission_script)
            local team = PLAYER.GET_PLAYER_TEAM(PLAYER.PLAYER_ID())

            LOCAL_SET_INT(mission_script, Locals[mission_script].iMultiObjectiveTimeLimit + team, value * 60 * 1000)
        end)
    end
    ImGui.SameLine()
    ImGui.Text("(单位: 分钟, 右下角的剩余时间倒计时)")
    ImGui.SameLine()
    MenuHMission.LockObjectiveLimitTimer = ImGui.Checkbox("锁定任务剩余时间", MenuHMission.LockObjectiveLimitTimer)


    --------------------------------
    -- Launch Mission
    --------------------------------

    ImGui.SeparatorText("启动差事")
    ImGui.BulletText("未对室内类型进行检查，启动差事前确保在正确的室内")
    ImGui.BulletText("点击启动差事后，耐心等待差事加载")
    ImGui.Dummy(1, 5)


    if ImGui.Button("启动差事: 别惹德瑞") then
        script.run_in_fiber(function()
            if not CAN_LAUNCH_MISSION() then
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

            -- local Data = {
            --     iRootContentID = 1645353926, -- Tunable: FIXER_INSTANCED_STORY_MISSION_ROOT_CONTENT_ID5
            --     iMissionType = 0,            -- FMMC_TYPE_MISSION
            --     iMissionEnteryType = 81,     -- ciMISSION_ENTERY_TYPE_FIXER_WORLD_TRIGGER
            -- }

            LAUNCH_MISSION(1645353926) -- Tunable: FIXER_INSTANCED_STORY_MISSION_ROOT_CONTENT_ID5
            notify("启动差事", "请稍等...")
        end)
    end
    ImGui.SameLine()
    ImGui.Text("要求: 1. 注册为老大; 2. 拥有事务所")
    ImGui.Dummy(1, 5)


    if ImGui.Button("启动差事: 佩里科岛抢劫") then
        script.run_in_fiber(function()
            if not CAN_LAUNCH_MISSION() then
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

            -- local Data = {
            --     iRootContentID = -1172878953, -- Tunable: H4_ROOT_CONTENT_ID_0
            --     iMissionType = 260,           -- FMMC_TYPE_HEIST_ISLAND_FINALE
            --     iMissionEnteryType = 67,      -- ciMISSION_ENTERY_TYPE_HEIST_ISLAND_TABLE
            -- }

            LAUNCH_MISSION(-1172878953) -- Tunable: H4_ROOT_CONTENT_ID_0
            notify("启动差事", "请稍等...")
        end)
    end
    ImGui.SameLine()
    ImGui.Text("要求: 1. 注册为老大; 2. 拥有虎鲸; 3. 在虎鲸内部;")

    if ImGui.Button("佩里科岛抢劫 设置终章面板") then
        IslandHeistConfig.menu.showUI = not IslandHeistConfig.menu.showUI
    end
    ImGui.SameLine()
    ImGui.Text("如果没有完成必须前置，需要设置终章面板后才可点击继续按钮")

    if IslandHeistConfig.menu.showUI then
        IslandHeistConfig.menu.drawUI()
    end
    ImGui.Dummy(1, 5)


    HeistMissionSelect.apartmentFinal = ImGui.Combo("选择公寓抢劫任务", HeistMissionSelect.apartmentFinal, {
        "全福银行差事", "越狱", "突袭人道研究实验室", "首轮募资", "太平洋标准银行差事"
    }, 5)

    if ImGui.Button("启动差事: 公寓抢劫任务 终章") then
        script.run_in_fiber(function()
            if not CAN_LAUNCH_MISSION() then
                return
            end

            local ApartmentHeistFinal = {
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

            local ContentID = ApartmentHeistFinal[HeistMissionSelect.apartmentFinal]
            LAUNCH_APARTMENT_HEIST(ContentID)
            notify("启动差事", "请稍等...")
        end)
    end
    ImGui.SameLine()
    if ImGui.Button("跳过动画 (点击 开始游戏 之前使用)") then
        GLOBAL_SET_BIT(g_TransitionSessionNonResetVars.sTransVars.iCoronaBitSet + 1 + 4, 0)   -- CORONA_HEIST_CUTSCENE_HAS_BEEN_VALIDATED
        GLOBAL_CLEAR_BIT(g_TransitionSessionNonResetVars.sTransVars.iCoronaBitSet + 1 + 4, 1) -- CORONA_HEIST_FINALE_CUTSCENE_CAN_PLAY
    end
    ImGui.Text("要求: 1. 需要在公寓内部 抢劫计划面板附近; 2. 启动差事后右下角没有提示下载，就动两下")
    ImGui.Dummy(1, 5)


    HeistMissionSelect.autoShop = ImGui.Combo("选择改装铺合约", HeistMissionSelect.autoShop, {
        "联合储蓄合约", "大钞交易", "银行合约", "电控单元差事", "监狱合约", "IAA 交易", "失落摩托帮合约", "数据合约"
    }, 8, 5)

    if ImGui.Button("启动差事: 改装铺抢劫") then
        script.run_in_fiber(function()
            if not CAN_LAUNCH_MISSION() then
                return
            end

            local AutoShopFinal = {
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

            LAUNCH_MISSION(AutoShopFinal[HeistMissionSelect.autoShop])
            notify("启动差事", "请稍等...")
        end)
    end
    ImGui.SameLine()
    ImGui.Text("要求: 1. 注册为老大; 2. 拥有改装铺; 3. 在改装铺内部")
    ImGui.Dummy(1, 5)


    HeistMissionSelect.doomsdayFinal = ImGui.Combo("选择末日豪劫终章", HeistMissionSelect.doomsdayFinal, {
        "数据泄露", "波格丹危机", "末日将至"
    }, 3)
    if ImGui.Button("启动差事: 末日豪劫 终章") then
        script.run_in_fiber(function()
            if not CAN_LAUNCH_MISSION() then
                return
            end

            local DoomsdayHeistFinal = {
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

            LAUNCH_MISSION(DoomsdayHeistFinal[HeistMissionSelect.doomsdayFinal])
            notify("启动差事", "请稍等...")
        end)
    end
    ImGui.SameLine()
    ImGui.Text("要求: 1. 注册为老大; 2. 拥有设施; 3. 在设施内部")

    HeistMissionSelect.doomsdaySetup = ImGui.Combo("选择末日豪劫准备任务", HeistMissionSelect.doomsdaySetup, {
        "亡命速递", "拦截信号", "服务器群组",
        "复仇者", "营救 ULP", "抢救硬盘", "潜水艇侦察",
        "营救 14 号探员", "护送 ULP", "巴拉杰", "可汗贾利", "空中防御"
    }, 12, 5)
    if ImGui.Button("启动差事: 末日豪劫 准备任务") then
        script.run_in_fiber(function()
            if not CAN_LAUNCH_MISSION() then
                return
            end

            local DoomsdayHeistSetup = {
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

            LAUNCH_MISSION(DoomsdayHeistSetup[HeistMissionSelect.doomsdaySetup])
            notify("启动差事", "请稍等...")
        end)
    end
    ImGui.SameLine()
    ImGui.Text("要求: 1. 注册为老大; 2. 拥有设施; 3. 在设施内部")
    ImGui.Dummy(1, 5)

    HeistMissionSelect.mission = ImGui.Combo("选择差事任务", HeistMissionSelect.mission, {
        "犯罪现场 (潜行)", "犯罪现场 (强攻)",
        "头号通缉犯：惠特尼", "头号通缉犯：里伯曼", "头号通缉犯：奥尼尔", "头号通缉犯：汤普森", "头号通缉犯：宋", "头号通缉犯：加西亚"
    }, 8, 5)
    if ImGui.Button("启动差事任务") then
        script.run_in_fiber(function()
            if not CAN_LAUNCH_MISSION() then
                return
            end

            local MissionRootContentIDHash = {
                [0] = 13546844,    -- Tunable: SALV23_CHICKEN_FACTORY_RAID_ROOT_CONTENT_ID_6
                [1] = 2107866924,  -- Tunable: SALV23_CHICKEN_FACTORY_RAID_ROOT_CONTENT_ID_5
                [2] = -1814367299, -- Tunable: 1246442820
                [3] = -1443228923, -- Tunable: 950440443
                [4] = -625494467,  -- Tunable: 1992953409
                [5] = -1381858108, -- Tunable: 1693084290
                [6] = 1585225527,  -- Tunable: 59877330
                [7] = -62594295,   -- Tunable: -243334227
            }

            LAUNCH_MISSION(MissionRootContentIDHash[HeistMissionSelect.mission])
            notify("启动差事", "请稍等...")
        end)
    end
end)




--------------------------------------------------------
--                AUTOMATIC HEIST
--------------------------------------------------------

local menu_automation <const> = menu_root:add_tab("[RSM] 自动化任务")

--------------------
-- Globals
--------------------

local bTransitionSessionSkipLbAndNjvs = g_sTransitionSessionData + 702

g_HeistPlanningClient.bLaunchTimerExpired = 1931285 + 2812

local function GET_CORONA_STATUS()
    return GLOBAL_GET_INT(Globals.GlobalplayerBD_FM() + 193)
end

--------------------
-- Locals
--------------------

local _coronaMenuData = 17602
local coronaMenuData = {
    iCurrentSelection = _coronaMenuData + 920
}



local function _REGISTER_AS_A_CEO()
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
        local g_Private_Players_FM_SESSION_Menu_Choice = 1575036
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




local CORONA_STATUS_ENUM = {
    CORONA_STATUS_IDLE = 0,
    CORONA_STATUS_INTRO = 9,
    CORONA_STATUS_TEAM_DM = 26,
    CORONA_STATUS_HEIST_PLANNING = 27,
    CORONA_STATUS_GENERIC_HEIST_PLANNING = 34
}




--------------------------------
-- Auto Island Heist
--------------------------------

menu_automation:add_text("<<  全自动佩里科岛抢劫  >>")

menu_automation:add_text("*仅适用于单人*")
menu_automation:add_text("要求: 1. 开启后无需任何操作，只需等待任务结束")

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

    AutoIslandHeist.setting.rewardValue = get_input_value(AutoIslandHeist.menu.rewardValue, 0, 2550000)
    AutoIslandHeist.setting.addRandom = AutoIslandHeist.menu.addRandom:is_enabled()
    AutoIslandHeist.setting.disableCut = AutoIslandHeist.menu.disableCut:is_enabled()
    AutoIslandHeist.setting.delay = get_input_value(AutoIslandHeist.menu.delay, 0, 5000)


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
                    GB_BOSS_REGISTER()

                    AutoIslandHeist.notify("注册为CEO...")
                    AutoIslandHeist.setStatus(AutoIslandHeistStatus.RegisterAsCEO)
                else
                    -- local Data = {
                    --     iRootContentID = -1172878953, -- HIM_STUB
                    --     iMissionType = 260,           -- FMMC_TYPE_HEIST_ISLAND_FINALE
                    --     iMissionEnteryType = 67,      -- ciMISSION_ENTERY_TYPE_HEIST_ISLAND_TABLE
                    -- }
                    LAUNCH_MISSION(-1172878953)

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
                    GLOBAL_SET_INT(g_FMMC_STRUCT.iDifficulity, 1)

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
    GLOBAL_SET_INT(g_FMMC_STRUCT.iDifficulity, 2)
    -- First Person
    GLOBAL_SET_INT(g_FMMC_STRUCT.iFixedCamera, 1)
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
    MenuHMission.SetMinPlayers = AutoApartmentHeist.minPlayers
    MenuHMission.SetMaxTeams = AutoApartmentHeist.maxTeams

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

    AutoApartmentHeist.minPlayers = MenuHMission.SetMinPlayers
    AutoApartmentHeist.maxTeams = MenuHMission.SetMaxTeams

    MenuHMission.SetMinPlayers = true
    MenuHMission.SetMaxTeams = true

    AutoApartmentHeist.setting.delay = get_input_value(AutoApartmentHeist.menu.delay, 0, 5000)

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





--------------------------------------------------------
--                MISC MENU
--------------------------------------------------------

local menu_misc <const> = menu_root:add_tab("[RSM] 其它")

local MenuMisc = {}

menu_misc:add_text("<<  CEO 工具  >>")
menu_misc:add_button("注册为 CEO/VIP", function()
    if not IS_PLAYER_BOSS_OF_A_GANG() then
        GB_BOSS_REGISTER(0)
    end
end)
menu_misc:add_sameline()
menu_misc:add_button("注册为 摩托帮首领", function()
    if not IS_PLAYER_BOSS_OF_A_GANG() then
        GB_BOSS_REGISTER(1)
    end
end)
menu_misc:add_sameline()
menu_misc:add_button("退出注册", function()
    if IS_PLAYER_BOSS_OF_A_GANG() then
        GB_BOSS_RETIRE()
    end
end)

MenuMisc["CeoVehicleModel"] = menu_misc:add_input_string("CEO 载具模型名称/Hash")
MenuMisc["CeoVehicleModel"]:set_value("oppressor2")
menu_misc:add_button("请求 CEO 载具", function()
    script.run_in_fiber(function()
        local model = MenuMisc["CeoVehicleModel"]:get_value()
        if model ~= tonumber(model) then
            model = joaat(model)
        end
        if not STREAMING.IS_MODEL_A_VEHICLE(model) then
            notify("请求 CEO 载具", "载具模型 Hash 错误")
            return
        end
        if not IS_PLAYER_BOSS_OF_A_GANG() then
            notify("请求 CEO 载具", "你还未注册为 CEO")
            return
        end

        network.trigger_script_event(1 << PLAYER.PLAYER_ID(), {
            -1140090124, -- SCRIPT_EVENT_REQUEST_BOSS_LIMO
            PLAYER.PLAYER_ID(),
            -1,
            model, -- vehicleModel
            true   -- bIgnoreDistanceChecks
        })
        notify("请求 CEO 载具", "已请求")
    end)
end)


menu_misc:add_separator()
menu_misc:add_text("<<  零食和护甲  >>")
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


menu_misc:add_separator()
menu_misc:add_text("<<  限制任务差事收入  >>")
MenuMisc["MissionEarningHigh"] = menu_misc:add_input_int("最高收入")
MenuMisc["MissionEarningLow"] = menu_misc:add_input_int("最低收入")
MenuMisc["MissionEarningModifier"] = menu_misc:add_checkbox("开启限制差事收入 [0 ~ 15000000]")
menu_misc:add_sameline()
menu_misc:add_button("取消差事收入限制", function()
    MenuMisc["MissionEarningModifier"]:set_enabled(false)

    GLOBAL_SET_FLOAT(Tunables["HIGH_ROCKSTAR_MISSIONS_MODIFIER"], 0)
    GLOBAL_SET_FLOAT(Tunables["LOW_ROCKSTAR_MISSIONS_MODIFIER"], 0)
end)
menu_misc:add_text("数值为0, 则不进行限制; 限制最低收入后, 差事最终结算时最低收入就为设置的值;")


menu_misc:add_separator()
menu_misc:add_text("<<  增强选项  >>")
MenuMisc["SpeedDial"] = menu_misc:add_checkbox("快速拨号")
menu_misc:add_sameline()
menu_misc:add_button("离开当前室内", function()
    GLOBAL_SET_BOOL(g_SimpleInteriorData.bTriggerExit, true)
end)
menu_misc:add_sameline()
menu_misc:add_button("移除自由模式横幅通知", function()
    script.run_in_fiber(function()
        scr_function.call_script_function("freemode",
            "CLEAR_ALL_BIG_MESSAGES",
            "2D 00 03 00 00 71 39 02 38 02 74 5C 3A 00 38 02 61",
            "void", {})
    end)
end)



local Patcher = {}

add_toggle_button(menu_misc, "移除洛圣都改车王限制", function(toggle)
    local patch_name1 = "CAN_WE_USE_THIS_VEHICLE"
    local patch_name2 = "SHOULD_CARMOD_MENU_OPTION_BE_BLOCKED"

    if toggle then
        if Patcher[patch_name1] and Patcher[patch_name2] then
            Patcher[patch_name1]:enable_patch()
            Patcher[patch_name2]:enable_patch()
        else
            Patcher[patch_name1] = scr_patch:new("carmod_shop",
                "CAN_WE_USE_THIS_VEHICLE",
                "2D 03 16 00 00 38 00 5D ? ? ? 56 04 00 71",
                5,
                { 0x72, 0x2E, 0x03, 0x01 })

            Patcher[patch_name2] = scr_patch:new("carmod_shop",
                "SHOULD_CARMOD_MENU_OPTION_BE_BLOCKED",
                "2D 01 04 00 00 38 00 5D ? ? ? 5D ? ? ? 56 04 00 72 2E 01 01",
                5,
                { 0x71, 0x2E, 0x01, 0x01 })
        end
    else
        Patcher[patch_name1]:disable_patch()
        Patcher[patch_name2]:disable_patch()
    end
end)
menu_misc:add_sameline()
menu_misc:add_text("允许你驾驶任意载具进入洛圣都改车王进行改装")

add_toggle_button(menu_misc, "修补单人赌场无法设置终章面板问题", function(toggle)
    local patch_name = "SHOULD_CORONA_JOB_LAUNCH_AFTER_TRANSITION"

    if toggle then
        if Patcher[patch_name] then
            Patcher[patch_name]:enable_patch()
        else
            Patcher[patch_name] = scr_patch:new("fmmc_launcher",
                "SHOULD_CORONA_JOB_LAUNCH_AFTER_TRANSITION",
                "2D 01 03 00 00 5D ? ? ? 2A 06 56 05 00 5D ? ? ? 20 2A 06 56 05 00 5D",
                5,
                { 0x71, 0x2E, 0x01, 0x01 })
        end
    else
        Patcher[patch_name]:disable_patch()
    end
end)
menu_misc:add_sameline()
menu_misc:add_text("注意！确保在开始任务前开启，任务结束后关闭！不建议一直开启！")






--------------------------------
-- Loop Script
--------------------------------

script.register_looped("RS_Missions.Main", function()
    if MenuHMission.SetMinPlayers then
        local script_name = "fmmc_launcher"
        if IS_SCRIPT_RUNNING(script_name) then
            local iArrayPos = LOCAL_GET_INT(script_name, sLaunchMissionDetails.iMissionVariation)
            if iArrayPos > 0 then
                if GLOBAL_GET_INT(g_FMMC_ROCKSTAR_CREATED.sMissionHeaderVars + iArrayPos * 89 + 69) > 1 then
                    GLOBAL_SET_INT(g_FMMC_ROCKSTAR_CREATED.sMissionHeaderVars + iArrayPos * 89 + 69, 1)
                    LOCAL_SET_INT(script_name, sLaunchMissionDetails.iMinPlayers, 1)
                end

                GLOBAL_SET_INT(g_FMMC_STRUCT.iMinNumParticipants, 1)
                GLOBAL_SET_INT(g_FMMC_STRUCT.iNumPlayersPerTeam, 1)
                GLOBAL_SET_INT(g_FMMC_STRUCT.iCriticalMinimumForTeam, 0)
            end
        end
    end

    if MenuHMission.SetMaxTeams then
        GLOBAL_SET_INT(g_FMMC_STRUCT.iNumberOfTeams, 1)
        GLOBAL_SET_INT(g_FMMC_STRUCT.iMaxNumberOfTeams, 1)
    end

    if MenuHMission.DisableMissionAggroFail then
        FM_MISSION_CONTROLLER.RUN(function(mission_script)
            LOCAL_CLEAR_BITS(mission_script, Locals[mission_script].iServerBitSet1, 24, 28)
        end)
    end

    if MenuHMission.DisableMissionFail then
        FM_MISSION_CONTROLLER.RUN(function(mission_script)
            LOCAL_SET_BIT(mission_script, Locals[mission_script].iLocalBoolCheck11, 7)
        end)
    end

    if MenuHMission.LockObjectiveLimitTimer then
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

    if MenuMisc["SpeedDial"]:is_enabled() then
        GLOBAL_SET_INT(Globals.g_Outgoing_Call_Pause_Answering_Time, 0)
    end
end)

script.register_looped("RS_Missions.MissionEarning", function()
    local earning_max = get_input_value(MenuMisc["MissionEarningHigh"], 0, 15000000)
    local earning_min = get_input_value(MenuMisc["MissionEarningLow"], 0, 15000000)

    if MenuMisc["MissionEarningModifier"]:is_enabled() then
        if earning_max ~= 0 then
            GLOBAL_SET_FLOAT(Tunables["HIGH_ROCKSTAR_MISSIONS_MODIFIER"], earning_max)
        end
        if earning_min ~= 0 then
            GLOBAL_SET_FLOAT(Tunables["LOW_ROCKSTAR_MISSIONS_MODIFIER"], earning_min)
        end
    end
end)



--------------------------------
-- Menu Event
--------------------------------

event.register_handler(menu_event.ScriptsReloaded, function()
    if Patcher["CAN_WE_USE_THIS_VEHICLE"] and Patcher["SHOULD_CARMOD_MENU_OPTION_BE_BLOCKED"] then
        Patcher["CAN_WE_USE_THIS_VEHICLE"]:disable_patch()
        Patcher["SHOULD_CARMOD_MENU_OPTION_BE_BLOCKED"]:disable_patch()
    end

    if Patcher["SHOULD_CORONA_JOB_LAUNCH_AFTER_TRANSITION"] then
        Patcher["SHOULD_CORONA_JOB_LAUNCH_AFTER_TRANSITION"]:disable_patch()
    end
end)
