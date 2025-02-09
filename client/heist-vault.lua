cartLayout = 0
vaultLayout = 0
isInVault = false

isBusy = false

status = {
    {
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0
    },
    {
        false,
        false,
        false,
        false,
        false,
        false,
        false
    }
}

local doorHash = {}
local ptfx = {}
local test = {}
local takeObjs = {}
local paintingObjs = {}
local slideDoorObjs = {}
local blips = {}

local paintingNames = {
    "ch_prop_vault_painting_01a",
    "ch_prop_vault_painting_01d",
    "ch_prop_vault_painting_01f",
    "ch_prop_vault_painting_01g",
    "ch_prop_vault_painting_01h",
    "ch_prop_vault_painting_01i",
}

local paintingAnims = {
    {
        -- Player, Knife, Painting, Bag, Cam
        {"ver_01_top_left_enter",               "ver_01_top_left_enter_w_me_switchblade",                   "ver_01_top_left_enter_ch_prop_vault_painting_01a",                 "ver_01_top_left_enter_hei_p_m_bag_var22_arm_s",                "ver_01_top_left_enter_ch_prop_ch_sec_cabinet_02a",                "ver_01_top_left_enter_cam"}, -- Enter top left
        {"ver_01_cutting_top_left_idle",        "ver_01_cutting_top_left_idle_w_me_switchblade",            "ver_01_cutting_top_left_idle_ch_prop_vault_painting_01a",          "ver_01_cutting_top_left_idle_hei_p_m_bag_var22_arm_s",         "ver_01_cutting_top_left_idle_ch_prop_ch_sec_cabinet_02a",         "ver_01_cutting_top_left_idle_cam"}, -- Idle top left
        {"ver_01_cutting_top_left_to_right",    "ver_01_cutting_top_left_to_right_w_me_switchblade",        "ver_01_cutting_top_left_to_right_ch_prop_vault_painting_01a",      "ver_01_cutting_top_left_to_right_hei_p_m_bag_var22_arm_s",     "ver_01_cutting_top_left_to_right_ch_prop_ch_sec_cabinet_02a",     "ver_01_cutting_top_left_to_right_cam"}, -- Cut top left to right
        {"ver_01_cutting_top_right_idle",       "ver_01_cutting_top_right_idle_w_me_switchblade",           "ver_01_cutting_top_right_idle_ch_prop_vault_painting_01a",         "ver_01_cutting_top_right_idle_hei_p_m_bag_var22_arm_s",        "ver_01_cutting_top_right_idle_ch_prop_ch_sec_cabinet_02a",        "ver_01_cutting_top_right_idle_cam"}, -- Idle top right
        {"ver_01_cutting_right_top_to_bottom",  "ver_01_cutting_right_top_to_bottom_w_me_switchblade",      "ver_01_cutting_right_top_to_bottom_ch_prop_vault_painting_01a",    "ver_01_cutting_right_top_to_bottom_hei_p_m_bag_var22_arm_s",   "ver_01_cutting_right_top_to_bottom_ch_prop_ch_sec_cabinet_02a",   "ver_01_cutting_right_top_to_bottom_cam"}, -- Cut top right to bottom
        {"ver_01_cutting_bottom_right_idle",    "ver_01_cutting_bottom_right_idle_w_me_switchblade",        "ver_01_cutting_bottom_right_idle_ch_prop_vault_painting_01a",      "ver_01_cutting_bottom_right_idle_hei_p_m_bag_var22_arm_s",     "ver_01_cutting_bottom_right_idle_ch_prop_ch_sec_cabinet_02a",     "ver_01_cutting_bottom_right_idle_cam"}, -- Idle bottom right
        {"ver_01_cutting_bottom_right_to_left", "ver_01_cutting_bottom_right_to_left_w_me_switchblade",     "ver_01_cutting_bottom_right_to_left_ch_prop_vault_painting_01a",   "ver_01_cutting_bottom_right_to_left_hei_p_m_bag_var22_arm_s",  "ver_01_cutting_bottom_right_to_left_ch_prop_ch_sec_cabinet_02a",  "ver_01_cutting_bottom_right_to_left_cam"}, -- Cut top right to bottom
        {"ver_01_cutting_left_top_to_bottom",   "ver_01_cutting_left_top_to_bottom_w_me_switchblade",       "ver_01_cutting_left_top_to_bottom_ch_prop_vault_painting_01a",     "ver_01_cutting_left_top_to_bottom_hei_p_m_bag_var22_arm_s",    "ver_01_cutting_left_top_to_bottom_ch_prop_ch_sec_cabinet_02a",    "ver_01_cutting_left_top_to_bottom_cam"}, -- Cut top right to bottom
        {"ver_01_with_painting_exit",           "ver_01_with_painting_exit_w_me_switchblade",               "ver_01_with_painting_exit_ch_prop_vault_painting_01a",             "ver_01_with_painting_exit_hei_p_m_bag_var22_arm_s",            "ver_01_with_painting_exit_ch_prop_ch_sec_cabinet_02a",            "ver_01_with_painting_exit_cam"}, -- Cut top right to bottom
        
    }, 
    {}
}

