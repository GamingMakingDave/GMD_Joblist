ESX = exports['es_extended']:getSharedObject()

local propTab = 0

if Config.UseCommand then
    RegisterKeyMapping(Config.Command, 'Open Job Tablet', 'keyboard', Config.DefaultHotkey)
    RegisterCommand(Config.Command, function(source, args)
        local playerData = ESX.GetPlayerData()
        local hasJob = false

        for _, job in ipairs(Config.Jobs) do
            if playerData.job.name == job then
                hasJob = true
                break
            end
        end

        if hasJob then
            sendServerCallback()
        else
            ESX.ShowNotification((Config.Language[Config.Locale]['no_job']))
        end
    end, false)
end


----------
--EVENTS--
----------
RegisterNetEvent('GMD_Joblists:jobTabletUse')
AddEventHandler('GMD_Joblists:jobTabletUse', function()
    ESX.TriggerServerCallback('GMD_Joblists:hasItem', function(check)
        if check then
            sendServerCallback()
        end
    end)
end)

-----------------
--NUI CALLBACKS--
-----------------
RegisterNUICallback('escape', function(data, cb)
    SetNuiFocus(false, false)
    stopAnim()
end)

RegisterNUICallback('numberNotify', function(data, cb)
    local playerName = data.name
    local playerPhone = data.number
    ESX.ShowNotification((Config.Language[Config.Locale]['copy_number_msg']):format(tostring(playerPhone), tostring(playerName)))
end)

-------------
--FUNCTIONS--
-------------
function sendServerCallback()
    ESX.TriggerServerCallback('GMD_Joblists:GetAllPlayerData', function(players)
        local allPlayerData = {}
        startAnim()
        print(ESX.DumpTable(players))
        for _, player in ipairs(players) do
            table.insert(allPlayerData, {
                playerName = player.name,
                playerPhone = player.phone
            })
        end

        SetNuiFocus(true, true)
        SendNUIMessage({
            type = "openNui",
            playersData = allPlayerData,
        })
    end)
end

--------------------
-- ANIMATION STUFF--
--------------------
function startAnim()
    CreateThread(function()
        RequestAnimDict("amb@world_human_seat_wall_tablet@female@base")
        while not HasAnimDictLoaded("amb@world_human_seat_wall_tablet@female@base") do
            Wait(0)
        end
        attachObject()
        TaskPlayAnim(GetPlayerPed(-1), "amb@world_human_seat_wall_tablet@female@base", "base" ,8.0, -8.0, -1, 50, 0, false, false, false)
    end)
end

function attachObject()
    propTab = CreateObject(GetHashKey("prop_cs_tablet"), 0, 0, 0, true, true, true)
    AttachEntityToEntity(propTab, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 57005), 0.17, 0.10, -0.13, 20.0, 180.0, 180.0, true, true, false, true, 1, true)
end

function stopAnim()
    StopAnimTask(GetPlayerPed(-1), "amb@world_human_seat_wall_tablet@female@base", "base", 8.0, -8.0, -1, 50, 0, false, false, false)
    ClearPedTasks(GetPlayerPed(-1))
    if propTab ~= 0 then
		Citizen.InvokeNative(0xAE3CBE5BF394C9C9, Citizen.PointerValueIntInitialized(propTab))
		propTab = 0
	end
end
