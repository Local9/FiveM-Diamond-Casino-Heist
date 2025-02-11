heistInProgress = false

hPlayer = {}

entrypointsCasino = {
    -- Agressive 
    --[[4]]  vector3(993.17, 77.05, 80.99),     -- Waste Disposal
    --[[1]]  vector3(923.76, 47.20, 81.11),     -- Main Entrance
    --[[9]]  vector3(936.42, 14.51, 112.55),    -- Roof South West
    --[[5]]  vector3(972.15, 25.54, 120.24),    -- Roof Helipad North  
    --[[10]] vector3(953.40, 79.20, 111.25),    -- Roof North West
    --[[11]] vector3(1000.4, -54.99, 74.96),     -- Security Tunnel
    --[[2]]  vector3(893.29, -176.47, 22.58),   -- Sewer
    --[[8]]  vector3(953.78, 4.02, 111.26),     -- Roof South East 
    --[[6]]  vector3(959.39, 31.75, 120.23),    -- Roof Helipad South 
    --[[7]]  vector3(988.32, 59.03, 111.26),    -- Roof North East
    --[[3]]  vector3(978.78, 18.64, 80.99)     -- Staff Lobby
}

difficulty = 1 -- 1 = Normal, 2 = Hard
loot = 0 -- 1 = CASH, 2 = GOLD, 3 = ARTWORK, 4 = DIAMONDS
approach = 0 -- 1 = Silent and Sneaky, 2 = The Big Con, 3 = Aggressive
playerAmount = 0
teamlives = 0
take = 0

selectedGunman = 0         
selectedLoadout = 0         
selectedDriver = 0          
selectedVehicle = 0         
selectedHacker = 0          
selectedKeycard = 0
selectedEntrance = 0        
selectedExit = 0            
selectedBuyer = 0          
selectedEntryDisguise = 0      
selectedExitDisguise = 0 

boughtCasinoModel = false 
boughtDoorSecurity = false 
boughtVault = false
boughtCleanVehicle = false
boughtDecoy = false

AddTextEntry("warning_message_first_line", "confirm")

playerCut = {
    [1] = {100},
    [2] = {85, 15},
    [3] = {70, 15, 15},
    [4] = {55, 15, 15, 15}
}

alarmTriggered = 0

local models = { 
    GetHashKey("a_f_m_bevhills_01"),
    GetHashKey("a_f_m_bevhills_02"),
    GetHashKey("a_f_m_bodybuild_01") 
}

local nPropsCoords = { 
    vector3(2505.54, -238.53, -71.65),
    vector3(2504.98, -240.31, -70.19)
}

local nPropsNames = { 
    GetHashKey("ch_prop_ch_vault_wall_damage"),
    GetHashKey("ch_des_heist3_vault_end")
}

RegisterCommand("vl_break", function()
    for i = 1, #nPropsCoords, 1 do 
        local prop = GetClosestObjectOfType(nPropsCoords[i], 1.0, nPropsNames[i], false, false, false)
        local prop1 = GetClosestObjectOfType(2504.97, -240.31, -70.17, 1.0, GetHashKey("ch_des_heist3_vault_01"), false, false, false)
        SetEntityVisible(prop, true)
        SetEntityVisible(prop1, false)
        SetEntityCollision(prop, true, true)
        SetEntityCollision(prop1, false, true)
    end
end, false)

function GetHeistPlayers()
    Models()
    --hPlayer[2] = CreatePed(7, models[1], 0.0, 0.0, 0.0, 0.0, true, true)
    --hPlayer[3] = CreatePed(7, models[2], 0.0, 0.0, 0.0, 0.0, true, true)
    --hPlayer[4] = CreatePed(7, models[3], 0.0, 0.0, 0.0, 0.0, true, true)
    return hPlayer 
end

function GetCurrentHeistPlayer()
    if PlayerId() == GetPlayerFromServerId(hPlayer[1]) then 
        return 1 
    elseif PlayerId() == GetPlayerFromServerId(hPlayer[2]) then 
        return 2
    elseif PlayerId() == GetPlayerFromServerId(hPlayer[3]) then 
        return 3
    elseif PlayerId() == GetPlayerFromServerId(hPlayer[4]) then
        return 4
    else 
        return nil
    end
end

function DeletePeds()
    for i = 3, #hPlayer, 1 do 
        DeletePed(hPlayer[i])
    end
end

function Models()
    for i = 1, #models, 1 do 
        LoadModel(models[i])
    end
end

function SetRoom(room)
    AddBlipsForSelectedRoom(room)
    
    if alarmTriggered == 0 then 
        SetGuardVision(room)
    else 
        StartGuardSpawn(room)
    end
end

function SetBlipsColour(colour)
    SetGuardColour(colour)
    SetCamColour(colour)
end

function TriggerAlarm()
    SetAmbientZoneStatePersistent("AZ_H3_Casino_Alarm_Zone_01_Exterior", true, true)
    SetAmbientZoneStatePersistent("AZ_H3_Casino_Alarm_Zone_02_Interior", true, true)

    CancelMusicEvent("CH_IDLE")
    PrepareMusicEvent("CH_GUNFIGHT")
    TriggerMusicEvent("CH_GUNFIGHT")
    SetGuardAgg()

    alarmTriggered = 1
end

function RemoveObjs()
    RemoveCams()
    RemoveGuards()
end

function DisableAlarm()
    SetAmbientZoneStatePersistent("AZ_H3_Casino_Alarm_Zone_01_Exterior", false, true)
    SetAmbientZoneStatePersistent("AZ_H3_Casino_Alarm_Zone_02_Interior", false, true)
end

function SetLayout()
    if loot ~= 3 then 
        vaultLayout = math.random(1,6)
    else  
        vaultLayout = math.random(7,10)
    end
end

AddEventHandler("onResourceStart", function()
end)

RegisterNetEvent("cl:casinoheist:updateHeistPlayers", function(crew)
    hPlayer = crew
    PlayerJoinedCrew(#hPlayer)
end)

RegisterNetEvent("cl:casinoheist:startHeist", function(obj)
    heistInProgress = true
    hPlayer = obj[1]
    approach = obj[2]
    loot = obj[3]
    playerCut[#hPlayer] = obj[4]
    selectedGunman = obj[5]
    selectedLoadout = obj[6]         
    selectedDriver = obj[7]          
    selectedVehicle = obj[8]         
    selectedHacker = obj[9]          
    selectedKeycard = obj[10]
    selectedEntrance = obj[11]        
    selectedExit = obj[12]            
    selectedBuyer = obj[13]          
    selectedEntryDisguise = obj[14]      
    selectedExitDisguise = obj[15] 

    boughtCleanVehicle = obj[16]
    boughtDecoy = obj[17]

    vaultLayout = obj[18]
    cartLayout = obj[19]

    StartHeist()
end)

RegisterNetEvent("cl:casinoheist:alarm", TriggerAlarm)

AddEventHandler("baseevents:onPlayerDied", function(o, i)
    if hPlayer[1] == GetPlayerServerId(PlayerId()) or hPlayer[2] == GetPlayerServerId(PlayerId()) or hPlayer[3] == GetPlayerServerId(PlayerId()) or hPlayer[4] == GetPlayerServerId(PlayerId()) then 
        TriggerServerEvent("sv:casinoheist:removeteamlive")
        exports.spawnmanager:spawnPlayer({
            x = 2516.84,
            y = -256.21,
            z = -55.12,
            heading = 117.02,
            skipFade = false
        })
    end
end)