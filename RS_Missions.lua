--------------------------------
-- Author: Rostal
--------------------------------

local SUPPORT_GAME_VERSION <const> = "1.68-3095"


--#region check game version

local online_version = NETWORK.GET_ONLINE_VERSION()
local build_version = memory.scan_pattern("8B C3 33 D2 C6 44 24 20"):add(0x24):rip()
local CURRENT_GAME_VERSION <const> = string.format("%s-%s", online_version, build_version:get_string())

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
-- Misc Functions
--------------------------------

function IS_SCRIPT_RUNNING(script_name)
    return SCRIPT.GET_NUMBER_OF_THREADS_RUNNING_THE_SCRIPT_WITH_THIS_HASH(joaat(script_name)) > 0
end

function IS_MISSION_CONTROLLER_SCRIPT_RUNNING()
    return IS_SCRIPT_RUNNING("fm_mission_controller_2020") or IS_SCRIPT_RUNNING("fm_mission_controller")
end

--#endregion


--#region game variables (The shit that needs to be updated with the game version)

-- FMMC_GLOBAL_STRUCT
local g_FMMC_STRUCT <const> = 4718592
local FMMC_STRUCT <const> = {
    iMinNumParticipants = g_FMMC_STRUCT + 3249,
    iNumberOfTeams = g_FMMC_STRUCT + 3252,
    iMaxNumberOfTeams = g_FMMC_STRUCT + 3253,
    iNumPlayersPerTeam = g_FMMC_STRUCT + 3255 + 1, -- +[0~3]
    iRootContentIDHash = g_FMMC_STRUCT + 126144,
    tl63MissionName = g_FMMC_STRUCT + 126151,
    tl31LoadedContentID = g_FMMC_STRUCT + 126431,
    tl23NextContentID = g_FMMC_STRUCT + 126459 + 1,      -- +[0~5]
    iCriticalMinimumForTeam = g_FMMC_STRUCT + 176675 + 1 -- +[0~3]
}

-- FMMC_ROCKSTAR_CREATED_STRUCT
local g_FMMC_ROCKSTAR_CREATED <const> = 794744
local FMMC_ROCKSTAR_CREATED <const> = {
    sMissionHeaderVars = g_FMMC_ROCKSTAR_CREATED + 4 + 1, -- +[iArrayPos]
}

-- TRANSITION_SESSION_NON_RESET_VARS
local g_TransitionSessionNonResetVars <const> = 2685249

-- FMMC_STRAND_MISSION_DATA
local g_sTransitionSessionData <const> = 2684312
local sStrandMissionData <const> = g_sTransitionSessionData + 43
local StrandMissionData <const> = {
    bPassedFirstMission = sStrandMissionData + 55,
    bPassedFirstStrandNoReset = sStrandMissionData + 56,
    bIsThisAStrandMission = sStrandMissionData + 57,
    bLastMission = sStrandMissionData + 58
}

-- MISSION_TO_LAUNCH_DETAILS
local sLaunchMissionDetails <const> = 19331
local LaunchMissionDetails <const> = {
    iMinPlayers = sLaunchMissionDetails + 15,
    iMissionVariation = sLaunchMissionDetails + 34
}

local Locals <const> = {
    ["fm_mission_controller"] = {
        iNextMission = 19728 + 1062,

        iTeamScore = 19728 + 1232 + 1, -- +[0~3]
        iServerBitSet = 19728 + 1,
        iServerBitSet1 = 19728 + 2,

        iLocalBoolCheck11 = 15149
    },
    ["fm_mission_controller_2020"] = {
        iNextMission = 48513 + 1578,

        iTeamScore = 48513 + 1765 + 1, -- +[0~3]
        iServerBitSet = 48513 + 1,
        iServerBitSet1 = 48513 + 2,

        iLocalBoolCheck11 = 47286
    }
}


local g_sMPTunables <const> = 262145
local Tunables <const> = {
    ["HIGH_ROCKSTAR_MISSIONS_MODIFIER"] = g_sMPTunables + 2430,
    ["LOW_ROCKSTAR_MISSIONS_MODIFIER"] = g_sMPTunables + 2434,
}