local cartType = {
    {"ch_prop_ch_cash_trolly_01a", "ch_prop_ch_cash_trolly_01b", "ch_prop_ch_cash_trolly_01c"},
    {"ch_prop_gold_trolly_01a", "ch_prop_gold_trolly_01b", "ch_prop_gold_trolly_01c"},
    {},
    {"ch_prop_diamond_trolly_01a", "ch_prop_diamond_trolly_01b", "ch_prop_diamond_trolly_01c"} 
}

local function CartType(i)
    j = 0
    if i > 3 and i < 7 then 
        j = i - 3 
    elseif i > 6 then 
        j = i - 6
    else 
        j = i
    end

    return j
end

RegisterCommand("test_doorslide", function() 
    OpenSlideDoors("A", 1, "ch_prop_ch_vault_slide_door_lrg")
end, false)

local function GetVaultObjs()
    if loot == 3 then 
        for i = 1, #artCabinets do 
            takeObjs[i] = GetClosestObjectOfType(artCabinets[i].x, artCabinets[i].y, artCabinets[i].z, 1.0, GetHashKey("ch_prop_ch_sec_cabinet_02a"), false, false, false)
            paintingObjs[i] = GetClosestObjectOfType(paintings[i], 1.0, GetHashKey(paintingNames[i]), false, false, false)
            
            blips[i] = AddBlipForEntity(takeObjs[i])
            SetBlipSprite(blips[i], 534 + i)
            SetBlipScale(blips[i], 0.8)
            SetBlipColour(blips[i], 2)
        end 
    else 
        for i = 1, #carts[cartLayout] do 
            local j = CartType(i)

            takeObjs[i] = GetClosestObjectOfType(carts[cartLayout][i].x, carts[cartLayout][i].y, carts[cartLayout][i].z, 1.0, GetHashKey(cartType[loot][j]), false, false, false)
            
            blips[i] = AddBlipForCoord(carts[cartLayout][i].x, carts[cartLayout][i].y, carts[cartLayout][i].z)
            SetBlipSprite(blips[i], 534 + i)
            SetBlipColour(blips[i], 2)
            SetBlipScale(blips[i], 0.8)
        end
    end
end

local function GetGasCoords(num)
    if num == 1 then 
        return vector3(2521.0, -226.2, -71.7)
    elseif num == 2 then 
        return vector3(2533.4, -238.5, -71.7)
    elseif num == 3 then
        return vector3(2521.0, -250.9, -71.7)
    end 
end

local function GetGasRot(num)
    if num == 2 then 
        return vector3(0.0, 0.0, 90.0)
    else
        return vector3(0.0, 0.0, 0.0)
    end 
end

local function AreAllObjectsDone(num)
    local count = 0

    if not isInVault and isBusy then 
        return true 
    end

    if (loot == 3 and num == 1) or num == 2 then 
        count = 7
    else 
        count = 8
    end
    
    for i = 1, count do 
        if not status[num][i] or status[num][i] ~= 1.0 then 
            return false
        end
    end
    
    return true
end

local function RemoveAllBlips()
    for i = 1, #blips do 
        RemoveBlip(blips[i])
    end
end