local function LAUNCH_MISSION(Data)
    notify("启动差事", "请稍等...")

    local iArrayPos = MISC.GET_CONTENT_ID_INDEX(Data.iRootContentID)

    local tlName = GLOBAL_GET_STRING(FMMC_ROCKSTAR_CREATED.sMissionHeaderVars + iArrayPos * 89)
    local iMaxPlayers = GLOBAL_GET_INT(FMMC_ROCKSTAR_CREATED.sMissionHeaderVars + iArrayPos * 89 + 71)

    GLOBAL_SET_INT(g_TransitionSessionNonResetVars + 3836, 1)
    GLOBAL_SET_INT(2693219 + 1, 0)
    GLOBAL_SET_BIT(g_sTransitionSessionData + 3, 2)
    GLOBAL_SET_INT(1057441, Data.iMissionEnteryType)

    if Data.iMissionType == 274 then
        GLOBAL_SET_BIT(g_sTransitionSessionData + 3, 13)
        GLOBAL_SET_BIT(1882422 + 1 + PLAYER.PLAYER_ID() * 142 + 30, 28)
    end

    GLOBAL_SET_INT(g_sTransitionSessionData + 9, Data.iMissionType)
    GLOBAL_SET_STRING(g_sTransitionSessionData + 860, tlName)
    GLOBAL_SET_INT(g_sTransitionSessionData + 42, iMaxPlayers)
    GLOBAL_CLEAR_BIT(g_sTransitionSessionData + 2, 14)
    GLOBAL_SET_BIT(g_sTransitionSessionData, 5)
    GLOBAL_SET_BIT(g_sTransitionSessionData, 8)
    GLOBAL_CLEAR_BIT(g_sTransitionSessionData, 7)
    GLOBAL_CLEAR_BIT(g_sTransitionSessionData, 15)
    GLOBAL_SET_INT(g_sTransitionSessionData + 717, 1)

    GLOBAL_SET_INT(1845263 + 1 + PLAYER.PLAYER_ID() * 877 + 95, 8)
end

local function LAUNCH_DOOMSDAY_HEIST_MISSION(Data)
    notify("启动差事", "请稍等...")

    local iArrayPos = MISC.GET_CONTENT_ID_INDEX(Data.iRootContentID)

    local tlName = GLOBAL_GET_STRING(FMMC_ROCKSTAR_CREATED.sMissionHeaderVars + iArrayPos * 89)
    local iMaxPlayers = GLOBAL_GET_INT(FMMC_ROCKSTAR_CREATED.sMissionHeaderVars + iArrayPos * 89 + 71)

    GLOBAL_SET_BIT(g_sTransitionSessionData + 2, 29)
    GLOBAL_SET_INT(g_sTransitionSessionData + 9, Data.iMissionType)
    GLOBAL_SET_STRING(g_sTransitionSessionData + 860, tlName)
    GLOBAL_SET_INT(g_sTransitionSessionData + 42, iMaxPlayers)
    GLOBAL_CLEAR_BIT(g_sTransitionSessionData + 2, 14)
    GLOBAL_SET_BIT(g_sTransitionSessionData, 5)
    GLOBAL_SET_BIT(g_sTransitionSessionData, 8)
    GLOBAL_CLEAR_BIT(g_sTransitionSessionData, 7)
    GLOBAL_CLEAR_BIT(g_sTransitionSessionData, 15)
    GLOBAL_SET_INT(g_sTransitionSessionData + 718, 0)
    GLOBAL_SET_INT(g_sTransitionSessionData + 717, 1)
    GLOBAL_SET_BIT(g_sTransitionSessionData + 3, 4)

    GLOBAL_SET_INT(1845263 + 1 + PLAYER.PLAYER_ID() * 877 + 95, 8)
end

local function IS_PLAYER_BOSS_OF_A_GANG()
    return globals.get_int(1886967 + 1 + PLAYER.PLAYER_ID() * 609 + 10) == PLAYER.PLAYER_ID()
end


--#endregion



--------------------------------
-- Menu: Main
--------------------------------

local menu_root <const> = gui.add_tab("RS Missions")

menu_root:add_text("支持的GTA版本: " .. SUPPORT_GAME_VERSION)
menu_root:add_text("当前GTA版本: " .. CURRENT_GAME_VERSION)
local status_text = IS_SUPPORT and "支持" or "不支持当前游戏版本, 请停止使用"
menu_root:add_text("状态: " .. status_text)



--------------------------------
-- Menu: Heist Mission
--------------------------------

local menu_mission <const> = menu_root:add_tab("[RSM] 抢劫任务")

local MenuMission = {}

menu_mission:add_text("*所有功能均在单人战局测试可用*")


menu_mission:add_text("<<  通用  >>")

MenuMission["SetMinPlayers"] = menu_mission:add_checkbox("最小玩家数为 1 (强制任务单人可开)")
menu_mission:add_sameline()
MenuMission["SetMaxTeams"] = menu_mission:add_checkbox("最大团队数为 1 (用于多团队任务)")

menu_mission:add_button("直接完成任务 (通用)", function()
    local mission_script = "fm_mission_controller_2020"
    if not IS_SCRIPT_RUNNING(mission_script) then
        mission_script = "fm_mission_controller"
        if not IS_SCRIPT_RUNNING(mission_script) then
            return
        end
    end

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
    LOCAL_SET_INT(mission_script, Locals[mission_script].iNextMission, 6)

    LOCAL_SET_BIT(mission_script, Locals[mission_script].iLocalBoolCheck11, 7)

    for i = 0, 3 do
        LOCAL_SET_INT(mission_script, Locals[mission_script].iTeamScore + i, 999999)
    end

    LOCAL_SET_BITS(mission_script, Locals[mission_script].iServerBitSet, 9, 10, 11, 12, 16)
end)
menu_mission:add_sameline()
menu_mission:add_button("跳到下一个检查点 (解决单人任务卡关问题)", function()
    local mission_script = "fm_mission_controller_2020"
    if not IS_SCRIPT_RUNNING(mission_script) then
        mission_script = "fm_mission_controller"
        if not IS_SCRIPT_RUNNING(mission_script) then
            return
        end
    end

    LOCAL_SET_BIT(mission_script, Locals[mission_script].iServerBitSet1, 17)
end)