local function SetVaultObjs()
    --loot = 1
    if loot == 3 then        
        LoadModel("ch_prop_ch_sec_cabinet_02a")

        for i = 1, #paintingNames do 
            LoadModel(paintingNames[i])
        end 

        for i = 1, #artCabinets do 
            takeObjs[i] = CreateObject(GetHashKey("ch_prop_ch_sec_cabinet_02a"), artCabinets[i].x, artCabinets[i].y, artCabinets[i].z, true, false, false)
            SetEntityHeading(takeObjs[i], artCabinets[i].w)
            paintingObjs[i] = CreateObject(GetHashKey(paintingNames[i]), paintings[i], true, false, false)
            SetEntityHeading(paintingObjs[i], artCabinets[i].w)

            blips[i] = AddBlipForEntity(takeObjs[i])
            SetBlipSprite(blips[i], 534 + i)
            SetBlipScale(blips[i], 0.8)
            SetBlipColour(blips[i], 2)
        end
        
        blips[#blips + 1] = AddBlipForCoord(vaultEntryDoorCoords)
        SetBlipColour(blips[#blips + 1], 5)

        for i = 1, #paintingNames do 
            SetModelAsNoLongerNeeded(paintingNames[i]) 
        end

        SetModelAsNoLongerNeeded("ch_prop_ch_sec_cabinet_02a") 
    else 
        cartLayout = 1
            
        for i = 1, #cartType[loot] do 
            LoadModel(cartType[loot][i])
        end
        
        for i = 1, #carts[cartLayout] do 
            local j = CartType(i)
            
            takeObjs[i] = CreateObject(GetHashKey(cartType[loot][j]), carts[cartLayout][i].x, carts[cartLayout][i].y, carts[cartLayout][i].z, true, false, false)
            SetEntityHeading(takeObjs[i], carts[cartLayout][i].w)

            blips[i] = AddBlipForCoord(carts[cartLayout][i].x, carts[cartLayout][i].y, carts[cartLayout][i].z)
            SetBlipSprite(blips[i], 534 + i)
            SetBlipColour(blips[i], 2)
            SetBlipScale(blips[i], 0.8)
        end
        
        for i = 1, #cartType[loot] do 
            SetModelAsNoLongerNeeded(cartType[loot][i])
        end
    end
end

local function SetVaultLayout()
    local layouts = {
        {2, 3, 5, 7},
        {1, 5, 7},
        {2, 3, 4, 5},
        {1, 5, 7},
        {2, 3, 4},
        {4, 5},
        {2, 3, 4, 5},
        {1, 6, 7},
        {2, 3, 5},
        {5, 7}
    }
    
    if loot == 3 then 
        vaultLayout = math.random(7, 10)
    else
        vaultLayout = math.random(1, 6)
        
        if vaultLayout < 3 then 
            cartLayout = 1
        else 
            cartLayout = 2
        end
    end

    for i = 1, 7 do 
        if i < 4 then 
            slideDoorObjs[i] = GetClosestObjectOfType(slideDoors[i], 1.0, GetHashKey("ch_prop_ch_vault_slide_door_lrg"), false, false, false)
        else
            slideDoorObjs[i] = GetClosestObjectOfType(slideDoors[i], 1.0, GetHashKey("ch_prop_ch_vault_slide_door_sm"), false, false, false)
        end
    end 

    for i = 1, #layouts[vaultLayout] do 
        local coords = GetEntityCoords(slideDoorObjs[layouts[vaultLayout][i]])

        SetEntityCoords(slideDoorObjs[layouts[vaultLayout][i]], coords + (GetEntityOffset(slideDoorObjs[layouts[vaultLayout][i]], true) * 2), true, false, false, false)
        status[2][layouts[vaultLayout][i]] = true
    end
end

local function GrabLoot(i)
    if loot == 2 or loot == 4 then 
        if status[1][1] == 0.0 then 
            for j = 1, 8 do 
                status[1][j] = 0.5037
            end
        end
    end

    local animTime = status[1][i]
    local grabbing = false
    local quit = false
    local waiting = false
    local animDict = "anim@heists@ornate_bank@grab_cash"
    local bagColour = GetPedTextureVariation(PlayerPedId(), 5)
    local bag = "ch_p_m_bag_var0" .. GetClothingModel(bagColour) .. "_arm_s"
    local propType = {
        "ch_prop_20dollar_pile_01a",
        "ch_prop_gold_bar_01a",
        "",
        "ch_prop_dimaondbox_01a"
    }
    local lootStrings = {
        "cash",
        "gold",
        "",
        "diamonds"
    }
    
    isBusy = true
    
    local cartCoords = GetEntityCoords(takeObjs[i])
    local cartHeading = GetEntityHeading(takeObjs[i]) / 180 * math.pi
    local camCoords = (1.25 * vector3(math.cos(cartHeading + ((14 / 12) * math.pi)), math.sin(cartHeading + ((14 / 12) * math.pi)), 1.0)) + cartCoords

    LoadAnim(animDict)
    LoadModel(propType[loot])
    LoadModel(bag)
    SetPedComponentVariation(PlayerPedId(), 5, 0, 0, 0)
        
    bagObj = CreateObject(GetHashKey(bag), GetEntityCoords(PlayerPedId()), true, false, false)
    boxObj = CreateObject(propType[loot], GetEntityCoords(PlayerPedId()), true, false, false)

    NetworkRequestControlOfEntity(takeObjs[i])

    repeat Wait(0) until NetworkHasControlOfEntity(takeObjs[i])

    AttachEntityToEntity(boxObj, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
    SetEntityVisible(boxObj, false, false)
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(cam, camCoords)
    PointCamAtCoord(cam, cartCoords.xy, cartCoords.z + 0.5)
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 1000, true, false)
    
    y = NetworkCreateSynchronisedScene(cartCoords, GetEntityRotation(takeObjs[i]), 2, true, false, 1.0, animTime, 0.0)
    NetworkAddEntityToSynchronisedScene(takeObjs[i], y, animDict, "cart_cash_dissapear", 1000.0, -4.0, 1)
    ForceEntityAiAndAnimationUpdate(takeObjs[i])
    NetworkStartSynchronisedScene(y)
    
    x = NetworkCreateSynchronisedScene(cartCoords, GetEntityRotation(takeObjs[i]), 2, true, false, 1.0, 0.0, 1.0)
    NetworkAddEntityToSynchronisedScene(bagObj, x, animDict, "bag_intro", 1000.0, -1000.0, 0)
    ForceEntityAiAndAnimationUpdate(bagObj)
    NetworkAddPedToSynchronisedScene(PlayerPedId(), x, animDict, "intro", 1.5, -8.0, 13, 16, 1.5, 0)
    ForcePedAiAndAnimationUpdate(PlayerPedId(), false, true)
    NetworkStartSynchronisedScene(x)
    
    Wait(2000)
    
    z = NetworkCreateSynchronisedScene(cartCoords, GetEntityRotation(takeObjs[i]), 2, false, true, 1.0, 0.0, 1.0)
    NetworkAddEntityToSynchronisedScene(bagObj, z, animDict, "bag_grab_idle", 1000.0, -1000.0, 0)
    ForceEntityAiAndAnimationUpdate(bagObj)
    NetworkAddPedToSynchronisedScene(PlayerPedId(), z, animDict, "grab_idle", 2.0, -8.0, 13, 16, 1000.0, 0)
    ForcePedAiAndAnimationUpdate(PlayerPedId(), false, true)
    NetworkStartSynchronisedScene(z)
    
    Wait(1000)
    
    CreateThread(function()
        while animTime < 1.0 and not quit do 
            Wait(5)
            HelpMsg("Repeatedly tap ~INPUT_CURSOR_ACCEPT~ to quickly grab the \n" .. lootStrings[loot] .. ". Press ~INPUT_CURSOR_CANCEL~ to stop grabbing the \n" .. lootStrings[loot] .. ".")
        end
    end)
    
    while animTime < 1.0 do 
        Wait(GetFrameTime())
        if IsControlPressed(0, 237) and not grabbing then 

        DisableControlAction(0, 1, true)

            waiting = false
            grabbing = true
            
            a = NetworkCreateSynchronisedScene(cartCoords, GetEntityRotation(takeObjs[i]), 2, true, false, 1.0, animTime, 1.0)
            NetworkAddEntityToSynchronisedScene(bagObj, a, animDict, "bag_grab", 1000.0, -1000.0, 0)
            ForceEntityAiAndAnimationUpdate(bagObj)
            NetworkAddPedToSynchronisedScene(PlayerPedId(), a, animDict, "grab", 8.0, -8.0, 13, 16, 1000.0, 0)
            NetworkAddEntityToSynchronisedScene(takeObjs[i], a, animDict, "cart_cash_dissapear", 1000.0, -4.0, 1)
            ForceEntityAiAndAnimationUpdate(takeObjs[i])
            NetworkStartSynchronisedScene(a)
            
            while not HasAnimEventFired(PlayerPedId(), GetHashKey("CASH_APPEAR")) do 
                Wait(1)
            end
            
            SetEntityVisible(boxObj, true, false)            
            
            while not HasAnimEventFired(PlayerPedId(), GetHashKey("RELEASE_CASH_DESTROY")) do 
                Wait(1)
            end
            
            grabbing = false
            
            SetEntityVisible(boxObj, false, false)            
            TriggerServerEvent("sv:casinoheist:addtake")

            SetSynchronizedSceneRate(NetworkGetLocalSceneFromNetworkId(a), 0)
            animTime = GetSynchronizedScenePhase(NetworkGetLocalSceneFromNetworkId(a))
            
        elseif IsControlPressed(0, 238) then 
            waiting = false
            quit = true
            break
        elseif not waiting then 
            waiting = true 
            y = NetworkCreateSynchronisedScene(cartCoords, GetEntityRotation(takeObjs[i]), 2, true, false, 1.0, animTime, 0.0)
            NetworkAddEntityToSynchronisedScene(takeObjs[i], y, animDict, "cart_cash_dissapear", 1000.0, -4.0, 1)
            ForceEntityAiAndAnimationUpdate(takeObjs[i])
            NetworkStartSynchronisedScene(y)
            
            z = NetworkCreateSynchronisedScene(cartCoords, GetEntityRotation(takeObjs[i]), 2, false, true, 1.0, 0.0, 1.0)
            NetworkAddEntityToSynchronisedScene(bagObj, z, animDict, "bag_grab_idle", 1000.0, -1000.0, 0)
            ForceEntityAiAndAnimationUpdate(bagObj)
            NetworkAddPedToSynchronisedScene(PlayerPedId(), z, animDict, "grab_idle", 2.0, -8.0, 13, 16, 1000.0, 0)
            ForcePedAiAndAnimationUpdate(PlayerPedId(), false, true)
            NetworkStartSynchronisedScene(z)
        end
    end 

    y = NetworkCreateSynchronisedScene(cartCoords, GetEntityRotation(takeObjs[i]), 2, true, false, 1.0, animTime, 0.0)
    NetworkAddEntityToSynchronisedScene(takeObjs[i], y, animDict, "cart_cash_dissapear", 1000.0, -4.0, 1)
    ForceEntityAiAndAnimationUpdate(takeObjs[i])
    NetworkStartSynchronisedScene(y)

    exit = NetworkCreateSynchronisedScene(cartCoords, GetEntityRotation(takeObjs[i]), 2, true, false, 1.0, 0.0, 1.0)
    NetworkAddEntityToSynchronisedScene(bagObj, exit, animDict, "bag_exit", 1000.0, -1000.0, 0)
    ForceEntityAiAndAnimationUpdate(bagObj)
    NetworkAddPedToSynchronisedScene(PlayerPedId(), exit, animDict, "exit", 4.0, -1.5, 13, 16, 1000.0, 0)
    ForcePedAiAndAnimationUpdate(PlayerPedId(), false, true)
    NetworkStartSynchronisedScene(exit)
    RenderScriptCams(false, true, 2000, true, false)
    TriggerServerEvent("sv:casinoheist:syncLStatus", i, animTime)

    Wait(2000)

    DeleteEntity(bagObj)
    DeleteEntity(boxObj)
    DestroyCam(cam)
    SetModelAsNoLongerNeeded(bag)
    SetPedComponentVariation(PlayerPedId(), 5, 82, bagColour, 0)

    isBusy = false
end

local function CutPainting(j)
    DestroyAllCams()
    local animDict = "anim_heist@hs3f@ig11_steal_painting@male@"
    local blade = "w_me_switchblade"
    local bagColour = GetPedTextureVariation(PlayerPedId(), 5)
    local bag = "ch_p_m_bag_var0" .. GetClothingModel(bagColour) .. "_arm_s"
    local x = 3
    local quit = false
    local txt = {
        [3] = "~INPUT_MOVE_RIGHT_ONLY~ to cut right.",
        [5] = "~INPUT_MOVE_DOWN_ONLY~ to cut down.",
        [7] = "~INPUT_MOVE_LEFT_ONLY~ to cut left.",
        [8] = "~INPUT_MOVE_DOWN_ONLY~ to cut down.",
        [10] = ""
    }
    local keys = { [3] = 35, [5] =  33, [7] = 34, [8] = 33}

    isBusy = true

    LoadAnim(animDict)
    LoadModel(blade)
    LoadModel(bag)
    SetPedComponentVariation(PlayerPedId(), 5, 0, 0, 0)
    NetworkRequestControlOfEntity(paintingObjs[j])

    repeat Wait(0) until NetworkHasControlOfEntity(paintingObjs[i])
    
    local bladeObj = CreateObject(GetHashKey(blade), GetEntityCoords(PlayerPedId()), true, false, false)
    local bagObj = CreateObject(GetHashKey(bag), GetEntityCoords(PlayerPedId()), true, false, false)
    local cam = CreateCam("DEFAULT_ANIMATED_CAMERA", true)
    SetCamActive(cam, true)
    SetCamCoord(cam, GetEntityCoords(PlayerPedId()))

    for i = 1, #paintingAnims[1] do 
        if i == 2 or i == 4 or i == 6 --[[or i == 7 or i == 8]] then 
            paintingAnims[2][i] = NetworkCreateSynchronisedScene(GetEntityCoords(takeObjs[j]), GetEntityRotation(takeObjs[j]), 2, false, true, 1.0, 0.0, 1.0)
            NetworkAddPedToSynchronisedScene(PlayerPedId(), paintingAnims[2][i], animDict, paintingAnims[1][i][1], 4.0, -1.5, 13, 16, 1000.0, 0)
            NetworkAddEntityToSynchronisedScene(bladeObj, paintingAnims[2][i], animDict, paintingAnims[1][i][2], 1000.0, -1000.0, 134149)
            NetworkAddEntityToSynchronisedScene(paintingObjs[j], paintingAnims[2][i], animDict, paintingAnims[1][i][3], 1000.0, -1000.0, 0)
            NetworkAddEntityToSynchronisedScene(bagObj, paintingAnims[2][i], animDict, paintingAnims[1][i][4], 1000.0, -1000.0, 0)
        else 
            paintingAnims[2][i] = NetworkCreateSynchronisedScene(GetEntityCoords(takeObjs[j]), GetEntityRotation(takeObjs[j]), 2, true, false, 1.0, 0.0, 1.0)
            NetworkAddPedToSynchronisedScene(PlayerPedId(), paintingAnims[2][i], animDict, paintingAnims[1][i][1], 4.0, -1.5, 13, 16, 1000.0, 0)
            NetworkAddEntityToSynchronisedScene(bladeObj, paintingAnims[2][i], animDict, paintingAnims[1][i][2], 1000.0, -1000.0, 134149)
            NetworkAddEntityToSynchronisedScene(paintingObjs[j], paintingAnims[2][i], animDict, paintingAnims[1][i][3], 1000.0, -1000.0, 0)
            NetworkAddEntityToSynchronisedScene(bagObj, paintingAnims[2][i], animDict, paintingAnims[1][i][4], 1000.0, -1000.0, 0)
        end
    end
    
    NetworkStartSynchronisedScene(paintingAnims[2][1])
    PlayCamAnim(cam, paintingAnims[1][1][6], animDict, GetEntityCoords(takeObjs[j]), GetEntityRotation(takeObjs[j]), false, 2)
    Wait(2000)
    RenderScriptCams(true, false, 2500, true, false)
    PlayCamAnim(cam, paintingAnims[1][2][6], animDict, GetEntityCoords(takeObjs[j]), GetEntityRotation(takeObjs[j]), false, 2)
    NetworkStartSynchronisedScene(paintingAnims[2][2])
    
    while x < 11 and not quit do 
        Wait(GetFrameTime())
    
        if x == 10 then 
            SetCamCoord(cam, GetEntityCoords(PlayerPedId()) + GetEntityOffset(PlayerPedId(), true))
            PointCamAtEntity(cam, PlayerPedId(), 1.0, 1.0, 0.0)
            Wait(GetAnimDuration(animDict, paintingAnims[1][9][1]) * 1000)
            RenderScriptCams(false, true, 2000, true, false)
            y = NetworkCreateSynchronisedScene(GetEntityCoords(takeObjs[j]), GetEntityRotation(takeObjs[j]), 2, true, false, 1.0, 1.0, 0.0)
            NetworkAddEntityToSynchronisedScene(paintingObjs[j], y, animDict, "ver_01_with_painting_exit_ch_prop_vault_painting_01a", 1000.0, -4.0, 1)
            ForceEntityAiAndAnimationUpdate(paintingObjs[j])
            NetworkStartSynchronisedScene(y)
            break
        end
        
        DisableControlAction(0, 1, true)

        HelpMsg(txt[x])
        if IsControlPressed(0, keys[x]) then 
            PlayCamAnim(cam, paintingAnims[1][x][6], animDict, GetEntityCoords(takeObjs[j]), GetEntityRotation(takeObjs[j]), false, 2)
            ForcePedAiAndAnimationUpdate(PlayerPedId(), false, true)
            ForceEntityAiAndAnimationUpdate(paintingObjs[j])
            ForceEntityAiAndAnimationUpdate(bladeObj)
            NetworkStartSynchronisedScene(paintingAnims[2][x])
            Wait(GetAnimDuration(animDict, paintingAnims[1][x][1]) * 1000)
            x = x + 1
            
            if x ~= 8 then 
                PlayCamAnim(cam, paintingAnims[1][x][6], animDict, GetEntityCoords(takeObjs[j]), GetEntityRotation(takeObjs[j]), false, 2)
                NetworkStartSynchronisedScene(paintingAnims[2][x])
                x = x + 1
            end
        end
    end

    TriggerServerEvent("sv:casinoheist:syncLStatus", j, 1.0)
    TriggerServerEvent("sv:casinoheist:addtake")

    --take = take + 1

    ClearPedTasks(PlayerPedId())

    DeleteEntity(bagObj)
    DeleteEntity(bladeObj)
    SetCamActive(cam, false)
    DestroyAllCams()
    SetModelAsNoLongerNeeded(bag)
    SetPedComponentVariation(PlayerPedId(), 5, 82, bagColour, 0)
    isBusy = false
end

local function OpenSlideDoors(size, num, hash)
    local dHash = GetHashKey("WHOUSE_DOOR_RANCHO_" .. tostring(num) .. size)

    if not IsDoorRegisteredWithSystem(dHash) then
        AddDoorToSystem(dHash, GetHashKey(hash), slideDoors[num], false, false, false)
    end
    
    DoorSystemSetDoorState(dHash, 0, false, false)
    DoorSystemSetHoldOpen(dHash, true)
    
    doorHash[#doorHash + 1] = dHash
end

local function VaultGas()
    local x = 0.0
    local cough = {
        {"COUGH_A", "COUGH_A_FACIAL"},
        {"COUGH_B", "COUGH_B_FACIAL"},
        {"COUGH_C", "COUGH_C_FACIAL"}
    }
    local arr1 = {
        1,
        "anim@fidgets@coughs",
        "",
        0.0,
        1065353216,
        1065353216,
        0,
        0,
        0,
        1065353216,
        1065353216,
        0,
        0,
        0,
        1065353216,
        1065353216,
        GetHashKey("BONEMASK_UPPERONLY"),
        1040187392,
        1040187392,
        -1,
        304
    }
    local arr2 = {
        0,
        0,
        0,
        0,
        1065353216,
        1065353216,
        0,
        0,
        0,
        1065353216,
        1065353216,
        0,
        0,
        0,
        1065353216,
        1065353216,
        0,
        1040187392,
        1040187392,
        -1
    }
    local arr3 = {
        0,
        0,
        0,
        0,
        1065353216,
        1065353216,
        0,
        0,
        0,
        1065353216,
        1065353216,
        0,
        0,
        0,
        1065353216,
        1065353216,
        0,
        1040187392,
        1040187392,
        -1
    }
    
    RequestScriptAudioBank("DLC_HEIST3/CASINO_HEIST_FINALE_GENERAL_01", false, -1)
    RequestAnimSet("anim@fidgets@coughs")

    while not HasAnimSetLoaded("anim@fidgets@coughs") do 
        Wait(0)
    end

    RequestNamedPtfxAsset("scr_ch_finale")

    while not HasNamedPtfxAssetLoaded("scr_ch_finale") do 
        Wait(0)
    end

    LoadAnim("anim@fidgets@coughs")

    for i = 1, 3 do 
        UseParticleFxAsset("scr_ch_finale")
        ptfx[i] = StartParticleFxLoopedAtCoord("scr_ch_finale_poison_gas", GetGasCoords(i), GetGasRot(i), 1.0, false, false, false, true)
        SetParticleFxLoopedColour(ptfx[i], 255.0, 255.0, 255.0, true)
        SetParticleFxLoopedAlpha(ptfx[i], 255.0)
    end

    UseParticleFxAsset("scr_ch_finale")
    ptfx[4] = StartParticleFxLoopedAtCoord("scr_ch_finale_vault_haze", 2527.0, -238.5, -71.8, 0.0, 0.0, 0.0, 1.0, false, false, false, true)

    while x < .02 do 
        Wait(20)

        x = x + (0 * 0.01)
        
        if x > 1.0 then 
            x = 1.0
        elseif x < 0.0 then 
            x = 0.0
        end
        
        while x < .02 do 
            Wait(20)
    
            x = x + (GetFrameTime() * 0.01)
            
            if x > 1.0 then 
                x = 1.0
            elseif x < 0.0 then 
                x = 0.0
            end
    
            SetParticleFxLoopedEvolution(ptfx[4], "fill", x, true)
            SetParticleFxLoopedEvolution(ptfx[4], "fade", x, true)
        end

        SetParticleFxLoopedEvolution(ptfx[4], "fill", x, true)
        SetParticleFxLoopedEvolution(ptfx[4], "fade", x, true)
    end
    
    CreateThread(function()
        while isInVault do 
            Wait(1500)
            local num = math.random(1, 3)
            
            -- This might break. Remove if needed
            TaskScriptedAnimation(PlayerPedId(), tonumber(arr1), tonumber(arr2), tonumber(arr3), 0.125, 0.125)
            PlayFacialAnim(PlayerPedId(), cough[2][num], "anim@fidgets@coughs")
            PlaySoundFromEntity(-1, "Male_0".. num, PlayerPedId(), "dlc_ch_heist_finale_poison_gas_coughs_sounds", true, 500)

            ApplyDamageToPed(PlayerPedId(), 10, false)
        end

        RemoveAnimDict("anim@fidgets@coughs")
        RemoveAnimSet("anim@fidgets@coughs")
        RemoveNamedPtfxAsset("scr_ch_finale")
    end)
    
    repeat Wait(3000) until x > 0.02

    Wait(5000)

    for i = 1 , 3 do 
        StopParticleFxLooped(ptfx[i], 0)
    end
end

function VaultCheck()
    for i = 1, #hPlayer do 
        if #(GetEntityCoords(GetHeistPlayerPed(hPlayer[i])) - vaultEntryDoorCoords) > 7 and isInVault then 
            print("gas active")
            TriggerServerEvent("sv:casinoheist:alarm")
            VaultGas()
            return 
        end
    end
end

function Vault()
    local bTake = take
    
    isInVault = true

    local txt = {
        "Press ~INPUT_CONTEXT~ to begin grabbing the cash.",
        "Press ~INPUT_CONTEXT~ to begin grabbing the gold.",
        "Press ~INPUT_CONTEXT~ to cut the paintings.",
        "Press ~INPUT_CONTEXT~ to begin grabbing the diamonds."
    }
    
    SetVaultLayout()

    if player == 1 then 
        SetVaultObjs()
    elseif player ~= 1 then 
        Wait(100)
        GetVaultObjs()
    end

    RequestScriptAudioBank("DLC_HEIST3/CASINO_HEIST_FINALE_GENERAL_01", false, -1)

    ShowTimerbars(true)
    DrawTimer()

    if loot == 3 then 
        RequestScriptAudioBank("DLC_HEIST3/HEIST_FINALE_STEAL_PAINTINGS", false, -1)
        CreateThread(function()
            while true do 
                Wait(GetFrameTime())

                if not isBusy and isInVault then 
                    for k, v in pairs(artCabinets) do 
                        if status[1][k] < 1.0 then 
                            local distance = #(GetEntityCoords(PlayerPedId()) - v.xyz)
                            if distance < 1.2 then 
                                HelpMsg("Press ~INPUT_CONTEXT~ to cut the paintings.")
                                if IsControlPressed(0, 38) then 
                                    CutPainting(k)
                                end
                            end
                        elseif AreAllObjectsDone(1) then 
                            break
                        end
                    end
                else 
                    Wait(3000)
                end
            end
        end)
    elseif loot == 1 or loot == 2 or loot == 4 then 
        CreateThread(function()
            while true do 
                Wait(GetFrameTime())
                if not isBusy and isInVault then
                    for k, v in pairs(carts[cartLayout]) do 
                        if status[1][k] < 1.0 then 
                            local distance = #(GetEntityCoords(PlayerPedId()) - (v.xyz + GetEntityOffset(takeObjs[k], false)))
                            if distance < 1.2 then
                                HelpMsg(txt[loot])
                                if IsControlPressed(0, 38) then 
                                    GrabLoot(k)
                                end
                            end
                        elseif AreAllObjectsDone(1) then 
                            break
                        end
                    end
                else 
                    Wait(3000)
                end
            end
        end)
    end

    CreateThread(function()
        while true do 
            Wait(GetFrameTime())

            if not isBusy and isInVault then 
                for k, v in pairs(keypads[3]) do
                    if not status[2][k] then 
                        local distance = #(GetEntityCoords(PlayerPedId()) - v)
                        if distance < 1.0 then 
                            HelpMsg("Press ~INPUT_CONTEXT~ to hack the keypad")
                            if IsControlPressed(0, 38) then 
                               HackKeypad(3, k, true)
                            end
                        end
                    elseif AreAllObjectsDone(2) then 
                        break
                    end
                end
            else 
                Wait(3000)
            end
        end
    end)

    CreateThread(function()
        while true do 
            Wait(1000)
            
            if take > bTake then 
                SubtitleMsg("Continue ~g~looting~s~ or leave the ~y~vault. ", 1100)
                
                local distance = #(GetEntityCoords(PlayerPedId()) - vaultEntryDoorCoords)
    
                if not IsNotClose(vaultEntryDoorCoords, 7) then
                    print("Distance " .. distance)
                    RemoveAllBlips()

                    if loot == 3 then 
                        for i = 1, #paintingNames do 
                            SetModelAsNoLongerNeeded(paintingNames[i])
                        end
                        
                        SetModelAsNoLongerNeeded("w_me_switchblade")

                        RemoveAnimDict("anim_heist@hs3f@ig11_steal_painting@male@")
                        ReleaseNamedScriptAudioBank("DLC_HEIST3/HEIST_FINALE_STEAL_PAINTINGS")
                    else 
                        if loot == 1 then 
                            SetModelAsNoLongerNeeded("ch_prop_20dollar_pile_01a")
                        elseif loot == 2 then 
                            SetModelAsNoLongerNeeded("ch_prop_gold_bar_01a")
                        elseif loot == 4 then 
                            SetModelAsNoLongerNeeded("ch_prop_dimaondbox_01a")
                        end
                        
                        RemoveAnimDict("anim@heists@ornate_bank@grab_cash")
                    end

                    isInVault = false 
                    isBusy = true 
                    showTimer = false
                    VaultLobby(true, false)

                    break
                elseif distance < 7 or distance > 40 then 
                    isInVault = false 
                else
                    isInVault = true
                end
            else
                SubtitleMsg("Grab the ~g~loot.", 1100)
            end
        end
    end)
end

RegisterNetEvent("cl:casinoheist:syncLStatus", function(key, time)
    status[1][key] = time
    RemoveBlip(blips[key])
end)

RegisterNetEvent("cl:casinoheist:syncDStatus", function(num)
    status[2][num] = true
    if num < 4 then 
        OpenSlideDoors("A", num, "ch_prop_ch_vault_slide_door_lrg")
    else 
        OpenSlideDoors("A", num, "ch_prop_ch_vault_slide_door_sm")
    end    
end)

-- Test event??
RegisterNetEvent("test:cl:vault", Vault)