MenuMission["DisableMissionAggroFail"] = menu_mission:add_checkbox("禁止因触发惊动而任务失败")
menu_mission:add_sameline()
MenuMission["DisableMissionFail"] = menu_mission:add_checkbox("禁止任务失败")
menu_mission:add_sameline()
menu_mission:add_button("允许任务失败", function()
    MenuMission["DisableMissionFail"]:set_enabled(false)

    local mission_script = "fm_mission_controller_2020"
    if not IS_SCRIPT_RUNNING(mission_script) then
        mission_script = "fm_mission_controller"
        if not IS_SCRIPT_RUNNING(mission_script) then
            return
        end
    end

    LOCAL_CLEAR_BIT(mission_script, Locals[mission_script].iLocalBoolCheck11, 7)
end)


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

    LAUNCH_DOOMSDAY_HEIST_MISSION(Data)
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

    LAUNCH_DOOMSDAY_HEIST_MISSION(Data)
end)
menu_mission:add_sameline()
menu_mission:add_text("要求: 1. 注册为老大; 2. 拥有设施; 3. 在设施内部")


menu_mission:add_separator()
menu_mission:add_text("<<  限制差事收入  >>")
MenuMission["MissionEarningHigh"] = menu_mission:add_input_int("最高收入")
MenuMission["MissionEarningLow"] = menu_mission:add_input_int("最低收入")
MenuMission["MissionEarningModifier"] = menu_mission:add_checkbox("开启限制差事收入 (范围: 0~15000000)")
menu_mission:add_sameline()
menu_mission:add_button("取消差事收入限制", function()
    MenuMission["MissionEarningModifier"]:set_enabled(false)

    GLOBAL_SET_FLOAT(Tunables["HIGH_ROCKSTAR_MISSIONS_MODIFIER"], 0)
    GLOBAL_SET_FLOAT(Tunables["LOW_ROCKSTAR_MISSIONS_MODIFIER"], 0)
end)

menu_mission:add_text("数值为0, 则不进行限制; 限制最低收入后, 差事最终结算时最低收入就为设置的值;")






--------------------------------
-- Loop Script
--------------------------------

script.register_looped("RS_Missions.Main", function()
    if not IS_SUPPORT then
        return false
    end

    if MenuMission["SetMinPlayers"]:is_enabled() then
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

    if MenuMission["SetMaxTeams"]:is_enabled() then
        GLOBAL_SET_INT(FMMC_STRUCT.iNumberOfTeams, 1)
        GLOBAL_SET_INT(FMMC_STRUCT.iMaxNumberOfTeams, 1)
    end

    if MenuMission["DisableMissionAggroFail"]:is_enabled() then
        local mission_script = "fm_mission_controller_2020"
        if not IS_SCRIPT_RUNNING(mission_script) then
            mission_script = "fm_mission_controller"
            if not IS_SCRIPT_RUNNING(mission_script) then
                return
            end
        end

        LOCAL_CLEAR_BITS(mission_script, Locals[mission_script].iServerBitSet1, 24, 28)
    end

    if MenuMission["DisableMissionFail"]:is_enabled() then
        local mission_script = "fm_mission_controller_2020"
        if not IS_SCRIPT_RUNNING(mission_script) then
            mission_script = "fm_mission_controller"
            if not IS_SCRIPT_RUNNING(mission_script) then
                return
            end
        end

        LOCAL_SET_BIT(mission_script, Locals[mission_script].iLocalBoolCheck11, 7)
    end
end)

script.register_looped("RS_Missions.Mission_Earning", function()
    if not IS_SUPPORT then
        return false
    end

    local earning_max = MenuMission["MissionEarningHigh"]:get_value()
    local earning_min = MenuMission["MissionEarningLow"]:get_value()

    if earning_max < 0 then
        MenuMission["MissionEarningHigh"]:set_value(0)
    elseif earning_max > 15000000 then
        MenuMission["MissionEarningHigh"]:set_value(15000000)
    end

    if earning_min < 0 then
        MenuMission["MissionEarningLow"]:set_value(0)
    elseif earning_min > 15000000 then
        MenuMission["MissionEarningLow"]:set_value(15000000)
    end

    if MenuMission["MissionEarningModifier"]:is_enabled() then
        if earning_max ~= 0 then
            GLOBAL_SET_FLOAT(Tunables["HIGH_ROCKSTAR_MISSIONS_MODIFIER"], earning_max)
        end
        if earning_min ~= 0 then
            GLOBAL_SET_FLOAT(Tunables["LOW_ROCKSTAR_MISSIONS_MODIFIER"], earning_min)
        end
    end
end)


if not IS_SUPPORT then
    menu_mission:clear()
end
